#!/bin/bash

# Configurações de segurança e tratamento de erros
set -euo pipefail

# =============================================================================
# check-versions.sh - Verificar versões das ferramentas instaladas
# Autor: Bruno Hiago
# Versão: 1.0 - Verificação de versões atualizadas
# =============================================================================

# Carregar sistema core
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! source "$SCRIPT_DIR/../core/bootstrap.sh"; then
    printf "\033[0;31m❌ ERRO CRÍTICO: Falha ao carregar sistema core\033[0m\n" >&2
    exit 1
fi

# =============================================================================
# FUNÇÕES DE VERIFICAÇÃO DE VERSÃO
# =============================================================================

# Verificar versão do Git
check_git_version() {
    if command_exists git; then
        local current=$(git --version | cut -d' ' -f3)
        local latest=$(curl -s https://api.github.com/repos/git/git/releases/latest | grep -o '"tag_name": "v[^"]*"' | cut -d'"' -f4 | tr -d 'v')
        
        print_info "🔧 Git: $current (Última: ${latest:-unknown})"
        
        if [[ "$current" < "$latest" ]] 2>/dev/null; then
            print_warning "⚠️  Git pode ser atualizado"
        fi
    else
        print_error "❌ Git não instalado"
    fi
}

# Verificar versão do Node.js
check_node_version() {
    if command_exists node; then
        local current=$(node --version | tr -d 'v')
        local latest_lts=$(curl -s https://nodejs.org/dist/index.json | jq -r '[.[] | select(.lts != false)][0].version' | tr -d 'v')
        
        print_info "🟢 Node.js: $current (LTS: ${latest_lts:-unknown})"
    else
        print_info "⚪ Node.js não instalado"
    fi
}

# Verificar versão do Docker
check_docker_version() {
    if command_exists docker; then
        local current=$(docker --version | cut -d' ' -f3 | tr -d ',')
        print_info "🐳 Docker: $current"
    else
        print_info "⚪ Docker não instalado"
    fi
}

# Verificar versão do VS Code
check_vscode_version() {
    if command_exists code; then
        local current=$(code --version | head -1)
        print_info "💻 VS Code: $current"
    else
        print_info "⚪ VS Code não instalado"
    fi
}

# Verificar ferramentas modernas
check_modern_tools() {
    local tools=("bat" "eza" "fzf" "zoxide" "starship")
    
    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            local version_output=""
            case "$tool" in
                "bat")
                    version_output=$(bat --version 2>/dev/null | head -1 | cut -d' ' -f2)
                    ;;
                "eza")
                    version_output=$(eza --version 2>/dev/null | head -1 | cut -d' ' -f2)
                    ;;
                "fzf")
                    version_output=$(fzf --version 2>/dev/null | cut -d' ' -f1)
                    ;;
                "zoxide")
                    version_output=$(zoxide --version 2>/dev/null | cut -d' ' -f2)
                    ;;
                "starship")
                    version_output=$(starship --version 2>/dev/null | cut -d' ' -f2)
                    ;;
            esac
            
            print_info "✨ $tool: ${version_output:-unknown}"
        else
            print_warning "⚪ $tool não instalado"
        fi
    done
}

# Verificar ZSH e Oh My Zsh
check_shell_tools() {
    if command_exists zsh; then
        local zsh_version=$(zsh --version | cut -d' ' -f2)
        print_info "🐚 ZSH: $zsh_version"
        
        if [[ -d "$HOME/.oh-my-zsh" ]]; then
            local omz_version=""
            if [[ -f "$HOME/.oh-my-zsh/lib/git.zsh" ]]; then
                omz_version=$(grep "OMZ_VERSION" "$HOME/.oh-my-zsh/oh-my-zsh.sh" 2>/dev/null | cut -d'"' -f2 || echo "unknown")
            fi
            print_info "⚡ Oh My Zsh: ${omz_version:-installed}"
        else
            print_warning "⚪ Oh My Zsh não instalado"
        fi
    else
        print_warning "⚪ ZSH não instalado"
    fi
}

# Verificar Python
check_python_version() {
    if command_exists python3; then
        local current=$(python3 --version | cut -d' ' -f2)
        print_info "🐍 Python: $current"
        
        if command_exists pip3; then
            local pip_version=$(pip3 --version | cut -d' ' -f2)
            print_info "📦 pip: $pip_version"
        fi
    else
        print_warning "⚪ Python3 não instalado"
    fi
}

# =============================================================================
# FUNÇÃO PRINCIPAL
# =============================================================================

main() {
    print_module_banner "VERIFICAÇÃO DE VERSÕES" "🔍"
    
    print_step "Verificando versões das ferramentas instaladas"
    
    # Verificações básicas
    check_git_version
    check_shell_tools
    check_node_version
    check_python_version
    check_docker_version
    check_vscode_version
    
    echo ""
    print_step "Verificando ferramentas CLI modernas"
    check_modern_tools
    
    echo ""
    print_info "💡 Para atualizar ferramentas:"
    print_info "   • Git: sudo apt update && sudo apt upgrade git"
    print_info "   • Node.js: nvm install --lts && nvm use --lts"
    print_info "   • Docker: Reinstalar via script oficial"
    print_info "   • VS Code: Atualização automática ou via apt"
    print_info "   • Ferramentas modernas: Reinstalar via scripts oficiais"
    
    print_success "🎉 Verificação de versões concluída!"
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi