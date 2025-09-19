#!/bin/bash

# Configurações de segurança e tratamento de erros
set -euo pipefail

# bootstrap.sh - Sistema de carregamento robusto e validado
# Este é o ÚNICO arquivo que deve ser carregado pelos scripts principais
# Versão: 1.0 - Dev Senior Architecture

# =============================================================================
# CONFIGURAÇÕES DE BOOTSTRAP
# =============================================================================

# Diretório do core
CORE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Lista de dependências na ordem correta
CORE_DEPENDENCIES=("colors.sh" "utils.sh" "env-loader.sh" "paths.sh")

# =============================================================================
# SISTEMA DE CARREGAMENTO ROBUSTO
# =============================================================================

# Função para carregar dependências com validação
load_core_system() {
    local loaded_count=0
    local total_count=${#CORE_DEPENDENCIES[@]}
    
    # Primeira validação: verificar se todos os arquivos existem
    for dependency in "${CORE_DEPENDENCIES[@]}"; do
        local dep_path="$CORE_DIR/$dependency"
        if [[ ! -f "$dep_path" ]]; then
            printf "\033[0;31m❌ ERRO CRÍTICO: Dependência não encontrada: %s\033[0m\n" "$dep_path" >&2
            printf "\033[0;33m💡 Verifique se o sistema foi instalado corretamente\033[0m\n" >&2
            return 1
        fi
        
        if [[ ! -r "$dep_path" ]]; then
            printf "\033[0;31m❌ ERRO CRÍTICO: Dependência não é legível: %s\033[0m\n" "$dep_path" >&2
            return 1
        fi
    done
    
    # Segunda etapa: carregar cada dependência
    for dependency in "${CORE_DEPENDENCIES[@]}"; do
        local dep_path="$CORE_DIR/$dependency"
        local dep_name="${dependency%.sh}"
        
        printf "\033[0;36m⏳ Carregando: %s\033[0m\n" "$dep_name"
        
        # Carregar com verificação de erro
        if source "$dep_path"; then
            ((loaded_count++))
            printf "\033[0;32m✅ %s carregado com sucesso\033[0m\n" "$dep_name"
        else
            local exit_code=$?
            printf "\033[0;31m❌ ERRO ao carregar: %s (código: %d)\033[0m\n" "$dep_name" "$exit_code" >&2
            return 1
        fi
    done
    
    # Validação final
    if [[ $loaded_count -eq $total_count ]]; then
        printf "\033[1;32m🎉 Sistema CORE carregado com sucesso (%d/%d)\033[0m\n" "$loaded_count" "$total_count"
        return 0
    else
        printf "\033[0;31m❌ ERRO: Sistema CORE parcialmente carregado (%d/%d)\033[0m\n" "$loaded_count" "$total_count" >&2
        return 1
    fi
}

# Função para validar que o sistema está funcionando
validate_core_system() {
    local validation_errors=()
    
    # Testar funções de cores
    if ! declare -F print_success >/dev/null; then
        validation_errors+=("print_success não está disponível")
    fi
    
    if ! declare -F print_error >/dev/null; then
        validation_errors+=("print_error não está disponível")
    fi
    
    # Testar funções utilitárias
    if ! declare -F command_exists >/dev/null; then
        validation_errors+=("command_exists não está disponível")
    fi
    
    if ! declare -F validate_not_empty >/dev/null; then
        validation_errors+=("validate_not_empty não está disponível")
    fi
    
    # Testar funções de env
    if ! declare -F is_enabled >/dev/null; then
        validation_errors+=("is_enabled não está disponível")
    fi
    
    # Verificar variáveis de cores
    if [[ -z "${GREEN:-}" ]]; then
        validation_errors+=("Variáveis de cores não carregadas")
    fi
    
    # Reportar erros de validação
    if [[ ${#validation_errors[@]} -gt 0 ]]; then
        printf "\033[0;31m❌ ERROS DE VALIDAÇÃO:\033[0m\n" >&2
        for error in "${validation_errors[@]}"; do
            printf "\033[0;31m   - %s\033[0m\n" "$error" >&2
        done
        return 1
    fi
    
    printf "\033[0;32m✅ Validação do sistema CORE: OK\033[0m\n"
    return 0
}

# =============================================================================
# FUNÇÃO PRINCIPAL DE BOOTSTRAP
# =============================================================================

# Inicializar sistema completo
bootstrap_system() {
    printf "\033[1;36m🚀 Inicializando Sistema Dev Setup v3.0\033[0m\n"
    printf "\033[0;36m═══════════════════════════════════════\033[0m\n"
    
    # Carregar sistema core
    if ! load_core_system; then
        printf "\033[0;31m💥 FALHA CRÍTICA no carregamento do sistema\033[0m\n" >&2
        return 1
    fi
    
    # Validar sistema
    if ! validate_core_system; then
        printf "\033[0;31m💥 FALHA na validação do sistema\033[0m\n" >&2
        return 1
    fi
    
    # Inicializar sistema de configuração
    if ! init_env_system; then
        print_error "💥 FALHA na inicialização das configurações"
        return 1
    fi
    
    print_success "🎉 Sistema bootstrap concluído com sucesso!"
    print_info "✨ Todas as funções e configurações estão disponíveis"
    
    return 0
}

# =============================================================================
# FUNÇÕES DE DIAGNÓSTICO
# =============================================================================

# Diagnosticar problemas do sistema
diagnose_system() {
    printf "\033[1;33m🔍 DIAGNÓSTICO DO SISTEMA\033[0m\n"
    printf "\033[0;33m═══════════════════════════\033[0m\n"
    
    # Verificar estrutura de arquivos
    printf "\033[0;36m📁 Verificando estrutura de arquivos:\033[0m\n"
    for dependency in "${CORE_DEPENDENCIES[@]}"; do
        local dep_path="$CORE_DIR/$dependency"
        if [[ -f "$dep_path" ]]; then
            printf "\033[0;32m   ✅ %s\033[0m\n" "$dependency"
        else
            printf "\033[0;31m   ❌ %s (não encontrado)\033[0m\n" "$dependency"
        fi
    done
    
    # Verificar permissões
    printf "\033[0;36m🔒 Verificando permissões:\033[0m\n"
    if [[ -r "$CORE_DIR" ]]; then
        printf "\033[0;32m   ✅ Diretório core legível\033[0m\n"
    else
        printf "\033[0;31m   ❌ Diretório core não legível\033[0m\n"
    fi
    
    # Verificar shell
    printf "\033[0;36m🐚 Verificando shell:\033[0m\n"
    printf "\033[0;37m   Shell atual: %s\033[0m\n" "$SHELL"
    printf "\033[0;37m   Versão bash: %s\033[0m\n" "$BASH_VERSION"
    
    # Verificar variáveis de ambiente
    printf "\033[0;36m🌍 Verificando ambiente:\033[0m\n"
    printf "\033[0;37m   HOME: %s\033[0m\n" "$HOME"
    printf "\033[0;37m   PWD: %s\033[0m\n" "$PWD"
    printf "\033[0;37m   USER: %s\033[0m\n" "$USER"
}

# Mostrar informações de versão
show_version() {
    printf "\033[1;36m📋 INFORMAÇÕES DE VERSÃO\033[0m\n"
    printf "\033[0;36m══════════════════════════\033[0m\n"
    printf "\033[0;37m   Sistema: Dev Setup v3.0 - Senior Edition\033[0m\n"
    printf "\033[0;37m   Bootstrap: 1.0\033[0m\n"
    printf "\033[0;37m   Core Dir: %s\033[0m\n" "$CORE_DIR"
    printf "\033[0;37m   Dependências: %d arquivos\033[0m\n" "${#CORE_DEPENDENCIES[@]}"
    printf "\033[0;37m   Data: %s\033[0m\n" "$(date '+%Y-%m-%d %H:%M:%S')"
}

# =============================================================================
# INTERFACE DE LINHA DE COMANDO
# =============================================================================

# Função para testar sistema core
test_core_system() {
    print_module_banner "TESTE DO SISTEMA CORE" "🧪"
    
    local tests_passed=0
    local tests_total=0
    
    # Teste 1: Verificar se funções de cores existem
    ((tests_total++))
    if declare -f print_success >/dev/null 2>&1 && \
       declare -f print_error >/dev/null 2>&1 && \
       declare -f print_step >/dev/null 2>&1; then
        print_success "✅ Funções de cores carregadas"
        ((tests_passed++))
    else
        print_error "❌ Funções de cores não encontradas"
    fi
    
    # Teste 2: Verificar se funções utilitárias existem
    ((tests_total++))
    if declare -f command_exists >/dev/null 2>&1 && \
       declare -f backup_file >/dev/null 2>&1; then
        print_success "✅ Funções utilitárias carregadas"
        ((tests_passed++))
    else
        print_error "❌ Funções utilitárias não encontradas"
    fi
    
    # Teste 3: Verificar se variáveis de ambiente foram carregadas
    ((tests_total++))
    if [[ -n "${DEV_USER_NAME:-}" ]] && [[ -n "${DEV_PROJECTS_DIR:-}" ]]; then
        print_success "✅ Variáveis de ambiente carregadas"
        ((tests_passed++))
    else
        print_error "❌ Variáveis de ambiente não carregadas"
    fi
    
    # Teste 4: Verificar se paths.sh foi carregado
    ((tests_total++))
    if [[ -n "${VSCODE_CONFIG_DIR:-}" ]] && [[ -n "${TERMINAL_CONFIG_DIR:-}" ]]; then
        print_success "✅ Paths centralizados carregados"
        ((tests_passed++))
    else
        print_error "❌ Paths centralizados não carregados"
    fi
    
    # Teste 5: Verificar comandos básicos
    ((tests_total++))
    if command_exists git && command_exists curl; then
        print_success "✅ Comandos básicos disponíveis"
        ((tests_passed++))
    else
        print_error "❌ Comandos básicos não disponíveis"
    fi
    
    # Resultado final
    print_step "Resultado dos testes: $tests_passed/$tests_total"
    
    if [[ $tests_passed -eq $tests_total ]]; then
        print_success "🎉 Todos os testes passaram! Sistema funcionando perfeitamente"
        return 0
    else
        print_error "❌ Alguns testes falharam. Sistema pode não funcionar corretamente"
        return 1
    fi
}

# Processar argumentos de linha de comando
process_bootstrap_args() {
    case "${1:-}" in
        "diagnose"|"--diagnose"|"-d")
            diagnose_system
            return 0
            ;;
        "version"|"--version"|"-v")
            show_version
            return 0
            ;;
        "test"|"--test"|"-t")
            printf "\033[1;33m🧪 MODO DE TESTE\033[0m\n"
            bootstrap_system
            return $?
            ;;
        "help"|"--help"|"-h")
            printf "\033[1;36mUSO: source bootstrap.sh [opção]\033[0m\n"
            printf "\033[0;36m\nOpções:\033[0m\n"
            printf "\033[0;37m   diagnose, -d    Diagnosticar problemas\033[0m\n"
            printf "\033[0;37m   version, -v     Mostrar versão\033[0m\n"
            printf "\033[0;37m   test, -t        Executar em modo de teste\033[0m\n"
            printf "\033[0;37m   help, -h        Mostrar esta ajuda\033[0m\n"
            printf "\033[0;37m\nSem argumentos: Carregamento normal\033[0m\n"
            return 0
            ;;
        "")
            # Carregamento normal
            bootstrap_system
            return $?
            ;;
        *)
            printf "\033[0;31m❌ Argumento inválido: %s\033[0m\n" "$1" >&2
            printf "\033[0;33m💡 Use 'source bootstrap.sh help' para ver opções\033[0m\n" >&2
            return 1
            ;;
    esac
}

# =============================================================================
# EXECUÇÃO PRINCIPAL
# =============================================================================

# Se o arquivo for executado diretamente (não sourced)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    printf "\033[0;31m❌ ERRO: Este arquivo deve ser carregado com 'source'\033[0m\n" >&2
    printf "\033[0;33m💡 Use: source %s\033[0m\n" "${BASH_SOURCE[0]}" >&2
    exit 1
fi

# Se o arquivo for sourced, processar argumentos
process_bootstrap_args "$@"