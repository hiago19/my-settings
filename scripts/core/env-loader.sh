#!/bin/bash

# env-loader.sh - Carregador de configurações .env (sem colors)
# Este arquivo deve ser carregado APÓS colors.sh e utils.sh
# Versão: 1.0 - Dev Senior Architecture

# =============================================================================
# CONFIGURAÇÕES INTERNAS
# =============================================================================

# Diretório base do projeto
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Arquivos de configuração
ENV_FILE="$PROJECT_ROOT/.env"
ENV_EXAMPLE_FILE="$PROJECT_ROOT/.env.example"

# =============================================================================
# FUNÇÕES PRINCIPAIS
# =============================================================================

# Criar arquivo .env a partir do .env.example se não existir
create_env_from_example() {
    if [[ ! -f "$ENV_FILE" ]] && [[ -f "$ENV_EXAMPLE_FILE" ]]; then
        print_step "Criando arquivo .env a partir do .env.example"
        cp "$ENV_EXAMPLE_FILE" "$ENV_FILE"
        print_success "Arquivo .env criado com sucesso"
        print_warning "⚠️  IMPORTANTE: Edite o arquivo .env com suas configurações pessoais"
        print_info "Arquivo localizado em: $ENV_FILE"
        return 0
    fi
    return 1
}

# Validar arquivo .env
validate_env_file() {
    if [[ ! -f "$ENV_FILE" ]]; then
        print_error "Arquivo .env não encontrado: $ENV_FILE"
        print_info "💡 Execute: cp .env.example .env"
        return 1
    fi
    
    if [[ ! -r "$ENV_FILE" ]]; then
        print_error "Arquivo .env não é legível: $ENV_FILE"
        return 1
    fi
    
    return 0
}

# Carregar arquivo .env
load_env_file() {
    print_step "Carregando configurações do arquivo .env"
    
    # Validar arquivo antes de carregar
    if ! validate_env_file; then
        return 1
    fi
    
    # Carregar arquivo linha por linha para melhor controle
    local loaded_vars=0
    local line_num=0
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        ((line_num++))
        
        # Pular linhas vazias e comentários
        [[ "$line" =~ ^[[:space:]]*$ ]] && continue
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        
        # Validar formato da linha
        if [[ "$line" =~ ^[a-zA-Z_][a-zA-Z0-9_]*=.*$ ]]; then
            # Exportar variável
            export "$line"
            ((loaded_vars++))
        else
            print_warning "⚠️  Linha inválida no .env (linha $line_num): $line"
        fi
    done < "$ENV_FILE"
    
    print_success "✅ $loaded_vars variáveis carregadas do .env"
    return 0
}

# Validar variáveis obrigatórias
validate_required_vars() {
    local required_vars=(
        "DEV_USER_NAME"
        "DEV_USER_EMAIL"
        "DEV_PROJECTS_DIR"
    )
    
    local missing_vars=()
    
    print_step "Validando variáveis obrigatórias"
    
    for var in "${required_vars[@]}"; do
        if [[ -z "${!var:-}" ]]; then
            missing_vars+=("$var")
        fi
    done
    
    if [[ ${#missing_vars[@]} -gt 0 ]]; then
        print_error "❌ Variáveis obrigatórias não definidas no .env:"
        for var in "${missing_vars[@]}"; do
            print_error "   - $var"
        done
        print_info "💡 Edite o arquivo .env: $ENV_FILE"
        return 1
    fi
    
    print_success "✅ Todas as variáveis obrigatórias estão definidas"
    return 0
}

# Função para verificar se uma configuração está habilitada
is_enabled() {
    local var_name="$1"
    local var_value="${!var_name:-}"
    
    # Considerar habilitado se for: true, 1, yes, on (case insensitive)
    [[ "$var_value" =~ ^(true|1|yes|on)$ ]]
}

# Mostrar resumo das configurações
show_config_summary() {
    print_header "📋 RESUMO DAS CONFIGURAÇÕES"
    
    echo -e "${BLUE}👤 Informações do Desenvolvedor:${NC}"
    echo "   Nome: ${DEV_USER_NAME:-'não definido'}"
    echo "   Email: ${DEV_USER_EMAIL:-'não definido'}"
    echo
    
    echo -e "${BLUE}📁 Diretórios:${NC}"
    echo "   Projetos: ${DEV_PROJECTS_DIR:-'não definido'}"
    echo "   Home: $HOME"
    echo
    
    echo -e "${BLUE}🎨 Personalizações:${NC}"
    echo "   Tema VS Code: ${VSCODE_THEME:-'não definido'}"
    echo "   Fonte: ${DEFAULT_FONT:-'não definido'}"
    echo
    
    echo -e "${BLUE}🚀 Módulos Habilitados:${NC}"
    local modules=(
        "INSTALL_TERMINAL_TOOLS:Terminal Tools"
        "INSTALL_DEVELOPMENT_TOOLS:Dev Tools"
        "INSTALL_VSCODE:VS Code"
        "INSTALL_VSCODE_EXTENSIONS:VS Code Extensions"
        "CONFIGURE_GIT:Git Config"
        "CONFIGURE_SHELL:Shell Config"
    )
    
    for module in "${modules[@]}"; do
        local var_name="${module%%:*}"
        local display_name="${module##*:}"
        
        if is_enabled "$var_name"; then
            echo -e "   ${GREEN}✓${NC} $display_name"
        else
            echo -e "   ${GRAY}○${NC} $display_name"
        fi
    done
    
    echo
}

# Validar configurações específicas
validate_configs() {
    print_step "Validando configurações específicas"
    
    # Validar email se fornecido
    if [[ -n "${DEV_USER_EMAIL:-}" ]] && ! validate_email "$DEV_USER_EMAIL"; then
        print_warning "⚠️  Email inválido: $DEV_USER_EMAIL"
    fi
    
    # Validar diretório de projetos
    if [[ -n "${DEV_PROJECTS_DIR:-}" ]]; then
        # Expandir ~ se presente
        DEV_PROJECTS_DIR="${DEV_PROJECTS_DIR/#\~/$HOME}"
        export DEV_PROJECTS_DIR
        
        # Criar diretório se não existir
        if [[ ! -d "$DEV_PROJECTS_DIR" ]]; then
            print_step "Criando diretório de projetos: $DEV_PROJECTS_DIR"
            mkdir -p "$DEV_PROJECTS_DIR"
            print_success "✅ Diretório criado"
        fi
    fi
    
    print_success "✅ Configurações validadas"
}

# =============================================================================
# FUNÇÃO PRINCIPAL DE INICIALIZAÇÃO
# =============================================================================

# Inicializar sistema de configuração
init_env_system() {
    print_step "Inicializando sistema de configuração"
    
    # Criar .env se não existir
    create_env_from_example
    
    # Carregar .env
    if ! load_env_file; then
        return 1
    fi
    
    # Validar variáveis obrigatórias
    if ! validate_required_vars; then
        return 1
    fi
    
    # Validar configurações específicas
    validate_configs
    
    # Mostrar resumo se solicitado
    if [[ "${SHOW_CONFIG_SUMMARY:-true}" == "true" ]]; then
        show_config_summary
    fi
    
    print_success "✅ Sistema de configuração inicializado"
    return 0
}

# =============================================================================
# FUNÇÕES DE GERENCIAMENTO
# =============================================================================

# Atualizar configuração específica
update_config() {
    local key="$1"
    local value="$2"
    
    if [[ -z "$key" || -z "$value" ]]; then
        print_error "Uso: update_config <chave> <valor>"
        return 1
    fi
    
    if [[ ! -f "$ENV_FILE" ]]; then
        print_error "Arquivo .env não encontrado"
        return 1
    fi
    
    # Backup do arquivo atual
    backup_file "$ENV_FILE"
    
    # Atualizar ou adicionar configuração
    if grep -q "^$key=" "$ENV_FILE"; then
        # Atualizar existente
        sed -i "s/^$key=.*/$key=$value/" "$ENV_FILE"
        print_success "✅ Configuração atualizada: $key"
    else
        # Adicionar nova
        echo "$key=$value" >> "$ENV_FILE"
        print_success "✅ Configuração adicionada: $key"
    fi
    
    # Reexportar a variável
    export "$key=$value"
}

# Listar todas as configurações
list_configs() {
    if [[ ! -f "$ENV_FILE" ]]; then
        print_error "Arquivo .env não encontrado"
        return 1
    fi
    
    print_header "📋 CONFIGURAÇÕES ATUAIS"
    
    while IFS= read -r line; do
        # Pular linhas vazias e comentários
        [[ "$line" =~ ^[[:space:]]*$ ]] && continue
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        
        if [[ "$line" =~ ^([^=]+)=(.*)$ ]]; then
            local key="${BASH_REMATCH[1]}"
            local value="${BASH_REMATCH[2]}"
            echo -e "${BLUE}$key${NC} = ${GREEN}$value${NC}"
        fi
    done < "$ENV_FILE"
}

# =============================================================================
# FUNÇÃO DE AUTO-TESTE
# =============================================================================

# Testar sistema de configuração
test_env_loader() {
    print_header "Teste do Sistema de Configuração"
    
    print_step "Testando validação de email"
    if validate_email "test@example.com"; then
        print_success "validate_email funcionando"
    else
        print_error "validate_email falhando"
    fi
    
    print_step "Testando função is_enabled"
    export TEST_VAR_TRUE="true"
    export TEST_VAR_FALSE="false"
    
    if is_enabled "TEST_VAR_TRUE"; then
        print_success "is_enabled funcionando para true"
    else
        print_error "is_enabled falhando para true"
    fi
    
    if ! is_enabled "TEST_VAR_FALSE"; then
        print_success "is_enabled funcionando para false"
    else
        print_error "is_enabled falhando para false"
    fi
    
    # Limpar variáveis de teste
    unset TEST_VAR_TRUE TEST_VAR_FALSE
    
    print_success "Sistema de configuração testado com sucesso!"
}

# Executar auto-teste se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Carregar dependências para os testes
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/colors.sh"
    source "$SCRIPT_DIR/utils.sh"
    test_env_loader
fi