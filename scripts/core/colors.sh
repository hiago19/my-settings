#!/bin/bash

# Configurações de segurança e tratamento de erros
set -euo pipefail

# colors.sh - ÚNICA fonte de cores e funções de output
# Este arquivo deve ser carregado PRIMEIRO por todos os scripts
# Versão: 1.0 - Dev Senior Architecture

# =============================================================================
# DEFINIÇÃO DE CORES - ÚNICA E CENTRALIZADA
# =============================================================================

# Cores básicas
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly GRAY='\033[0;37m'
readonly NC='\033[0m' # No Color

# Cores de fundo
readonly BG_RED='\033[41m'
readonly BG_GREEN='\033[42m'
readonly BG_YELLOW='\033[43m'
readonly BG_BLUE='\033[44m'

# Formatação
readonly BOLD='\033[1m'
readonly DIM='\033[2m'
readonly UNDERLINE='\033[4m'
readonly BLINK='\033[5m'
readonly REVERSE='\033[7m'

# =============================================================================
# FUNÇÕES DE OUTPUT - ÚNICAS E PADRONIZADAS
# =============================================================================

# Função para output de sucesso
print_success() {
    echo -e "${GREEN}[✓]${NC} $1"
}

# Função para output de informação
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

# Função para output de aviso
print_warning() {
    echo -e "${YELLOW}[⚠]${NC} $1"
}

# Função para output de erro
print_error() {
    echo -e "${RED}[✗]${NC} $1" >&2
}

# Função para output de passo/etapa
print_step() {
    echo -e "${CYAN}[STEP]${NC} $1"
}

# Função para cabeçalhos
print_header() {
    echo
    echo -e "${PURPLE}${BOLD}═══════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}${BOLD}$1${NC}"
    echo -e "${PURPLE}${BOLD}═══════════════════════════════════════════════════════${NC}"
    echo
}

# Função para debug (apenas se DEBUG=true)
print_debug() {
    if [[ "${DEBUG:-false}" == "true" ]]; then
        echo -e "${GRAY}[DEBUG]${NC} $1" >&2
    fi
}

# Função para progresso
print_progress() {
    echo -e "${CYAN}⏳${NC} $1..."
}

# Função para mostrar comandos sendo executados
print_command() {
    echo -e "${DIM}${GRAY}$ $1${NC}"
}

# =============================================================================
# FUNÇÕES DE BANNER - PADRONIZADAS
# =============================================================================

# Banner principal do sistema
print_main_banner() {
    clear
    echo -e "${PURPLE}${BOLD}"
    echo "██████╗ ███████╗██╗   ██╗    ███████╗███████╗████████╗██╗   ██╗██████╗ "
    echo "██╔══██╗██╔════╝██║   ██║    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗"
    echo "██║  ██║█████╗  ██║   ██║    ███████╗█████╗     ██║   ██║   ██║██████╔╝"
    echo "██║  ██║██╔══╝  ╚██╗ ██╔╝    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝ "
    echo "██████╔╝███████╗ ╚████╔╝     ███████║███████╗   ██║   ╚██████╔╝██║     "
    echo "╚═════╝ ╚══════╝  ╚═══╝      ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝     "
    echo ""
    echo "                🚀 SETUP COMPLETO DE DESENVOLVIMENTO 🚀"
    echo "                     Terminal + VS Code + Apps"
    echo "                     v3.0 - Dev Senior Edition"
    echo -e "${NC}"
}

# Banner para módulos específicos
print_module_banner() {
    local module_name="$1"
    local icon="${2:-🔧}"
    
    echo -e "${CYAN}${BOLD}"
    echo "═══════════════════════════════════════════════════════"
    echo "    $icon $module_name"
    echo "═══════════════════════════════════════════════════════"
    echo -e "${NC}"
}

# =============================================================================
# FUNÇÕES DE VALIDAÇÃO DE OUTPUT
# =============================================================================

# Verificar se terminal suporta cores
colors_supported() {
    if [[ -t 1 ]] && command -v tput >/dev/null 2>&1; then
        local colors
        colors=$(tput colors 2>/dev/null)
        [[ $colors -ge 8 ]]
    else
        return 1
    fi
}

# Desabilitar cores se não suportadas
if ! colors_supported; then
    print_warning "Terminal não suporta cores, usando output simples"
    # Redefinir todas as cores como vazias
    RED='' GREEN='' YELLOW='' BLUE='' PURPLE='' CYAN='' WHITE='' GRAY='' NC=''
    BG_RED='' BG_GREEN='' BG_YELLOW='' BG_BLUE=''
    BOLD='' DIM='' UNDERLINE='' BLINK='' REVERSE=''
fi

# =============================================================================
# FUNÇÃO DE AUTO-TESTE
# =============================================================================

# Testar se todas as funções estão funcionando
test_colors() {
    print_header "Teste do Sistema de Cores"
    print_success "Teste de sucesso"
    print_info "Teste de informação"
    print_warning "Teste de aviso"
    print_error "Teste de erro"
    print_step "Teste de passo"
    print_progress "Teste de progresso"
    print_debug "Teste de debug (apenas se DEBUG=true)"
    print_command "echo 'Teste de comando'"
    echo
    print_info "Sistema de cores carregado com sucesso!"
}

# Executar auto-teste se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    DEBUG=true test_colors
fi