#!/bin/bash

# =============================================================================
# setup-vscode.sh - Instalação e configuração completa do VS Code
# Autor: Bruno Hiago  
# Versão: 4.0 - Modular com bootstrap system
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
    print_module_banner "CONFIGURAÇÃO DO VS CODE" "💻"
    
    # Verificar se está habilitado
    if ! is_enabled "INSTALL_VSCODE"; then
        print_info "⏭️  Setup do VS Code desabilitado (INSTALL_VSCODE=false)"
        return 0
    fi
    
    print_step "Iniciando configuração do VS Code"
    
    # Instalar VS Code se necessário
    if ! command_exists code; then
        print_step "Instalando VS Code..."
        
        # Adicionar repositório Microsoft
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        
        # Atualizar e instalar
        sudo apt update
        install_apt_package "code" "Visual Studio Code"
        
        if command_exists code; then
            print_success "✅ VS Code instalado com sucesso"
        else
            print_error "❌ Falha ao instalar VS Code"
            return 1
        fi
    else
        print_info "✅ VS Code já está instalado"
    fi
    
    # Instalar extensões
    local extensions_file="$CONFIG_VSCODE_DIR/extensions.txt"
    if [[ -f "$extensions_file" ]]; then
        print_step "Instalando extensões do VS Code..."
        
        local installed=0
        local skipped=0
        
        while IFS= read -r extension || [[ -n "$extension" ]]; do
            # Pular linhas vazias e comentários
            [[ -z "$extension" || "$extension" =~ ^[[:space:]]*# ]] && continue
            
            extension=$(echo "$extension" | xargs) # trim
            
            if vscode_extension_installed "$extension"; then
                print_info "⏭️  Já instalada: $extension"
                ((skipped++))
            else
                print_info "🔄 Instalando: $extension"
                if code --install-extension "$extension" --force; then
                    print_success "✅ Instalada: $extension"
                    ((installed++))
                else
                    print_error "❌ Falha ao instalar: $extension"
                fi
            fi
        done < "$extensions_file"
        
        print_success "📊 Extensões: $installed instaladas, $skipped já existentes"
    else
        print_warning "⚠️  Arquivo de extensões não encontrado: $extensions_file"
    fi
    
    # Configurar settings.json
    local settings_source="$CONFIG_VSCODE_DIR/settings.json"
    if [[ -f "$settings_source" ]]; then
        print_step "Aplicando configurações do VS Code..."
        
        local config_dir="$HOME/.config/Code/User"
        mkdir -p "$config_dir"
        
        backup_file "$config_dir/settings.json"
        cp "$settings_source" "$config_dir/settings.json"
        print_success "✅ Configurações aplicadas"
    else
        print_warning "⚠️  Arquivo de configurações não encontrado: $settings_source"
    fi
    
    # Configurar keybindings.json
    local keybindings_source="$CONFIG_VSCODE_DIR/keybindings.json"
    if [[ -f "$keybindings_source" ]]; then
        print_step "Aplicando atalhos de teclado..."
        
        local config_dir="$HOME/.config/Code/User"
        backup_file "$config_dir/keybindings.json"
        cp "$keybindings_source" "$config_dir/keybindings.json"
        print_success "✅ Atalhos aplicados"
    fi
    
    # Configurar snippets se existir
    local snippets_dir="$CONFIG_VSCODE_DIR/snippets"
    if [[ -d "$snippets_dir" ]]; then
        print_step "Aplicando snippets..."
        
        local user_snippets_dir="$HOME/.config/Code/User/snippets"
        mkdir -p "$user_snippets_dir"
        
        cp -r "$snippets_dir"/* "$user_snippets_dir/"
        print_success "✅ Snippets aplicados"
    fi
    
    print_success "🎉 VS Code configurado com sucesso!"
    print_info "💡 Próximos passos:"
    print_info "   1. Reinicie o VS Code se estiver aberto"
    print_info "   2. Configure seu tema preferido"
    print_info "   3. Faça login na sua conta Microsoft/GitHub"
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
