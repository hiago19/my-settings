# 💻 Setup Completo do Visual Studio Code

Este guia contém todas as configurações, extensões e personalizações para um ambiente de desenvolvimento profissional no VS Code.

## 📋 Índice

- [1. Instalação do VS Code](#1-instalação-do-vs-code)
- [2. Extensões Essenciais](#2-extensões-essenciais)
- [3. Configurações (settings.json)](#3-configurações-settingsjson)
- [4. Atalhos de Teclado (keybindings.json)](#4-atalhos-de-teclado-keybindingsjson)
- [5. Snippets Personalizados](#5-snippets-personalizados)
- [6. Configurações por Linguagem](#6-configurações-por-linguagem)
- [7. Configurações do Workspace](#7-configurações-do-workspace)
- [8. Scripts de Instalação Automática](#8-scripts-de-instalação-automática)
- [9. Themes e Personalização](#9-themes-e-personalização)
- [10. Configurações Avançadas](#10-configurações-avançadas)

---

## 1. Instalação do VS Code

### 📖 Documentação Oficial

- [Visual Studio Code](https://code.visualstudio.com/)
- [Setup Overview](https://code.visualstudio.com/docs/setup/setup-overview)

### 🚀 Instalação

#### Windows

```powershell
# Via Chocolatey
choco install vscode

# Via Winget
winget install Microsoft.VisualStudioCode

# Ou baixar diretamente
# https://code.visualstudio.com/download
```

#### Linux (WSL/Ubuntu)

```bash
# Método 1: Via repositório oficial
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code

# Método 2: Via Snap
sudo snap install code --classic
```

---

## 2. Extensões Essenciais

### 📦 Lista Completa de Extensões

#### 🤖 AI e Produtividade

- `github.copilot` - GitHub Copilot
- `github.copilot-chat` - GitHub Copilot Chat
- `continue.continue` - Continue AI Code Assistant

#### 🎨 Visual e Themes

- `vscode-icons-team.vscode-icons` - VSCode Icons
- `github.github-vscode-theme` - GitHub Theme
- `johnpapa.vscode-peacock` - Peacock (Colorir workspaces)

#### 🔧 Ferramentas Gerais

- `adpyke.codesnap` - CodeSnap (Screenshots de código)
- `ms-vscode.live-server` - Live Server
- `humao.rest-client` - REST Client
- `gruntfuggly.todo-tree` - Todo Tree
- `streetsidesoftware.code-spell-checker` - Code Spell Checker
- `streetsidesoftware.code-spell-checker-portuguese-brazilian` - Spell Checker PT-BR

#### 🌐 Web Development

- `esbenp.prettier-vscode` - Prettier
- `dbaeumer.vscode-eslint` - ESLint
- `bradlc.vscode-tailwindcss` - Tailwind CSS
- `christian-kohler.path-intellisense` - Path Intellisense
- `zignd.html-css-class-completion` - HTML CSS Class Completion

#### ⚛️ JavaScript/TypeScript/React

- `ms-vscode.vscode-typescript-next` - TypeScript Importer
- `chakrounanas.turbo-console-log` - Turbo Console Log
- `firsttris.vscode-jest-runner` - Jest Runner
- `orta.vscode-jest` - Jest
- `wallabyjs.quokka-vscode` - Quokka.js

#### 🐍 Python

- `ms-python.python` - Python
- `ms-python.vscode-pylance` - Pylance
- `ms-python.debugpy` - Python Debugger
- `ms-python.isort` - isort

#### 🗄️ Database e Backend

- `mongodb.mongodb-vscode` - MongoDB
- `prisma.prisma` - Prisma
- `batisteo.vscode-django` - Django

#### 🐳 DevOps e Cloud

- `ms-azuretools.vscode-docker` - Docker
- `ms-kubernetes-tools.vscode-kubernetes-tools` - Kubernetes
- `github.vscode-github-actions` - GitHub Actions
- `redhat.vscode-yaml` - YAML

#### 🔗 Git e Colaboração

- `eamodio.gitlens` - GitLens
- `github.vscode-pull-request-github` - GitHub Pull Requests
- `donjayamanne.githistory` - Git History
- `ms-vsliveshare.vsliveshare` - Live Share

#### 🔍 Qualidade de Código

- `sonarsource.sonarlint-vscode` - SonarLint
- `naumovs.color-highlight` - Color Highlight
- `oderwat.indent-rainbow` - Indent Rainbow

#### 📝 Marcação e Documentação

- `jebbs.plantuml` - PlantUML
- `tamasfe.even-better-toml` - Better TOML
- `quicktype.quicktype` - Quicktype

#### 🔧 Utilitários

- `xyz.local-history` - Local History
- `postman.postman-for-vscode` - Postman

---

## 3. Configurações (settings.json)

### ⚙️ Configuração Completa

```json
{
  // === GITHUB COPILOT ===
  "github.copilot.enable": {
    "*": true,
    "plaintext": true,
    "markdown": false,
    "scminput": false
  },
  "github.copilot.nextEditSuggestions.enabled": true,

  // === APPEARANCE ===
  "workbench.iconTheme": "vscode-icons",
  "workbench.colorTheme": "GitHub Dark",
  "workbench.activityBar.location": "top",
  "workbench.tree.indent": 12,

  // === EDITOR ===
  "editor.fontFamily": "FiraCode Nerd Font, 'Courier New', monospace",
  "editor.fontSize": 13,
  "editor.fontLigatures": true,
  "editor.lineHeight": 1.6,
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.wordWrap": "on",
  "editor.minimap.enabled": true,
  "editor.minimap.maxColumn": 120,
  "editor.rulers": [80, 120],
  "editor.formatOnSave": true,
  "editor.formatOnPaste": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": "explicit",
    "source.organizeImports": "explicit"
  },
  "editor.suggestSelection": "first",
  "editor.acceptSuggestionOnCommitCharacter": false,
  "editor.cursorBlinking": "smooth",
  "editor.cursorSmoothCaretAnimation": "on",
  "editor.smoothScrolling": true,

  // === FILES ===
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "files.trimFinalNewlines": true,
  "files.exclude": {
    "**/node_modules": true,
    "**/dist": true,
    "**/build": true,
    "**/.git": true,
    "**/.DS_Store": true,
    "**/Thumbs.db": true
  },

  // === TERMINAL ===
  "terminal.integrated.fontSize": 12,
  "terminal.integrated.fontFamily": "FiraCode Nerd Font",
  "terminal.integrated.copyOnSelection": true,
  "terminal.integrated.cursorBlinking": true,
  "terminal.integrated.defaultProfile.windows": "Git Bash",
  "terminal.integrated.defaultProfile.linux": "zsh",

  // === SEARCH ===
  "search.exclude": {
    "**/node_modules": true,
    "**/bower_components": true,
    "**/dist": true,
    "**/build": true,
    "**/.git": true
  },

  // === LANGUAGE SPECIFIC ===
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[css]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.organizeImports": "explicit"
    }
  },

  // === EXTENSIONS SETTINGS ===

  // Prettier
  "prettier.singleQuote": true,
  "prettier.semi": true,
  "prettier.tabWidth": 2,
  "prettier.trailingComma": "es5",
  "prettier.printWidth": 80,

  // ESLint
  "eslint.alwaysShowStatus": true,
  "eslint.format.enable": true,

  // GitLens
  "gitlens.codeLens.enabled": false,
  "gitlens.currentLine.enabled": false,
  "gitlens.hovers.enabled": false,

  // Python
  "python.defaultInterpreterPath": "python3",
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": false,
  "python.linting.flake8Enabled": true,
  "python.formatting.provider": "black",

  // Live Server
  "liveServer.settings.donotShowInfoMsg": true,
  "liveServer.settings.donotVerifyTags": true,

  // Todo Tree
  "todo-tree.general.tags": [
    "BUG",
    "HACK",
    "FIXME",
    "TODO",
    "XXX",
    "[ ]",
    "[x]"
  ],
  "todo-tree.regex.regex": "(//|#|<!--|;|/\\*|^|^\\s*(-|\\d+.))\\s*($TAGS)",

  // Peacock
  "peacock.favoriteColors": [
    {
      "name": "Angular Red",
      "value": "#dd0531"
    },
    {
      "name": "React Blue",
      "value": "#61dafb"
    },
    {
      "name": "Vue Green",
      "value": "#42b883"
    },
    {
      "name": "Node Green",
      "value": "#215732"
    },
    {
      "name": "Python",
      "value": "#25415d"
    },
    {
      "name": "TypeScript",
      "value": "#007acc"
    },
    {
      "name": "JavaScript Yellow",
      "value": "#f9e64f"
    },
    {
      "name": "Docker",
      "value": "#1d63ed"
    },
    {
      "name": "Kubernetes",
      "value": "#436ee3"
    }
  ],

  // Remote Development
  "remote.autoForwardPortsSource": "hybrid",
  "remote.defaultExtensionsIfInstalledLocally": [
    "GitHub.copilot",
    "GitHub.copilot-chat",
    "GitHub.vscode-pull-request-github",
    "adpyke.codesnap"
  ],

  // Workbench
  "workbench.settings.applyToAllProfiles": [
    "editor.fontFamily",
    "editor.formatOnSave",
    "workbench.tree.indent"
  ],

  // Telemetry
  "redhat.telemetry.enabled": false,
  "telemetry.telemetryLevel": "off",

  // Security
  "security.workspace.trust.untrustedFiles": "open",

  // Extensions
  "extensions.autoUpdate": true,
  "extensions.ignoreRecommendations": false,

  // Emmet
  "emmet.includeLanguages": {
    "javascript": "javascriptreact",
    "typescript": "typescriptreact"
  },

  // Breadcrumbs
  "breadcrumbs.enabled": true,
  "breadcrumbs.symbolSortOrder": "type",

  // Problems
  "problems.showCurrentInStatus": true,

  // Debug
  "debug.inlineValues": "auto",
  "debug.showInStatusBar": "always",

  // Chat
  "chat.instructionsFilesLocations": {
    ".github/instructions": true,
    "/tmp/postman-collections-post-response.instructions.md": true,
    "/tmp/postman-collections-pre-request.instructions.md": true,
    "/tmp/postman-folder-post-response.instructions.md": true,
    "/tmp/postman-folder-pre-request.instructions.md": true,
    "/tmp/postman-http-request-post-response.instructions.md": true,
    "/tmp/postman-http-request-pre-request.instructions.md": true
  }
}
```

---

## 4. Atalhos de Teclado (keybindings.json)

### ⌨️ Atalhos Personalizados

```json
[
  // === NAVIGATION ===
  {
    "key": "ctrl+shift+e",
    "command": "workbench.view.explorer"
  },
  {
    "key": "ctrl+shift+f",
    "command": "workbench.view.search"
  },
  {
    "key": "ctrl+shift+g",
    "command": "workbench.view.scm"
  },
  {
    "key": "ctrl+shift+d",
    "command": "workbench.view.debug"
  },
  {
    "key": "ctrl+shift+x",
    "command": "workbench.view.extensions"
  },

  // === TERMINAL ===
  {
    "key": "ctrl+`",
    "command": "workbench.action.terminal.toggleTerminal"
  },
  {
    "key": "ctrl+shift+`",
    "command": "workbench.action.terminal.new"
  },

  // === EDITOR ===
  {
    "key": "ctrl+d",
    "command": "editor.action.duplicateSelection"
  },
  {
    "key": "alt+up",
    "command": "editor.action.moveLinesUpAction"
  },
  {
    "key": "alt+down",
    "command": "editor.action.moveLinesDownAction"
  },
  {
    "key": "ctrl+alt+up",
    "command": "editor.action.insertCursorAbove"
  },
  {
    "key": "ctrl+alt+down",
    "command": "editor.action.insertCursorBelow"
  },
  {
    "key": "ctrl+shift+k",
    "command": "editor.action.deleteLines"
  },
  {
    "key": "ctrl+enter",
    "command": "editor.action.insertLineAfter"
  },
  {
    "key": "ctrl+shift+enter",
    "command": "editor.action.insertLineBefore"
  },

  // === FORMATTING ===
  {
    "key": "ctrl+shift+i",
    "command": "editor.action.formatDocument"
  },
  {
    "key": "ctrl+k ctrl+f",
    "command": "editor.action.formatSelection"
  },

  // === SIDEBAR ===
  {
    "key": "ctrl+b",
    "command": "workbench.action.toggleSidebarVisibility"
  },

  // === QUICK ACTIONS ===
  {
    "key": "ctrl+shift+p",
    "command": "workbench.action.showCommands"
  },
  {
    "key": "ctrl+p",
    "command": "workbench.action.quickOpen"
  },
  {
    "key": "ctrl+shift+o",
    "command": "workbench.action.gotoSymbol"
  },

  // === SPLIT EDITOR ===
  {
    "key": "ctrl+\\",
    "command": "workbench.action.splitEditor"
  },
  {
    "key": "ctrl+1",
    "command": "workbench.action.focusFirstEditorGroup"
  },
  {
    "key": "ctrl+2",
    "command": "workbench.action.focusSecondEditorGroup"
  },
  {
    "key": "ctrl+3",
    "command": "workbench.action.focusThirdEditorGroup"
  },

  // === SEARCH AND REPLACE ===
  {
    "key": "ctrl+f",
    "command": "actions.find"
  },
  {
    "key": "ctrl+h",
    "command": "editor.action.startFindReplaceAction"
  },
  {
    "key": "ctrl+shift+f",
    "command": "workbench.action.findInFiles"
  },
  {
    "key": "ctrl+shift+h",
    "command": "workbench.action.replaceInFiles"
  },

  // === GIT ===
  {
    "key": "ctrl+shift+g g",
    "command": "git.openChange"
  },
  {
    "key": "ctrl+shift+g c",
    "command": "git.commit"
  },
  {
    "key": "ctrl+shift+g p",
    "command": "git.push"
  },
  {
    "key": "ctrl+shift+g s",
    "command": "git.sync"
  },

  // === CUSTOM EXTENSIONS ===
  {
    "key": "ctrl+shift+a",
    "command": "turboConsoleLog.displayLogMessage"
  },
  {
    "key": "ctrl+shift+alt+a",
    "command": "turboConsoleLog.deleteAllLogMessages"
  }
]
```

---

## 5. Snippets Personalizados

### 📝 JavaScript/TypeScript Snippets

Criar arquivo: `%APPDATA%\Code\User\snippets\javascript.json`

```json
{
  "Console Log": {
    "prefix": "log",
    "body": ["console.log('$1:', $1);"],
    "description": "Console log with label"
  },
  "Arrow Function": {
    "prefix": "af",
    "body": ["const $1 = ($2) => {", "  $3", "};"],
    "description": "Arrow function"
  },
  "Async Arrow Function": {
    "prefix": "aaf",
    "body": ["const $1 = async ($2) => {", "  $3", "};"],
    "description": "Async arrow function"
  },
  "Try Catch": {
    "prefix": "tc",
    "body": [
      "try {",
      "  $1",
      "} catch (error) {",
      "  console.error('Error:', error);",
      "  $2",
      "}"
    ],
    "description": "Try catch block"
  },
  "Promise": {
    "prefix": "prom",
    "body": ["new Promise((resolve, reject) => {", "  $1", "});"],
    "description": "Promise"
  },
  "Import": {
    "prefix": "imp",
    "body": ["import { $2 } from '$1';"],
    "description": "Import statement"
  },
  "Export Default": {
    "prefix": "ed",
    "body": ["export default $1;"],
    "description": "Export default"
  },
  "React Component": {
    "prefix": "rfc",
    "body": [
      "import React from 'react';",
      "",
      "const $1 = () => {",
      "  return (",
      "    <div>",
      "      $2",
      "    </div>",
      "  );",
      "};",
      "",
      "export default $1;"
    ],
    "description": "React functional component"
  },
  "React useState": {
    "prefix": "us",
    "body": ["const [$1, set${1/(.*)/${1:/capitalize}/}] = useState($2);"],
    "description": "React useState hook"
  },
  "React useEffect": {
    "prefix": "ue",
    "body": ["useEffect(() => {", "  $1", "}, [$2]);"],
    "description": "React useEffect hook"
  }
}
```

### 🐍 Python Snippets

Criar arquivo: `%APPDATA%\Code\User\snippets\python.json`

```json
{
  "Print Debug": {
    "prefix": "pdb",
    "body": ["print(f'$1: {$1}')"],
    "description": "Print debug with f-string"
  },
  "Main Guard": {
    "prefix": "main",
    "body": ["if __name__ == '__main__':", "    $1"],
    "description": "Main guard"
  },
  "Try Except": {
    "prefix": "try",
    "body": [
      "try:",
      "    $1",
      "except $2 as e:",
      "    print(f'Error: {e}')",
      "    $3"
    ],
    "description": "Try except block"
  },
  "Class": {
    "prefix": "class",
    "body": [
      "class $1:",
      "    def __init__(self$2):",
      "        $3",
      "",
      "    def __str__(self):",
      "        return f'$1($4)'"
    ],
    "description": "Python class"
  },
  "Function": {
    "prefix": "def",
    "body": ["def $1($2) -> $3:", "    \"\"\"$4\"\"\"", "    $5"],
    "description": "Python function with type hints"
  }
}
```

---

## 6. Configurações por Linguagem

### ⚙️ Workspace Settings

Criar arquivo `.vscode/settings.json` na raiz do projeto:

```json
{
  // === PROJECT SPECIFIC ===
  "python.defaultInterpreterPath": "./venv/bin/python",
  "python.terminal.activateEnvironment": true,

  "eslint.workingDirectories": ["src"],
  "typescript.preferences.includePackageJsonAutoImports": "auto",

  // === EXCLUDE FILES ===
  "files.exclude": {
    "**/node_modules": true,
    "**/.git": true,
    "**/.DS_Store": true,
    "**/Thumbs.db": true,
    "**/__pycache__": true,
    "**/.pytest_cache": true,
    "**/dist": true,
    "**/build": true
  },

  // === SEARCH EXCLUDE ===
  "search.exclude": {
    "**/node_modules": true,
    "**/bower_components": true,
    "**/*.code-search": true,
    "**/dist": true,
    "**/build": true
  },

  // === EMMET ===
  "emmet.includeLanguages": {
    "javascript": "javascriptreact",
    "typescript": "typescriptreact"
  }
}
```

---

## 7. Configurações do Workspace

### 📁 Estrutura do .vscode

```
.vscode/
├── settings.json      # Configurações do projeto
├── launch.json        # Configurações de debug
├── tasks.json         # Tasks automatizadas
└── extensions.json    # Extensões recomendadas
```

#### extensions.json

```json
{
  "recommendations": [
    "github.copilot",
    "github.copilot-chat",
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "ms-python.python",
    "ms-python.vscode-pylance",
    "vscode-icons-team.vscode-icons",
    "github.github-vscode-theme"
  ]
}
```

#### launch.json (Node.js)

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch Node.js",
      "type": "node",
      "request": "launch",
      "program": "${workspaceFolder}/index.js",
      "console": "integratedTerminal"
    },
    {
      "name": "Launch React App",
      "type": "node",
      "request": "launch",
      "cwd": "${workspaceFolder}",
      "runtimeExecutable": "npm",
      "runtimeArgs": ["start"]
    }
  ]
}
```

#### tasks.json

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "npm install",
      "type": "shell",
      "command": "npm install",
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    },
    {
      "label": "npm start",
      "type": "shell",
      "command": "npm start",
      "group": "build",
      "presentation": {
        "echo": true,
        "reveal": "always",
        "focus": false,
        "panel": "shared"
      }
    }
  ]
}
```

---

## 8. Scripts de Instalação Automática

### 🚀 Script Principal (install-vscode-extensions.sh)

Criar arquivo `scripts/install-vscode-extensions.sh`:

```bash
#!/usr/bin/env bash

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se VS Code está instalado
if ! command -v code &> /dev/null; then
    print_error "VS Code não está instalado ou não está no PATH"
    exit 1
fi

print_status "Instalando extensões do VS Code..."

# Lista de extensões
extensions=(
    # AI e Produtividade
    "github.copilot"
    "github.copilot-chat"

    # Visual e Themes
    "vscode-icons-team.vscode-icons"
    "github.github-vscode-theme"
    "johnpapa.vscode-peacock"

    # Ferramentas Gerais
    "adpyke.codesnap"
    "ms-vscode.live-server"
    "humao.rest-client"
    "gruntfuggly.todo-tree"
    "streetsidesoftware.code-spell-checker"
    "streetsidesoftware.code-spell-checker-portuguese-brazilian"

    # Web Development
    "esbenp.prettier-vscode"
    "dbaeumer.vscode-eslint"
    "bradlc.vscode-tailwindcss"
    "christian-kohler.path-intellisense"
    "zignd.html-css-class-completion"

    # JavaScript/TypeScript/React
    "ms-vscode.vscode-typescript-next"
    "chakrounanas.turbo-console-log"
    "firsttris.vscode-jest-runner"
    "orta.vscode-jest"
    "wallabyjs.quokka-vscode"

    # Python
    "ms-python.python"
    "ms-python.vscode-pylance"
    "ms-python.debugpy"
    "ms-python.isort"

    # Database e Backend
    "mongodb.mongodb-vscode"
    "prisma.prisma"
    "batisteo.vscode-django"

    # DevOps e Cloud
    "ms-azuretools.vscode-docker"
    "ms-kubernetes-tools.vscode-kubernetes-tools"
    "github.vscode-github-actions"
    "redhat.vscode-yaml"

    # Git e Colaboração
    "eamodio.gitlens"
    "github.vscode-pull-request-github"
    "donjayamanne.githistory"
    "ms-vsliveshare.vsliveshare"

    # Qualidade de Código
    "sonarsource.sonarlint-vscode"
    "naumovs.color-highlight"
    "oderwat.indent-rainbow"

    # Marcação e Documentação
    "jebbs.plantuml"
    "tamasfe.even-better-toml"
    "quicktype.quicktype"

    # Utilitários
    "xyz.local-history"
    "postman.postman-for-vscode"
)

# Instalar extensões
for extension in "${extensions[@]}"; do
    print_status "Instalando $extension..."
    code --install-extension "$extension" --force
done

print_status "Todas as extensões foram instaladas!"
print_warning "Reinicie o VS Code para garantir que todas as extensões funcionem corretamente."
```

### 📦 Script com arquivo de extensões

Usar o arquivo `configs/extensions.txt` existente:

```bash
#!/usr/bin/env bash

print_status() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

# Verificar se arquivo extensions.txt existe
if [ ! -f "extensions.txt" ]; then
    echo "Baixando lista de extensões..."
    wget https://raw.githubusercontent.com/hiago19/my-settings/main/configs/extensions.txt
fi

print_status "Instalando extensões do VS Code..."

# Instalar extensões
cat extensions.txt | while read extension || [[ -n $extension ]]; do
    if [[ -n "$extension" && ! "$extension" =~ ^# ]]; then
        print_status "Instalando $extension..."
        code --install-extension $extension --force
    fi
done

print_status "Instalação concluída!"
```

---

## 9. Themes e Personalização

### 🎨 Themes Recomendados

#### Themes Escuros

- `GitHub Dark` (Padrão recomendado)
- `One Dark Pro`
- `Dracula Official`
- `Night Owl`
- `Material Theme`

#### Themes Claros

- `GitHub Light`
- `Light+`
- `Solarized Light`

#### Icon Themes

- `VSCode Icons` (Recomendado)
- `Material Icon Theme`
- `Helium Icon Theme`

### 🎨 Customização Visual

```json
{
  // === WORKBENCH COLORS ===
  "workbench.colorCustomizations": {
    "editor.background": "#0d1117",
    "sideBar.background": "#010409",
    "activityBar.background": "#010409",
    "panel.background": "#0d1117",
    "terminal.background": "#0d1117"
  },

  // === TOKEN COLORS ===
  "editor.tokenColorCustomizations": {
    "[GitHub Dark]": {
      "comments": "#6e7681",
      "keywords": "#ff7b72",
      "strings": "#a5d6ff",
      "numbers": "#79c0ff",
      "functions": "#d2a8ff"
    }
  }
}
```

---

## 10. Configurações Avançadas

### 🔧 Performance

```json
{
  "files.watcherExclude": {
    "**/node_modules/**": true,
    "**/dist/**": true,
    "**/build/**": true,
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true
  },
  "search.followSymlinks": false,
  "typescript.tsc.autoDetect": "off",
  "npm.autoDetect": "off",
  "gulp.autoDetect": "off",
  "grunt.autoDetect": "off",
  "jake.autoDetect": "off"
}
```

### 🔒 Segurança

```json
{
  "security.workspace.trust.untrustedFiles": "prompt",
  "security.workspace.trust.banner": "always",
  "security.workspace.trust.startupPrompt": "always",
  "security.workspace.trust.enabled": true
}
```

### 📱 Sync Settings

```json
{
  "settingsSync.ignoredExtensions": [],
  "settingsSync.ignoredSettings": [],
  "settingsSync.keybindingsPerPlatform": true
}
```

---

## 🚀 Setup Rápido

### 📥 Instalação Completa

```bash
# 1. Baixar configurações
git clone https://github.com/hiago19/my-settings.git
cd my-settings

# 2. Instalar extensões
chmod +x vscode/install-extensions.sh
./vscode/install-extensions.sh

# 3. Copiar configurações (backup automático)
cp ~/.config/Code/User/settings.json ~/.config/Code/User/settings.json.backup
cp configs/vscode-settings.json ~/.config/Code/User/settings.json
cp configs/vscode-keybindings.json ~/.config/Code/User/keybindings.json
```

### 🔄 Update Script

```bash
#!/bin/bash
# update-vscode-config.sh

print_status() {
    echo -e "\033[0;32m[INFO]\033[0m $1"
}

print_status "Atualizando configurações do VS Code..."

# Backup das configurações atuais
cp ~/.config/Code/User/settings.json ~/.config/Code/User/settings.json.backup.$(date +%Y%m%d_%H%M%S)

# Baixar configurações atualizadas
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/configs/vscode-settings.json -o ~/.config/Code/User/settings.json
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/configs/vscode-keybindings.json -o ~/.config/Code/User/keybindings.json

# Atualizar extensões
./vscode/install-extensions.sh

print_status "Configurações atualizadas com sucesso!"
```

---

## ✅ Verificação Final

### 🔍 Checklist

- [ ] VS Code instalado
- [ ] Todas as extensões instaladas
- [ ] Configurações aplicadas
- [ ] Atalhos funcionando
- [ ] Themes configurados
- [ ] Terminal integrado funcionando
- [ ] Git integrado funcionando
- [ ] Formatação automática ativa
- [ ] Copilot configurado

### 🧪 Teste Rápido

```bash
# Verificar instalação do VS Code
code --version

# Listar extensões instaladas
code --list-extensions

# Abrir VS Code com configurações
code .
```

---

## 🔗 Links Úteis

- [VS Code Documentation](https://code.visualstudio.com/docs)
- [VS Code Extensions Marketplace](https://marketplace.visualstudio.com/)
- [VS Code Settings Reference](https://code.visualstudio.com/docs/getstarted/settings)
- [VS Code Keybindings](https://code.visualstudio.com/docs/getstarted/keybindings)
- [VS Code Themes](https://code.visualstudio.com/docs/getstarted/themes)
- [GitHub Copilot](https://copilot.github.com/)

---

**🎉 Seu VS Code está configurado e otimizado para desenvolvimento profissional!**
