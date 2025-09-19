#!/bin/bash

# setup-complete.sh - Orquestrador principal do setup completo
# Autor: Bruno Hiago
# Versão: 3.0 - Modular com bootstrap system

# =============================================================================
# CARREGAMENTO DO SISTEMA
# =============================================================================

# Carregar sistema core com validação rigorosa
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! source "$SCRIPT_DIR/../core/bootstrap.sh"; then
    printf "\033[0;31m💥 ERRO CRÍTICO: Sistema core não pôde ser carregado\033[0m\n" >&2
    printf "\033[0;33m💡 Verifique se todos os arquivos estão presentes\033[0m\n" >&2
    exit 1
fi

# Carregar configuração de caminhos
source "$SCRIPT_DIR/../core/paths.sh"

# =============================================================================
# CONFIGURAÇÕES DO ORQUESTRADOR
# =============================================================================

# Lista de módulos disponíveis (ordem de execução)
readonly MODULES=(
    "terminal:terminal.sh:Terminal Tools e ZSH"
    "vscode:vscode.sh:Visual Studio Code"
    "extensions:install-extensions.sh:Extensões VS Code"
)

# =============================================================================
# FUNÇÕES DE VERIFICAÇÃO
# =============================================================================

# Verificar pré-requisitos do sistema
check_prerequisites() {
    print_step "Verificando pré-requisitos do sistema"
    
    # Não executar como root
    check_not_root
    
    # Verificar sistema operacional
    local os_type
    os_type=$(detect_os)
    case $os_type in
        "WSL2")
            ENV_TYPE="WSL2"
            print_info "✅ Sistema: WSL2 detectado"
            ;;
        "LINUX")
            ENV_TYPE="LINUX"
            print_info "✅ Sistema: Linux nativo detectado"
            ;;
        *)
            print_error "❌ Sistema não suportado: $os_type"
            print_info "💡 Este script funciona apenas no WSL2 ou Linux"
            return 1
            ;;
    esac
    
    # Verificar conexão com internet
    if ! check_internet; then
        print_error "❌ Sem conexão com internet"
        print_info "💡 Conexão necessária para download de pacotes"
        return 1
    fi
    
    # Verificar dependências básicas
    if ! check_dependencies; then
        return 1
    fi
    
    # Verificar estrutura de configurações
    if ! validate_full_structure; then
        print_warning "⚠️  Estrutura de configurações incompleta"
        print_step "Criando estrutura necessária"
        create_config_structure
    fi
    
    print_success "✅ Todos os pré-requisitos verificados"
    return 0
}

# =============================================================================
# FUNÇÃO PRINCIPAL
# =============================================================================

main() {
    # Verificar pré-requisitos
    if ! check_prerequisites; then
        print_error "� Pré-requisitos não atendidos"
        exit 1
    fi
    
    # Menu simples por enquanto
    print_main_banner
    print_info "🎯 Setup Dev Completo iniciado"
    
    # Executar todos os módulos (versão simplificada)
    for module in "${MODULES[@]}"; do
        local module_name="${module%%:*}"
        local module_script="${module#*:}"
        module_script="${module_script%%:*}"
        local module_desc="${module##*:}"
        
        print_header "🔧 EXECUTANDO: $module_desc"
        
        local script_path="$SCRIPT_DIR/$module_script"
        
        if [[ -f "$script_path" ]]; then
            chmod +x "$script_path"
            bash "$script_path"
        else
            print_warning "⚠️  Script não encontrado: $script_path"
        fi
    done
    
    print_success "🎉 Setup concluído!"
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

# ================================================
# VERIFICAÇÕES E VALIDAÇÕES
# ================================================

# Verificar pré-requisitos
check_prerequisites() {
    print_step "Verificando pré-requisitos..."
    
    # Não executar como root
    check_not_root
    
    # Verificar sistema operacional
    local os_type=$(detect_os)
    case $os_type in
        "WSL2")
            ENV_TYPE="WSL2"
            print_info "Sistema: WSL2 detectado"
            ;;
        "LINUX")
            ENV_TYPE="LINUX"
            print_info "Sistema: Linux nativo detectado"
            ;;
        *)
            print_error "Sistema não suportado: $os_type"
            print_info "Este script funciona apenas no WSL2 ou Linux"
            exit 1
            ;;
    esac
    
    # Verificar internet
    if ! check_internet; then
        print_error "Sem conexão com internet"
        print_info "Conexão necessária para download de pacotes"
        exit 1
    fi
    
    # Verificar dependências básicas
    if ! check_dependencies; then
        exit 1
    fi
    
    print_status "Pré-requisitos verificados com sucesso"
}

print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar ambiente
check_environment() {
    print_step "Verificando ambiente..."
    
    # Verificar se está no WSL/Linux
    if [[ -f /proc/version ]] && grep -q Microsoft /proc/version; then
        ENV_TYPE="WSL2"
        print_info "Ambiente detectado: WSL2"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        ENV_TYPE="LINUX"
        print_info "Ambiente detectado: Linux nativo"
    else
        print_error "Este script deve ser executado no WSL2 ou Linux"
        exit 1
    fi
    
    # Verificar internet
    if ping -c 1 google.com &> /dev/null; then
        print_status "Conexão com internet verificada"
    else
        print_error "Sem conexão com internet"
        exit 1
    fi
}

# Menu de seleção
show_menu() {
    echo -e "${CYAN}"
    echo "═══════════════════════════════════════════════════════"
    echo "              ESCOLHA O QUE INSTALAR"
    echo "═══════════════════════════════════════════════════════"
    echo -e "${NC}"
    echo "1) 🖥️ Setup Terminal Completo (WSL2 + ZSH + Ferramentas)"
    echo "2) 💻 Setup VS Code (Extensões + Configurações)"
    echo "3) 📝 Setup Sublime Text (Pacotes + Configurações)" 
    echo "4) 🔧 Instalar Ferramentas de Desenvolvimento"
    echo "5) 🚀 SETUP COMPLETO (Tudo acima)"
    echo "6) ⚙️ Ver/Editar Configurações"
    echo "7) 📋 Criar Configuração Personalizada"
    echo "8) ❌ Sair"
    echo
    echo -e "${YELLOW}Digite sua escolha (1-8):${NC} "
}

# ================================================
# FUNÇÕES DE SETUP MODULARES
# ================================================

# Setup do Terminal (chama script específico)
setup_terminal() {
    print_header "🖥️  SETUP DO TERMINAL"
    
    local terminal_script="$SCRIPT_DIR/modules/terminal.sh"
    
    if [[ -f "$terminal_script" ]]; then
        print_info "Executando setup do terminal..."
        chmod +x "$terminal_script"
        
        if "$terminal_script"; then
            print_status "Setup do terminal concluído com sucesso"
        else
            print_error "Falha no setup do terminal"
            return 1
        fi
    else
        print_error "Script terminal.sh não encontrado"
        print_info "Caminho esperado: $terminal_script"
        return 1
    fi
}

# Setup do VS Code (chama script específico)
setup_vscode() {
    print_header "💻 SETUP DO VS CODE"

    local vscode_script="$SCRIPT_DIR/modules/vscode.sh"

    if [[ -f "$vscode_script" ]]; then
        print_info "Executando setup do VS Code..."
        chmod +x "$vscode_script"
        
        if "$vscode_script"; then
            print_status "Setup do VS Code concluído com sucesso"
        else
            print_error "Falha no setup do VS Code"
            return 1
        fi
    else
        print_error "Script vscode.sh não encontrado"
        print_info "Caminho esperado: $vscode_script"
        return 1
    fi
}

# Setup do Sublime Text (integrado - mais simples)
setup_sublime() {
    print_header "📝 SETUP DO SUBLIME TEXT"
    
    # Verificar se já está instalado
    if command_exists subl; then
        print_info "Sublime Text já está instalado"
    else
        print_info "Instalando Sublime Text..."
        
        # Adicionar repositório e instalar
        if wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null; then
            echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
            sudo apt-get update
            
            if install_apt_package "sublime-text" "Sublime Text"; then
                print_status "Sublime Text instalado com sucesso"
            else
                print_error "Falha ao instalar Sublime Text"
                return 1
            fi
        else
            print_error "Falha ao adicionar repositório do Sublime Text"
            return 1
        fi
    fi
    
    # Aplicar configurações se habilitado
    if is_enabled "INSTALL_SUBLIME_PACKAGES"; then
        print_info "Configurando Sublime Text..."
        
        # Detectar diretório de configuração
        local st_config_dir="$HOME/.config/sublime-text/Packages/User"
        ensure_directory "$st_config_dir"
        ensure_directory "$(dirname "$st_config_dir")/Installed Packages"
        
        # Instalar Package Control se não existir
        local package_control_file="$(dirname "$st_config_dir")/Installed Packages/Package Control.sublime-package"
        if [[ ! -f "$package_control_file" ]]; then
            print_info "Instalando Package Control..."
            download_file \
                "https://packagecontrol.io/Package%20Control.sublime-package" \
                "$package_control_file" \
                "Package Control"
        fi
        
        print_status "Sublime Text configurado"
    fi
}

# Setup do Terminal
setup_terminal() {
    print_step "Iniciando setup do terminal..."
    
    # Verificar se script existe
    if [ -f "scripts/modules/terminal.sh" ]; then
        chmod +x scripts/modules/terminal.sh
        ./scripts/modules/terminal.sh
    else
        print_info "Baixando script do terminal..."
        curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/modules/terminal.sh | bash
    fi
    
    print_status "Setup do terminal concluído"
}

# Setup do VS Code
setup_vscode() {
    print_step "Iniciando setup do VS Code..."
    
    # Verificar se VS Code está instalado
    if ! command_exists code; then
        print_warning "VS Code não encontrado. Instalando..."
        
        # Instalar VS Code
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        sudo apt update
        sudo apt install -y code
        
        print_status "VS Code instalado"
    fi
    
    # Instalar extensões
    if [ -f "scripts/tools/install-extensions.sh" ]; then
        chmod +x scripts/tools/install-extensions.sh
        ./scripts/tools/install-extensions.sh
    else
        print_info "Baixando e instalando extensões..."
        curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/tools/install-extensions.sh | bash
    fi
    
    # Aplicar configurações
    print_info "Aplicando configurações do VS Code..."
    
    # Backup das configurações existentes
    if [ -f "$HOME/.config/Code/User/settings.json" ]; then
        cp "$HOME/.config/Code/User/settings.json" "$HOME/.config/Code/User/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Criar diretório se não existir
    mkdir -p "$HOME/.config/Code/User"
    
    # Baixar configurações
    if [ -f "configs/vscode-settings.json" ]; then
        cp configs/vscode-settings.json "$HOME/.config/Code/User/settings.json"
    else
        curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/configs/vscode-settings.json -o "$HOME/.config/Code/User/settings.json"
    fi
    
    if [ -f "configs/vscode-keybindings.json" ]; then
        cp configs/vscode-keybindings.json "$HOME/.config/Code/User/keybindings.json"
    else
        curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/configs/vscode-keybindings.json -o "$HOME/.config/Code/User/keybindings.json"
    fi
    
    print_status "Setup do VS Code concluído"
}

# Setup do Sublime Text
setup_sublime() {
    print_step "Iniciando setup do Sublime Text..."
    
    # Verificar se Sublime está instalado
    if ! command_exists subl; then
        print_warning "Sublime Text não encontrado. Instalando..."
        
        # Instalar Sublime Text
        wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
        echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
        sudo apt-get update
        sudo apt-get install -y sublime-text
        
        print_status "Sublime Text instalado"
    fi
    
    # Aplicar configurações
    print_info "Aplicando configurações do Sublime Text..."
    
    # Detectar diretório do Sublime
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        ST_PATH="$HOME/.config/sublime-text/Packages/User"
    else
        print_error "Sistema não suportado para configuração do Sublime Text"
        return 1
    fi
    
    # Criar diretórios
    mkdir -p "$ST_PATH"
    mkdir -p "$ST_PATH/../Installed Packages"
    
    # Backup das configurações existentes
    if [ -f "$ST_PATH/Preferences.sublime-settings" ]; then
        cp "$ST_PATH/Preferences.sublime-settings" "$ST_PATH/Preferences.sublime-settings.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Baixar configurações
    if [ -f "configs/sublime-preferences.json" ]; then
        cp configs/sublime-preferences.json "$ST_PATH/Preferences.sublime-settings"
    else
        curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/configs/sublime-preferences.json -o "$ST_PATH/Preferences.sublime-settings"
    fi
    
    if [ -f "configs/sublime-keymap.json" ]; then
        cp configs/sublime-keymap.json "$ST_PATH/Default.sublime-keymap"
    else
        curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/configs/sublime-keymap.json -o "$ST_PATH/Default.sublime-keymap"
    fi
    
    # Instalar Package Control
    if [ ! -f "$ST_PATH/../Installed Packages/Package Control.sublime-package" ]; then
        print_info "Instalando Package Control..."
        curl -fsSL https://packagecontrol.io/Package%20Control.sublime-package -o "$ST_PATH/../Installed Packages/Package Control.sublime-package"
    fi
    
    print_status "Setup do Sublime Text concluído"
}

# Ferramentas de desenvolvimento (instalação inteligente)
install_dev_tools() {
    print_header "🔧 FERRAMENTAS DE DESENVOLVIMENTO"
    
    # Docker
    if is_enabled "INSTALL_DOCKER"; then
        if command_exists docker; then
            print_info "Docker já está instalado"
            docker --version
        else
            print_info "Instalando Docker..."
            
            # Remover versões antigas
            sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true
            
            # Instalar dependências
            install_apt_packages ca-certificates curl gnupg lsb-release
            
            # Adicionar chave GPG
            sudo mkdir -p /etc/apt/keyrings
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
            
            # Adicionar repositório
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
            
            # Instalar Docker
            sudo apt-get update
            if install_apt_packages docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin; then
                # Adicionar usuário ao grupo docker
                sudo usermod -aG docker $USER
                print_status "Docker instalado com sucesso"
                print_warning "Faça logout/login para usar Docker sem sudo"
            else
                print_error "Falha ao instalar Docker"
            fi
        fi
    fi
    
    # Ferramentas CLI configuráveis
    if [[ -n "$CLI_TOOLS" ]]; then
        print_info "Instalando ferramentas CLI configuradas..."
        
        # Converter string em array
        IFS=' ' read -ra tools_array <<< "$CLI_TOOLS"
        
        # Separar ferramentas por método de instalação
        local apt_tools=()
        local special_tools=()
        
        for tool in "${tools_array[@]}"; do
            case "$tool" in
                "bat"|"eza"|"zoxide"|"fzf"|"ripgrep"|"fd-find")
                    special_tools+=("$tool")
                    ;;
                *)
                    apt_tools+=("$tool")
                    ;;
            esac
        done
        
        # Instalar ferramentas via apt
        if [[ ${#apt_tools[@]} -gt 0 ]]; then
            install_apt_packages "${apt_tools[@]}"
        fi
        
        # Instalar ferramentas especiais
        for tool in "${special_tools[@]}"; do
            case "$tool" in
                "bat")
                    if ! command_exists batcat && ! command_exists bat; then
                        install_apt_package "bat" "Bat (cat melhorado)"
                    fi
                    ;;
                "eza")
                    if ! command_exists eza; then
                        print_info "Instalando eza (ls melhorado)..."
                        if download_file "https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz" "/tmp/eza.tar.gz" "eza"; then
                            cd /tmp && tar xzf eza.tar.gz && sudo mv eza /usr/local/bin/
                            print_status "Eza instalado"
                        fi
                    fi
                    ;;
                "zoxide")
                    if ! command_exists zoxide; then
                        install_from_script "https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh" "zoxide"
                    fi
                    ;;
                "fzf")
                    if [[ ! -d "$HOME/.fzf" ]]; then
                        print_info "Instalando FZF..."
                        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
                        ~/.fzf/install --all --no-bash --no-fish
                        print_status "FZF instalado"
                    fi
                    ;;
            esac
        done
    fi
    
    # Pacotes Python configuráveis
    if [[ -n "$PYTHON_PACKAGES" ]] && command_exists pip3; then
        print_info "Instalando pacotes Python configurados..."
        IFS=' ' read -ra python_packages <<< "$PYTHON_PACKAGES"
        
        for package in "${python_packages[@]}"; do
            install_python_package "$package"
        done
    fi
    
    # Pacotes NPM configuráveis
    if [[ -n "$NPM_GLOBAL_PACKAGES" ]] && command_exists npm; then
        print_info "Instalando pacotes NPM globais configurados..."
        IFS=' ' read -ra npm_packages <<< "$NPM_GLOBAL_PACKAGES"
        
        for package in "${npm_packages[@]}"; do
            install_npm_package "$package"
        done
    fi
    
    print_status "Ferramentas de desenvolvimento instaladas"
}

# Criar arquivos de configuração
create_config_files() {
    print_step "Criando arquivos de configuração..."
    
    # Criar diretório de configs se não existir
    mkdir -p configs
    
    # .gitconfig global
    if [ ! -f "$HOME/.gitconfig" ]; then
        cat > "$HOME/.gitconfig" << 'EOF'
[user]
    # Configure com: git config --global user.name "Seu Nome"
    # Configure com: git config --global user.email "seu.email@exemplo.com"

[core]
    editor = code --wait
    autocrlf = input
    safecrlf = true

[init]
    defaultBranch = main

[pull]
    rebase = false

[push]
    default = simple

[alias]
    st = status
    co = checkout
    br = branch
    ci = commit
    unstage = reset HEAD --
    last = log -1 HEAD
    visual = !gitk
    lg = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit

[color]
    ui = auto
EOF
        print_status "Arquivo .gitconfig criado"
    fi
    
    print_status "Arquivos de configuração criados"
}

# Verificar instalações
verify_installation() {
    print_step "Verificando instalações..."
    
    echo -e "${BLUE}Versões instaladas:${NC}"
    
    # Terminal tools
    if command_exists zsh; then
        echo "  ✓ ZSH: $(zsh --version)"
    fi
    
    if command_exists starship; then
        echo "  ✓ Starship: $(starship --version)"
    fi
    
    # Development tools
    if command_exists git; then
        echo "  ✓ Git: $(git --version)"
    fi
    
    if command_exists node; then
        echo "  ✓ Node.js: $(node --version)"
    fi
    
    if command_exists python3; then
        echo "  ✓ Python: $(python3 --version)"
    fi
    
    if command_exists docker; then
        echo "  ✓ Docker: $(docker --version)"
    fi
    
    # Editors
    if command_exists code; then
        echo "  ✓ VS Code: $(code --version | head -1)"
    fi
    
    if command_exists subl; then
        echo "  ✓ Sublime Text: Instalado"
    fi
    
    print_status "Verificação concluída"
}

# Mostrar resumo final
show_summary() {
    echo
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}               🎉 SETUP COMPLETO! 🎉${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo
    
    print_info "O que foi instalado e configurado:"
    echo "  🖥️  Terminal com ZSH + Oh My Zsh + Starship"
    echo "  🔧 Ferramentas CLI: bat, eza, zoxide, fzf"
    echo "  📦 Node.js + NVM + ferramentas globais"
    echo "  🐍 Python + pip + ferramentas de desenvolvimento"
    echo "  🐳 Docker + Docker Compose"
    echo "  💻 VS Code + extensões + configurações"
    echo "  📝 Sublime Text + Package Control + configurações"
    echo "  ⚙️  Git configurado"
    echo
    
    print_warning "Próximos passos:"
    echo "  1. Reinicie o terminal: source ~/.zshrc"
    echo "  2. Configure seu Git: git config --global user.name 'Seu Nome'"
    echo "  3. Configure seu Git: git config --global user.email 'seu@email.com'"
    echo "  4. Configure SSH key: ssh-keygen -t ed25519 -C 'seu@email.com'"
    echo "  5. Se instalou Docker, faça logout/login para usar sem sudo"
    echo
    
    if [[ "$ENV_TYPE" == "WSL2" ]]; then
        print_info "Configurações específicas do WSL2:"
        echo "  • Configure Windows Terminal com FiraCode Nerd Font"
        echo "  • Considere instalar Windows Terminal Preview"
        echo "  • Configure Docker Desktop para integração com WSL2"
    fi
    
    echo
    print_status "🚀 Ambiente de desenvolvimento configurado com sucesso!"
    print_status "Happy coding! 💻✨"
    echo
}

# Gerenciar configurações
manage_config() {
    echo
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}         🔧 GERENCIAR CONFIGURAÇÕES 🔧${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo
    
    echo "1. Ver configurações atuais"
    echo "2. Editar configurações"
    echo "3. Resetar para padrões"
    echo "4. Criar backup das configurações"
    echo "5. Restaurar backup"
    echo "6. Voltar ao menu principal"
    echo
    echo -n "Escolha uma opção: "
    read -r config_choice
    
    case $config_choice in
        1)
            show_current_config
            ;;
        2)
            edit_config_file
            ;;
        3)
            reset_to_defaults
            ;;
        4)
            backup_config
            ;;
        5)
            restore_config
            ;;
        6)
            return
            ;;
        *)
            print_error "Opção inválida"
            ;;
    esac
}

# Mostrar configurações atuais
show_current_config() {
    echo
    print_info "📋 Configurações Atuais:"
    echo
    
    echo -e "${YELLOW}ZSH Plugins:${NC}"
    echo "  $ZSH_PLUGINS"
    echo
    
    echo -e "${YELLOW}CLI Tools:${NC}"
    echo "  $CLI_TOOLS"
    echo
    
    echo -e "${YELLOW}VS Code Extensions (Essential):${NC}"
    echo "  $VSCODE_EXTENSIONS_ESSENTIAL"
    echo
    
    echo -e "${YELLOW}Theme & Font:${NC}"
    echo "  Starship Theme: $STARSHIP_THEME"
    echo "  Terminal Font: $TERMINAL_FONT"
    echo
    
    echo -e "${YELLOW}Performance:${NC}"
    echo "  Fast Node Modules: $FAST_NODE_MODULES"
    echo "  Skip Heavy Installs: $SKIP_HEAVY_INSTALLS"
    echo
    
    echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
    read
}

# Editar arquivo de configuração
edit_config_file() {
    local config_file="$PROJECT_ROOT/configs/dev-settings.sh"
    
    if command_exists code; then
        print_info "Abrindo configurações no VS Code..."
        code "$config_file"
    elif command_exists nano; then
        print_info "Abrindo configurações no nano..."
        nano "$config_file"
    elif command_exists vim; then
        print_info "Abrindo configurações no vim..."
        vim "$config_file"
    else
        print_warning "Editor não encontrado. Caminho do arquivo:"
        echo "$config_file"
    fi
    
    echo
    echo -e "${YELLOW}Após editar, pressione Enter para recarregar as configurações...${NC}"
    read
    
    # Recarregar configurações
    source "$config_file"
    validate_config
    print_status "Configurações recarregadas!"
}

# Resetar para configurações padrão
reset_to_defaults() {
    echo
    print_warning "⚠️  Isso irá resetar TODAS as configurações para os valores padrão."
    echo -n "Tem certeza? (y/N): "
    read -r confirm
    
    if [[ $confirm =~ ^[Yy]$ ]]; then
        local config_file="$PROJECT_ROOT/configs/dev-settings.sh"
        local backup_file="$config_file.backup.$(date +%Y%m%d_%H%M%S)"
        
        # Fazer backup atual
        cp "$config_file" "$backup_file"
        print_info "Backup criado: $backup_file"
        
        # Criar arquivo com configurações padrão
        create_default_config "$config_file"
        
        # Recarregar
        source "$config_file"
        validate_config
        
        print_status "✅ Configurações resetadas para os padrões!"
    else
        print_info "Operação cancelada."
    fi
}

# Criar backup das configurações
backup_config() {
    local config_file="$PROJECT_ROOT/configs/dev-settings.sh"
    local backup_dir="$PROJECT_ROOT/backups"
    local backup_file="$backup_dir/dev-settings_$(date +%Y%m%d_%H%M%S).sh"
    
    mkdir -p "$backup_dir"
    
    if cp "$config_file" "$backup_file"; then
        print_status "✅ Backup criado: $backup_file"
    else
        print_error "❌ Erro ao criar backup!"
    fi
    
    echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
    read
}

# Restaurar backup
restore_config() {
    local backup_dir="$PROJECT_ROOT/backups"
    
    if [[ ! -d "$backup_dir" ]]; then
        print_error "Nenhum backup encontrado!"
        return
    fi
    
    echo
    print_info "📁 Backups disponíveis:"
    local backups=($(ls -1 "$backup_dir"/dev-settings_*.sh 2>/dev/null))
    
    if [[ ${#backups[@]} -eq 0 ]]; then
        print_error "Nenhum backup encontrado!"
        return
    fi
    
    for i in "${!backups[@]}"; do
        local filename=$(basename "${backups[$i]}")
        echo "$((i+1)). $filename"
    done
    
    echo
    echo -n "Escolha um backup para restaurar (1-${#backups[@]}): "
    read -r backup_choice
    
    if [[ "$backup_choice" -ge 1 && "$backup_choice" -le ${#backups[@]} ]]; then
        local selected_backup="${backups[$((backup_choice-1))]}"
        local config_file="$PROJECT_ROOT/configs/dev-settings.sh"
        
        echo
        print_warning "⚠️  Isso irá substituir as configurações atuais."
        echo -n "Continuar? (y/N): "
        read -r confirm
        
        if [[ $confirm =~ ^[Yy]$ ]]; then
            if cp "$selected_backup" "$config_file"; then
                source "$config_file"
                validate_config
                print_status "✅ Configurações restauradas!"
            else
                print_error "❌ Erro ao restaurar backup!"
            fi
        else
            print_info "Operação cancelada."
        fi
    else
        print_error "Opção inválida!"
    fi
}

# Criar configuração personalizada
create_custom_config() {
    echo
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}        📋 CRIAR CONFIGURAÇÃO PERSONALIZADA 📋${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo
    
    print_info "Vamos criar uma configuração personalizada para você!"
    echo
    
    # Perguntar sobre ZSH plugins
    echo -e "${YELLOW}🔌 ZSH Plugins:${NC}"
    echo "Plugins padrão: git z zsh-autosuggestions zsh-syntax-highlighting"
    echo -n "Deseja adicionar plugins extras? (digite os nomes separados por espaço, ou Enter para manter padrão): "
    read -r extra_plugins
    
    # Perguntar sobre CLI tools
    echo
    echo -e "${YELLOW}🛠️  CLI Tools:${NC}"
    echo "Tools padrão: curl wget git vim nano htop tree bat eza zoxide fzf ripgrep fd-find"
    echo -n "Deseja adicionar tools extras? (digite os nomes separados por espaço, ou Enter para manter padrão): "
    read -r extra_tools
    
    # Perguntar sobre VS Code extensions
    echo
    echo -e "${YELLOW}💻 VS Code Extensions:${NC}"
    echo "1. Apenas essenciais (recomendado)"
    echo "2. Essenciais + Linguagens"
    echo "3. Essenciais + Linguagens + Ferramentas"
    echo "4. Tudo (completo)"
    echo -n "Escolha o nível de extensões (1-4): "
    read -r extension_level
    
    # Perguntar sobre tema
    echo
    echo -e "${YELLOW}🎨 Tema do Starship:${NC}"
    echo "1. default (padrão)"
    echo "2. minimal"
    echo "3. pure"
    echo "4. tokyo-night"
    echo -n "Escolha o tema (1-4): "
    read -r theme_choice
    
    # Perguntar sobre performance
    echo
    echo -e "${YELLOW}⚡ Configurações de Performance:${NC}"
    echo -n "Ativar modo rápido (pula algumas instalações pesadas)? (y/N): "
    read -r fast_mode
    
    # Gerar configuração personalizada
    echo
    print_info "Gerando configuração personalizada..."
    
    local config_file="$PROJECT_ROOT/configs/dev-settings-custom.sh"
    local custom_plugins="$ZSH_PLUGINS $extra_plugins"
    local custom_tools="$CLI_TOOLS $extra_tools"
    
    # Definir extensões baseado na escolha
    local custom_extensions=""
    case $extension_level in
        1) custom_extensions="$VSCODE_EXTENSIONS_ESSENTIAL" ;;
        2) custom_extensions="$VSCODE_EXTENSIONS_ESSENTIAL $VSCODE_EXTENSIONS_LANGUAGE" ;;
        3) custom_extensions="$VSCODE_EXTENSIONS_ESSENTIAL $VSCODE_EXTENSIONS_LANGUAGE $VSCODE_EXTENSIONS_TOOLS" ;;
        4) custom_extensions="$VSCODE_EXTENSIONS_ESSENTIAL $VSCODE_EXTENSIONS_LANGUAGE $VSCODE_EXTENSIONS_TOOLS $VSCODE_EXTENSIONS_ADVANCED" ;;
    esac
    
    # Definir tema
    local custom_theme
    case $theme_choice in
        1) custom_theme="default" ;;
        2) custom_theme="minimal" ;;
        3) custom_theme="pure" ;;
        4) custom_theme="tokyo-night" ;;
        *) custom_theme="default" ;;
    esac
    
    # Definir modo rápido
    local fast_mode_setting="false"
    [[ $fast_mode =~ ^[Yy]$ ]] && fast_mode_setting="true"
    
    # Criar arquivo de configuração personalizada
    cat > "$config_file" << EOF
#!/bin/bash
# Configuração Personalizada - Gerada em $(date)

# ZSH Plugins personalizados
export ZSH_PLUGINS="$custom_plugins"

# CLI Tools personalizados
export CLI_TOOLS="$custom_tools"

# VS Code Extensions personalizadas
export VSCODE_EXTENSIONS_CUSTOM="$custom_extensions"

# Tema personalizado
export STARSHIP_THEME="$custom_theme"

# Performance personalizada
export FAST_MODE="$fast_mode_setting"
export SKIP_HEAVY_INSTALLS="$fast_mode_setting"

# Demais configurações (mantém padrão)
$(grep "^export" "$PROJECT_ROOT/configs/dev-settings.sh" | grep -v "ZSH_PLUGINS\|CLI_TOOLS\|STARSHIP_THEME\|FAST_MODE\|SKIP_HEAVY_INSTALLS")
EOF
    
    print_status "✅ Configuração personalizada criada: $config_file"
    echo
    echo -n "Deseja usar esta configuração agora? (y/N): "
    read -r use_now
    
    if [[ $use_now =~ ^[Yy]$ ]]; then
        # Fazer backup da configuração atual
        cp "$PROJECT_ROOT/configs/dev-settings.sh" "$PROJECT_ROOT/configs/dev-settings.sh.backup"
        
        # Aplicar configuração personalizada
        cp "$config_file" "$PROJECT_ROOT/configs/dev-settings.sh"
        source "$PROJECT_ROOT/configs/dev-settings.sh"
        validate_config
        
        print_status "✅ Configuração personalizada aplicada!"
        print_info "Backup da configuração anterior salvo em: dev-settings.sh.backup"
    fi
    
    echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
    read
}

# Criar arquivo de configuração com valores padrão
create_default_config() {
    local config_file="$1"
    
    cat > "$config_file" << 'EOF'
#!/bin/bash
# Configurações padrão do ambiente de desenvolvimento

# === CONFIGURAÇÕES GERAIS ===
export USER_NAME="${USER_NAME:-${USER}}"
export USER_EMAIL="${USER_EMAIL:-}"
export PROJECT_ROOT="${PROJECT_ROOT:-$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")}"

# === ZSH CONFIGURAÇÃO ===
export ZSH_PLUGINS="${ZSH_PLUGINS:-git z zsh-autosuggestions zsh-syntax-highlighting}"
export OH_MY_ZSH_THEME="${OH_MY_ZSH_THEME:-robbyrussell}"
export ENABLE_STARSHIP="${ENABLE_STARSHIP:-true}"
export STARSHIP_THEME="${STARSHIP_THEME:-default}"

# === FERRAMENTAS CLI ===
export CLI_TOOLS="${CLI_TOOLS:-curl wget git vim nano htop tree bat eza zoxide fzf ripgrep fd-find}"
export INSTALL_DOCKER="${INSTALL_DOCKER:-true}"
export INSTALL_DOCKER_COMPOSE="${INSTALL_DOCKER_COMPOSE:-true}"

# === NODE.JS CONFIGURAÇÃO ===
export NODE_VERSION="${NODE_VERSION:-lts}"
export NPM_GLOBAL_PACKAGES="${NPM_GLOBAL_PACKAGES:-yarn pnpm create-react-app @vue/cli @angular/cli typescript ts-node nodemon prettier eslint}"

# === PYTHON CONFIGURAÇÃO ===
export PYTHON_PACKAGES="${PYTHON_PACKAGES:-pip setuptools wheel virtualenv pipenv poetry black flake8 pytest jupyter notebook pandas numpy requests}"

# === VS CODE EXTENSÕES ===
export VSCODE_EXTENSIONS_ESSENTIAL="${VSCODE_EXTENSIONS_ESSENTIAL:-ms-vscode.vscode-icons vscode-icons-team.vscode-icons}"
export VSCODE_EXTENSIONS_LANGUAGE="${VSCODE_EXTENSIONS_LANGUAGE:-ms-python.python bradlc.vscode-tailwindcss}"
export VSCODE_EXTENSIONS_TOOLS="${VSCODE_EXTENSIONS_TOOLS:-ms-vscode.vscode-json esbenp.prettier-vscode}"
export VSCODE_EXTENSIONS_ADVANCED="${VSCODE_EXTENSIONS_ADVANCED:-ms-vscode.live-server ms-vsliveshare.vsliveshare}"

# === CONFIGURAÇÕES DE VISUAL ===
export TERMINAL_FONT="${TERMINAL_FONT:-FiraCode Nerd Font}"
export TERMINAL_FONT_SIZE="${TERMINAL_FONT_SIZE:-12}"
export COLOR_SCHEME="${COLOR_SCHEME:-dark}"

# === PERFORMANCE ===
export FAST_NODE_MODULES="${FAST_NODE_MODULES:-true}"
export SKIP_HEAVY_INSTALLS="${SKIP_HEAVY_INSTALLS:-false}"
export PARALLEL_JOBS="${PARALLEL_JOBS:-4}"

# === BACKUP E SYNC ===
export ENABLE_BACKUP="${ENABLE_BACKUP:-true}"
export BACKUP_DIR="${BACKUP_DIR:-$HOME/.config-backup}"
export SYNC_DOTFILES="${SYNC_DOTFILES:-true}"
EOF
}

# Função principal
main() {
    print_main_banner
    check_prerequisites
    
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1)
                setup_terminal
                ;;
            2)
                setup_vscode
                ;;
            3)
                setup_sublime
                ;;
            4)
                install_dev_tools
                ;;
            5)
                print_header "🚀 SETUP COMPLETO"
                print_info "Iniciando instalação completa do ambiente..."
                
                # Executar todos os setups em sequência
                local steps=("Terminal" "VS Code" "Sublime Text" "Ferramentas de Dev")
                local total_steps=${#steps[@]}
                
                for i in "${!steps[@]}"; do
                    local current=$((i + 1))
                    show_progress $current $total_steps "${steps[$i]}"
                    
                    case $current in
                        1) setup_terminal ;;
                        2) setup_vscode ;;
                        3) setup_sublime ;;
                        4) install_dev_tools ;;
                    esac
                    
                    if [[ $? -ne 0 ]]; then
                        print_error "Falha na etapa: ${steps[$i]}"
                        echo
                        echo -n "Continuar mesmo assim? (y/N): "
                        read -r continue_choice
                        if [[ ! $continue_choice =~ ^[Yy]$ ]]; then
                            print_info "Setup interrompido pelo usuário"
                            exit 1
                        fi
                    fi
                done
                
                # Configurações finais
                create_config_files
                verify_installation
                show_summary
                break
                ;;
            6)
                manage_config
                ;;
            7)
                create_custom_config
                ;;
            8)
                print_info "Saindo..."
                exit 0
                ;;
            *)
                print_error "Opção inválida. Digite 1-8."
                ;;
        esac
        
        echo
        echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
        read
    done
}

# Executar script principal
main "$@"