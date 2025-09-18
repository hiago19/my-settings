#!/bin/bash

# restore-configs.sh - Script para restaurar configurações do backup
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
    echo "██████╗ ███████╗███████╗████████╗ ██████╗ ██████╗ ███████╗"
    echo "██╔══██╗██╔════╝██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗██╔════╝"
    echo "██████╔╝█████╗  ███████╗   ██║   ██║   ██║██████╔╝█████╗  "
    echo "██╔══██╗██╔══╝  ╚════██║   ██║   ██║   ██║██╔══██╗██╔══╝  "
    echo "██║  ██║███████╗███████║   ██║   ╚██████╔╝██║  ██║███████╗"
    echo "╚═╝  ╚═╝╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝╚══════╝"
    echo ""
    echo "        🔄 Restauração de Configurações 🔄"
    echo -e "${NC}"
}

# Verificar se arquivo de backup existe
check_backup_file() {
    if [ -z "$1" ]; then
        print_error "Uso: $0 <arquivo-backup.tar.gz>"
        echo "Exemplo: $0 backup-configs-20241201_143022.tar.gz"
        exit 1
    fi
    
    BACKUP_FILE="$1"
    
    if [ ! -f "$BACKUP_FILE" ]; then
        print_error "Arquivo de backup não encontrado: $BACKUP_FILE"
        exit 1
    fi
    
    print_status "Arquivo de backup encontrado: $BACKUP_FILE"
}

# Extrair backup
extract_backup() {
    print_step "Extraindo backup..."
    
    # Criar diretório temporário
    TEMP_DIR="/tmp/restore-configs-$$"
    mkdir -p "$TEMP_DIR"
    
    # Extrair
    tar -xzf "$BACKUP_FILE" -C "$TEMP_DIR"
    
    # Encontrar diretório extraído
    BACKUP_DIR=$(find "$TEMP_DIR" -type d -name "backup-configs-*" | head -1)
    
    if [ -z "$BACKUP_DIR" ]; then
        print_error "Estrutura de backup não encontrada"
        exit 1
    fi
    
    print_status "Backup extraído em: $BACKUP_DIR"
}

# Menu de seleção
show_menu() {
    echo
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}            ESCOLHA O QUE RESTAURAR${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo
    echo "1) 🖥️  Configurações do ZSH (.zshrc, Oh My Zsh, Starship)"
    echo "2) 🔧 Configurações do Git (.gitconfig, SSH)"
    echo "3) 💻 Configurações do VS Code (settings, keybindings, snippets)"
    echo "4) 📝 Configurações do Sublime Text"
    echo "5) ⚙️  Outras configurações (bash, vim, tmux, etc)"
    echo "6) 🚀 RESTAURAR TUDO"
    echo "7) 📋 Ver informações do backup"
    echo "0) ❌ Sair"
    echo
    echo -e "${YELLOW}Digite sua escolha (0-7):${NC} "
}

# Confirmar sobrescrita
confirm_overwrite() {
    local file="$1"
    
    if [ -f "$file" ]; then
        print_warning "Arquivo já existe: $file"
        echo -n "Deseja sobrescrever? [y/N]: "
        read -r response
        case "$response" in
            [yY][eE][sS]|[yY])
                return 0
                ;;
            *)
                return 1
                ;;
        esac
    fi
    return 0
}

# Restaurar configurações do ZSH
restore_zsh() {
    print_step "Restaurando configurações do ZSH..."
    
    ZSH_BACKUP_DIR="$BACKUP_DIR/zsh"
    
    if [ ! -d "$ZSH_BACKUP_DIR" ]; then
        print_warning "Backup do ZSH não encontrado"
        return 1
    fi
    
    # .zshrc
    if [ -f "$ZSH_BACKUP_DIR/.zshrc" ]; then
        if confirm_overwrite "$HOME/.zshrc"; then
            cp "$ZSH_BACKUP_DIR/.zshrc" "$HOME/"
            print_status ".zshrc restaurado"
        fi
    fi
    
    # .zsh_history
    if [ -f "$ZSH_BACKUP_DIR/.zsh_history" ]; then
        if confirm_overwrite "$HOME/.zsh_history"; then
            cp "$ZSH_BACKUP_DIR/.zsh_history" "$HOME/"
            print_status ".zsh_history restaurado"
        fi
    fi
    
    # Oh My Zsh custom
    if [ -d "$ZSH_BACKUP_DIR/oh-my-zsh/custom" ]; then
        mkdir -p "$HOME/.oh-my-zsh"
        cp -r "$ZSH_BACKUP_DIR/oh-my-zsh/custom" "$HOME/.oh-my-zsh/"
        print_status "Oh My Zsh custom restaurado"
    fi
    
    # Starship config
    if [ -f "$ZSH_BACKUP_DIR/starship/starship.toml" ]; then
        mkdir -p "$HOME/.config"
        if confirm_overwrite "$HOME/.config/starship.toml"; then
            cp "$ZSH_BACKUP_DIR/starship/starship.toml" "$HOME/.config/"
            print_status "Configuração do Starship restaurada"
        fi
    fi
}

# Restaurar configurações do Git
restore_git() {
    print_step "Restaurando configurações do Git..."
    
    GIT_BACKUP_DIR="$BACKUP_DIR/git"
    
    if [ ! -d "$GIT_BACKUP_DIR" ]; then
        print_warning "Backup do Git não encontrado"
        return 1
    fi
    
    # .gitconfig
    if [ -f "$GIT_BACKUP_DIR/.gitconfig" ]; then
        if confirm_overwrite "$HOME/.gitconfig"; then
            cp "$GIT_BACKUP_DIR/.gitconfig" "$HOME/"
            print_status ".gitconfig restaurado"
        fi
    fi
    
    # .gitignore_global
    if [ -f "$GIT_BACKUP_DIR/.gitignore_global" ]; then
        if confirm_overwrite "$HOME/.gitignore_global"; then
            cp "$GIT_BACKUP_DIR/.gitignore_global" "$HOME/"
            print_status ".gitignore_global restaurado"
        fi
    fi
    
    # SSH config e chaves públicas
    if [ -d "$GIT_BACKUP_DIR/ssh" ]; then
        mkdir -p "$HOME/.ssh"
        
        # Config
        if [ -f "$GIT_BACKUP_DIR/ssh/config" ]; then
            if confirm_overwrite "$HOME/.ssh/config"; then
                cp "$GIT_BACKUP_DIR/ssh/config" "$HOME/.ssh/"
                chmod 600 "$HOME/.ssh/config"
                print_status "SSH config restaurado"
            fi
        fi
        
        # Chaves públicas
        find "$GIT_BACKUP_DIR/ssh" -name "*.pub" -exec cp {} "$HOME/.ssh/" \;
        print_status "Chaves SSH públicas restauradas"
    fi
}

# Restaurar configurações do VS Code
restore_vscode() {
    print_step "Restaurando configurações do VS Code..."
    
    VSCODE_BACKUP_DIR="$BACKUP_DIR/vscode"
    
    if [ ! -d "$VSCODE_BACKUP_DIR" ]; then
        print_warning "Backup do VS Code não encontrado"
        return 1
    fi
    
    # Criar diretório
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
    mkdir -p "$VSCODE_CONFIG_DIR"
    
    # settings.json
    if [ -f "$VSCODE_BACKUP_DIR/settings.json" ]; then
        if confirm_overwrite "$VSCODE_CONFIG_DIR/settings.json"; then
            cp "$VSCODE_BACKUP_DIR/settings.json" "$VSCODE_CONFIG_DIR/"
            print_status "settings.json restaurado"
        fi
    fi
    
    # keybindings.json
    if [ -f "$VSCODE_BACKUP_DIR/keybindings.json" ]; then
        if confirm_overwrite "$VSCODE_CONFIG_DIR/keybindings.json"; then
            cp "$VSCODE_BACKUP_DIR/keybindings.json" "$VSCODE_CONFIG_DIR/"
            print_status "keybindings.json restaurado"
        fi
    fi
    
    # snippets
    if [ -d "$VSCODE_BACKUP_DIR/snippets" ]; then
        cp -r "$VSCODE_BACKUP_DIR/snippets" "$VSCODE_CONFIG_DIR/"
        print_status "Snippets restaurados"
    fi
    
    # Instalar extensões
    if [ -f "$VSCODE_BACKUP_DIR/extensions.txt" ] && command -v code >/dev/null 2>&1; then
        print_info "Instalando extensões do VS Code..."
        while read -r extension; do
            if [ -n "$extension" ]; then
                print_info "Instalando: $extension"
                code --install-extension "$extension" --force >/dev/null 2>&1
            fi
        done < "$VSCODE_BACKUP_DIR/extensions.txt"
        print_status "Extensões instaladas"
    fi
}

# Restaurar configurações do Sublime Text
restore_sublime() {
    print_step "Restaurando configurações do Sublime Text..."
    
    SUBLIME_BACKUP_DIR="$BACKUP_DIR/sublime"
    
    if [ ! -d "$SUBLIME_BACKUP_DIR" ]; then
        print_warning "Backup do Sublime Text não encontrado"
        return 1
    fi
    
    # Criar diretório
    SUBLIME_CONFIG_DIR="$HOME/.config/sublime-text/Packages/User"
    mkdir -p "$SUBLIME_CONFIG_DIR"
    
    # Restaurar todos os arquivos
    find "$SUBLIME_BACKUP_DIR" -type f -exec cp {} "$SUBLIME_CONFIG_DIR/" \;
    
    print_status "Configurações do Sublime Text restauradas"
}

# Restaurar outras configurações
restore_others() {
    print_step "Restaurando outras configurações..."
    
    OTHERS_BACKUP_DIR="$BACKUP_DIR/others"
    
    if [ ! -d "$OTHERS_BACKUP_DIR" ]; then
        print_warning "Backup de outras configurações não encontrado"
        return 1
    fi
    
    # Lista de arquivos para restaurar
    files_to_restore=(
        ".bashrc"
        ".profile"
        ".vimrc"
        ".tmux.conf"
        ".npmrc"
    )
    
    for file in "${files_to_restore[@]}"; do
        if [ -f "$OTHERS_BACKUP_DIR/$file" ]; then
            if confirm_overwrite "$HOME/$file"; then
                cp "$OTHERS_BACKUP_DIR/$file" "$HOME/"
                print_status "$file restaurado"
            fi
        fi
    done
    
    # Docker config
    if [ -f "$OTHERS_BACKUP_DIR/docker/config.json" ]; then
        mkdir -p "$HOME/.docker"
        if confirm_overwrite "$HOME/.docker/config.json"; then
            cp "$OTHERS_BACKUP_DIR/docker/config.json" "$HOME/.docker/"
            print_status "Configuração do Docker restaurada"
        fi
    fi
    
    # Pip config
    if [ -f "$OTHERS_BACKUP_DIR/pip/pip.conf" ]; then
        mkdir -p "$HOME/.pip"
        if confirm_overwrite "$HOME/.pip/pip.conf"; then
            cp "$OTHERS_BACKUP_DIR/pip/pip.conf" "$HOME/.pip/"
            print_status "Configuração do pip restaurada"
        fi
    fi
}

# Mostrar informações do backup
show_backup_info() {
    print_step "Informações do backup..."
    
    if [ -f "$BACKUP_DIR/system_info.txt" ]; then
        echo
        cat "$BACKUP_DIR/system_info.txt"
        echo
    else
        print_warning "Arquivo de informações não encontrado"
    fi
}

# Limpeza
cleanup() {
    if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ]; then
        rm -rf "$TEMP_DIR"
        print_info "Arquivos temporários removidos"
    fi
}

# Mostrar resumo final
show_summary() {
    echo
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}         🎉 RESTAURAÇÃO CONCLUÍDA! 🎉${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo
    
    print_warning "Próximos passos:"
    echo "  1. Reinicie o terminal para aplicar configurações do ZSH"
    echo "  2. Reinicie o VS Code se as configurações foram restauradas"
    echo "  3. Verifique se todas as ferramentas estão funcionando"
    echo "  4. Configure novamente chaves SSH privadas se necessário"
    echo
    
    print_status "🔄 Configurações restauradas com sucesso!"
}

# Função principal
main() {
    print_banner
    check_backup_file "$1"
    extract_backup
    
    # Trap para limpeza
    trap cleanup EXIT
    
    while true; do
        show_menu
        read -r choice
        
        case $choice in
            1) restore_zsh ;;
            2) restore_git ;;
            3) restore_vscode ;;
            4) restore_sublime ;;
            5) restore_others ;;
            6)
                print_info "Restaurando todas as configurações..."
                restore_zsh
                restore_git
                restore_vscode
                restore_sublime
                restore_others
                show_summary
                break
                ;;
            7) show_backup_info ;;
            0)
                print_info "Saindo..."
                break
                ;;
            *)
                print_error "Opção inválida. Digite 0-7."
                ;;
        esac
        
        if [ "$choice" != "7" ] && [ "$choice" != "0" ] && [ "$choice" != "6" ]; then
            echo
            echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
            read
        fi
    done
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi