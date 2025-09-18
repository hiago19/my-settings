#!/bin/bash

# paths.sh - Configuração centralizada de caminhos
# Evita caminhos hardcoded e facilita manutenção
# Versão: 1.0 - Dev Senior Architecture

# =============================================================================
# DIRETÓRIOS BASE
# =============================================================================

# Diretório raiz do projeto
readonly PROJECT_ROOT="$(cd "$(dirname "$(dirname "${BASH_SOURCE[0]}")")" && pwd)"

# Diretórios principais
readonly SCRIPTS_DIR="$PROJECT_ROOT/scripts"
readonly CONFIGS_DIR="$PROJECT_ROOT/configs"
readonly DOCS_DIR="$PROJECT_ROOT/docs"

# Diretórios core
readonly CORE_DIR="$SCRIPTS_DIR/core"

# =============================================================================
# CONFIGURAÇÕES POR CATEGORIA
# =============================================================================

# VS Code
readonly VSCODE_CONFIG_DIR="$CONFIGS_DIR/vscode"
readonly VSCODE_EXTENSIONS_FILE="$VSCODE_CONFIG_DIR/extensions.txt"
readonly VSCODE_SETTINGS_FILE="$VSCODE_CONFIG_DIR/settings.json"
readonly VSCODE_KEYBINDINGS_FILE="$VSCODE_CONFIG_DIR/keybindings.json"

# Terminal
readonly TERMINAL_CONFIG_DIR="$CONFIGS_DIR/terminal"
readonly ZSHRC_FILE="$TERMINAL_CONFIG_DIR/zshrc"
readonly STARSHIP_CONFIG_FILE="$TERMINAL_CONFIG_DIR/starship.toml"

# Git
readonly GIT_CONFIG_DIR="$CONFIGS_DIR/git"
readonly GITCONFIG_FILE="$GIT_CONFIG_DIR/gitconfig"
readonly GITIGNORE_GLOBAL_FILE="$GIT_CONFIG_DIR/gitignore_global"

# =============================================================================
# DIRETÓRIOS DO SISTEMA
# =============================================================================

# VS Code do usuário
readonly USER_VSCODE_DIR="$HOME/.config/Code/User"
readonly USER_VSCODE_SETTINGS="$USER_VSCODE_DIR/settings.json"
readonly USER_VSCODE_KEYBINDINGS="$USER_VSCODE_DIR/keybindings.json"
readonly USER_VSCODE_SNIPPETS="$USER_VSCODE_DIR/snippets"

# Configurações do shell
readonly USER_ZSHRC="$HOME/.zshrc"
readonly USER_STARSHIP_CONFIG="$HOME/.config/starship.toml"

# Git do usuário
readonly USER_GITCONFIG="$HOME/.gitconfig"

# =============================================================================
# FUNÇÕES DE VALIDAÇÃO DE CAMINHOS
# =============================================================================

# Verificar se todos os diretórios de configuração existem
validate_config_structure() {
    local missing_dirs=()
    local config_dirs=(
        "$VSCODE_CONFIG_DIR"
        "$TERMINAL_CONFIG_DIR"
        "$GIT_CONFIG_DIR"
    )
    
    print_step "Validando estrutura de configurações"
    
    for dir in "${config_dirs[@]}"; do
        if [[ ! -d "$dir" ]]; then
            missing_dirs+=("$dir")
        fi
    done
    
    if [[ ${#missing_dirs[@]} -gt 0 ]]; then
        print_warning "Diretórios de configuração faltando:"
        for dir in "${missing_dirs[@]}"; do
            print_warning "  - $dir"
        done
        return 1
    fi
    
    print_success "✅ Estrutura de configurações válida"
    return 0
}

# Verificar se arquivos de configuração essenciais existem
validate_config_files() {
    local missing_files=()
    local essential_files=(
        "$VSCODE_EXTENSIONS_FILE"
        "$ZSHRC_FILE"
        "$GITCONFIG_FILE"
    )
    
    print_step "Validando arquivos de configuração essenciais"
    
    for file in "${essential_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            missing_files+=("$file")
        fi
    done
    
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        print_warning "Arquivos de configuração faltando:"
        for file in "${missing_files[@]}"; do
            print_warning "  - $file"
        done
        return 1
    fi
    
    print_success "✅ Arquivos de configuração essenciais encontrados"
    return 0
}

# =============================================================================
# FUNÇÕES DE CRIAÇÃO DE ESTRUTURA
# =============================================================================

# Criar estrutura completa de configurações
create_config_structure() {
    print_step "Criando estrutura de configurações"
    
    local dirs_to_create=(
        "$VSCODE_CONFIG_DIR"
        "$TERMINAL_CONFIG_DIR"
        "$GIT_CONFIG_DIR"
        "$USER_VSCODE_DIR"
        "$HOME/.config"
    )
    
    for dir in "${dirs_to_create[@]}"; do
        if [[ ! -d "$dir" ]]; then
            mkdir -p "$dir"
            print_info "📁 Criado: $dir"
        fi
    done
    
    print_success "✅ Estrutura de configurações criada"
}

# =============================================================================
# FUNÇÕES DE UTILITÁRIO
# =============================================================================

# Mostrar resumo dos caminhos
show_paths_summary() {
    print_header "📁 RESUMO DOS CAMINHOS"
    
    echo -e "${BLUE}🏠 Diretórios Base:${NC}"
    echo "   Projeto: $PROJECT_ROOT"
    echo "   Scripts: $SCRIPTS_DIR"
    echo "   Configs: $CONFIGS_DIR"
    echo "   Core: $CORE_DIR"
    echo
    
    echo -e "${BLUE}💻 VS Code:${NC}"
    echo "   Config Dir: $VSCODE_CONFIG_DIR"
    echo "   Extensions: $VSCODE_EXTENSIONS_FILE"
    echo "   Settings: $VSCODE_SETTINGS_FILE"
    echo "   User Dir: $USER_VSCODE_DIR"
    echo
    
    echo -e "${BLUE}🐚 Terminal:${NC}"
    echo "   Config Dir: $TERMINAL_CONFIG_DIR"
    echo "   ZSH RC: $ZSHRC_FILE"
    echo "   Starship: $STARSHIP_CONFIG_FILE"
    echo "   User ZSH: $USER_ZSHRC"
    echo
    
    echo -e "${BLUE}📊 Git:${NC}"
    echo "   Config Dir: $GIT_CONFIG_DIR"
    echo "   Git Config: $GITCONFIG_FILE"
    echo "   Git Ignore: $GITIGNORE_GLOBAL_FILE"
    echo "   User Git: $USER_GITCONFIG"
    echo
}

# Verificar integridade completa
validate_full_structure() {
    print_header "🔍 VALIDAÇÃO COMPLETA DA ESTRUTURA"
    
    local validation_passed=true
    
    if ! validate_config_structure; then
        validation_passed=false
    fi
    
    if ! validate_config_files; then
        validation_passed=false
    fi
    
    if [[ "$validation_passed" == true ]]; then
        print_success "🎉 Estrutura completa válida!"
        return 0
    else
        print_error "❌ Problemas encontrados na estrutura"
        print_info "💡 Execute create_config_structure para corrigir"
        return 1
    fi
}

# =============================================================================
# FUNÇÃO DE AUTO-TESTE
# =============================================================================

# Testar sistema de caminhos
test_paths() {
    print_header "Teste do Sistema de Caminhos"
    
    print_step "Testando variáveis de caminho"
    echo "PROJECT_ROOT: $PROJECT_ROOT"
    echo "VSCODE_EXTENSIONS_FILE: $VSCODE_EXTENSIONS_FILE"
    echo "ZSHRC_FILE: $ZSHRC_FILE"
    
    print_step "Testando validações"
    validate_full_structure
    
    print_success "Sistema de caminhos testado!"
}

# Executar auto-teste se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Carregar dependências para os testes
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/colors.sh"
    test_paths
fi