#!/bin/bash

# setup-vscode.sh - Instalação e configuração completa do VS Code
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

# Verificar se comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Banner
print_banner() {
    echo -e "${PURPLE}"
    echo "██╗   ██╗███████╗     ██████╗ ██████╗ ██████╗ ███████╗"
    echo "██║   ██║██╔════╝    ██╔════╝██╔═══██╗██╔══██╗██╔════╝"
    echo "██║   ██║███████╗    ██║     ██║   ██║██║  ██║█████╗  "
    echo "╚██╗ ██╔╝╚════██║    ██║     ██║   ██║██║  ██║██╔══╝  "
    echo " ╚████╔╝ ███████║    ╚██████╗╚██████╔╝██████╔╝███████╗"
    echo "  ╚═══╝  ╚══════╝     ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝"
    echo ""
    echo "          🚀 Setup Completo do VS Code 🚀"
    echo -e "${NC}"
}

# Instalar VS Code
install_vscode() {
    print_step "Verificando instalação do VS Code..."
    
    if command_exists code; then
        print_status "VS Code já está instalado"
        code --version
        return 0
    fi
    
    print_info "Instalando VS Code..."
    
    # Baixar e instalar chave GPG
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    
    # Adicionar repositório
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    
    # Atualizar e instalar
    sudo apt update
    sudo apt install -y code
    
    # Limpar arquivo temporário
    rm packages.microsoft.gpg
    
    if command_exists code; then
        print_status "VS Code instalado com sucesso!"
        code --version
    else
        print_error "Falha na instalação do VS Code"
        exit 1
    fi
}

# Lista de extensões
install_extensions() {
    print_step "Instalando extensões do VS Code..."
    
    # Array de extensões
    extensions=(
        # Temas e aparência
        "PKief.material-icon-theme"
        "Catppuccin.catppuccin-vsc"
        "github.github-vscode-theme"
        "zhuangtongfa.Material-theme"
        "ms-vscode.vscode-json"
        
        # Git e versionamento
        "eamodio.gitlens"
        "github.vscode-pull-request-github"
        "github.copilot"
        "github.copilot-chat"
        "mhutchie.git-graph"
        
        # Linguagens - JavaScript/TypeScript
        "ms-vscode.vscode-typescript-next"
        "bradlc.vscode-tailwindcss"
        "ms-vscode.vscode-eslint"
        "esbenp.prettier-vscode"
        "ms-vscode.vscode-json"
        "formulahendry.auto-rename-tag"
        "christian-kohler.path-intellisense"
        "wix.vscode-import-cost"
        
        # Linguagens - Python
        "ms-python.python"
        "ms-python.flake8"
        "ms-python.black-formatter"
        "ms-python.mypy-type-checker"
        "kevinrose.vsc-python-indent"
        "ms-python.autopep8"
        
        # Linguagens - Web
        "ritwickdey.LiveServer"
        "ms-vscode.live-server"
        "bradlc.vscode-tailwindcss"
        "pranaygp.vscode-css-peek"
        "zignd.html-css-class-completion"
        
        # Linguagens - Outras
        "ms-vscode.cpptools"
        "rust-lang.rust-analyzer"
        "golang.go"
        "ms-dotnettools.csharp"
        "redhat.java"
        "ms-vscode.powershell"
        
        # Docker e DevOps
        "ms-azuretools.vscode-docker"
        "ms-vscode-remote.remote-containers"
        "ms-vscode-remote.remote-wsl"
        "ms-vscode-remote.remote-ssh"
        "ms-kubernetes-tools.vscode-kubernetes-tools"
        
        # Banco de dados
        "ms-mssql.mssql"
        "mtxr.sqltools"
        "mtxr.sqltools-driver-pg"
        "mtxr.sqltools-driver-mysql"
        "mongodb.mongodb-vscode"
        
        # Ferramentas de produtividade
        "aaron-bond.better-comments"
        "alefragnani.Bookmarks"
        "alefragnani.project-manager"
        "ms-vscode.todo-highlight"
        "gruntfuggly.todo-tree"
        "streetsidesoftware.code-spell-checker"
        "streetsidesoftware.code-spell-checker-portuguese-brazilian"
        
        # Formatação e qualidade de código
        "editorconfig.editorconfig"
        "DotJoshJohnson.xml"
        "ms-vscode.hexeditor"
        "mechatroner.rainbow-csv"
        "janisdd.vscode-edit-csv"
        
        # Ferramentas avançadas
        "ms-vscode.vscode-speech"
        "ms-toolsai.jupyter"
        "ms-toolsai.jupyter-keymap"
        "ms-toolsai.vscode-jupyter-cell-tags"
        "ms-toolsai.vscode-jupyter-slideshow"
        
        # Utilitários
        "formulahendry.code-runner"
        "humao.rest-client"
        "ms-vscode.vscode-serial-monitor"
        "vscode-icons-team.vscode-icons"
        "wayou.vscode-todo-highlight"
        "ms-vscode.wordcount"
        
        # Framework específicos
        "ms-vscode.vscode-node-azure-pack"
        "ms-vscode.azure-account"
        "angular.ng-template"
        "johnpapa.angular2"
        "octref.vetur"
        "vue.volar"
        "ms-vscode.vscode-react-native"
    )
    
    print_info "Instalando ${#extensions[@]} extensões..."
    
    # Instalar cada extensão
    for extension in "${extensions[@]}"; do
        print_info "Instalando: $extension"
        code --install-extension "$extension" --force
        
        if [ $? -eq 0 ]; then
            echo -e "  ${GREEN}✓${NC} $extension"
        else
            echo -e "  ${RED}✗${NC} Falha ao instalar $extension"
        fi
    done
    
    print_status "Extensões instaladas!"
}

# Configurar settings.json
configure_settings() {
    print_step "Configurando settings.json..."
    
    # Diretório de configuração do VS Code
    config_dir="$HOME/.config/Code/User"
    mkdir -p "$config_dir"
    
    # Backup da configuração existente
    if [ -f "$config_dir/settings.json" ]; then
        cp "$config_dir/settings.json" "$config_dir/settings.json.backup.$(date +%Y%m%d_%H%M%S)"
        print_info "Backup da configuração atual criado"
    fi
    
    # Criar settings.json
    cat > "$config_dir/settings.json" << 'EOF'
{
  // Editor
  "editor.fontSize": 14,
  "editor.fontFamily": "'FiraCode Nerd Font', 'Courier New', monospace",
  "editor.fontLigatures": true,
  "editor.lineHeight": 1.5,
  "editor.wordWrap": "on",
  "editor.minimap.enabled": true,
  "editor.minimap.maxColumn": 120,
  "editor.rulers": [80, 120],
  "editor.tabSize": 2,
  "editor.insertSpaces": true,
  "editor.detectIndentation": true,
  "editor.renderWhitespace": "boundary",
  "editor.trimAutoWhitespace": true,
  "editor.multiCursorModifier": "ctrlCmd",
  "editor.snippetSuggestions": "top",
  "editor.formatOnSave": true,
  "editor.formatOnPaste": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "editor.suggest.insertMode": "replace",
  "editor.acceptSuggestionOnCommitCharacter": false,
  "editor.acceptSuggestionOnEnter": "on",
  "editor.quickSuggestions": {
    "other": true,
    "comments": false,
    "strings": true
  },

  // Workbench
  "workbench.iconTheme": "material-icon-theme",
  "workbench.colorTheme": "Catppuccin Mocha",
  "workbench.startupEditor": "welcomePage",
  "workbench.editor.enablePreview": false,
  "workbench.editor.limit.enabled": true,
  "workbench.editor.limit.value": 10,
  "workbench.activityBar.visible": true,
  "workbench.statusBar.visible": true,
  "workbench.sideBar.location": "left",

  // Terminal
  "terminal.integrated.shell.linux": "/usr/bin/zsh",
  "terminal.integrated.defaultProfile.linux": "zsh",
  "terminal.integrated.fontFamily": "'FiraCode Nerd Font', monospace",
  "terminal.integrated.fontSize": 13,
  "terminal.integrated.lineHeight": 1.2,
  "terminal.integrated.cursorBlinking": true,
  "terminal.integrated.cursorStyle": "line",
  "terminal.integrated.scrollback": 10000,

  // Files
  "files.autoSave": "afterDelay",
  "files.autoSaveDelay": 1000,
  "files.trimTrailingWhitespace": true,
  "files.insertFinalNewline": true,
  "files.trimFinalNewlines": true,
  "files.encoding": "utf8",
  "files.eol": "\n",
  "files.exclude": {
    "**/node_modules": true,
    "**/bower_components": true,
    "**/.git": true,
    "**/.DS_Store": true,
    "**/Thumbs.db": true,
    "**/.nyc_output": true,
    "**/coverage": true,
    "**/.next": true,
    "**/dist": true,
    "**/build": true
  },
  "files.watcherExclude": {
    "**/node_modules/**": true,
    "**/.git/objects/**": true,
    "**/.git/subtree-cache/**": true,
    "**/node_modules/*/**": true
  },

  // Explorer
  "explorer.confirmDelete": false,
  "explorer.confirmDragAndDrop": false,
  "explorer.compactFolders": false,

  // Git
  "git.enabled": true,
  "git.autofetch": true,
  "git.confirmSync": false,
  "git.enableSmartCommit": true,
  "git.suggestSmartCommit": true,
  "scm.diffDecorations": "all",

  // Extensions
  "extensions.autoUpdate": true,
  "extensions.autoCheckUpdates": true,

  // Language-specific settings
  "[javascript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    }
  },
  "[typescript]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode",
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true
    }
  },
  "[json]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[jsonc]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[html]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[css]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[scss]": {
    "editor.defaultFormatter": "esbenp.prettier-vscode"
  },
  "[python]": {
    "editor.defaultFormatter": "ms-python.black-formatter",
    "editor.formatOnSave": true,
    "editor.codeActionsOnSave": {
      "source.organizeImports": true
    }
  },
  "[markdown]": {
    "editor.wordWrap": "on",
    "editor.renderWhitespace": "all",
    "editor.quickSuggestions": {
      "comments": "off",
      "strings": "off",
      "other": "off"
    }
  },

  // Python
  "python.defaultInterpreterPath": "/usr/bin/python3",
  "python.linting.enabled": true,
  "python.linting.flake8Enabled": true,
  "python.linting.mypyEnabled": true,
  "python.formatting.provider": "black",
  "python.sortImports.args": ["--profile", "black"],

  // JavaScript/TypeScript
  "typescript.updateImportsOnFileMove.enabled": "always",
  "javascript.updateImportsOnFileMove.enabled": "always",
  "typescript.preferences.importModuleSpecifier": "relative",
  "javascript.preferences.importModuleSpecifier": "relative",

  // Prettier
  "prettier.singleQuote": true,
  "prettier.trailingComma": "es5",
  "prettier.tabWidth": 2,
  "prettier.semi": true,
  "prettier.printWidth": 80,

  // ESLint
  "eslint.format.enable": true,
  "eslint.codeAction.showDocumentation": {
    "enable": true
  },

  // Live Server
  "liveServer.settings.donotShowInfoMsg": true,
  "liveServer.settings.donotVerifyTags": true,

  // GitLens
  "gitlens.codeLens.enabled": false,
  "gitlens.currentLine.enabled": false,

  // Auto imports
  "typescript.suggest.autoImports": true,
  "javascript.suggest.autoImports": true,

  // Breadcrumbs
  "breadcrumbs.enabled": true,

  // Emmet
  "emmet.includeLanguages": {
    "javascript": "javascriptreact",
    "typescript": "typescriptreact"
  },

  // Telemetry
  "telemetry.telemetryLevel": "off",

  // Security
  "security.workspace.trust.untrustedFiles": "open",

  // Misc
  "update.mode": "manual",
  "window.zoomLevel": 0,
  "diffEditor.ignoreTrimWhitespace": false
}
EOF
    
    print_status "settings.json configurado"
}

# Configurar keybindings.json
configure_keybindings() {
    print_step "Configurando keybindings.json..."
    
    config_dir="$HOME/.config/Code/User"
    
    # Backup dos keybindings existentes
    if [ -f "$config_dir/keybindings.json" ]; then
        cp "$config_dir/keybindings.json" "$config_dir/keybindings.json.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Criar keybindings.json
    cat > "$config_dir/keybindings.json" << 'EOF'
[
  // Navegação rápida
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
    "key": "ctrl+shift+x",
    "command": "workbench.view.extensions"
  },
  {
    "key": "ctrl+shift+d",
    "command": "workbench.view.debug"
  },
  
  // Terminal
  {
    "key": "ctrl+shift+t",
    "command": "workbench.action.terminal.new"
  },
  {
    "key": "ctrl+shift+`",
    "command": "workbench.action.terminal.toggleTerminal"
  },
  
  // Duplicar linha
  {
    "key": "ctrl+shift+d",
    "command": "editor.action.copyLinesDownAction",
    "when": "editorTextFocus && !editorReadonly"
  },
  
  // Mover linha
  {
    "key": "alt+up",
    "command": "editor.action.moveLinesUpAction",
    "when": "editorTextFocus && !editorReadonly"
  },
  {
    "key": "alt+down",
    "command": "editor.action.moveLinesDownAction",
    "when": "editorTextFocus && !editorReadonly"
  },
  
  // Comentários
  {
    "key": "ctrl+/",
    "command": "editor.action.commentLine",
    "when": "editorTextFocus && !editorReadonly"
  },
  {
    "key": "ctrl+shift+/",
    "command": "editor.action.blockComment",
    "when": "editorTextFocus && !editorReadonly"
  },
  
  // Formatação
  {
    "key": "ctrl+shift+i",
    "command": "editor.action.formatDocument",
    "when": "editorHasDocumentFormattingProvider && editorTextFocus && !editorReadonly && !inCompositeEditor"
  },
  
  // Seleção múltipla
  {
    "key": "ctrl+d",
    "command": "editor.action.addSelectionToNextFindMatch",
    "when": "editorFocus"
  },
  
  // Paleta de comandos
  {
    "key": "f1",
    "command": "workbench.action.showCommands"
  },
  
  // Quick Open
  {
    "key": "ctrl+p",
    "command": "workbench.action.quickOpen"
  },
  
  // Fechar aba
  {
    "key": "ctrl+w",
    "command": "workbench.action.closeActiveEditor"
  },
  
  // Reabrir aba
  {
    "key": "ctrl+shift+t",
    "command": "workbench.action.reopenClosedEditor"
  },
  
  // Split editor
  {
    "key": "ctrl+\\",
    "command": "workbench.action.splitEditor"
  },
  
  // Toggle sidebar
  {
    "key": "ctrl+b",
    "command": "workbench.action.toggleSidebarVisibility"
  }
]
EOF
    
    print_status "keybindings.json configurado"
}

# Criar snippets úteis
create_snippets() {
    print_step "Criando snippets personalizados..."
    
    config_dir="$HOME/.config/Code/User/snippets"
    mkdir -p "$config_dir"
    
    # JavaScript/TypeScript snippets
    cat > "$config_dir/javascript.json" << 'EOF'
{
  "Console Log": {
    "prefix": "cl",
    "body": [
      "console.log('$1');"
    ],
    "description": "Console log"
  },
  "Console Log Variable": {
    "prefix": "clv",
    "body": [
      "console.log('$1:', $1);"
    ],
    "description": "Console log with variable name"
  },
  "Arrow Function": {
    "prefix": "af",
    "body": [
      "const $1 = ($2) => {",
      "  $3",
      "};"
    ],
    "description": "Arrow function"
  },
  "Async Arrow Function": {
    "prefix": "aaf",
    "body": [
      "const $1 = async ($2) => {",
      "  $3",
      "};"
    ],
    "description": "Async arrow function"
  },
  "Try Catch": {
    "prefix": "tc",
    "body": [
      "try {",
      "  $1",
      "} catch (error) {",
      "  console.error('Error:', error);",
      "}"
    ],
    "description": "Try catch block"
  },
  "Async Try Catch": {
    "prefix": "atc",
    "body": [
      "try {",
      "  const $1 = await $2;",
      "  $3",
      "} catch (error) {",
      "  console.error('Error:', error);",
      "}"
    ],
    "description": "Async try catch block"
  }
}
EOF
    
    # Python snippets
    cat > "$config_dir/python.json" << 'EOF'
{
  "Print Statement": {
    "prefix": "p",
    "body": [
      "print('$1')"
    ],
    "description": "Print statement"
  },
  "Print Variable": {
    "prefix": "pv",
    "body": [
      "print(f'$1: {$1}')"
    ],
    "description": "Print variable with f-string"
  },
  "Main Function": {
    "prefix": "main",
    "body": [
      "def main():",
      "    $1",
      "",
      "",
      "if __name__ == '__main__':",
      "    main()"
    ],
    "description": "Main function template"
  },
  "Class Template": {
    "prefix": "class",
    "body": [
      "class $1:",
      "    def __init__(self$2):",
      "        $3",
      "",
      "    def __str__(self):",
      "        return f'$1($4)'"
    ],
    "description": "Basic class template"
  },
  "Try Except": {
    "prefix": "te",
    "body": [
      "try:",
      "    $1",
      "except Exception as e:",
      "    print(f'Error: {e}')"
    ],
    "description": "Try except block"
  }
}
EOF
    
    print_status "Snippets criados"
}

# Configurar workspace padrão
configure_workspace() {
    print_step "Configurando workspace padrão..."
    
    # Criar pasta de projetos
    mkdir -p "$HOME/Projetos"
    
    # Criar arquivo de workspace
    cat > "$HOME/Projetos/workspace.code-workspace" << 'EOF'
{
  "folders": [
    {
      "path": "."
    }
  ],
  "settings": {
    "terminal.integrated.cwd": "${workspaceFolder}",
    "files.exclude": {
      "**/node_modules": true,
      "**/dist": true,
      "**/build": true,
      "**/.git": true,
      "**/.vscode": false
    }
  },
  "extensions": {
    "recommendations": [
      "ms-python.python",
      "ms-vscode.vscode-typescript-next",
      "esbenp.prettier-vscode",
      "ms-vscode.vscode-eslint",
      "PKief.material-icon-theme",
      "eamodio.gitlens"
    ]
  }
}
EOF
    
    print_status "Workspace padrão configurado em ~/Projetos"
}

# Verificar instalação
verify_installation() {
    print_step "Verificando instalação..."
    
    if command_exists code; then
        print_status "VS Code instalado e configurado com sucesso!"
        
        echo -e "${BLUE}Versão:${NC} $(code --version | head -1)"
        echo -e "${BLUE}Extensões instaladas:${NC} $(code --list-extensions | wc -l)"
        
        # Listar algumas extensões importantes
        echo -e "${BLUE}Extensões importantes:${NC}"
        important_extensions=(
            "PKief.material-icon-theme"
            "eamodio.gitlens"
            "ms-python.python"
            "esbenp.prettier-vscode"
            "github.copilot"
        )
        
        for ext in "${important_extensions[@]}"; do
            if code --list-extensions | grep -q "$ext"; then
                echo -e "  ${GREEN}✓${NC} $ext"
            else
                echo -e "  ${RED}✗${NC} $ext"
            fi
        done
        
    else
        print_error "VS Code não foi instalado corretamente"
        return 1
    fi
}

# Mostrar informações finais
show_final_info() {
    echo
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}        🎉 VS CODE CONFIGURADO COM SUCESSO! 🎉${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo
    
    print_info "O que foi instalado:"
    echo "  💻 VS Code (versão mais recente)"
    echo "  🧩 70+ extensões para desenvolvimento"
    echo "  ⚙️  Configurações otimizadas"
    echo "  🎨 Temas Material e Catppuccin"
    echo "  ⌨️  Atalhos de teclado personalizados"
    echo "  📝 Snippets úteis para JS/TS e Python"
    echo "  🗂️  Workspace padrão em ~/Projetos"
    echo
    
    print_warning "Próximos passos:"
    echo "  1. Reinicie o VS Code para aplicar todas as configurações"
    echo "  2. Instale a fonte FiraCode Nerd Font para melhor experiência"
    echo "  3. Configure o GitHub Copilot se tiver acesso"
    echo "  4. Ajuste o tema conforme sua preferência"
    echo
    
    print_info "Para abrir o VS Code:"
    echo "  code                    # Abre na pasta atual"
    echo "  code ~/Projetos         # Abre na pasta de projetos"
    echo "  code arquivo.js         # Abre arquivo específico"
    echo
    
    print_status "Happy coding! 🚀✨"
}

# Função principal
main() {
    print_banner
    install_vscode
    install_extensions
    configure_settings
    configure_keybindings
    create_snippets
    configure_workspace
    verify_installation
    show_final_info
}

# Executar apenas se chamado diretamente
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi