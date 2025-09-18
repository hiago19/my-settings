#!/bin/bash

# backup-configs.sh - Script para backup das configurações do sistema
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

# Banner
print_banner() {
    echo -e "${PURPLE}"
    echo "██████╗  █████╗  ██████╗██╗  ██╗██╗   ██╗██████╗ "
    echo "██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██║   ██║██╔══██╗"
    echo "██████╔╝███████║██║     █████╔╝ ██║   ██║██████╔╝"
    echo "██╔══██╗██╔══██║██║     ██╔═██╗ ██║   ██║██╔═══╝ "
    echo "██████╔╝██║  ██║╚██████╗██║  ██╗╚██████╔╝██║     "
    echo "╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     "
    echo ""
    echo "        🗄️ Backup de Configurações 🗄️"
    echo -e "${NC}"
}

# Criar diretório de backup
create_backup_dir() {
    BACKUP_DATE=$(date +%Y%m%d_%H%M%S)
    BACKUP_DIR="$HOME/backup-configs-$BACKUP_DATE"
    
    print_step "Criando diretório de backup..."
    mkdir -p "$BACKUP_DIR"
    
    if [ -d "$BACKUP_DIR" ]; then
        print_status "Diretório criado: $BACKUP_DIR"
    else
        print_error "Falha ao criar diretório de backup"
        exit 1
    fi
}

# Backup das configurações do ZSH
backup_zsh() {
    print_step "Fazendo backup das configurações do ZSH..."
    
    ZSH_BACKUP_DIR="$BACKUP_DIR/zsh"
    mkdir -p "$ZSH_BACKUP_DIR"
    
    # .zshrc
    if [ -f "$HOME/.zshrc" ]; then
        cp "$HOME/.zshrc" "$ZSH_BACKUP_DIR/"
        print_status "Backup do .zshrc"
    fi
    
    # .zsh_history
    if [ -f "$HOME/.zsh_history" ]; then
        cp "$HOME/.zsh_history" "$ZSH_BACKUP_DIR/"
        print_status "Backup do .zsh_history"
    fi
    
    # Oh My Zsh
    if [ -d "$HOME/.oh-my-zsh" ]; then
        # Copiar apenas arquivos de configuração importantes
        mkdir -p "$ZSH_BACKUP_DIR/oh-my-zsh"
        
        # Custom themes e plugins
        if [ -d "$HOME/.oh-my-zsh/custom" ]; then
            cp -r "$HOME/.oh-my-zsh/custom" "$ZSH_BACKUP_DIR/oh-my-zsh/"
            print_status "Backup do Oh My Zsh custom"
        fi
    fi
    
    # Starship config
    if [ -f "$HOME/.config/starship.toml" ]; then
        mkdir -p "$ZSH_BACKUP_DIR/starship"
        cp "$HOME/.config/starship.toml" "$ZSH_BACKUP_DIR/starship/"
        print_status "Backup da configuração do Starship"
    fi
}

# Backup das configurações do Git
backup_git() {
    print_step "Fazendo backup das configurações do Git..."
    
    GIT_BACKUP_DIR="$BACKUP_DIR/git"
    mkdir -p "$GIT_BACKUP_DIR"
    
    # .gitconfig
    if [ -f "$HOME/.gitconfig" ]; then
        cp "$HOME/.gitconfig" "$GIT_BACKUP_DIR/"
        print_status "Backup do .gitconfig"
    fi
    
    # .gitignore_global
    if [ -f "$HOME/.gitignore_global" ]; then
        cp "$HOME/.gitignore_global" "$GIT_BACKUP_DIR/"
        print_status "Backup do .gitignore_global"
    fi
    
    # SSH keys (apenas chaves públicas por segurança)
    if [ -d "$HOME/.ssh" ]; then
        mkdir -p "$GIT_BACKUP_DIR/ssh"
        
        # Copiar apenas chaves públicas
        find "$HOME/.ssh" -name "*.pub" -exec cp {} "$GIT_BACKUP_DIR/ssh/" \;
        
        # Copiar config se existir
        if [ -f "$HOME/.ssh/config" ]; then
            cp "$HOME/.ssh/config" "$GIT_BACKUP_DIR/ssh/"
        fi
        
        print_status "Backup das chaves SSH públicas"
    fi
}

# Backup das configurações do VS Code
backup_vscode() {
    print_step "Fazendo backup das configurações do VS Code..."
    
    VSCODE_BACKUP_DIR="$BACKUP_DIR/vscode"
    mkdir -p "$VSCODE_BACKUP_DIR"
    
    # Diretório do VS Code
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
    
    if [ -d "$VSCODE_CONFIG_DIR" ]; then
        # settings.json
        if [ -f "$VSCODE_CONFIG_DIR/settings.json" ]; then
            cp "$VSCODE_CONFIG_DIR/settings.json" "$VSCODE_BACKUP_DIR/"
            print_status "Backup do settings.json"
        fi
        
        # keybindings.json
        if [ -f "$VSCODE_CONFIG_DIR/keybindings.json" ]; then
            cp "$VSCODE_CONFIG_DIR/keybindings.json" "$VSCODE_BACKUP_DIR/"
            print_status "Backup do keybindings.json"
        fi
        
        # snippets
        if [ -d "$VSCODE_CONFIG_DIR/snippets" ]; then
            cp -r "$VSCODE_CONFIG_DIR/snippets" "$VSCODE_BACKUP_DIR/"
            print_status "Backup dos snippets"
        fi
        
        # Lista de extensões
        if command -v code >/dev/null 2>&1; then
            code --list-extensions > "$VSCODE_BACKUP_DIR/extensions.txt"
            print_status "Lista de extensões salva"
        fi
    fi
}

# Backup das configurações do Sublime Text
backup_sublime() {
    print_step "Fazendo backup das configurações do Sublime Text..."
    
    SUBLIME_BACKUP_DIR="$BACKUP_DIR/sublime"
    mkdir -p "$SUBLIME_BACKUP_DIR"
    
    # Diretório do Sublime Text
    SUBLIME_CONFIG_DIR="$HOME/.config/sublime-text/Packages/User"
    
    if [ -d "$SUBLIME_CONFIG_DIR" ]; then
        # Preferences
        if [ -f "$SUBLIME_CONFIG_DIR/Preferences.sublime-settings" ]; then
            cp "$SUBLIME_CONFIG_DIR/Preferences.sublime-settings" "$SUBLIME_BACKUP_DIR/"
            print_status "Backup das preferências do Sublime"
        fi
        
        # Keymaps
        find "$SUBLIME_CONFIG_DIR" -name "*.sublime-keymap" -exec cp {} "$SUBLIME_BACKUP_DIR/" \;
        
        # Snippets
        find "$SUBLIME_CONFIG_DIR" -name "*.sublime-snippet" -exec cp {} "$SUBLIME_BACKUP_DIR/" \;
        
        # Package Control
        if [ -f "$SUBLIME_CONFIG_DIR/Package Control.sublime-settings" ]; then
            cp "$SUBLIME_CONFIG_DIR/Package Control.sublime-settings" "$SUBLIME_BACKUP_DIR/"
            print_status "Backup do Package Control"
        fi
    fi
}

# Backup de outras configurações importantes
backup_others() {
    print_step "Fazendo backup de outras configurações..."
    
    OTHERS_BACKUP_DIR="$BACKUP_DIR/others"
    mkdir -p "$OTHERS_BACKUP_DIR"
    
    # .bashrc
    if [ -f "$HOME/.bashrc" ]; then
        cp "$HOME/.bashrc" "$OTHERS_BACKUP_DIR/"
        print_status "Backup do .bashrc"
    fi
    
    # .profile
    if [ -f "$HOME/.profile" ]; then
        cp "$HOME/.profile" "$OTHERS_BACKUP_DIR/"
        print_status "Backup do .profile"
    fi
    
    # .vimrc
    if [ -f "$HOME/.vimrc" ]; then
        cp "$HOME/.vimrc" "$OTHERS_BACKUP_DIR/"
        print_status "Backup do .vimrc"
    fi
    
    # .tmux.conf
    if [ -f "$HOME/.tmux.conf" ]; then
        cp "$HOME/.tmux.conf" "$OTHERS_BACKUP_DIR/"
        print_status "Backup do .tmux.conf"
    fi
    
    # Docker config
    if [ -d "$HOME/.docker" ]; then
        mkdir -p "$OTHERS_BACKUP_DIR/docker"
        cp -r "$HOME/.docker/config.json" "$OTHERS_BACKUP_DIR/docker/" 2>/dev/null || true
        print_status "Backup da configuração do Docker"
    fi
    
    # NPM config
    if [ -f "$HOME/.npmrc" ]; then
        cp "$HOME/.npmrc" "$OTHERS_BACKUP_DIR/"
        print_status "Backup do .npmrc"
    fi
    
    # Pip config
    if [ -f "$HOME/.pip/pip.conf" ]; then
        mkdir -p "$OTHERS_BACKUP_DIR/pip"
        cp "$HOME/.pip/pip.conf" "$OTHERS_BACKUP_DIR/pip/"
        print_status "Backup da configuração do pip"
    fi
}

# Criar arquivo de informações do sistema
create_system_info() {
    print_step "Coletando informações do sistema..."
    
    cat > "$BACKUP_DIR/system_info.txt" << EOF
# Informações do Sistema - Backup $BACKUP_DATE

## Sistema Operacional
$(lsb_release -a 2>/dev/null || cat /etc/os-release)

## Kernel
$(uname -a)

## Versões de Ferramentas Instaladas
EOF

    # Adicionar versões das ferramentas
    echo "### Shell e Terminal" >> "$BACKUP_DIR/system_info.txt"
    command -v zsh >/dev/null && echo "ZSH: $(zsh --version)" >> "$BACKUP_DIR/system_info.txt"
    command -v starship >/dev/null && echo "Starship: $(starship --version)" >> "$BACKUP_DIR/system_info.txt"
    
    echo -e "\n### Desenvolvimento" >> "$BACKUP_DIR/system_info.txt"
    command -v git >/dev/null && echo "Git: $(git --version)" >> "$BACKUP_DIR/system_info.txt"
    command -v node >/dev/null && echo "Node.js: $(node --version)" >> "$BACKUP_DIR/system_info.txt"
    command -v npm >/dev/null && echo "NPM: $(npm --version)" >> "$BACKUP_DIR/system_info.txt"
    command -v python3 >/dev/null && echo "Python: $(python3 --version)" >> "$BACKUP_DIR/system_info.txt"
    command -v docker >/dev/null && echo "Docker: $(docker --version)" >> "$BACKUP_DIR/system_info.txt"
    
    echo -e "\n### Editores" >> "$BACKUP_DIR/system_info.txt"
    command -v code >/dev/null && echo "VS Code: $(code --version | head -1)" >> "$BACKUP_DIR/system_info.txt"
    command -v subl >/dev/null && echo "Sublime Text: Instalado" >> "$BACKUP_DIR/system_info.txt"
    
    print_status "Informações do sistema coletadas"
}

# Compactar backup
compress_backup() {
    print_step "Compactando backup..."
    
    cd "$HOME"
    tar -czf "backup-configs-$BACKUP_DATE.tar.gz" "backup-configs-$BACKUP_DATE"
    
    if [ -f "$HOME/backup-configs-$BACKUP_DATE.tar.gz" ]; then
        print_status "Backup compactado: $HOME/backup-configs-$BACKUP_DATE.tar.gz"
        
        # Remover diretório não compactado
        rm -rf "$BACKUP_DIR"
        print_info "Diretório temporário removido"
    else
        print_error "Falha na compactação"
    fi
}

# Mostrar resumo
show_summary() {
    echo
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}           🎉 BACKUP CONCLUÍDO! 🎉${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo
    
    print_info "Backup criado em:"
    echo "  📁 $HOME/backup-configs-$BACKUP_DATE.tar.gz"
    echo
    
    print_info "Configurações incluídas:"
    echo "  🖥️  ZSH (.zshrc, Oh My Zsh, Starship)"
    echo "  🔧 Git (.gitconfig, SSH keys públicas)"
    echo "  💻 VS Code (settings, keybindings, snippets, extensões)"
    echo "  📝 Sublime Text (preferências, pacotes)"
    echo "  ⚙️  Outras configurações (bash, vim, tmux, docker, npm)"
    echo "  📋 Informações do sistema"
    echo
    
    print_warning "Como restaurar:"
    echo "  1. Extrair: tar -xzf backup-configs-$BACKUP_DATE.tar.gz"
    echo "  2. Usar o script restore-configs.sh"
    echo "  3. Ou copiar manualmente os arquivos desejados"
    echo
    
    print_status "🗄️ Backup realizado com sucesso!"
}

# Função principal
main() {
    print_banner
    create_backup_dir
    backup_zsh
    backup_git
    backup_vscode
    backup_sublime
    backup_others
    create_system_info
    compress_backup
    show_summary
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi