# 🔧 Solução de Problemas e FAQ

Este documento contém soluções para problemas comuns que podem ocorrer durante a configuração e uso do ambiente de desenvolvimento.

## 📑 Índice

- [🐧 WSL2 e Ubuntu](#-wsl2-e-ubuntu)
- [🖥️ Terminal e ZSH](#️-terminal-e-zsh)
- [⭐ Starship](#-starship)
- [🔧 Git](#-git)
- [📦 Node.js e NPM](#-nodejs-e-npm)
- [🐍 Python](#-python)
- [🐳 Docker](#-docker)
- [💻 VS Code](#-vs-code)
- [📝 Sublime Text](#-sublime-text)
- [🚀 Performance Geral](#-performance-geral)

---

## 🐧 WSL2 e Ubuntu

### ❌ Problema: WSL2 não inicia ou trava

**Soluções:**

```bash
# 1. Reiniciar WSL2
wsl --shutdown
wsl

# 2. Verificar versão do WSL
wsl --list --verbose

# 3. Atualizar WSL
wsl --update

# 4. Definir WSL2 como padrão
wsl --set-default-version 2
```

### ❌ Problema: Erro "WslRegisterDistribution failed"

**Solução:**

```powershell
# No PowerShell como Administrador
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform
```

### ❌ Problema: Performance lenta

**Soluções:**

```bash
# 1. Limitar uso de memória
# Criar arquivo .wslconfig em C:\Users\%USERNAME%
echo "[wsl2]
memory=8GB
processors=4
swap=2GB" > /mnt/c/Users/$USER/.wslconfig

# 2. Mover arquivos para sistema de arquivos Linux
mv /mnt/c/Users/$USER/projetos ~/Projetos
```

### ❌ Problema: Acesso a arquivos Windows lento

**Solução:**

```bash
# Trabalhar sempre no sistema de arquivos Linux
cd ~
mkdir -p ~/Projetos
# Evitar trabalhar em /mnt/c/
```

---

## 🖥️ Terminal e ZSH

### ❌ Problema: ZSH não é o shell padrão

**Solução:**

```bash
# Verificar shells disponíveis
cat /etc/shells

# Definir ZSH como padrão
chsh -s /usr/bin/zsh

# Ou adicionar no .bashrc
echo 'exec zsh' >> ~/.bashrc
```

### ❌ Problema: Oh My Zsh não carrega

**Soluções:**

```bash
# 1. Verificar se Oh My Zsh está instalado
ls -la ~/.oh-my-zsh

# 2. Reinstalar Oh My Zsh
rm -rf ~/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 3. Verificar .zshrc
cat ~/.zshrc | grep "source \$ZSH/oh-my-zsh.sh"
```

### ❌ Problema: Plugins não funcionam

**Soluções:**

```bash
# 1. Instalar plugins manualmente
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# 2. Verificar se plugins estão na lista
grep "plugins=" ~/.zshrc

# 3. Recarregar configuração
source ~/.zshrc
```

### ❌ Problema: Fontes não aparecem corretamente

**Soluções:**

```bash
# 1. Instalar Nerd Fonts
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip
unzip FiraCode.zip
fc-cache -fv

# 2. Configurar terminal para usar FiraCode Nerd Font
# Windows Terminal: Settings > Profiles > Font face: "FiraCode Nerd Font"
```

---

## ⭐ Starship

### ❌ Problema: Starship não aparece

**Soluções:**

```bash
# 1. Verificar se Starship está instalado
starship --version

# 2. Verificar se está no .zshrc
grep "starship init zsh" ~/.zshrc

# 3. Adicionar ao .zshrc se não estiver
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
source ~/.zshrc

# 4. Reinstalar se necessário
curl -sS https://starship.rs/install.sh | sh
```

### ❌ Problema: Configuração não carrega

**Soluções:**

```bash
# 1. Verificar localização do arquivo de config
starship config

# 2. Criar diretório se não existir
mkdir -p ~/.config

# 3. Copiar configuração
cp ~/my-settings/configs/starship.toml ~/.config/

# 4. Testar configuração
starship config
```

### ❌ Problema: Ícones não aparecem

**Solução:**

- Instalar uma Nerd Font
- Configurar o terminal para usar a fonte
- Verificar se o terminal suporta Unicode

---

## 🔧 Git

### ❌ Problema: Git não configurado

**Soluções:**

```bash
# 1. Configurar usuário
git config --global user.name "Seu Nome"
git config --global user.email "seu@email.com"

# 2. Verificar configuração
git config --list

# 3. Usar configuração pronta
cp ~/my-settings/configs/gitconfig ~/.gitconfig
```

### ❌ Problema: SSH não funciona

**Soluções:**

```bash
# 1. Gerar chave SSH
ssh-keygen -t ed25519 -C "seu@email.com"

# 2. Adicionar ao ssh-agent
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# 3. Copiar chave pública
cat ~/.ssh/id_ed25519.pub

# 4. Testar conexão
ssh -T git@github.com
```

### ❌ Problema: Erro de permissão HTTPS

**Soluções:**

```bash
# 1. Usar SSH ao invés de HTTPS
git remote set-url origin git@github.com:usuario/repo.git

# 2. Configurar credential helper
git config --global credential.helper store

# 3. Usar token pessoal ao invés de senha
# Criar token em GitHub Settings > Developer settings > Personal access tokens
```

---

## 📦 Node.js e NPM

### ❌ Problema: NVM não funciona

**Soluções:**

```bash
# 1. Instalar NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 2. Recarregar terminal
source ~/.bashrc
source ~/.zshrc

# 3. Verificar instalação
nvm --version

# 4. Instalar Node.js
nvm install --lts
nvm use --lts
```

### ❌ Problema: Erro de permissão NPM

**Soluções:**

```bash
# 1. Configurar diretório global do NPM
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.zshrc
source ~/.zshrc

# 2. Ou usar NPX para executar pacotes
npx create-react-app meu-app
```

### ❌ Problema: Versão incorreta do Node

**Soluções:**

```bash
# 1. Listar versões instaladas
nvm list

# 2. Instalar versão específica
nvm install 18.17.0
nvm use 18.17.0

# 3. Definir versão padrão
nvm alias default 18.17.0
```

---

## 🐍 Python

### ❌ Problema: Python 2 ao invés de Python 3

**Soluções:**

```bash
# 1. Verificar versões instaladas
python --version
python3 --version

# 2. Criar alias no .zshrc
echo 'alias python=python3' >> ~/.zshrc
echo 'alias pip=pip3' >> ~/.zshrc
source ~/.zshrc

# 3. Instalar Python 3 se necessário
sudo apt update
sudo apt install python3 python3-pip
```

### ❌ Problema: Pip não funciona

**Soluções:**

```bash
# 1. Reinstalar pip
sudo apt install python3-pip

# 2. Atualizar pip
python3 -m pip install --upgrade pip

# 3. Usar python -m pip
python3 -m pip install package_name
```

### ❌ Problema: Ambiente virtual não ativa

**Soluções:**

```bash
# 1. Criar ambiente virtual
python3 -m venv venv

# 2. Ativar ambiente
source venv/bin/activate

# 3. Verificar se está ativo
which python
which pip

# 4. Desativar quando necessário
deactivate
```

---

## 🐳 Docker

### ❌ Problema: Docker não inicia

**Soluções:**

```bash
# 1. Verificar se serviço está rodando
sudo systemctl status docker

# 2. Iniciar serviço
sudo systemctl start docker

# 3. Habilitar inicialização automática
sudo systemctl enable docker

# 4. Adicionar usuário ao grupo docker
sudo usermod -aG docker $USER
# Fazer logout/login após este comando
```

### ❌ Problema: Erro de permissão

**Soluções:**

```bash
# 1. Verificar grupos do usuário
groups $USER

# 2. Adicionar ao grupo docker
sudo usermod -aG docker $USER

# 3. Reiniciar WSL2 ou fazer logout/login
exit
# Abrir novo terminal

# 4. Testar sem sudo
docker run hello-world
```

### ❌ Problema: Docker Desktop no Windows

**Soluções:**

1. Instalar Docker Desktop para Windows
2. Habilitar integração com WSL2
3. Configurar recursos (CPU/Memory)
4. Verificar se WSL2 backend está habilitado

---

## 💻 VS Code

### ❌ Problema: VS Code não abre do terminal

**Soluções:**

```bash
# 1. Instalar novamente
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code

# 2. Verificar PATH
which code

# 3. Adicionar ao PATH se necessário
echo 'export PATH="/usr/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### ❌ Problema: Extensões não instalam

**Soluções:**

```bash
# 1. Verificar se VS Code está funcionando
code --version

# 2. Instalar extensão específica
code --install-extension ms-python.python

# 3. Listar extensões instaladas
code --list-extensions

# 4. Limpar cache se necessário
rm -rf ~/.vscode/extensions
```

### ❌ Problema: Terminal integrado não funciona

**Soluções:**

1. Verificar configuração no settings.json:

```json
{
  "terminal.integrated.shell.linux": "/usr/bin/zsh",
  "terminal.integrated.defaultProfile.linux": "zsh"
}
```

2. Recarregar VS Code: `Ctrl+Shift+P` > "Developer: Reload Window"

### ❌ Problema: Fonte não aparece

**Soluções:**

1. Instalar FiraCode Nerd Font
2. Configurar no settings.json:

```json
{
  "editor.fontFamily": "'FiraCode Nerd Font', monospace",
  "editor.fontLigatures": true
}
```

---

## 📝 Sublime Text

### ❌ Problema: Package Control não instala

**Soluções:**

```bash
# 1. Instalar manualmente
cd ~/.config/sublime-text/Installed\ Packages/
wget https://packagecontrol.io/Package\ Control.sublime-package

# 2. Reiniciar Sublime Text

# 3. Verificar instalação
# Tools > Command Palette > Package Control
```

### ❌ Problema: Configurações não carregam

**Soluções:**

```bash
# 1. Verificar diretório de configuração
ls ~/.config/sublime-text/Packages/User/

# 2. Copiar configurações
cp ~/my-settings/configs/sublime-* ~/.config/sublime-text/Packages/User/

# 3. Reiniciar Sublime Text
```

---

## 🚀 Performance Geral

### ❌ Problema: Sistema lento

**Soluções:**

```bash
# 1. Verificar uso de CPU e memória
htop

# 2. Limpar cache
sudo apt clean
sudo apt autoremove

# 3. Verificar processos
ps aux | head -20

# 4. Verificar espaço em disco
df -h
du -sh ~/.[^.]*
```

### ❌ Problema: Terminal lento

**Soluções:**

```bash
# 1. Reduzir plugins do ZSH
# Editar ~/.zshrc e comentar plugins desnecessários

# 2. Limpar histórico
rm ~/.zsh_history

# 3. Otimizar Starship
# Editar ~/.config/starship.toml e desabilitar módulos desnecessários

# 4. Verificar se há loops infinitos
echo $PATH | tr ':' '\n' | sort | uniq -c | sort -nr
```

### ❌ Problema: Git lento

**Soluções:**

```bash
# 1. Configurar garbage collection
git config --global gc.auto 1

# 2. Limpar repositório
git gc --prune=now

# 3. Verificar tamanho do repositório
git count-objects -vH

# 4. Usar SSH ao invés de HTTPS
git remote set-url origin git@github.com:usuario/repo.git
```

---

## 🆘 Comandos de Emergência

### 🔄 Reset Completo do Ambiente

```bash
#!/bin/bash
# reset-environment.sh - Use apenas em caso de problemas graves

echo "⚠️ ATENÇÃO: Este script irá resetar todo o ambiente!"
echo "Pressione Ctrl+C para cancelar ou Enter para continuar..."
read

# Backup configurações atuais
mkdir -p ~/backup-emergency-$(date +%Y%m%d_%H%M%S)
cp ~/.zshrc ~/backup-emergency-*/
cp ~/.gitconfig ~/backup-emergency-*/
cp -r ~/.config ~/backup-emergency-*/

# Reset ZSH
rm -rf ~/.oh-my-zsh
rm ~/.zshrc

# Reset Starship
rm ~/.config/starship.toml

# Reinstalar tudo
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/setup-complete.sh | bash
```

### 🔍 Diagnóstico Completo

```bash
#!/bin/bash
# diagnostico.sh - Verificar estado do ambiente

echo "🔍 DIAGNÓSTICO DO AMBIENTE DE DESENVOLVIMENTO"
echo "============================================="

echo "📋 Sistema:"
uname -a
lsb_release -a 2>/dev/null

echo -e "\n🐚 Shell:"
echo "Current shell: $SHELL"
echo "ZSH version: $(zsh --version 2>/dev/null || echo 'Não instalado')"

echo -e "\n⭐ Starship:"
starship --version 2>/dev/null || echo "Não instalado"

echo -e "\n🔧 Git:"
git --version 2>/dev/null || echo "Não instalado"
git config user.name 2>/dev/null || echo "Usuário não configurado"
git config user.email 2>/dev/null || echo "Email não configurado"

echo -e "\n📦 Node.js:"
node --version 2>/dev/null || echo "Não instalado"
npm --version 2>/dev/null || echo "NPM não instalado"
nvm --version 2>/dev/null || echo "NVM não instalado"

echo -e "\n🐍 Python:"
python3 --version 2>/dev/null || echo "Python3 não instalado"
pip3 --version 2>/dev/null || echo "pip3 não instalado"

echo -e "\n🐳 Docker:"
docker --version 2>/dev/null || echo "Docker não instalado"
docker-compose --version 2>/dev/null || echo "Docker Compose não instalado"

echo -e "\n💻 Editores:"
code --version 2>/dev/null | head -1 || echo "VS Code não instalado"
subl --version 2>/dev/null || echo "Sublime Text não instalado"

echo -e "\n🗂️ Ferramentas CLI:"
bat --version 2>/dev/null | head -1 || echo "bat não instalado"
eza --version 2>/dev/null | head -1 || echo "eza não instalado"
fzf --version 2>/dev/null || echo "fzf não instalado"
zoxide --version 2>/dev/null || echo "zoxide não instalado"

echo -e "\n📁 Estrutura de arquivos importantes:"
ls -la ~/.zshrc 2>/dev/null || echo ".zshrc não encontrado"
ls -la ~/.gitconfig 2>/dev/null || echo ".gitconfig não encontrado"
ls -la ~/.config/starship.toml 2>/dev/null || echo "starship.toml não encontrado"
ls -la ~/.oh-my-zsh 2>/dev/null || echo "Oh My Zsh não encontrado"

echo -e "\n✅ Diagnóstico concluído!"
```

---

## 📞 Suporte Adicional

### 🔗 Links Úteis

- [WSL2 Troubleshooting](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting)
- [Oh My Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh/wiki)
- [Starship Configuration](https://starship.rs/config/)
- [Git Documentation](https://git-scm.com/docs)
- [VS Code Documentation](https://code.visualstudio.com/docs)

### 📧 Como Relatar Problemas

1. Execute o script de diagnóstico acima
2. Descreva o problema detalhadamente
3. Inclua mensagens de erro completas
4. Mencione o que você estava tentando fazer
5. Inclua informações do sistema (WSL2, Ubuntu, etc.)

### 🏃‍♂️ Ações Rápidas

```bash
# Ver este arquivo
cat ~/my-settings/docs/TROUBLESHOOTING.md

# Recarregar configurações
source ~/.zshrc

# Verificar logs do sistema
journalctl --user -f

# Verificar processos
htop

# Limpar cache
sudo apt clean && sudo apt autoremove
```

---

**💡 Dica:** Mantenha este arquivo sempre atualizado com novos problemas e soluções que você encontrar!
