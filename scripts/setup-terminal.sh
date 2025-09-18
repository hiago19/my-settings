#!/bin/bash

# setup-terminal.sh - Setup completo do terminal WSL2 + ZSH + ferramentas
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

# Função para print colorido
print_banner() {
    echo -e "${PURPLE}"
    echo "================================"
    echo "   SETUP TERMINAL COMPLETO     "
    echo "   WSL2 + ZSH + FERRAMENTAS    "
    echo "================================"
    echo -e "${NC}"
}

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

# Verificar se está executando no WSL ou Linux
check_environment() {
    if [[ -f /proc/version ]] && grep -q Microsoft /proc/version; then
        print_info "Detectado WSL2 - procedendo com instalação"
        return 0
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_info "Detectado Linux nativo - procedendo com instalação"
        return 0
    else
        print_error "Este script deve ser executado no WSL2 ou Linux"
        exit 1
    fi
}

# Verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para instalar dependências
install_dependencies() {
    print_step "Instalando dependências básicas..."
    
    sudo apt update && sudo apt upgrade -y
    
    sudo apt install -y \
        curl \
        wget \
        git \
        unzip \
        zip \
        tree \
        htop \
        neofetch \
        build-essential \
        software-properties-common \
        apt-transport-https \
        ca-certificates \
        gnupg \
        lsb-release \
        python3 \
        python3-pip \
        nodejs \
        npm \
        fontconfig
        
    print_status "Dependências básicas instaladas"
}

# Configurar Git
setup_git() {
    print_step "Configurando Git..."
    
    read -p "Digite seu nome para o Git: " git_name
    read -p "Digite seu email para o Git: " git_email
    
    git config --global user.name "$git_name"
    git config --global user.email "$git_email"
    git config --global init.defaultBranch main
    git config --global pull.rebase false
    git config --global core.autocrlf input
    git config --global core.safecrlf true
    
    print_status "Git configurado para $git_name <$git_email>"
}

# Instalar FiraCode Nerd Font
install_fonts() {
    print_step "Instalando FiraCode Nerd Font..."
    
    # Criar diretório de fonts
    mkdir -p ~/.local/share/fonts
    
    # Baixar e instalar FiraCode Nerd Font
    cd /tmp
    if wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip; then
        unzip -q FiraCode.zip -d FiraCode
        cp FiraCode/*.ttf ~/.local/share/fonts/
        fc-cache -fv > /dev/null 2>&1
        print_status "FiraCode Nerd Font instalada"
    else
        print_warning "Erro ao baixar FiraCode Nerd Font"
    fi
    
    cd - > /dev/null
}

# Instalar ZSH
install_zsh() {
    print_step "Instalando ZSH..."
    
    if ! command_exists zsh; then
        sudo apt install -y zsh
        print_status "ZSH instalado"
    else
        print_info "ZSH já está instalado"
    fi
}

# Instalar Oh My Zsh
install_oh_my_zsh() {
    print_step "Instalando Oh My Zsh..."
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_status "Oh My Zsh instalado"
    else
        print_info "Oh My Zsh já está instalado"
    fi
}

# Instalar plugins do ZSH
install_zsh_plugins() {
    print_step "Instalando plugins do ZSH..."
    
    # zsh-autosuggestions
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        print_status "zsh-autosuggestions instalado"
    fi
    
    # zsh-syntax-highlighting
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        print_status "zsh-syntax-highlighting instalado"
    fi
}

# Instalar Starship
install_starship() {
    print_step "Instalando Starship..."
    
    if ! command_exists starship; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
        print_status "Starship instalado"
    else
        print_info "Starship já está instalado"
    fi
}

# Instalar ferramentas CLI
install_cli_tools() {
    print_step "Instalando ferramentas CLI..."
    
    # Bat
    if ! command_exists batcat; then
        sudo apt install -y bat
        print_status "Bat instalado"
    fi
    
    # Eza (substituto do ls)
    if ! command_exists eza; then
        if wget -q -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz; then
            sudo mv eza /usr/local/bin/
            print_status "Eza instalado"
        else
            print_warning "Erro ao instalar Eza"
        fi
    fi
    
    # Zoxide
    if ! command_exists zoxide; then
        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
        print_status "Zoxide instalado"
    fi
    
    # FZF
    if [ ! -d "$HOME/.fzf" ]; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all --no-bash --no-fish
        print_status "FZF instalado"
    fi
}

# Instalar NVM e Node.js
install_node() {
    print_step "Instalando NVM e Node.js..."
    
    if [ ! -d "$HOME/.nvm" ]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        
        # Carregar NVM
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        
        # Instalar Node LTS
        nvm install --lts
        nvm use --lts
        nvm alias default node
        
        print_status "NVM e Node.js LTS instalados"
    else
        print_info "NVM já está instalado"
    fi
}

# Configurar Python
setup_python() {
    print_step "Configurando Python..."
    
    # Instalar pip packages úteis
    pip3 install --user pipenv poetry black flake8 mypy pytest
    
    print_status "Python configurado com ferramentas essenciais"
}

# Configurar .zshrc
configure_zshrc() {
    print_step "Configurando .zshrc..."
    
    # Backup do .zshrc atual
    if [ -f ~/.zshrc ]; then
        cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
    fi
    
    # Criar novo .zshrc
    cat > ~/.zshrc << 'EOF'
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
plugins=(
    git
    fzf
    zsh-autosuggestions
    zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# ALIASES
# =============================================================================

# Ferramentas modernas
alias cat='batcat'
alias cd="z"

# Eza (ls melhorado)
alias ls='eza -1 --color=always --git --icons --group-directories-first'
alias ll='eza -1 --tree --level=2 --icons --color=always --git --group-directories-first'
alias la='eza -la --icons --git'
alias l='ll'

# Git aliases
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'

# System aliases
alias reload='source ~/.zshrc'
alias zshconfig='code ~/.zshrc'
alias c='clear'
alias h='history'
alias ..='cd ..'
alias ...='cd ../..'

# =============================================================================
# EXPORTS
# =============================================================================

# PATH
export PATH="$HOME/.local/bin:$PATH"

# Editor
export EDITOR='code'

# =============================================================================
# TOOL INITIALIZATIONS
# =============================================================================

# Starship prompt
eval "$(starship init zsh)"

# Zoxide (cd melhorado)
eval "$(zoxide init zsh)"

# FZF
eval "$(fzf --zsh)"

# FZF configuration
export FZF_CTRL_T_OPTS="
--style full
--walker-skip .git,node_modules,target,dist,build
--preview 'batcat -n --color=always {}'
--bind 'ctrl-/:change-preview-window(down|hidden)'"

export FZF_CTRL_R_OPTS="
--preview 'echo {}' --preview-window up:3:hidden:wrap
--bind 'ctrl-/:toggle-preview'
--bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
--color header:italic
--header 'Press CTRL-Y to copy command into clipboard'"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# =============================================================================
# FUNCTIONS
# =============================================================================

# Criar e entrar em diretório
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Extrair arquivos
extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Git log bonito
glog() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
}

# Buscar processos
psg() {
    ps aux | grep -v grep | grep "$@" -i --color=auto
}

# =============================================================================
# WELCOME MESSAGE
# =============================================================================

# Mostrar informações do sistema na inicialização
if command -v neofetch >/dev/null 2>&1; then
    neofetch
fi

echo -e "\n🚀 Terminal configurado com sucesso!"
echo -e "💡 Dica: Use 'fzf' para busca rápida, 'z <dir>' para navegação inteligente"
echo -e "📖 Digite 'alias' para ver todos os aliases disponíveis\n"
EOF

    print_status ".zshrc configurado"
}

# Configurar Starship
configure_starship() {
    print_step "Configurando Starship..."
    
    mkdir -p ~/.config
    
    cat > ~/.config/starship.toml << 'EOF'
format = """
[](#9A348E)\
$os\
$username\
[](bg:#DA627D fg:#9A348E)\
$directory\
[](fg:#DA627D bg:#FCA17D)\
$git_branch\
$git_status\
[](fg:#FCA17D bg:#86BBD8)\
$c\
$elixir\
$elm\
$golang\
$gradle\
$haskell\
$java\
$julia\
$nodejs\
$nim\
$rust\
$scala\
$python\
[](fg:#86BBD8 bg:#06969A)\
$docker_context\
[](fg:#06969A bg:#33658A)\
$time\
[ ](fg:#33658A)\
"""

[os]
disabled = false
style = "bg:#9A348E"

[os.symbols]
Windows = "󰍲"
Ubuntu = "󰕈"
SUSE = ""
Raspbian = "󰐿"
Mint = "󰣭"
Macos = "󰀵"
Manjaro = ""
Linux = "󰌽"
Gentoo = "󰣨"
Fedora = "󰣛"
Alpine = ""
Amazon = ""
Android = ""
Arch = "󰣇"
Artix = "󰣇"
CentOS = ""
Debian = "󰣚"
Redhat = "󱄛"
RedHatEnterprise = "󱄛"

[username]
show_always = true
style_user = "bg:#9A348E"
style_root = "bg:#9A348E"
format = '[$user ]($style)'
disabled = false

[directory]
style = "bg:#DA627D"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

[git_branch]
symbol = ""
style = "bg:#FCA17D"
format = '[ $symbol $branch ]($style)'

[git_status]
style = "bg:#FCA17D"
format = '[$all_status$ahead_behind ]($style)'

[nodejs]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[python]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[docker_context]
symbol = ""
style = "bg:#06969A"
format = '[ $symbol $context ]($style)'

[time]
disabled = false
time_format = "%R"
style = "bg:#33658A"
format = '[ ♥ $time ]($style)'
EOF

    print_status "Starship configurado"
}

# Definir ZSH como shell padrão
set_default_shell() {
    print_step "Definindo ZSH como shell padrão..."
    
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s $(which zsh)
        print_status "ZSH definido como shell padrão"
        print_warning "Faça logout e login novamente para aplicar a mudança"
    else
        print_info "ZSH já é o shell padrão"
    fi
}

# Função principal
main() {
    print_banner
    
    print_info "Iniciando setup completo do terminal..."
    print_warning "Este processo pode levar alguns minutos"
    echo
    
    check_environment
    install_dependencies
    setup_git
    install_fonts
    install_zsh
    install_oh_my_zsh
    install_zsh_plugins
    install_starship
    install_cli_tools
    install_node
    setup_python
    configure_zshrc
    configure_starship
    set_default_shell
    
    echo
    print_status "═══════════════════════════════════════"
    print_status "  SETUP COMPLETO! 🎉"
    print_status "═══════════════════════════════════════"
    echo
    print_info "Próximos passos:"
    echo "  1. Reinicie o terminal ou execute: source ~/.zshrc"
    echo "  2. Configure o Windows Terminal com FiraCode Nerd Font"
    echo "  3. Configure seu SSH key: ssh-keygen -t ed25519 -C 'seu-email@exemplo.com'"
    echo
    print_warning "IMPORTANTE: Se você mudou o shell padrão, faça logout/login"
    echo
    print_status "Terminal configurado com sucesso! Happy coding! 🚀"
}

# Executar script principal
main "$@"