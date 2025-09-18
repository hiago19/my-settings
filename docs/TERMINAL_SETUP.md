# 🖥️ Setup Completo do Terminal - WSL2 + ZSH + Ferramentas

Este guia contém todas as instruções para configurar um ambiente de desenvolvimento completo no Windows usando WSL2, ZSH e ferramentas essenciais para desenvolvimento.

## 📋 Índice

- [1. WSL2 - Windows Subsystem for Linux](#1-wsl2---windows-subsystem-for-linux)
- [2. Ubuntu/Linux - Configuração Inicial](#2-ubuntulinux---configuração-inicial)
- [3. Git - Configuração](#3-git---configuração)
- [4. Fonts - Nerd Fonts](#4-fonts---nerd-fonts)
- [5. ZSH + Oh My Zsh](#5-zsh--oh-my-zsh)
- [6. Starship - Terminal Prompt](#6-starship---terminal-prompt)
- [7. Ferramentas CLI Essenciais](#7-ferramentas-cli-essenciais)
- [8. Node.js + NVM](#8-nodejs--nvm)
- [9. Python + Gerenciadores](#9-python--gerenciadores)
- [10. Docker](#10-docker)
- [11. Windows Terminal - Configuração](#11-windows-terminal---configuração)
- [12. Script de Instalação Automática](#12-script-de-instalação-automática)

---

## 1. WSL2 - Windows Subsystem for Linux

### 📖 Documentação Oficial

- [Microsoft WSL Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Install WSL](https://docs.microsoft.com/en-us/windows/wsl/install)

### 🚀 Instalação

#### Método 1: Instalação Automática (Recomendado)

```powershell
# Execute no PowerShell como Administrador
wsl --install
```

#### Método 2: Instalação Manual

```powershell
# 1. Habilitar WSL
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

# 2. Habilitar Plataforma de Máquina Virtual
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# 3. Reiniciar o computador

# 4. Baixar e instalar o pacote de atualização do kernel do Linux
# https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi

# 5. Definir WSL 2 como versão padrão
wsl --set-default-version 2

# 6. Instalar Ubuntu
wsl --install -d Ubuntu
```

### ⚙️ Configuração Inicial do WSL

```bash
# Atualizar o sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências essenciais
sudo apt install -y curl wget git build-essential software-properties-common apt-transport-https ca-certificates gnupg lsb-release
```

### 🛠️ Configurações Avançadas

#### .wslconfig (opcional)

Criar arquivo `C:\Users\[USERNAME]\.wslconfig`:

```ini
[wsl2]
memory=8GB
processors=4
swap=2GB
```

---

## 2. Ubuntu/Linux - Configuração Inicial

### 📦 Pacotes Essenciais

```bash
# Atualizar repositórios
sudo apt update

# Instalar ferramentas básicas
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
    npm
```

---

## 3. Git - Configuração

### 📖 Documentação Oficial

- [Git Documentation](https://git-scm.com/doc)
- [First-Time Git Setup](https://git-scm.com/book/en/v2/Getting-Started-First-Time-Git-Setup)

### ⚙️ Configuração Global

```bash
# Configurar nome e email
git config --global user.name "Seu Nome"
git config --global user.email "seu.email@exemplo.com"

# Configurar editor padrão
git config --global core.editor "code --wait"

# Configurar branch padrão
git config --global init.defaultBranch main

# Configurações adicionais recomendadas
git config --global pull.rebase false
git config --global core.autocrlf input
git config --global core.safecrlf true

# Verificar configuração
git config --list
```

### 🔐 SSH Key (Recomendado)

```bash
# Gerar chave SSH
ssh-keygen -t ed25519 -C "seu.email@exemplo.com"

# Iniciar ssh-agent
eval "$(ssh-agent -s)"

# Adicionar chave ao agent
ssh-add ~/.ssh/id_ed25519

# Copiar chave pública
cat ~/.ssh/id_ed25519.pub
```

---

## 4. Fonts - Nerd Fonts

### 📖 Documentação Oficial

- [Nerd Fonts](https://www.nerdfonts.com/)
- [Downloads](https://www.nerdfonts.com/font-downloads)

### 🔤 Instalação da FiraCode Nerd Font

#### Windows:

```powershell
# Baixar FiraCode Nerd Font
Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip" -OutFile "FiraCode.zip"

# Extrair e instalar manualmente
# Ou usar chocolatey:
choco install firacodenf
```

#### Linux (WSL):

```bash
# Criar diretório de fonts
mkdir -p ~/.local/share/fonts

# Baixar e extrair FiraCode Nerd Font
cd /tmp
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip
unzip FiraCode.zip -d FiraCode
cp FiraCode/*.ttf ~/.local/share/fonts/

# Atualizar cache de fonts
fc-cache -fv
```

---

## 5. ZSH + Oh My Zsh

### 📖 Documentação Oficial

- [ZSH](https://zsh.sourceforge.io/)
- [Oh My Zsh](https://ohmyz.sh/)

### 🐚 Instalação do ZSH

```bash
# Instalar ZSH
sudo apt install -y zsh

# Definir ZSH como shell padrão
chsh -s $(which zsh)

# Reiniciar terminal ou fazer logout/login
```

### 🎨 Instalação do Oh My Zsh

```bash
# Instalar Oh My Zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### 🔌 Plugins Essenciais

#### zsh-autosuggestions

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```

#### zsh-syntax-highlighting

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

#### fzf (Fuzzy Finder)

```bash
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

---

## 6. Starship - Terminal Prompt

### 📖 Documentação Oficial

- [Starship](https://starship.rs/)
- [Configuration](https://starship.rs/config/)

### ⭐ Instalação

```bash
# Instalação via script oficial
curl -sS https://starship.rs/install.sh | sh

# Ou via package manager
curl -fsSL https://starship.rs/install.sh | bash
```

### ⚙️ Configuração

Criar arquivo `~/.config/starship.toml`:

```toml
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
```

---

## 7. Ferramentas CLI Essenciais

### 🦇 Bat (Cat melhorado)

```bash
# Ubuntu/Debian
sudo apt install -y bat

# Criar alias se necessário
echo 'alias cat="batcat"' >> ~/.zshrc
```

### 📁 Eza (LS melhorado)

```bash
# Instalar via cargo
sudo apt install -y cargo
cargo install eza

# Ou baixar binary
wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
sudo mv eza /usr/local/bin/
```

### 🎯 Zoxide (CD melhorado)

```bash
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

### 🔍 FZF (Fuzzy Finder)

```bash
# Já instalado com Oh My Zsh, mas configurar manualmente:
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
```

### 📥 Curl

```bash
sudo apt install -y curl
```

---

## 8. Node.js + NVM

### 📖 Documentação Oficial

- [Node.js](https://nodejs.org/)
- [NVM](https://github.com/nvm-sh/nvm)

### 📦 Instalação do NVM

```bash
# Instalar NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Recarregar perfil
source ~/.zshrc

# Verificar instalação
nvm --version
```

### ⚙️ Instalação do Node.js

```bash
# Instalar versão LTS mais recente
nvm install --lts
nvm use --lts

# Definir como padrão
nvm alias default node

# Verificar versão
node --version
npm --version
```

### 📦 Configurações NPM Globais

```bash
# Configurar npm para instalar pacotes globais sem sudo
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'

# Adicionar ao PATH no ~/.zshrc
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
source ~/.zshrc

# Instalar ferramentas globais úteis
npm install -g yarn pnpm nodemon typescript ts-node @angular/cli @vue/cli create-react-app
```

---

## 9. Python + Gerenciadores

### 📖 Documentação Oficial

- [Python](https://www.python.org/)
- [pip](https://pip.pypa.io/)
- [pipenv](https://pipenv.pypa.io/)

### 🐍 Python já vem instalado no Ubuntu, mas vamos configurar:

```bash
# Instalar pip
sudo apt install -y python3-pip

# Instalar pipenv
pip3 install --user pipenv

# Instalar poetry
curl -sSL https://install.python-poetry.org | python3 -

# Adicionar ao PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Instalar ferramentas úteis
pip3 install --user black flake8 mypy pytest jupyterlab
```

---

## 10. Docker

### 📖 Documentação Oficial

- [Docker](https://docs.docker.com/)
- [Install Docker on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)

### 🐳 Instalação do Docker

```bash
# Remover versões antigas
sudo apt-get remove docker docker-engine docker.io containerd runc

# Adicionar repositório oficial
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Instalar Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER

# Reiniciar ou fazer logout/login

# Verificar instalação
docker --version
docker compose version
```

### ⚙️ Docker Desktop (Opcional)

- Baixar e instalar [Docker Desktop for Windows](https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe)
- Habilitar integração com WSL2

---

## 11. Windows Terminal - Configuração

### 📖 Documentação Oficial

- [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal/)

### ⚙️ Configuração JSON

O arquivo `settings.json` já está configurado, mas aqui estão as melhorias recomendadas:

```json
{
  "$help": "https://aka.ms/terminal-documentation",
  "$schema": "https://aka.ms/terminal-profiles-schema",
  "actions": [
    {
      "command": "copy",
      "keys": "ctrl+c"
    },
    {
      "command": "paste",
      "keys": "ctrl+v"
    },
    {
      "command": {
        "action": "splitPane",
        "split": "auto"
      },
      "keys": "alt+shift+d"
    }
  ],
  "copyFormatting": "none",
  "copyOnSelect": true,
  "defaultProfile": "{ba8ed8cc-e233-57e0-8cea-43f33d534f68}",
  "profiles": {
    "defaults": {
      "colorScheme": "One Half Dark",
      "font": {
        "face": "FiraCode Nerd Font",
        "size": 11
      },
      "opacity": 85,
      "useAcrylic": true,
      "scrollbarState": "hidden",
      "antialiasingMode": "grayscale"
    },
    "list": [
      {
        "guid": "{ba8ed8cc-e233-57e0-8cea-43f33d534f68}",
        "hidden": false,
        "name": "Ubuntu",
        "source": "Windows.Terminal.Wsl",
        "startingDirectory": "//wsl$/Ubuntu/home/username"
      }
    ]
  },
  "schemes": [],
  "theme": "dark"
}
```

---

## 12. Script de Instalação Automática

### 🚀 Setup Completo

Criar arquivo `setup-terminal.sh`:

```bash
#!/bin/bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Função para print colorido
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se está executando no WSL
if ! grep -q Microsoft /proc/version; then
    print_error "Este script deve ser executado no WSL2"
    exit 1
fi

print_status "Iniciando setup completo do terminal..."

# 1. Atualizar sistema
print_status "Atualizando sistema..."
sudo apt update && sudo apt upgrade -y

# 2. Instalar dependências básicas
print_status "Instalando dependências básicas..."
sudo apt install -y curl wget git unzip zip tree htop neofetch build-essential software-properties-common apt-transport-https ca-certificates gnupg lsb-release python3 python3-pip

# 3. Instalar ZSH
print_status "Instalando ZSH..."
sudo apt install -y zsh

# 4. Instalar Oh My Zsh
print_status "Instalando Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 5. Instalar plugins do ZSH
print_status "Instalando plugins do ZSH..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions 2>/dev/null || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting 2>/dev/null || true

# 6. Instalar Starship
print_status "Instalando Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

# 7. Instalar bat
print_status "Instalando bat..."
sudo apt install -y bat

# 8. Instalar eza
print_status "Instalando eza..."
wget -c https://github.com/eza-community/eza/releases/latest/download/eza_x86_64-unknown-linux-gnu.tar.gz -O - | tar xz
sudo mv eza /usr/local/bin/ 2>/dev/null || true

# 9. Instalar zoxide
print_status "Instalando zoxide..."
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

# 10. Instalar fzf
print_status "Instalando fzf..."
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install --all
fi

# 11. Instalar NVM
print_status "Instalando NVM..."
if [ ! -d "$HOME/.nvm" ]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm use --lts
    nvm alias default node
fi

# 12. Configurar .zshrc
print_status "Configurando .zshrc..."
cp ~/.zshrc ~/.zshrc.backup
cat > ~/.zshrc << 'EOF'
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git fzf zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# Aliases
alias cat='batcat'
alias cd="z"
alias ls='eza -1 --color=always --git --icons --group-directories-first'
alias ll='eza -1 --tree --level=2 --icons --color=always --git --group-directories-first'
alias la='eza -la --icons --git'
alias l='ll'

# Starship
eval "$(starship init zsh)"

# Zoxide
eval "$(zoxide init zsh)"

# FZF
eval "$(fzf --zsh)"
export FZF_CTRL_T_OPTS="
--style full
--walker-skip .git,node_modules,target
--preview 'batcat -n --color=always {}'
--bind 'ctrl-/:change-preview-window(down|hidden)'"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PATH
export PATH="$HOME/.local/bin:$PATH"
EOF

# 13. Definir ZSH como shell padrão
print_status "Definindo ZSH como shell padrão..."
chsh -s $(which zsh)

print_status "Setup concluído! Reinicie o terminal para aplicar todas as configurações."
print_warning "Lembre-se de:"
print_warning "1. Instalar FiraCode Nerd Font no Windows"
print_warning "2. Configurar Windows Terminal com as configurações fornecidas"
print_warning "3. Configurar Git com seus dados pessoais"
```

### 🎯 Executar Setup

```bash
# Baixar e executar
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/setup-terminal.sh | bash

# Ou clonar repositório e executar
git clone https://github.com/hiago19/my-settings.git
cd my-settings
chmod +x scripts/setup-terminal.sh
./scripts/setup-terminal.sh
```

---

## ✅ Verificação Final

Após concluir a instalação, execute estes comandos para verificar:

```bash
# Verificar versões
zsh --version
git --version
node --version
npm --version
python3 --version
docker --version

# Verificar ferramentas
which starship
which eza
which batcat
which zoxide
which fzf

# Testar aliases
ls
ll
la
```

---

## 🔗 Links Úteis

- [WSL2 Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [Windows Terminal](https://docs.microsoft.com/en-us/windows/terminal/)
- [Docker](https://docs.docker.com/)
- [Node.js](https://nodejs.org/)
- [Nerd Fonts](https://www.nerdfonts.com/)

---

**🎉 Parabéns! Seu ambiente de desenvolvimento está configurado e pronto para uso!**
