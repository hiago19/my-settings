#!/bin/bash

# validate-system.sh - Validação completa do sistema sem execução
# Testa se todos os scripts carregam corretamente e suas dependências
# Versão: 1.0 - Dev Senior Architecture

# =============================================================================
# CONFIGURAÇÕES DE VALIDAÇÃO
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VALIDATION_LOG="/tmp/validation-log-$$.txt"
VALIDATION_PASSED=0
VALIDATION_TOTAL=0

# Diretório raiz dos scripts
SCRIPTS_ROOT_DIR="$(dirname "$SCRIPT_DIR")"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# =============================================================================
# FUNÇÕES DE VALIDAÇÃO
# =============================================================================

print_header() {
    echo -e "${PURPLE}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║           🔍 VALIDAÇÃO COMPLETA DO SISTEMA                ║"
    echo "║                  (Sem Execução)                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_test() {
    echo -e "${CYAN}[TEST]${NC} $1"
}

print_pass() {
    echo -e "${GREEN}[PASS]${NC} ✅ $1"
    ((VALIDATION_PASSED++))
}

print_fail() {
    echo -e "${RED}[FAIL]${NC} ❌ $1"
}

print_section() {
    echo
    echo -e "${YELLOW}═══ $1 ═══${NC}"
}

# Validar syntax de um script bash
validate_syntax() {
    local script="$1"
    local name="$(basename "$script")"
    
    ((VALIDATION_TOTAL++))
    print_test "Validando sintaxe: $name"
    
    if bash -n "$script" 2>"$VALIDATION_LOG"; then
        print_pass "Sintaxe válida: $name"
        return 0
    else
        print_fail "Erro de sintaxe em $name:"
        cat "$VALIDATION_LOG"
        return 1
    fi
}

# Testar carregamento de script sem execução
test_script_loading() {
    local script="$1"
    local name="$(basename "$script")"
    
    ((VALIDATION_TOTAL++))
    print_test "Testando carregamento: $name"
    
    # Criar subshell para testar carregamento
    if (
        set -e  # Sair em qualquer erro
        cd "$(dirname "$script")"
        
        # Para scripts que usam bootstrap
        if grep -q "bootstrap.sh" "$script"; then
            source "$SCRIPTS_ROOT_DIR/core/bootstrap.sh" &>/dev/null
        fi
        
        # Carregar o script sem executar main
        source "$script" &>/dev/null
        
        # Verificar se função main existe
        if declare -f main >/dev/null 2>&1; then
            echo "Função main encontrada"
        fi
        
    ) 2>"$VALIDATION_LOG"; then
        print_pass "Carregamento OK: $name"
        return 0
    else
        print_fail "Erro no carregamento de $name:"
        head -5 "$VALIDATION_LOG" 2>/dev/null
        return 1
    fi
}

# Verificar dependências de arquivo
check_file_dependencies() {
    local script="$1"
    local name="$(basename "$script")"
    
    ((VALIDATION_TOTAL++))
    print_test "Verificando dependências: $name"
    
    local missing_deps=0
    
    # Verificar se bootstrap existe (se usado)
    if grep -q "bootstrap.sh" "$script"; then
        local bootstrap_path
        if [[ "$script" == *"/modules/"* ]] || [[ "$script" == *"/tools/"* ]]; then
            bootstrap_path="$SCRIPTS_ROOT_DIR/core/bootstrap.sh"
        else
            bootstrap_path="$SCRIPTS_ROOT_DIR/core/bootstrap.sh"  
        fi
        
        if [[ ! -f "$bootstrap_path" ]]; then
            print_fail "Dependência ausente: bootstrap.sh em $(dirname "$bootstrap_path")"
            ((missing_deps++))
        fi
    fi
    
    # Verificar arquivos de configuração referenciados
    while IFS= read -r config_file; do
        if [[ -n "$config_file" ]] && [[ ! -f "$config_file" ]] && [[ ! -d "$config_file" ]]; then
            # Ignorar variáveis e paths dinâmicos
            if [[ "$config_file" != *"\$"* ]] && [[ "$config_file" != *"HOME"* ]]; then
                print_fail "Arquivo referenciado não existe: $config_file"
                ((missing_deps++))
            fi
        fi
    done < <(grep -o '\$[A-Z_]*[^/]*[^"]*' "$script" 2>/dev/null | head -5)
    
    if [[ $missing_deps -eq 0 ]]; then
        print_pass "Dependências OK: $name"
        return 0
    else
        return 1
    fi
}

# =============================================================================
# VALIDAÇÕES PRINCIPAIS
# =============================================================================

# Validar sistema core
validate_core_system() {
    print_section "SISTEMA CORE"
    
    local core_files=(
        "$SCRIPTS_ROOT_DIR/core/bootstrap.sh"
        "$SCRIPTS_ROOT_DIR/core/colors.sh"
        "$SCRIPTS_ROOT_DIR/core/utils.sh"
        "$SCRIPTS_ROOT_DIR/core/env-loader.sh"
        "$SCRIPTS_ROOT_DIR/core/paths.sh"
    )
    
    for file in "${core_files[@]}"; do
        if [[ -f "$file" ]]; then
            validate_syntax "$file"
            test_script_loading "$file"
        else
            ((VALIDATION_TOTAL++))
            print_fail "Arquivo core não encontrado: $(basename "$file")"
        fi
    done
    
    # Teste especial do bootstrap
    ((VALIDATION_TOTAL++))
    print_test "Testando sistema bootstrap completo"
    if (cd "$SCRIPTS_ROOT_DIR/core" && source bootstrap.sh && test_core_system) &>/dev/null; then
        print_pass "Sistema bootstrap funcionando"
    else
        print_fail "Sistema bootstrap com problemas"
    fi
}

# Validar scripts principais
validate_main_scripts() {
    print_section "SCRIPTS PRINCIPAIS"
    
    local main_scripts=(
        "$SCRIPTS_ROOT_DIR/modules/terminal.sh"
        "$SCRIPTS_ROOT_DIR/modules/vscode.sh"
        "$SCRIPTS_ROOT_DIR/tools/backup-configs.sh"
        "$SCRIPTS_ROOT_DIR/tools/restore-configs.sh"
        "$SCRIPTS_ROOT_DIR/tools/install-extensions.sh"
        "$SCRIPTS_ROOT_DIR/modules/complete.sh"
    )
    
    for script in "${main_scripts[@]}"; do
        if [[ -f "$script" ]]; then
            validate_syntax "$script"
            check_file_dependencies "$script"
            test_script_loading "$script"
        else
            ((VALIDATION_TOTAL++))
            print_fail "Script não encontrado: $(basename "$script")"
        fi
    done
}

# Validar estrutura de arquivos
validate_file_structure() {
    print_section "ESTRUTURA DE ARQUIVOS"
    
    local required_dirs=(
        "$SCRIPTS_ROOT_DIR/core"
        "$SCRIPTS_ROOT_DIR/../configs"
        "$SCRIPTS_ROOT_DIR/../configs/vscode"
        "$SCRIPTS_ROOT_DIR/../configs/terminal"
        "$SCRIPTS_ROOT_DIR/../configs/git"
    )
    
    for dir in "${required_dirs[@]}"; do
        ((VALIDATION_TOTAL++))
        if [[ -d "$dir" ]]; then
            print_pass "Diretório existe: $(basename "$dir")"
        else
            print_fail "Diretório ausente: $(basename "$dir")"
        fi
    done
    
    # Verificar arquivos de configuração críticos
    local config_files=(
        "$SCRIPTS_ROOT_DIR/../.env"
        "$SCRIPTS_ROOT_DIR/../configs/vscode/extensions.txt"
    )
    
    for file in "${config_files[@]}"; do
        ((VALIDATION_TOTAL++))
        if [[ -f "$file" ]]; then
            print_pass "Arquivo de config existe: $(basename "$file")"
        else
            print_fail "Arquivo de config ausente: $(basename "$file")"
        fi
    done
}

# Verificar eliminação de duplicações
validate_no_duplications() {
    print_section "VERIFICAÇÃO DE DUPLICAÇÕES"
    
    ((VALIDATION_TOTAL++))
    print_test "Verificando duplicação de funções de cores"
    
    local color_definitions=0
    local print_function_definitions=0
    
    # Contar definições de cores fora do colors.sh
    color_definitions=$(grep -r "RED=" "$SCRIPTS_ROOT_DIR" --exclude-dir=core --exclude="validate-system.sh" 2>/dev/null | wc -l)
    print_function_definitions=$(grep -r "print_success()" "$SCRIPTS_ROOT_DIR" --exclude-dir=core --exclude="validate-system.sh" 2>/dev/null | wc -l)
    
    if [[ $color_definitions -eq 0 ]] && [[ $print_function_definitions -eq 0 ]]; then
        print_pass "Nenhuma duplicação de cores/funções encontrada"
    else
        print_fail "Ainda existem duplicações: $color_definitions cores, $print_function_definitions funções"
    fi
    
    ((VALIDATION_TOTAL++))
    print_test "Verificando uso correto do bootstrap"
    
    local scripts_with_bootstrap=$(grep -r "bootstrap.sh" "$SCRIPTS_ROOT_DIR" --include="*.sh" 2>/dev/null | wc -l)
    local total_scripts=$(find "$SCRIPTS_ROOT_DIR" -name "*.sh" 2>/dev/null | grep -v validate-system.sh | wc -l)
    
    if [[ $scripts_with_bootstrap -ge $((total_scripts - 1)) ]]; then
        print_pass "Maioria dos scripts usa bootstrap corretamente"
    else
        print_fail "Alguns scripts não usam bootstrap: $scripts_with_bootstrap/$total_scripts"
    fi
}

# =============================================================================
# FUNÇÃO PRINCIPAL
# =============================================================================

main() {
    print_header
    
    echo -e "${BLUE}🔍 Validando sistema completo sem execução...${NC}"
    echo -e "${BLUE}📍 Diretório scripts: $SCRIPTS_ROOT_DIR${NC}"
    echo
    
    # Executar todas as validações
    validate_core_system
    validate_main_scripts  
    validate_file_structure
    validate_no_duplications
    
    # Resultado final
    print_section "RESULTADO FINAL"
    
    local success_rate=$((VALIDATION_PASSED * 100 / VALIDATION_TOTAL))
    
    echo -e "${CYAN}Testes executados: $VALIDATION_TOTAL${NC}"
    echo -e "${GREEN}Testes aprovados: $VALIDATION_PASSED${NC}"
    echo -e "${YELLOW}Taxa de sucesso: $success_rate%${NC}"
    
    if [[ $VALIDATION_PASSED -eq $VALIDATION_TOTAL ]]; then
        echo
        echo -e "${GREEN}🎉 VALIDAÇÃO COMPLETA: SISTEMA 100% FUNCIONAL${NC}"
        echo -e "${GREEN}✅ Todos os scripts estão prontos para uso${NC}"
        echo -e "${GREEN}✅ Nenhuma inconsistência encontrada${NC}"
        echo -e "${GREEN}✅ Arquitetura modular implementada corretamente${NC}"
        return 0
    elif [[ $success_rate -ge 90 ]]; then
        echo
        echo -e "${YELLOW}⚠️  VALIDAÇÃO: SISTEMA QUASE PRONTO${NC}"
        echo -e "${YELLOW}⚠️  $((VALIDATION_TOTAL - VALIDATION_PASSED)) problema(s) menor(es) encontrado(s)${NC}"
        return 1
    else
        echo
        echo -e "${RED}❌ VALIDAÇÃO: SISTEMA COM PROBLEMAS${NC}"
        echo -e "${RED}❌ $((VALIDATION_TOTAL - VALIDATION_PASSED)) problema(s) encontrado(s)${NC}"
        echo -e "${RED}❌ Correções necessárias antes do uso${NC}"
        return 2
    fi
}

# Limpeza no final
cleanup() {
    [[ -f "$VALIDATION_LOG" ]] && rm -f "$VALIDATION_LOG"
}

trap cleanup EXIT

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi