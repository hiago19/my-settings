#!/bin/bash

# Configurações de segurança e tratamento de erros
set -euo pipefail

# =============================================================================
# setup.sh - Orquestrador principal do sistema de configuração
# Autor: Bruno Hiago  
# Versão: 3.0 - Dev Senior Architecture
# =============================================================================

# Carregar sistema core
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_SCRIPT_DIR="$SCRIPT_DIR"  # Salvar referência original
if ! source "$SCRIPT_DIR/core/bootstrap.sh"; then
    printf "\033[0;31m❌ ERRO CRÍTICO: Falha ao carregar sistema core\033[0m\n" >&2
    exit 1
fi

# =============================================================================
# FUNÇÕES DO MENU
# =============================================================================

show_main_menu() {
    print_module_banner "SETUP COMPLETO DO AMBIENTE" "🚀"
    
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    MENU PRINCIPAL                        ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo
    echo -e "${YELLOW}🔧 MÓDULOS DE CONFIGURAÇÃO:${NC}"
    echo "  1) 🖥️ Setup Terminal (ZSH + Oh My Zsh + Starship)"
    echo "  2) 💻 Setup VS Code (Settings + Extensions + Themes)"
    echo "  3) 🚀 Setup Completo (Terminal + VS Code + Git)"
    echo
    echo -e "${YELLOW}🛠️  FERRAMENTAS:${NC}"
    echo "  4) 📦 Instalar Extensões VS Code"
    echo "  5) 💾 Backup das Configurações"
    echo "  6) 🔄 Restaurar Configurações"
    echo "  7) 🔍 Validar Sistema"
    echo
    echo -e "${YELLOW}ℹ️  INFORMAÇÕES:${NC}"
    echo "  8) 📋 Ver Configurações Atuais"
    echo "  9) 📖 Ajuda e Documentação"
    echo "  0) ❌ Sair"
    echo
    echo -e "${BLUE}Digite sua escolha (0-9):${NC} "
}

show_current_config() {
    print_module_banner "CONFIGURAÇÕES ATUAIS" "📋"
    
    echo -e "${YELLOW}👤 Desenvolvedor:${NC}"
    echo "   Nome: $DEV_USER_NAME"
    echo "   Email: $DEV_USER_EMAIL"
    echo
    
    echo -e "${YELLOW}📁 Diretórios:${NC}"
    echo "   Projetos: $DEV_PROJECTS_DIR"
    echo "   Backups: $DEV_BACKUP_DIR"
    echo "   Fontes: $DEV_FONTS_DIR"
    echo
    
    echo -e "${YELLOW}🎨 Personalização:${NC}"
    echo "   Tema VS Code: $DEV_VSCODE_THEME"
    echo "   Fonte: $DEV_FONT_NAME"
    echo "   Tema Terminal: $DEV_TERMINAL_THEME"
    echo
    
    echo -e "${YELLOW}🔧 Sistema:${NC}"
    echo "   OS: $(detect_os)"
    echo "   Shell atual: $SHELL"
    echo "   Git instalado: $(command_exists git && echo "✅ Sim" || echo "❌ Não")"
    echo "   VS Code instalado: $(command_exists code && echo "✅ Sim" || echo "❌ Não")"
    echo "   ZSH instalado: $(command_exists zsh && echo "✅ Sim" || echo "❌ Não")"
}

show_help() {
    print_module_banner "AJUDA E DOCUMENTAÇÃO" "📖"
    
    echo -e "${YELLOW}🎯 PROPÓSITO:${NC}"
    echo "Este sistema automatiza a configuração completa do ambiente de desenvolvimento"
    echo "com foco em produtividade e consistência entre diferentes máquinas."
    echo
    
    echo -e "${YELLOW}📋 PRINCIPAIS RECURSOS:${NC}"
    echo "• Configuração automática do Terminal (ZSH + Oh My Zsh + Starship)"
    echo "• Setup completo do VS Code (settings, themes, extensões)"
    echo "• Backup e restauração de configurações"
    echo "• Validação de integridade do sistema"
    echo "• Estrutura modular e extensível"
    echo
    
    echo -e "${YELLOW}🚀 RECOMENDAÇÕES DE USO:${NC}"
    echo "1. Execute o 'Setup Completo' na primeira vez"
    echo "2. Use 'Backup' regularmente para salvar suas configurações"
    echo "3. Execute 'Validar Sistema' após mudanças importantes"
    echo "4. Personalize o arquivo .env conforme suas preferências"
    echo
    
    echo -e "${YELLOW}📁 ESTRUTURA DO PROJETO:${NC}"
    echo "scripts/"
    echo "├── core/          # Sistema base (bootstrap, colors, utils)"
    echo "├── modules/       # Módulos de configuração (terminal, vscode)"  
    echo "├── tools/         # Ferramentas (backup, restore, validate)"
    echo "└── setup.sh       # Este script principal"
    echo
    
    echo -e "${YELLOW}🔧 CONFIGURAÇÃO:${NC}"
    echo "Edite o arquivo .env para personalizar:"
    echo "• Nome e email do desenvolvedor"
    echo "• Diretórios de projetos e backups"
    echo "• Temas e fontes preferidas"
    echo "• Módulos habilitados/desabilitados"
}

# =============================================================================
# FUNÇÕES DE EXECUÇÃO
# =============================================================================

execute_module() {
    local module="$1"
    local description="$2"
    local module_path="$SETUP_SCRIPT_DIR/modules/$module"
    
    print_step "Executando: $description"
    
    if [[ -f "$module_path" ]]; then
        "$module_path"
        if [[ $? -eq 0 ]]; then
            print_success "✅ $description concluído com sucesso"
        else
            print_error "❌ Erro ao executar $description"
            return 1
        fi
    else
        print_error "❌ Módulo não encontrado: $module"
        print_error "   Caminho verificado: $module_path"
        return 1
    fi
}

execute_tool() {
    local tool="$1"
    local description="$2"
    shift 2
    
    print_step "Executando: $description"
    
    if [[ -f "$SETUP_SCRIPT_DIR/tools/$tool" ]]; then
        "$SETUP_SCRIPT_DIR/tools/$tool" "$@"
        if [[ $? -eq 0 ]]; then
            print_success "✅ $description concluído com sucesso"
        else
            print_error "❌ Erro ao executar $description"
            return 1
        fi
    else
        print_error "❌ Ferramenta não encontrada: $tool"
        return 1
    fi
}

run_complete_setup() {
    print_module_banner "SETUP COMPLETO DO AMBIENTE" "🚀"
    
    print_info "🎯 Executando configuração completa do ambiente de desenvolvimento"
    print_info "📋 Isso incluirá: Terminal + VS Code + Git + Extensões"
    echo
    
    # Confirmar execução apenas em modo interativo
    if [[ -t 0 ]]; then
        echo -e "${YELLOW}Deseja continuar com o setup completo? [y/N]:${NC} "
        read -r response
        case "$response" in
            [yY][eE][sS]|[yY])
                ;;
            *)
                print_info "Setup cancelado pelo usuário"
                return 0
                ;;
        esac
    else
        print_info "🤖 Modo não-interativo: Executando setup completo automaticamente"
    fi
    
    print_step "Iniciando setup completo"
    
    # 1. Terminal
    execute_module "terminal.sh" "Configuração do Terminal"
    
    # 2. VS Code  
    execute_module "vscode.sh" "Configuração do VS Code"
    
    # 3. Extensões
    if [[ -f "$SCRIPT_DIR/tools/install-extensions.sh" ]]; then
        print_step "Instalando extensões do VS Code"
        "$SCRIPT_DIR/tools/install-extensions.sh"
    fi
    
    # 4. Setup complete (se existir)
    if [[ -f "$SCRIPT_DIR/modules/complete.sh" ]]; then
        print_step "Executando configurações finais"
        "$SCRIPT_DIR/modules/complete.sh"
    fi
    
    print_success "🎉 Setup completo finalizado!"
    print_info "💡 Recomendações:"
    print_info "   1. Faça logout/login para aplicar mudanças do shell"
    print_info "   2. Reinicie o VS Code para aplicar configurações"
    print_info "   3. Execute um backup das configurações"
}

# =============================================================================
# FUNÇÃO PRINCIPAL
# =============================================================================

main() {
    # Verificar se não está executando como root
    check_not_root
    
    while true; do
        show_main_menu
        read -r choice
        
        case $choice in
            1)
                execute_module "terminal.sh" "Setup Terminal"
                ;;
            2)
                execute_module "vscode.sh" "Setup VS Code"
                ;;
            3)
                run_complete_setup
                ;;
            4)
                if [[ -f "$SCRIPT_DIR/tools/install-extensions.sh" ]]; then
                    "$SCRIPT_DIR/tools/install-extensions.sh"
                else
                    print_error "Script install-extensions.sh não encontrado"
                fi
                ;;
            5)
                execute_tool "backup-configs.sh" "Backup das Configurações"
                ;;
            6)
                echo -e "${YELLOW}Digite o caminho do arquivo de backup:${NC} "
                read -r backup_file
                if [[ -n "$backup_file" ]]; then
                    execute_tool "restore-configs.sh" "Restauração das Configurações" "$backup_file"
                else
                    print_error "Caminho do backup não fornecido"
                fi
                ;;
            7)
                execute_tool "validate-system.sh" "Validação do Sistema"
                ;;
            8)
                show_current_config
                ;;
            9)
                show_help
                ;;
            0)
                print_info "👋 Obrigado por usar o sistema de setup!"
                print_info "🌟 Happy coding!"
                exit 0
                ;;
            *)
                print_error "Opção inválida. Digite um número de 0 a 9."
                ;;
        esac
        
        # Se não estiver em terminal interativo, sair após executar uma opção
        if [[ $choice != "0" ]] && [[ ! -t 0 ]]; then
            print_info "🎯 Operação concluída (modo não-interativo)"
            exit 0
        fi
        
        if [[ $choice != "0" ]]; then
            echo
            echo -e "${YELLOW}Pressione Enter para continuar...${NC}"
            read -r
            clear
        fi
    done
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi