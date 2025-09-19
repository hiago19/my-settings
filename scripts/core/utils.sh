#!/bin/bash

# Configurações de segurança e tratamento de erros
set -euo pipefail

# utils.sh - Funções utilitárias puras (sem colors)
# Este arquivo deve ser carregado APÓS colors.sh
# Versão: 1.0 - Dev Senior Architecture

# =============================================================================
# VERIFICAÇÃO DE DEPENDÊNCIAS E FALLBACKS
# =============================================================================

# Verificar se funções de cores estão disponíveis e criar fallbacks se necessário
if ! declare -f print_success >/dev/null 2>&1; then
    # Fallbacks simples se colors.sh não foi carregado
    print_success() { echo "✅ $*"; }
    print_error() { echo "❌ $*" >&2; }
    print_step() { echo "🔄 $*"; }
    print_info() { echo "ℹ️  $*"; }
    print_warning() { echo "⚠️  $*"; }
    print_progress() { echo "⏳ $*"; }
fi

# =============================================================================
# VERIFICAÇÕES DE SISTEMA
# =============================================================================

# Verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Verificar se um pacote APT está instalado
package_installed() {
    dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

# Verificar se uma extensão do VS Code está instalada
vscode_extension_installed() {
    local extension="$1"
    [[ -n "$extension" ]] && code --list-extensions 2>/dev/null | grep -qi "^$extension$"
}

# Verificar se está rodando como root
is_root() {
    [[ $EUID -eq 0 ]]
}

# Verificar se não está rodando como root
check_not_root() {
    if is_root; then
        print_error "Este script não deve ser executado como root"
        print_info "Execute como usuário normal: ./script.sh"
        exit 1
    fi
}

# Detectar sistema operacional
detect_os() {
    if [[ -f /proc/version ]] && grep -qi microsoft /proc/version; then
        echo "WSL2"
    elif [[ -f /etc/os-release ]]; then
        echo "LINUX"
    else
        echo "UNKNOWN"
    fi
}

# Verificar conexão com internet
check_internet() {
    if command_exists curl; then
        curl -s --max-time 5 https://8.8.8.8 >/dev/null 2>&1
    elif command_exists wget; then
        wget --timeout=5 --tries=1 -q --spider https://8.8.8.8 >/dev/null 2>&1
    else
        ping -c 1 8.8.8.8 >/dev/null 2>&1
    fi
}

# =============================================================================
# FUNÇÕES DE INSTALAÇÃO INTELIGENTE
# =============================================================================

# Instalar pacote APT com verificação inteligente
install_apt_package() {
    local package="$1"
    local description="${2:-$package}"
    
    if [[ -z "$package" ]]; then
        print_error "Nome do pacote não fornecido"
        return 1
    fi
    
    print_step "Verificando $description"
    
    if package_installed "$package"; then
        print_info "✅ $description já está instalado"
        return 0
    fi
    
    print_progress "Instalando $description"
    if sudo apt install -y "$package" >/dev/null 2>&1; then
        print_success "✅ $description instalado com sucesso"
        return 0
    else
        print_error "❌ Falha ao instalar $description"
        return 1
    fi
}

# Instalar extensão do VS Code com verificação inteligente
install_vscode_extension() {
    local extension="$1"
    
    if [[ -z "$extension" ]]; then
        print_error "Nome da extensão não fornecido"
        return 1
    fi
    
    if ! command_exists code; then
        print_error "VS Code não está instalado"
        return 1
    fi
    
    if vscode_extension_installed "$extension"; then
        print_info "⏭️  Já instalada: $extension"
        return 0
    fi
    
    print_progress "Instalando extensão: $extension"
    if code --install-extension "$extension" --force >/dev/null 2>&1; then
        print_success "✅ Extensão instalada: $extension"
        return 0
    else
        print_error "❌ Falha ao instalar: $extension"
        return 1
    fi
}

# =============================================================================
# FUNÇÕES DE ARQUIVO E DIRETÓRIO
# =============================================================================

# Criar backup de arquivo
backup_file() {
    local file="$1"
    
    if [[ -f "$file" ]]; then
        local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$file" "$backup"
        print_info "📋 Backup criado: $backup"
        return 0
    else
        print_warning "Arquivo não encontrado para backup: $file"
        return 1
    fi
}

# Criar diretório se não existir
ensure_directory() {
    local dir="$1"
    
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        print_info "📁 Diretório criado: $dir"
    fi
}

# Verificar se arquivo existe e é legível
file_readable() {
    [[ -f "$1" && -r "$1" ]]
}

# =============================================================================
# FUNÇÕES DE VALIDAÇÃO
# =============================================================================

# Validar que uma variável não está vazia
validate_not_empty() {
    local var_name="$1"
    local var_value="$2"
    
    if [[ -z "$var_value" ]]; then
        print_error "Variável obrigatória não definida: $var_name"
        return 1
    fi
    return 0
}

# Validar email
validate_email() {
    local email="$1"
    [[ "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]
}

# Validar se string é um número
is_number() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

# =============================================================================
# FUNÇÕES DE SISTEMA
# =============================================================================

# Atualizar lista de pacotes APT
update_package_list() {
    print_step "Atualizando lista de pacotes"
    if sudo apt update >/dev/null 2>&1; then
        print_success "Lista de pacotes atualizada"
        return 0
    else
        print_error "Falha ao atualizar lista de pacotes"
        return 1
    fi
}

# Verificar dependências básicas do sistema
check_dependencies() {
    local dependencies=("curl" "wget" "git")
    local missing=()
    
    print_step "Verificando dependências básicas"
    
    for dep in "${dependencies[@]}"; do
        if ! command_exists "$dep"; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        print_warning "Dependências faltando: ${missing[*]}"
        print_step "Instalando dependências básicas"
        
        for dep in "${missing[@]}"; do
            install_apt_package "$dep" || return 1
        done
    fi
    
    print_success "Todas as dependências estão disponíveis"
    return 0
}

# =============================================================================
# FUNÇÕES DE PROGRESSO E TIMING
# =============================================================================

# Mostrar spinner de loading
show_spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    
    while [[ "$(ps a | awk '{print $1}' | grep $pid)" ]]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Executar comando com timeout
execute_with_timeout() {
    local timeout="$1"
    local command="$2"
    
    timeout "$timeout" bash -c "$command"
}

# =============================================================================
# FUNÇÕES DE CLEANUP E FINALIZAÇÃO
# =============================================================================

# Função de cleanup para ser chamada no exit
cleanup() {
    local exit_code=$?
    
    # Limpar arquivos temporários se existirem
    if [[ -n "${TEMP_FILES:-}" ]]; then
        for temp_file in $TEMP_FILES; do
            [[ -f "$temp_file" ]] && rm -f "$temp_file"
        done
    fi
    
    # Log do resultado final
    if [[ $exit_code -eq 0 ]]; then
        print_success "Script finalizado com sucesso"
    else
        print_error "Script finalizado com erro (código: $exit_code)"
    fi
    
    exit $exit_code
}

# Registrar função de cleanup
trap cleanup EXIT

# =============================================================================
# FUNÇÃO DE AUTO-TESTE
# =============================================================================

# Testar todas as funções utilitárias
test_utils() {
    print_header "Teste do Sistema de Utilitários"
    
    # Teste de comandos
    print_step "Testando verificação de comandos"
    if command_exists "bash"; then
        print_success "command_exists funcionando"
    else
        print_error "command_exists falhando"
    fi
    
    # Teste de sistema
    print_step "Testando detecção de sistema"
    local os_type=$(detect_os)
    print_info "Sistema detectado: $os_type"
    
    # Teste de validação
    print_step "Testando validações"
    if validate_email "test@example.com"; then
        print_success "validate_email funcionando"
    else
        print_error "validate_email falhando"
    fi
    
    if is_number "123"; then
        print_success "is_number funcionando"
    else
        print_error "is_number falhando"
    fi
    
    print_success "Sistema de utilitários carregado com sucesso!"
}

# Executar auto-teste se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Carregar colors.sh para os testes
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    source "$SCRIPT_DIR/colors.sh"
    test_utils
fi