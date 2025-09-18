#!/bin/bash

# =============================================================================
# setup-terminal.sh - Setup completo do terminal com ZSH e ferramentas
# Autor: Bruno Hiago
# Versão: 3.0 - Dev Senior Architecture
# =============================================================================

# Carregar sistema core
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! source "$SCRIPT_DIR/../core/bootstrap.sh"; then
    printf "\033[0;31m❌ ERRO CRÍTICO: Falha ao carregar sistema core\033[0m\n" >&2
    exit 1
fi

# =============================================================================
# FUNÇÃO PRINCIPAL
# =============================================================================

# =============================================================================
# FUNÇÕES AUXILIARES
# =============================================================================

# Instalar FZF oficial da versão mais recente
install_official_fzf() {
    local description="FZF (fuzzy finder) - Versão Oficial"
    
    print_step "Verificando $description"
    
    # Verificar se já está instalado via método oficial
    if command_exists fzf && [[ -d "$HOME/.fzf" ]] && [[ -f "$HOME/.fzf/install" ]]; then
        local current_version=$(fzf --version 2>/dev/null | cut -d' ' -f1)
        print_info "✅ FZF já está instalado via método oficial (versão: ${current_version:-unknown})"
        
        # Verificar se é uma versão recente (>= 0.40.0 suporta --zsh)
        local version_number=$(echo "$current_version" | grep -o '^[0-9]\+\.[0-9]\+' | head -1)
        if [[ -n "$version_number" ]]; then
            local major=$(echo "$version_number" | cut -d. -f1)
            local minor=$(echo "$version_number" | cut -d. -f2)
            
            # Versão >= 0.40 suporta --zsh
            if [[ "$major" -gt 0 ]] || [[ "$major" -eq 0 && "$minor" -ge 40 ]]; then
                print_info "⏭️  Versão suporta todas as funcionalidades modernas (--zsh)"
                return 0
            else
                print_info "🔄 Versão antiga detectada, atualizando..."
            fi
        else
            print_info "🔄 Atualizando para garantir compatibilidade..."
        fi
    fi
    
    print_progress "Instalando/Atualizando $description"
    
    # Remover instalação via apt se existir (pode causar conflito)
    if package_installed "fzf"; then
        print_info "🔄 Removendo versão apt do FZF para usar versão oficial..."
        sudo apt remove -y fzf >/dev/null 2>&1
    fi
    
    # Clonar ou atualizar repositório oficial
    if [[ -d "$HOME/.fzf" ]]; then
        print_info "📁 Atualizando repositório existente..."
        cd "$HOME/.fzf" && git pull >/dev/null 2>&1
    else
        print_info "📥 Clonando repositório oficial do FZF..."
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" >/dev/null 2>&1
    fi
    
    # Executar instalação oficial
    if [[ -d "$HOME/.fzf" ]]; then
        print_info "⚙️  Executando instalação oficial..."
        "$HOME/.fzf/install" --all >/dev/null 2>&1
        
        # Verificar se foi instalado com sucesso
        if command_exists fzf; then
            local installed_version=$(fzf --version 2>/dev/null | cut -d' ' -f1)
            print_success "✅ $description instalado com sucesso (versão: ${installed_version:-unknown})"
            print_info "💡 FZF instalado em ~/.fzf com suporte completo ao --zsh"
            return 0
        else
            print_error "❌ Instalação falhou - FZF não está disponível"
            return 1
        fi
    else
        print_error "❌ Falha ao clonar repositório do FZF"
        return 1
    fi
}

# =============================================================================
# FUNÇÃO PRINCIPAL
# =============================================================================

main() {
    print_module_banner "SETUP TERMINAL COMPLETO" "🚀"
    
    print_info "🔍 Sistema detectado: $(detect_os)"
    
    # Verificar se não está executando como root
    check_not_root
    
    # Atualizar sistema
    print_step "Atualizando sistema"
    update_package_list
    
    # Instalar ZSH
    print_step "Configurando ZSH"
    install_apt_package "zsh" "ZSH Shell"
    
    # Instalar Oh My Zsh se não existir
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        print_step "Instalando Oh My Zsh"
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null 2>&1
        print_success "✅ Oh My Zsh instalado"
    else
        print_info "⏭️  Oh My Zsh já está instalado"
    fi
    
    # Configurar plugins do ZSH
    print_step "Instalando plugins do ZSH"
    
    # zsh-autosuggestions
    local autosuggestions_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    if [[ ! -d "$autosuggestions_dir" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions "$autosuggestions_dir" >/dev/null 2>&1
        print_success "✅ zsh-autosuggestions instalado"
    fi
    
    # zsh-syntax-highlighting
    local highlighting_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
    if [[ ! -d "$highlighting_dir" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$highlighting_dir" >/dev/null 2>&1
        print_success "✅ zsh-syntax-highlighting instalado"
    fi
    
    # Instalar Starship prompt
    print_step "Instalando Starship prompt"
    if ! command_exists starship; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y >/dev/null 2>&1
        print_success "✅ Starship instalado"
    else
        print_info "⏭️  Starship já está instalado"
    fi
    
    # Copiar configurações
    print_step "Aplicando configurações do terminal"
    
    # Verificar se já tem configuração personalizada
    if [[ -f "$HOME/.zshrc" ]] && grep -q "oh-my-zsh\|starship\|custom" "$HOME/.zshrc" 2>/dev/null; then
        print_info "🔍 Configuração personalizada do ZSH detectada"
        print_info "⏭️  Pulando aplicação de templates (configuração existente preservada)"
    else
        # Aplicar .zshrc se existir
        if [[ -f "$ZSHRC_FILE" ]]; then
            backup_file "$HOME/.zshrc"
            cp "$ZSHRC_FILE" "$HOME/.zshrc"
            print_success "✅ .zshrc aplicado"
        else
            print_warning "⚠️  Arquivo $ZSHRC_FILE não encontrado"
        fi
        
        # Aplicar configuração Starship se existir
        if [[ -f "$STARSHIP_CONFIG_FILE" ]]; then
            ensure_directory "$HOME/.config"
            backup_file "$HOME/.config/starship.toml"
            cp "$STARSHIP_CONFIG_FILE" "$HOME/.config/starship.toml"
            print_success "✅ Configuração Starship aplicada"
        else
            print_warning "⚠️  Arquivo $STARSHIP_CONFIG_FILE não encontrado"
        fi
    fi
    
    # Instalar ferramentas úteis
    print_step "Instalando ferramentas de desenvolvimento"
    install_apt_package "tree" "Tree (visualizador de árvore)"
    install_apt_package "htop" "Htop (monitor de sistema)"
    install_apt_package "neofetch" "Neofetch (informações do sistema)"
    install_apt_package "bat" "Bat (cat melhorado)"
    install_official_fzf
    
    # Definir ZSH como shell padrão
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        print_step "Definindo ZSH como shell padrão"
        chsh -s "$(which zsh)"
        print_success "✅ ZSH definido como shell padrão"
        print_warning "⚠️  IMPORTANTE: Faça logout/login para aplicar a mudança"
    else
        print_info "⏭️  ZSH já é o shell padrão"
    fi
    
    print_success "🎉 Setup do terminal concluído com sucesso!"
    print_info "💡 Próximos passos:"
    print_info "   1. Faça logout e login novamente"
    print_info "   2. Abra um novo terminal para ver as mudanças"
    print_info "   3. Configure seu tema VS Code com: $DEV_VSCODE_THEME"
    print_info "   4. Configure sua fonte com: $DEV_FONT_NAME"
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi