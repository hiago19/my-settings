#!/bin/bash

# setup-complete.sh - Setup completo de desenvolvimento
# Autor: Bruno Hiago
# Versão: 1.0

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner principal
print_main_banner() {
    clear
    echo -e "${PURPLE}"
    echo "██████╗ ███████╗██╗   ██╗    ███████╗███████╗████████╗██╗   ██╗██████╗ "
    echo "██╔══██╗██╔════╝██║   ██║    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗"
    echo "██║  ██║█████╗  ██║   ██║    ███████╗█████╗     ██║   ██║   ██║██████╔╝"
    echo "██║  ██║██╔══╝  ╚██╗ ██╔╝    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ "
    echo "██████╔╝███████╗ ╚████╔╝     ███████║███████╗   ██║   ╚██████╔╝██║     "
    echo "╚═════╝ ╚══════╝  ╚═══╝      ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     "
    echo ""
    echo "                    🚀 SETUP COMPLETO DE DESENVOLVIMENTO 🚀"
    echo "                           Terminal + VS Code + Apps"
    echo -e "${NC}"
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
    echo "1) 🖥️  Setup Terminal Completo (WSL2 + ZSH + Ferramentas)"
    echo "2) 💻 Setup VS Code (Extensões + Configurações)"
    echo "3) 📝 Setup Sublime Text (Pacotes + Configurações)" 
    echo "4) 🔧 Instalar Ferramentas de Desenvolvimento"
    echo "5) 🚀 SETUP COMPLETO (Tudo acima)"
    echo "6) ❌ Sair"
    echo
    echo -e "${YELLOW}Digite sua escolha (1-6):${NC} "
}

# Setup do Terminal
setup_terminal() {
    print_step "Iniciando setup do terminal..."
    
    # Verificar se script existe
    if [ -f "scripts/setup-terminal.sh" ]; then
        chmod +x scripts/setup-terminal.sh
        ./scripts/setup-terminal.sh
    else
        print_info "Baixando script do terminal..."
        curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/setup-terminal.sh | bash
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
    if [ -f "vscode/install-extensions.sh" ]; then
        chmod +x vscode/install-extensions.sh
        ./vscode/install-extensions.sh
    else
        print_info "Baixando e instalando extensões..."
        curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/vscode/install-extensions.sh | bash
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

# Instalar ferramentas de desenvolvimento
install_dev_tools() {
    print_step "Instalando ferramentas de desenvolvimento..."
    
    # Docker
    if ! command_exists docker; then
        print_info "Instalando Docker..."
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        sudo usermod -aG docker $USER
        print_status "Docker instalado"
    fi
    
    # Ferramentas úteis
    print_info "Instalando ferramentas úteis..."
    sudo apt install -y \
        jq \
        ripgrep \
        fd-find \
        exa \
        tmux \
        vim \
        nano \
        git-lfs \
        sqlite3 \
        postgresql-client \
        redis-tools
    
    # Python tools
    pip3 install --user \
        black \
        flake8 \
        mypy \
        pytest \
        jupyter \
        pipenv \
        poetry
    
    # Node.js global tools
    if command_exists npm; then
        npm install -g \
            yarn \
            pnpm \
            nodemon \
            typescript \
            ts-node \
            @angular/cli \
            @vue/cli \
            create-react-app \
            eslint \
            prettier
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

# Função principal
main() {
    print_main_banner
    check_environment
    
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
                print_info "Iniciando setup completo..."
                setup_terminal
                setup_vscode
                setup_sublime
                install_dev_tools
                create_config_files
                verify_installation
                show_summary
                break
                ;;
            6)
                print_info "Saindo..."
                exit 0
                ;;
            *)
                print_error "Opção inválida. Digite 1-6."
                ;;
        esac
        
        echo
        echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
        read
    done
}

# Executar script principal
main "$@"