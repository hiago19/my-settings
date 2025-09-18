# 🛠️ My Development Settings

**Setup completo para desenvolvedores** - Configurações, scripts e documentação para configurar rapidamente um ambiente de desenvolvimento profissional.

![GitHub](https://img.shields.io/badge/Windows-WSL2-blue)
![GitHub](https://img.shields.io/badge/Terminal-ZSH-green)
![GitHub](https://img.shields.io/badge/Editor-VSCode-blue)
![GitHub](https://img.shields.io/badge/License-MIT-yellow)

## 🚀 Início Rápido

```bash
# Clonar o repositório
git clone https://github.com/hiago19/my-settings.git
cd my-settings

# Setup completo automatizado com menu interativo
./scripts/setup.sh
```

## ⚙️ Configuração Personalizada

Este projeto usa um sistema de configuração baseado em **variáveis de ambiente (.env)** seguindo padrões da indústria.

### 🔧 Como Personalizar

1. **Copie o template de configuração:**

   ```bash
   cp .env.example .env
   ```

2. **Edite suas configurações:**

   ```bash
   nano .env  # ou code .env
   ```

3. **Execute os scripts normalmente:**
   ```bash
   ./scripts/setup.sh
   ```

### 📋 Principais Configurações

| Variável                   | Descrição                              | Padrão              |
| -------------------------- | -------------------------------------- | ------------------- |
| `DEV_USER_NAME`            | Seu nome completo                      | "Bruno Hiago"       |
| `DEV_USER_EMAIL`           | Email para Git                         | "bruno@exemplo.com" |
| `INSTALL_VSCODE_ESSENTIAL` | Instalar extensões essenciais VS Code  | `true`              |
| `INSTALL_VSCODE_LANGUAGE`  | Instalar extensões de linguagens       | `true`              |
| `INSTALL_DOCKER`           | Instalar Docker                        | `true`              |
| `FAST_MODE`                | Modo rápido (pula instalações pesadas) | `false`             |

### 🎯 Exemplos de Personalização

**Modo minimalista:**

```env
INSTALL_VSCODE_LANGUAGE=false
INSTALL_VSCODE_TOOLS=false
INSTALL_DOCKER=false
FAST_MODE=true
```

**Modo desenvolvedor full-stack:**

```env
INSTALL_VSCODE_ESSENTIAL=true
INSTALL_VSCODE_LANGUAGE=true
INSTALL_VSCODE_TOOLS=true
INSTALL_VSCODE_ADVANCED=true
```

### 🛠️ Utilitários de Configuração

```bash
# Ver configurações atuais
./scripts/setup.sh  # Opção 8 do menu

# Editar configurações
nano .env  # ou code .env

# Validar sistema
./scripts/tools/validate-system.sh

# Fazer backup
./scripts/tools/backup-configs.sh
```

## 📋 Índice

- [📖 Documentação Completa](#-documentação-completa)
- [⚙️ Configurações Incluídas](#️-configurações-incluídas)
- [🔧 Scripts de Instalação](#-scripts-de-instalação)
- [📁 Estrutura do Projeto](#-estrutura-do-projeto)
- [🎯 Instalação Rápida](#-instalação-rápida)
- [🔗 Links Úteis](#-links-úteis)

---

## 📖 Documentação Completa

### 🖥️ [Terminal & WSL2 Setup](docs/TERMINAL_SETUP.md)

Configuração completa do ambiente terminal com WSL2, ZSH, Oh My Zsh, Starship e ferramentas CLI essenciais:

- ✅ WSL2 + Ubuntu
- ✅ ZSH + Oh My Zsh + Starship
- ✅ Git + SSH configurados
- ✅ Node.js (NVM) + Python + Docker
- ✅ Ferramentas CLI: bat, eza, zoxide, fzf, etc.

### 💻 [VS Code Setup](docs/VSCODE_SETUP.md)

Configuração completa do Visual Studio Code para desenvolvimento profissional:

- ✅ 40+ extensões essenciais
- ✅ Settings.json otimizado
- ✅ Atalhos personalizados
- ✅ Snippets para múltiplas linguagens
- ✅ Themes e personalização

### 📝 [Sublime Text Setup](docs/SUBLIME_TEXT_SETUP.md)

Configuração avançada do Sublime Text com pacotes e customizações:

- ✅ Package Control + pacotes essenciais
- ✅ Configurações otimizadas
- ✅ Atalhos avançados
- ✅ Snippets personalizados
- ✅ Build systems

### 🚀 [Apps Úteis](docs/USEFUL_APPS.md)

Lista curada de aplicativos essenciais para desenvolvedores:

- ✅ Ferramentas de produtividade (PowerToys, Notion)
- ✅ Desenvolvimento (Docker, Postman, DBeaver)
- ✅ Design (Figma, OBS Studio)
- ✅ Scripts de instalação automática

---

## ⚙️ Configurações Incluídas

### 🐚 Terminal (ZSH)

```bash
# Aliases otimizados
alias cat='batcat'
alias cd="z"
alias ls='eza -1 --color=always --git --icons --group-directories-first'
alias ll='eza -1 --tree --level=2 --icons --color=always --git --group-directories-first'

# Ferramentas integradas
eval "$(starship init zsh)"    # Prompt moderno
eval "$(zoxide init zsh)"      # cd inteligente
eval "$(fzf --zsh)"           # Fuzzy finder
```

### 💻 VS Code (Principais Extensões)

- **AI & Produtividade:** GitHub Copilot, GitHub Copilot Chat
- **Themes:** GitHub Theme, VSCode Icons, Peacock
- **Web Dev:** Prettier, ESLint, Tailwind CSS, Live Server
- **Languages:** Python, TypeScript, React, Vue
- **Tools:** GitLens, Docker, REST Client, SonarLint

### 📝 Sublime Text (Pacotes Essenciais)

- **Visual:** A File Icon, Material Theme, BracketHighlighter
- **Produtividade:** Emmet, SideBarEnhancements, GitGutter
- **Development:** SublimeLinter, Pretty JSON, Terminal

### 🎯 Windows Terminal

```json
{
  "defaultProfile": "Ubuntu",
  "font": "FiraCode Nerd Font",
  "colorScheme": "One Half Dark",
  "opacity": 85,
  "useAcrylic": true
}
```

---

## 🔧 Scripts de Instalação

### ⚙️ Setup Completo

```bash
# Setup completo do ambiente (Menu interativo)
./scripts/setup.sh
```

### 🖥️ Terminal Setup

```bash
# Setup completo do terminal (ZSH + Oh My Zsh + Starship)
./scripts/modules/terminal.sh
```

### 💻 VS Code Setup

```bash
# Setup completo do VS Code (extensões + configurações)
./scripts/modules/vscode.sh
```

```bash
# Instalar apenas extensões do VS Code
./scripts/tools/install-extensions.sh
```

### 🚀 Apps Windows

```powershell
# Instalar apps essenciais (PowerShell como Admin)
./scripts/tools/install-dev-apps.ps1
```

---

## 📁 Estrutura do Projeto

```
my-settings/
├── 📄 README.md                    # Este arquivo
├── 📄 LICENSE                      # Licença MIT
├── 📄 .gitignore                   # Ignorar arquivos desnecessários
├── 📄 .env.example                 # Template com 63 variáveis de configuração
├── 📄 .env                         # Suas configurações personalizadas
├── 📁 .github/                     # Instruções para IA e automação
│   └── 📖 copilot-instructions.md  # Guia para AI coding agents
├── 📁 docs/                        # Documentação detalhada
│   ├── 📖 TERMINAL_SETUP.md        # Setup Terminal/WSL2
│   ├── 📖 VSCODE_SETUP.md          # Setup VS Code
│   ├── 📖 SUBLIME_TEXT_SETUP.md    # Setup Sublime Text
│   ├── 📖 TROUBLESHOOTING.md       # Solução de problemas
│   └── 📖 USEFUL_APPS.md           # Apps recomendados
├── 📁 scripts/                     # Sistema modular de scripts
│   ├── 🎯 setup.sh                 # Interface principal (menu interativo)
│   ├── 📁 core/                    # Sistema base robusto
│   │   ├── 🏗️ bootstrap.sh         # Orquestrador de dependências
│   │   ├── 🎨 colors.sh            # Sistema de cores e UI
│   │   ├── 🔧 utils.sh             # Funções utilitárias
│   │   ├── ⚙️ env-loader.sh        # Carregador .env inteligente
│   │   └── 📂 paths.sh             # Gerenciador de caminhos
│   ├── 📁 modules/                 # Módulos de configuração
│   │   ├── 🖥️ terminal.sh          # Setup terminal completo
│   │   ├── � vscode.sh            # Setup VS Code completo
│   │   └── � complete.sh          # Setup geral completo
│   └── 📁 tools/                   # Ferramentas utilitárias
│       ├── � backup-configs.sh    # Backup automático
│       ├── � restore-configs.sh   # Restauração
│       ├── � validate-system.sh   # Validação do sistema
│       ├── � install-extensions.sh # Extensões VS Code
│       └── 🪟 install-dev-apps.ps1 # Apps Windows
└── 📁 configs/                     # Templates de configuração
    ├── 📁 git/                     # Configurações Git
    │   ├── gitconfig               # Config Git global
    │   └── gitignore_global        # Gitignore global
    ├── 📁 terminal/                # Configurações Terminal
    │   ├── zshrc                   # Config ZSH
    │   └── starship.toml           # Config Starship
    ├── 📁 vscode/                  # Configurações VS Code
    │   ├── settings.json           # Settings VS Code
    │   └── extensions.txt          # Lista de extensões
    └── 📁 sublime/                 # Configurações Sublime
        └── sublime-preferences.json # Preferences Sublime

```

---

## 🎯 Instalação Rápida

### 🔥 Setup Completo (Recomendado)

```bash
git clone https://github.com/hiago19/my-settings.git
cd my-settings

# 2. Executar setup completo
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 🎯 Setup Individual

#### Terminal (WSL2 + ZSH)

```bash
# Executar localmente
./scripts/modules/terminal.sh

# Ou via curl
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/modules/terminal.sh | bash
```

#### VS Code

```bash
# Configuração completa do VS Code
./scripts/modules/vscode.sh

# Ou apenas instalar extensões
./scripts/tools/install-extensions.sh
```

````

### 🎯 Setup Individual

#### Terminal (WSL2 + ZSH)

```bash
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/modules/terminal.sh | bash
````

#### VS Code

```bash
# Instalar extensões
wget -O - https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/tools/install-extensions.sh | bash

# Aplicar configurações
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/configs/vscode-settings.json -o ~/.config/Code/User/settings.json
```

#### Apps Windows

```powershell
# PowerShell como Administrador
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/install-dev-apps.ps1'))
```

---

## 🔄 Atualização

### 🆙 Atualizar Configurações

```bash
cd my-settings
git pull origin main
./scripts/update-configs.sh
```

### 🔄 Sincronizar com Repositório

```bash
# Fazer backup das configurações atuais
./scripts/backup-current-configs.sh

# Aplicar configurações atualizadas
./scripts/apply-configs.sh
```

---

## 🎨 Personalização

### ⚙️ Modificar Configurações ZSH

```bash
# Editar arquivo de configuração
nano ~/.zshrc

# Recarregar configurações
source ~/.zshrc
```

### 🎨 Customizar VS Code

1. Abra VS Code
2. `Ctrl+Shift+P` → "Preferences: Open Settings (JSON)"
3. Modifique conforme necessário
4. Salve e reinicie

### 🔧 Adicionar Apps

```bash
# Editar lista de apps
nano scripts/install-dev-apps.ps1

# Adicionar novos apps à lista
```

---

## 🤝 Contribuição

### 📝 Como Contribuir

1. Faça fork do projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

### 💡 Sugestões

- Novos apps úteis
- Melhorias nas configurações
- Correções de bugs
- Documentação adicional

---

## 📱 Compatibilidade

| Sistema              | Status                    | Versão Testada    |
| -------------------- | ------------------------- | ----------------- |
| Windows 10/11 + WSL2 | ✅ Totalmente Suportado   | WSL2 Ubuntu 22.04 |
| Windows 10/11        | ✅ Parcialmente Suportado | Apps e VS Code    |
| Linux Ubuntu         | ✅ Suportado              | 20.04+            |
| macOS                | ⚠️ Não testado            | -                 |

---

## 🔗 Links Úteis

### 📚 Documentação Oficial

- [WSL2 Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [VS Code](https://code.visualstudio.com/docs)
- [Sublime Text](https://www.sublimetext.com/docs/)

### 🛠️ Ferramentas

- [Windows Terminal](https://github.com/microsoft/terminal)
- [PowerToys](https://github.com/microsoft/PowerToys)
- [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts)

### 🎯 Recursos Adicionais

- [Awesome WSL](https://github.com/sirredbeard/Awesome-WSL)
- [Awesome Zsh](https://github.com/unixorn/awesome-zsh-plugins)
- [VS Code Extensions](https://marketplace.visualstudio.com/)

---

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo [LICENSE](LICENSE) para detalhes.

---

## 👨‍💻 Autor

**Bruno Hiago**

- GitHub: [@hiago19](https://github.com/hiago19)
- Email: [bhiago99@gmail.com](mailto:bhiago99@gmail.com)

---

## ⭐ Apoie o Projeto

Se este projeto te ajudou, considere dar uma ⭐ no repositório!

---

**🚀 Happy Coding! Seu ambiente de desenvolvimento está pronto para qualquer desafio!**
