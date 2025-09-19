#!/bin/bash

# =============================================================================
# setup-terminal.sh - Setup completo do terminal com ZSH e ferramentas
# Autor: Bruno Hiago
# Versão: 3.0
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

# Instalar EZA (substituto moderno do ls)
install_latest_eza() {
    local description="EZA (ls moderno)"
    
    print_step "Verificando $description"
    
    if command_exists eza; then
        local current_version=$(eza --version 2>/dev/null | head -1 | cut -d' ' -f2)
        print_info "✅ EZA já está instalado (versão: ${current_version:-unknown})"
        return 0
    fi
    
    print_progress "Instalando $description via oficial"
    
    # Instalar via cargo (Rust) para ter a versão mais recente
    if command_exists cargo; then
        cargo install eza >/dev/null 2>&1
        print_success "✅ $description instalado via Cargo"
    else
        # Fallback para apt se cargo não estiver disponível
        install_apt_package "eza" "$description"
    fi
}

# Instalar Zoxide (cd inteligente)
install_latest_zoxide() {
    local description="Zoxide (cd inteligente)"
    
    print_step "Verificando $description"
    
    if command_exists zoxide; then
        local current_version=$(zoxide --version 2>/dev/null | cut -d' ' -f2)
        print_info "✅ Zoxide já está instalado (versão: ${current_version:-unknown})"
        return 0
    fi
    
    print_progress "Instalando $description via script oficial"
    
    # Usar script oficial de instalação do Zoxide
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash >/dev/null 2>&1
    
    if command_exists zoxide; then
        print_success "✅ $description instalado com sucesso"
    else
        print_warning "⚠️  Falha na instalação oficial, tentando via apt..."
        install_apt_package "zoxide" "$description"
    fi
}

# Instalar Bat (cat melhorado)
install_latest_bat() {
    local description="Bat (cat melhorado)"
    
    print_step "Verificando $description"
    
    if command_exists bat || command_exists batcat; then
        local bat_cmd="bat"
        [[ ! -x "$(command -v bat)" ]] && bat_cmd="batcat"
        local current_version=$($bat_cmd --version 2>/dev/null | head -1 | cut -d' ' -f2)
        print_info "✅ Bat já está instalado (versão: ${current_version:-unknown})"
        return 0
    fi
    
    print_progress "Instalando $description"
    
    # Verificar arquitetura para download direto do GitHub
    local arch=$(uname -m)
    if [[ "$arch" == "x86_64" ]]; then
        # Download da versão mais recente do GitHub
        local latest_url="https://api.github.com/repos/sharkdp/bat/releases/latest"
        local download_url=$(curl -s "$latest_url" | grep -o 'https://.*amd64.*\.deb' | head -1)
        
        if [[ -n "$download_url" ]]; then
            print_info "📥 Baixando versão mais recente do GitHub..."
            local temp_file="/tmp/bat_latest.deb"
            curl -sL "$download_url" -o "$temp_file"
            sudo dpkg -i "$temp_file" >/dev/null 2>&1
            rm -f "$temp_file"
            
            if command_exists bat || command_exists batcat; then
                print_success "✅ $description instalado via GitHub"
                return 0
            fi
        fi
    fi
    
    # Fallback para apt
    install_apt_package "bat" "$description"
}

# Instalar NVM (Node Version Manager)
install_latest_nvm() {
    local description="NVM (Node Version Manager)"
    
    print_step "Verificando $description"
    
    if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
        # Source NVM para verificar versão
        source "$HOME/.nvm/nvm.sh"
        local current_version=$(nvm --version 2>/dev/null)
        print_info "✅ NVM já está instalado (versão: ${current_version:-unknown})"
        return 0
    fi
    
    print_progress "Instalando $description via script oficial"
    
    # Descobrir versão mais recente do NVM
    local latest_version=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep -o '"tag_name": "v[^"]*"' | cut -d'"' -f4)
    if [[ -z "$latest_version" ]]; then
        latest_version="v0.40.3"  # Fallback para versão conhecida
        print_info "⚠️  Usando versão fallback: $latest_version"
    else
        print_info "📥 Baixando versão mais recente: $latest_version"
    fi
    
    # Usar script oficial do NVM (versão mais recente)
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${latest_version}/install.sh" | bash >/dev/null 2>&1
    
    # Recarregar para verificar instalação
    if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
        source "$HOME/.nvm/nvm.sh"
        print_success "✅ $description instalado com sucesso"
        
        # Instalar Node.js LTS
        if is_enabled "INSTALL_NODEJS"; then
            print_info "📦 Instalando Node.js LTS..."
            nvm install --lts >/dev/null 2>&1
            nvm use --lts >/dev/null 2>&1
            print_success "✅ Node.js LTS instalado"
        fi
    else
        print_error "❌ Falha ao instalar NVM"
    fi
}

# Instalar Docker (versão oficial)
install_latest_docker() {
    local description="Docker Engine"
    
    if ! is_enabled "INSTALL_DOCKER"; then
        print_info "⏭️  Docker desabilitado (INSTALL_DOCKER=false)"
        return 0
    fi
    
    print_step "Verificando $description"
    
    if command_exists docker; then
        local current_version=$(docker --version 2>/dev/null | cut -d' ' -f3 | tr -d ',')
        print_info "✅ Docker já está instalado (versão: ${current_version:-unknown})"
        return 0
    fi
    
    print_progress "Instalando $description via script oficial"
    
    # Instalar dependências
    install_apt_package "ca-certificates" "CA Certificates"
    install_apt_package "curl" "Curl"
    install_apt_package "gnupg" "GnuPG"
    install_apt_package "lsb-release" "LSB Release"
    
    # Adicionar chave GPG oficial do Docker
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg >/dev/null 2>&1
    
    # Configurar repositório
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    
    # Atualizar e instalar
    sudo apt update >/dev/null 2>&1
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin >/dev/null 2>&1
    
    # Adicionar usuário ao grupo docker
    sudo usermod -aG docker "$USER"
    
    if command_exists docker; then
        print_success "✅ $description instalado com sucesso"
        print_info "💡 Faça logout/login para usar Docker sem sudo"
    else
        print_error "❌ Falha ao instalar Docker"
    fi
}
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
        # Usar URL oficial atualizada do Oh My Zsh
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" >/dev/null 2>&1
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
    
    # Instalar Starship prompt (versão oficial mais recente)
    print_step "Instalando Starship prompt"
    if ! command_exists starship; then
        print_info "📥 Baixando e instalando Starship via script oficial..."
        curl -sS https://starship.rs/install.sh | sh -s -- -y >/dev/null 2>&1
        print_success "✅ Starship instalado"
    else
        local current_version=$(starship --version 2>/dev/null | cut -d' ' -f2)
        print_info "⏭️  Starship já está instalado (versão: ${current_version:-unknown})"
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
    
    # Instalar ferramentas úteis e modernas
    print_step "Instalando ferramentas de desenvolvimento modernas"
    
    # Ferramentas básicas via apt
    install_apt_package "tree" "Tree (visualizador de árvore)"
    install_apt_package "htop" "Htop (monitor de sistema)"
    install_apt_package "neofetch" "Neofetch (informações do sistema)"
    install_apt_package "curl" "Curl (cliente HTTP)"
    install_apt_package "wget" "Wget (downloader)"
    install_apt_package "git" "Git (controle de versão)"
    install_apt_package "jq" "JQ (processador JSON)"
    install_apt_package "build-essential" "Build Essential (compiladores)"
    
    # Ferramentas modernas com versões mais recentes
    install_latest_bat        # cat melhorado
    install_latest_eza        # ls moderno  
    install_latest_zoxide     # cd inteligente
    install_official_fzf      # fuzzy finder
    install_latest_nvm        # Node Version Manager
    install_latest_docker     # Docker Engine
    
    # Instalar Rust/Cargo se habilitado (necessário para algumas ferramentas)
    if is_enabled "INSTALL_RUST_TOOLS"; then
        print_step "Instalando Rust e ferramentas Cargo"
        if ! command_exists cargo; then
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y >/dev/null 2>&1
            source "$HOME/.cargo/env"
            print_success "✅ Rust/Cargo instalado"
        fi
        
        # Instalar ferramentas Rust úteis
        if command_exists cargo; then
            cargo install ripgrep fd-find tokei >/dev/null 2>&1
            print_success "✅ Ferramentas Rust instaladas (ripgrep, fd-find, tokei)"
        fi
    fi
    
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