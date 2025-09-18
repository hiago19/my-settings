#!/bin/bash

# install-extensions.sh - Instala extensões do VS Code com verificação inteligente
# Autor: Bruno Hiago
# Versão: 3.0 - Dev Senior Architecture

# =============================================================================
# CARREGAMENTO DO SISTEMA
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

main() {
    print_module_banner "INSTALAÇÃO INTELIGENTE DE EXTENSÕES" "📦"
    
    # Verificar se VS Code está instalado
    if ! command_exists code; then
        print_error "VS Code não está instalado!"
        print_info "💡 Execute setup-vscode.sh primeiro"
        exit 1
    fi
    
    # Usar arquivo de extensões do novo caminho
    local extensions_file="${1:-$VSCODE_EXTENSIONS_FILE}"
    
    if [[ ! -f "$extensions_file" ]]; then
        print_error "Arquivo de extensões não encontrado: $extensions_file"
        print_info "💡 Estrutura esperada: $VSCODE_CONFIG_DIR/extensions.txt"
        exit 1
    fi
    
    print_info "📄 Arquivo: $extensions_file"
    
    # Contar extensões
    local total_extensions
    total_extensions=$(grep -v '^#' "$extensions_file" | grep -v '^$' | wc -l)
    print_info "📊 Total de extensões: $total_extensions"
    
    # Contadores
    local installed=0
    local skipped=0
    local failed=0
    
    echo
    print_step "🔍 Verificando e instalando extensões..."
    
    # Ler e processar cada extensão
    while IFS= read -r extension || [[ -n "$extension" ]]; do
        # Pular comentários e linhas vazias
        [[ "$extension" =~ ^#.*$ ]] && continue
        [[ -z "$extension" ]] && continue
        
        # Remover espaços em branco
        extension=$(echo "$extension" | xargs)
        [[ -z "$extension" ]] && continue
        
        # Verificar se já está instalada
        if vscode_extension_installed "$extension"; then
            print_info "⏭️  Já instalada: $extension"
            ((skipped++))
        elif install_vscode_extension "$extension"; then
            ((installed++))
        else
            ((failed++))
        fi
    done < "$extensions_file"
    
    # Resumo final
    echo
    print_header "📊 RESUMO DA INSTALAÇÃO"
    print_success "✅ Novas instalações: $installed"
    print_info "⏭️  Já existentes: $skipped"
    
    if [[ $failed -gt 0 ]]; then
        print_warning "❌ Falharam: $failed"
        exit 1
    else
        print_success "🎉 Todas as extensões foram processadas com sucesso!"
    fi
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi