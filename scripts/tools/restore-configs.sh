#!/bin/bash

# =============================================================================
# restore-configs.sh - Script para restaurar configurações do backup
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
    print_module_banner "RESTAURAÇÃO DAS CONFIGURAÇÕES" "🔄"
    
    local backup_file="$1"
    
    # Verificar se arquivo de backup foi fornecido
    if [[ -z "$backup_file" ]]; then
        print_error "❌ Arquivo de backup não especificado"
        print_info "💡 Uso: $0 <arquivo-backup.tar.gz>"
        print_info "📁 Exemplo: $0 ~/backup-configs-20240101_120000.tar.gz"
        exit 1
    fi
    
    # Verificar se arquivo existe
    if [[ ! -f "$backup_file" ]]; then
        print_error "❌ Arquivo de backup não encontrado: $backup_file"
        exit 1
    fi
    
    print_step "Iniciando restauração de: $(basename "$backup_file")"
    
    # Extrair backup
    local temp_dir=$(mktemp -d)
    local backup_name=$(basename "$backup_file" .tar.gz)
    
    print_step "Extraindo backup..."
    cd "$temp_dir"
    tar -xzf "$backup_file"
    
    if [[ ! -d "$backup_name" ]]; then
        print_error "❌ Estrutura de backup inválida"
        rm -rf "$temp_dir"
        exit 1
    fi
    
    local backup_path="$temp_dir/$backup_name"
    print_success "✅ Backup extraído em: $backup_path"
    
    # Restaurar configurações por categoria
    
    # VS Code
    if [[ -d "$backup_path/vscode" ]]; then
        print_step "Restaurando configurações do VS Code..."
        local vscode_config="$HOME/.config/Code/User"
        mkdir -p "$vscode_config"
        
        [[ -f "$backup_path/vscode/settings.json" ]] && {
            backup_file "$vscode_config/settings.json"
            cp "$backup_path/vscode/settings.json" "$vscode_config/"
            print_success "✅ settings.json restaurado"
        }
        
        [[ -f "$backup_path/vscode/keybindings.json" ]] && {
            backup_file "$vscode_config/keybindings.json"
            cp "$backup_path/vscode/keybindings.json" "$vscode_config/"
            print_success "✅ keybindings.json restaurado"
        }
        
        [[ -d "$backup_path/vscode/snippets" ]] && {
            backup_file "$vscode_config/snippets"
            cp -r "$backup_path/vscode/snippets" "$vscode_config/"
            print_success "✅ Snippets restaurados"
        }
        
        # Instalar extensões se VS Code estiver instalado
        if command_exists code && [[ -f "$backup_path/vscode/extensions.txt" ]]; then
            print_step "Instalando extensões do VS Code..."
            while IFS= read -r extension; do
                [[ -n "$extension" ]] && {
                    print_info "📦 Instalando: $extension"
                    code --install-extension "$extension" --force >/dev/null 2>&1
                }
            done < "$backup_path/vscode/extensions.txt"
            print_success "✅ Extensões instaladas"
        fi
    fi
    
    # Terminal (ZSH)
    if [[ -d "$backup_path/terminal" ]]; then
        print_step "Restaurando configurações do terminal..."
        
        [[ -f "$backup_path/terminal/.zshrc" ]] && {
            backup_file "$HOME/.zshrc"
            cp "$backup_path/terminal/.zshrc" "$HOME/"
            print_success "✅ .zshrc restaurado"
        }
        
        [[ -f "$backup_path/terminal/starship.toml" ]] && {
            mkdir -p "$HOME/.config"
            backup_file "$HOME/.config/starship.toml"
            cp "$backup_path/terminal/starship.toml" "$HOME/.config/"
            print_success "✅ Configuração Starship restaurada"
        }
    fi
    
    # Git
    if [[ -d "$backup_path/git" ]]; then
        print_step "Restaurando configurações do Git..."
        
        [[ -f "$backup_path/git/.gitconfig" ]] && {
            backup_file "$HOME/.gitconfig"
            cp "$backup_path/git/.gitconfig" "$HOME/"
            print_success "✅ .gitconfig restaurado"
        }
        
        [[ -f "$backup_path/git/.gitignore_global" ]] && {
            backup_file "$HOME/.gitignore_global"
            cp "$backup_path/git/.gitignore_global" "$HOME/"
            print_success "✅ .gitignore_global restaurado"
        }
        
        # SSH (apenas se não existir)
        if [[ -d "$backup_path/git/ssh" ]] && [[ ! -d "$HOME/.ssh" ]]; then
            print_step "Restaurando chaves SSH públicas..."
            mkdir -p "$HOME/.ssh"
            chmod 700 "$HOME/.ssh"
            cp "$backup_path/git/ssh"/* "$HOME/.ssh/" 2>/dev/null || true
            chmod 644 "$HOME/.ssh"/*.pub 2>/dev/null || true
            print_success "✅ Chaves SSH restauradas"
            print_warning "⚠️  Lembre-se de restaurar suas chaves privadas manualmente"
        fi
    fi
    
    # Limpeza
    rm -rf "$temp_dir"
    
    print_success "🎉 Restauração concluída!"
    print_info "💡 Próximos passos:"
    print_info "   1. Reinicie o terminal para aplicar configurações ZSH"
    print_info "   2. Reinicie o VS Code se estiver aberto"
    print_info "   3. Verifique as configurações restauradas"
    
    # Mostrar informações do sistema do backup se existir
    if [[ -f "$backup_path/system-info.txt" ]]; then
        print_info "📋 Informações do backup original:"
        head -5 "$backup_path/system-info.txt" 2>/dev/null || true
    fi
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi