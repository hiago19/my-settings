#!/bin/bash

# =============================================================================
# backup-configs.sh - Script para backup das configurações do sistema
# Autor: Bruno Hiago
# Versão: 3.0 - Modular com bootstrap system
# =============================================================================

# Carregar sistema core
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if ! source "$SCRIPT_DIR/../core/bootstrap.sh"; then
    printf "\033[0;31m❌ ERRO CRÍTICO: Falha ao carregar sistema core\033[0m\n" >&2
    exit 1
fi

# =============================================================================
# FUNÇÕES PRINCIPAIS
# =============================================================================

# Função principal
main() {
    print_module_banner "BACKUP DAS CONFIGURAÇÕES" "🗄️"
    
    print_step "Iniciando backup das configurações"
    
    # Criar diretório de backup com timestamp
    local backup_date=$(date +%Y%m%d_%H%M%S)
    local backup_dir="$HOME/backup-configs-$backup_date"
    
    mkdir -p "$backup_dir"
    print_info "📁 Diretório de backup: $backup_dir"
    
    # Backup VS Code
    if [[ -d "$HOME/.config/Code/User" ]]; then
        print_step "Fazendo backup das configurações do VS Code..."
        local vscode_backup="$backup_dir/vscode"
        mkdir -p "$vscode_backup"
        
        cp -r "$HOME/.config/Code/User/settings.json" "$vscode_backup/" 2>/dev/null || true
        cp -r "$HOME/.config/Code/User/keybindings.json" "$vscode_backup/" 2>/dev/null || true
        cp -r "$HOME/.config/Code/User/snippets" "$vscode_backup/" 2>/dev/null || true
        
        # Lista de extensões
        code --list-extensions > "$vscode_backup/extensions.txt" 2>/dev/null || true
        
        print_success "✅ Backup VS Code concluído"
    fi
    
    # Backup ZSH
    if [[ -f "$HOME/.zshrc" ]]; then
        print_step "Fazendo backup da configuração ZSH..."
        local terminal_backup="$backup_dir/terminal"
        mkdir -p "$terminal_backup"
        
        cp "$HOME/.zshrc" "$terminal_backup/"
        cp "$HOME/.config/starship.toml" "$terminal_backup/" 2>/dev/null || true
        
        print_success "✅ Backup terminal concluído"
    fi
    
    # Backup Git
    if [[ -f "$HOME/.gitconfig" ]]; then
        print_step "Fazendo backup da configuração Git..."
        local git_backup="$backup_dir/git"
        mkdir -p "$git_backup"
        
        cp "$HOME/.gitconfig" "$git_backup/"
        cp "$HOME/.gitignore_global" "$git_backup/" 2>/dev/null || true
        
        print_success "✅ Backup Git concluído"
    fi
    
    # Backup SSH (apenas chaves públicas)
    if [[ -d "$HOME/.ssh" ]]; then
        print_step "Fazendo backup das chaves SSH públicas..."
        local ssh_backup="$backup_dir/ssh"
        mkdir -p "$ssh_backup"
        
        cp "$HOME/.ssh"/*.pub "$ssh_backup/" 2>/dev/null || true
        cp "$HOME/.ssh/config" "$ssh_backup/" 2>/dev/null || true
        
        print_success "✅ Backup SSH concluído"
    fi
    
    # Criar arquivo de informações do sistema
    print_step "Coletando informações do sistema..."
    cat > "$backup_dir/system-info.txt" << EOF
Backup criado em: $(date)
Sistema: $(uname -a)
Usuário: $USER
Home: $HOME
Shell: $SHELL

Versões instaladas:
$(command -v zsh >/dev/null && echo "ZSH: $(zsh --version)")
$(command -v git >/dev/null && echo "Git: $(git --version)")
$(command -v code >/dev/null && echo "VS Code: $(code --version | head -1)")
$(command -v node >/dev/null && echo "Node.js: $(node --version)")
$(command -v python3 >/dev/null && echo "Python: $(python3 --version)")
EOF
    
    print_success "✅ Informações do sistema coletadas"
    
    # Criar arquivo compactado
    print_step "Compactando backup..."
    cd "$HOME"
    tar -czf "backup-configs-$backup_date.tar.gz" "backup-configs-$backup_date"
    
    if [[ $? -eq 0 ]]; then
        rm -rf "$backup_dir"
        print_success "🎉 Backup concluído com sucesso!"
        print_info "📦 Arquivo: ~/backup-configs-$backup_date.tar.gz"
        print_info "💡 Para restaurar: tar -xzf backup-configs-$backup_date.tar.gz"
    else
        print_error "❌ Erro ao criar arquivo compactado"
        return 1
    fi
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
