# 📝 Setup Completo do Sublime Text

Este guia contém todas as configurações, extensões, atalhos e personalizações para otimizar o Sublime Text para desenvolvimento profissional.

## 📋 Índice

- [1. Instalação do Sublime Text](#1-instalação-do-sublime-text)
- [2. Package Control](#2-package-control)
- [3. Pacotes Essenciais](#3-pacotes-essenciais)
- [4. Configurações (Preferences.sublime-settings)](#4-configurações-preferencessublime-settings)
- [5. Atalhos de Teclado (Default.sublime-keymap)](#5-atalhos-de-teclado-defaultsublime-keymap)
- [6. Snippets Personalizados](#6-snippets-personalizados)
- [7. Configurações por Linguagem](#7-configurações-por-linguagem)
- [8. Themes e Color Schemes](#8-themes-e-color-schemes)
- [9. Build Systems](#9-build-systems)
- [10. Configurações Avançadas](#10-configurações-avançadas)
- [11. Setup Automático](#11-setup-automático)

---

## 1. Instalação do Sublime Text

### 📖 Documentação Oficial

- [Sublime Text](https://www.sublimetext.com/)
- [Documentation](https://www.sublimetext.com/docs/)

### 🚀 Instalação

#### Windows

```powershell
# Via Chocolatey
choco install sublimetext4

# Via Winget
winget install SublimeHQ.SublimeText.4

# Ou baixar diretamente
# https://www.sublimetext.com/download
```

#### Linux (Ubuntu/WSL)

```bash
# Método 1: Via repositório oficial
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

# Método 2: Via Snap
sudo snap install sublime-text --classic
```

#### macOS

```bash
# Via Homebrew
brew install --cask sublime-text

# Ou baixar diretamente do site oficial
```

---

## 2. Package Control

### 📦 Instalação do Package Control

#### Método 1: Automático

1. Abra o Sublime Text
2. Vá em `Tools` → `Install Package Control`
3. Reinicie o Sublime Text

#### Método 2: Manual

1. Abra a console: ` Ctrl+`` (ou  `View`→`Show Console`)
2. Cole o código:

```python
import urllib.request,os,hashlib; h = '6f4c264a24d933ce70df5dedcf1dcaee' + 'ebe013ee18cced0ef93d5f746d80ef60'; pf = 'Package Control.sublime-package'; ipp = sublime.installed_packages_path(); urllib.request.install_opener( urllib.request.build_opener( urllib.request.ProxyHandler()) ); by = urllib.request.urlopen( 'http://packagecontrol.io/' + pf.replace(' ', '%20')).read(); dh = hashlib.sha256(by).hexdigest(); print('Error validating download (got %s instead of %s), please try manual install' % (dh, h)) if dh != h else open(os.path.join( ipp, pf), 'wb' ).write(by)
```

### 🎯 Usando o Package Control

- `Ctrl+Shift+P` → `Package Control: Install Package`
- `Ctrl+Shift+P` → `Package Control: Remove Package`
- `Ctrl+Shift+P` → `Package Control: List Packages`

---

## 3. Pacotes Essenciais

### 📋 Lista Completa de Pacotes

#### 🎨 Visual e Interface

```
A File Icon                    # Ícones para tipos de arquivo
Adaptive Theme                 # Theme adaptativo
Seti_UI                       # Interface moderna
Material Theme               # Material Design theme
```

#### 🔧 Produtividade

```
AutoSetSyntax                 # Detecção automática de sintaxe
BracketHighlighter           # Highlight de brackets
SideBarEnhancements          # Melhorias na sidebar
Origami                      # Gerenciamento de painéis
FileDiffs                    # Comparação de arquivos
IndentX                      # Guias de indentação
```

#### 🌐 Web Development

```
Emmet                        # HTML/CSS shortcuts
HTML-CSS-JS Prettify         # Formatação de código
ColorPicker                  # Seletor de cores
Color Highlighter            # Highlight de cores no código
AutoFileName                 # Autocompletar nomes de arquivo
```

#### 📊 Data e Markup

```
CSV                          # Suporte para CSV
Pretty JSON                  # Formatação JSON
Markdown Preview             # Preview de Markdown
MarkdownEditing              # Edição avançada de Markdown
Table Editor                 # Editor de tabelas
```

#### 🐍 Python

```
Anaconda                     # IDE para Python
SublimeLinter                # Linting
SublimeLinter-flake8         # Python linting
SublimeLinter-pylint         # Python linting avançado
Python 3                     # Syntax highlighting Python 3
```

#### ⚛️ JavaScript/TypeScript

```
JavaScript & NodeJS Snippets # Snippets JS/Node
TypeScript                   # Suporte TypeScript
React ES6 Snippets           # Snippets React
jQuery                       # Snippets jQuery
AngularJS                    # Suporte AngularJS
```

#### 🗄️ Database

```
SQLTools                     # Ferramentas SQL
MongoDB                      # Syntax highlighting MongoDB
```

#### 🔗 Git e VCS

```
GitGutter                    # Git annotations
SublimeGit                   # Git integration
Git Conflict Resolver        # Resolver conflitos Git
```

#### 🧪 Testing e Debug

```
SublimeLinter                # Framework de linting
SublimeCodeIntel             # Code intelligence
DocBlockr                    # Documentação automática
```

#### 🎯 Utilitários

```
Terminal                     # Terminal integrado
Local History                # Histórico local de arquivos
HexViewer                    # Visualizador hexadecimal
Compare Side-By-Side         # Comparação lado a lado
WordCount                    # Contador de palavras
```

---

## 4. Configurações (Preferences.sublime-settings)

### ⚙️ Configuração Completa Otimizada

```json
{
  // === APPEARANCE ===
  "theme": "Adaptive.sublime-theme",
  "color_scheme": "Monokai.sublime-color-scheme",
  "font_face": "FiraCode Nerd Font",
  "font_size": 12,
  "font_options": ["gray_antialias", "subpixel_antialias"],

  // === EDITOR BEHAVIOR ===
  "line_numbers": true,
  "gutter": true,
  "margin": 4,
  "fold_buttons": true,
  "fade_fold_buttons": false,
  "rulers": [80, 120],
  "spell_check": false,
  "tab_completion": true,
  "auto_complete": true,
  "auto_complete_size_limit": 4194304,
  "auto_complete_delay": 50,
  "auto_complete_selector": "meta.tag - punctuation.definition.tag.begin, source - comment - string.quoted.double.block - string.quoted.single.block - string.unquoted.heredoc",
  "auto_complete_triggers": [
    {
      "characters": "<",
      "selector": "text.html"
    }
  ],
  "auto_complete_commit_on_tab": true,
  "auto_complete_with_fields": true,
  "auto_complete_cycle": false,

  // === INDENTATION ===
  "tab_size": 2,
  "translate_tabs_to_spaces": true,
  "use_tab_stops": true,
  "detect_indentation": true,
  "auto_indent": true,
  "smart_indent": true,
  "indent_to_bracket": false,
  "trim_automatic_white_space": true,

  // === WORD WRAP ===
  "word_wrap": true,
  "wrap_width": 80,
  "indent_subsequent_lines": true,

  // === WHITESPACE ===
  "draw_white_space": "selection",
  "trim_trailing_white_space_on_save": true,
  "ensure_newline_at_eof_on_save": true,

  // === CURSOR ===
  "caret_style": "smooth",
  "caret_extra_top": 2,
  "caret_extra_bottom": 2,
  "caret_extra_width": 1,
  "block_caret": false,
  "wide_caret": false,

  // === LINE HIGHLIGHTING ===
  "highlight_line": true,
  "line_padding_top": 1,
  "line_padding_bottom": 1,

  // === BRACKET MATCHING ===
  "match_brackets": true,
  "match_brackets_content": true,
  "match_brackets_square": true,
  "match_brackets_braces": true,
  "match_brackets_angle": true,
  "match_tags": true,

  // === SELECTION ===
  "draw_minimap_border": true,
  "always_show_minimap_viewport": false,
  "highlight_modified_tabs": true,

  // === SEARCH ===
  "atomic_save": false,
  "auto_find_in_selection": false,
  "show_definitions": true,
  "show_errors_inline": true,

  // === FILES ===
  "default_encoding": "UTF-8",
  "default_line_ending": "unix",
  "fallback_encoding": "Western (Windows 1252)",
  "show_encoding": false,
  "show_line_endings": false,
  "enable_tab_scrolling": true,
  "preview_on_click": true,
  "folder_exclude_patterns": [
    ".svn",
    ".git",
    ".hg",
    "CVS",
    ".Trash",
    ".Trash-*",
    "node_modules",
    "bower_components",
    "dist",
    "build",
    ".vscode",
    "__pycache__",
    "*.pyc",
    ".pytest_cache",
    ".coverage"
  ],
  "file_exclude_patterns": [
    "*.pyc",
    "*.pyo",
    "*.exe",
    "*.dll",
    "*.obj",
    "*.o",
    "*.a",
    "*.lib",
    "*.so",
    "*.dylib",
    "*.ncb",
    "*.sdf",
    "*.suo",
    "*.pdb",
    "*.idb",
    ".DS_Store",
    ".directory",
    "desktop.ini",
    "*.class",
    "*.psd",
    "*.db",
    "*.sublime-workspace"
  ],
  "binary_file_patterns": [
    "*.jpg",
    "*.jpeg",
    "*.png",
    "*.gif",
    "*.ttf",
    "*.tga",
    "*.dds",
    "*.ico",
    "*.eot",
    "*.pdf",
    "*.swf",
    "*.jar",
    "*.zip"
  ],

  // === PERFORMANCE ===
  "index_files": true,
  "index_workers": 0,
  "index_exclude_patterns": ["*.log", "node_modules/*"],

  // === BEHAVIOR ===
  "hot_exit": true,
  "remember_open_files": true,
  "remember_full_screen": false,
  "scroll_past_end": true,
  "scroll_speed": 1.0,
  "tree_animation_enabled": true,
  "animation_enabled": true,
  "highlight_modified_tabs": true,
  "find_selected_text": true,

  // === VINTAGE MODE (Desabilitado) ===
  "ignored_packages": ["Vintage"],

  // === ADVANCED ===
  "always_prompt_for_file_reload": false,
  "open_files_in_new_window": true,
  "create_window_at_startup": true,
  "close_windows_when_empty": false,
  "show_tab_close_buttons": true,
  "mouse_wheel_switches_tabs": false,
  "shift_tab_unindent": false,

  // === TYPOGRAPHY ===
  "draw_centered": false,
  "auto_complete_preserve_order": false,
  "move_to_limit_on_up_down": false,

  // === SPECIFIC SETTINGS ===
  "word_separators": "./\\()\"'-:,.;<>~!@#$%^&*|+=[]{}`~?",
  "ensure_newline_at_eof_on_save": true,
  "atomic_save": false,
  "save_on_focus_lost": false,

  // === PACKAGES SETTINGS ===
  "auto_set_syntax": true,
  "bracket_highlighter.enabled": true,
  "git_gutter": true
}
```

---

## 5. Atalhos de Teclado (Default.sublime-keymap)

### ⌨️ Atalhos Personalizados Otimizados

```json
[
  // === SYNTAX SWITCHING ===
  {
    "keys": ["ctrl+alt+j"],
    "command": "set_file_type",
    "args": { "syntax": "Packages/JavaScript/JavaScript.sublime-syntax" }
  },
  {
    "keys": ["ctrl+alt+p"],
    "command": "set_file_type",
    "args": { "syntax": "Packages/Python/Python.sublime-syntax" }
  },
  {
    "keys": ["ctrl+alt+h"],
    "command": "set_file_type",
    "args": { "syntax": "Packages/HTML/HTML.sublime-syntax" }
  },
  {
    "keys": ["ctrl+alt+c"],
    "command": "set_file_type",
    "args": { "syntax": "Packages/C#/C#.sublime-syntax" }
  },
  {
    "keys": ["ctrl+alt+t"],
    "command": "set_file_type",
    "args": { "syntax": "Packages/Text/Plain text.tmLanguage" }
  },
  {
    "keys": ["ctrl+alt+m"],
    "command": "set_file_type",
    "args": { "syntax": "Packages/Markdown/Markdown.sublime-syntax" }
  },

  // === CODE FORMATTING ===
  {
    "keys": ["ctrl+alt+f"],
    "command": "reindent",
    "args": { "single_line": false }
  },
  {
    "keys": ["ctrl+shift+f"],
    "command": "js_prettier"
  },

  // === LINE MANIPULATION ===
  {
    "keys": ["ctrl+alt+d"],
    "command": "duplicate_line"
  },
  {
    "keys": ["ctrl+shift+k"],
    "command": "run_macro_file",
    "args": { "file": "res://Packages/Default/Delete Line.sublime-macro" }
  },
  {
    "keys": ["ctrl+alt+shift+up"],
    "command": "swap_line_up"
  },
  {
    "keys": ["ctrl+alt+shift+down"],
    "command": "swap_line_down"
  },
  {
    "keys": ["ctrl+alt+enter"],
    "command": "insert",
    "args": { "characters": "\\n\\n" }
  },
  {
    "keys": ["ctrl+enter"],
    "command": "run_macro_file",
    "args": { "file": "res://Packages/Default/Add Line.sublime-macro" }
  },
  {
    "keys": ["ctrl+shift+enter"],
    "command": "run_macro_file",
    "args": { "file": "res://Packages/Default/Add Line Before.sublime-macro" }
  },

  // === SELECTION ===
  {
    "keys": ["ctrl+d"],
    "command": "find_under_expand"
  },
  {
    "keys": ["ctrl+k", "ctrl+d"],
    "command": "find_under_expand_skip"
  },
  {
    "keys": ["ctrl+shift+l"],
    "command": "split_selection_into_lines"
  },
  {
    "keys": ["ctrl+alt+a"],
    "command": "select_all_bookmarks"
  },

  // === NAVIGATION ===
  {
    "keys": ["ctrl+p"],
    "command": "show_overlay",
    "args": { "overlay": "goto", "show_files": true }
  },
  {
    "keys": ["ctrl+r"],
    "command": "show_overlay",
    "args": { "overlay": "goto", "text": "@" }
  },
  {
    "keys": ["ctrl+shift+r"],
    "command": "goto_symbol_in_project"
  },
  {
    "keys": ["ctrl+g"],
    "command": "show_overlay",
    "args": { "overlay": "goto", "text": ":" }
  },
  {
    "keys": ["f12"],
    "command": "goto_definition"
  },
  {
    "keys": ["alt+minus"],
    "command": "jump_back"
  },
  {
    "keys": ["alt+shift+minus"],
    "command": "jump_forward"
  },

  // === PANEL MANAGEMENT ===
  {
    "keys": ["ctrl+shift+alt+1"],
    "command": "set_layout",
    "args": {
      "cols": [0.0, 1.0],
      "rows": [0.0, 1.0],
      "cells": [[0, 0, 1, 1]]
    }
  },
  {
    "keys": ["ctrl+shift+alt+2"],
    "command": "set_layout",
    "args": {
      "cols": [0.0, 0.5, 1.0],
      "rows": [0.0, 1.0],
      "cells": [
        [0, 0, 1, 1],
        [1, 0, 2, 1]
      ]
    }
  },
  {
    "keys": ["ctrl+shift+alt+3"],
    "command": "set_layout",
    "args": {
      "cols": [0.0, 0.33, 0.66, 1.0],
      "rows": [0.0, 1.0],
      "cells": [
        [0, 0, 1, 1],
        [1, 0, 2, 1],
        [2, 0, 3, 1]
      ]
    }
  },
  {
    "keys": ["ctrl+shift+alt+4"],
    "command": "set_layout",
    "args": {
      "cols": [0.0, 0.5, 1.0],
      "rows": [0.0, 0.5, 1.0],
      "cells": [
        [0, 0, 1, 1],
        [1, 0, 2, 1],
        [0, 1, 1, 2],
        [1, 1, 2, 2]
      ]
    }
  },

  // === FOLDING ===
  {
    "keys": ["ctrl+shift+["],
    "command": "fold"
  },
  {
    "keys": ["ctrl+shift+]"],
    "command": "unfold"
  },
  {
    "keys": ["ctrl+k", "ctrl+0"],
    "command": "unfold_all"
  },
  {
    "keys": ["ctrl+k", "ctrl+1"],
    "command": "fold_by_level",
    "args": { "level": 1 }
  },

  // === BOOKMARKS ===
  {
    "keys": ["ctrl+f2"],
    "command": "toggle_bookmark"
  },
  {
    "keys": ["f2"],
    "command": "next_bookmark"
  },
  {
    "keys": ["shift+f2"],
    "command": "prev_bookmark"
  },
  {
    "keys": ["ctrl+shift+f2"],
    "command": "clear_bookmarks"
  },

  // === BUILD SYSTEMS ===
  {
    "keys": ["f7"],
    "command": "build"
  },
  {
    "keys": ["ctrl+f7"],
    "command": "build",
    "args": { "select": true }
  },
  {
    "keys": ["ctrl+shift+b"],
    "command": "build",
    "args": { "select": true }
  },

  // === TERMINAL ===
  {
    "keys": ["ctrl+shift+t"],
    "command": "open_terminal"
  },
  {
    "keys": ["ctrl+shift+alt+t"],
    "command": "open_terminal_project_folder"
  },

  // === PACKAGE CONTROL ===
  {
    "keys": ["ctrl+shift+p"],
    "command": "show_overlay",
    "args": { "overlay": "command_palette" }
  },

  // === SIDEBAR ===
  {
    "keys": ["ctrl+k", "ctrl+b"],
    "command": "toggle_side_bar"
  },

  // === MINIMAP ===
  {
    "keys": ["ctrl+k", "ctrl+m"],
    "command": "toggle_minimap"
  },

  // === COMMENTS ===
  {
    "keys": ["ctrl+/"],
    "command": "toggle_comment",
    "args": { "block": false }
  },
  {
    "keys": ["ctrl+shift+/"],
    "command": "toggle_comment",
    "args": { "block": true }
  },

  // === SEARCH AND REPLACE ===
  {
    "keys": ["ctrl+h"],
    "command": "show_panel",
    "args": { "panel": "replace", "reverse": false }
  },
  {
    "keys": ["ctrl+shift+h"],
    "command": "show_panel",
    "args": { "panel": "find_in_files" }
  },

  // === CUSTOM MACROS ===
  {
    "keys": ["ctrl+shift+;"],
    "command": "insert",
    "args": { "characters": ";" }
  },
  {
    "keys": ["ctrl+alt+;"],
    "command": "move_to",
    "args": { "to": "eol", "extend": false }
  }
]
```

---

## 6. Snippets Personalizados

### 📝 JavaScript Snippets

Criar arquivo: `Packages/User/JavaScript.sublime-snippets/`

#### Console Log

```xml
<snippet>
    <content><![CDATA[
console.log('${1:label}:', ${1:variable});
]]></content>
    <tabTrigger>log</tabTrigger>
    <scope>source.js</scope>
    <description>Console log with label</description>
</snippet>
```

#### Arrow Function

```xml
<snippet>
    <content><![CDATA[
const ${1:functionName} = (${2:params}) => {
    ${3:// function body}
};
]]></content>
    <tabTrigger>af</tabTrigger>
    <scope>source.js</scope>
    <description>Arrow function</description>
</snippet>
```

#### Async Arrow Function

```xml
<snippet>
    <content><![CDATA[
const ${1:functionName} = async (${2:params}) => {
    ${3:// async function body}
};
]]></content>
    <tabTrigger>aaf</tabTrigger>
    <scope>source.js</scope>
    <description>Async arrow function</description>
</snippet>
```

#### Try Catch

```xml
<snippet>
    <content><![CDATA[
try {
    ${1:// code that might throw}
} catch (${2:error}) {
    console.error('Error:', ${2:error});
    ${3:// error handling}
}
]]></content>
    <tabTrigger>tc</tabTrigger>
    <scope>source.js</scope>
    <description>Try catch block</description>
</snippet>
```

### 🐍 Python Snippets

#### Print Debug

```xml
<snippet>
    <content><![CDATA[
print(f'${1:label}: {${1:variable}}')
]]></content>
    <tabTrigger>pdb</tabTrigger>
    <scope>source.python</scope>
    <description>Print debug with f-string</description>
</snippet>
```

#### Class Definition

```xml
<snippet>
    <content><![CDATA[
class ${1:ClassName}:
    def __init__(self${2:, args}):
        ${3:pass}

    def __str__(self):
        return f'${1:ClassName}(${4:attrs})'
]]></content>
    <tabTrigger>class</tabTrigger>
    <scope>source.python</scope>
    <description>Python class</description>
</snippet>
```

#### Function with Type Hints

```xml
<snippet>
    <content><![CDATA[
def ${1:function_name}(${2:args}) -> ${3:return_type}:
    """${4:docstring}"""
    ${5:pass}
]]></content>
    <tabTrigger>def</tabTrigger>
    <scope>source.python</scope>
    <description>Function with type hints</description>
</snippet>
```

### 🌐 HTML/CSS Snippets

#### HTML5 Boilerplate

```xml
<snippet>
    <content><![CDATA[
<!DOCTYPE html>
<html lang="${1:en}">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${2:Document}</title>
    ${3:<link rel="stylesheet" href="style.css">}
</head>
<body>
    ${4:<!-- content -->}
    ${5:<script src="script.js"></script>}
</body>
</html>
]]></content>
    <tabTrigger>html5</tabTrigger>
    <scope>text.html</scope>
    <description>HTML5 boilerplate</description>
</snippet>
```

---

## 7. Configurações por Linguagem

### 🐍 Python Settings

```json
{
  "rulers": [79, 120],
  "translate_tabs_to_spaces": true,
  "tab_size": 4,
  "trim_trailing_white_space_on_save": true,
  "ensure_newline_at_eof_on_save": true,
  "auto_complete_triggers": [
    {
      "characters": ".",
      "selector": "source.python - string - comment"
    }
  ]
}
```

### ⚛️ JavaScript Settings

```json
{
  "rulers": [80, 120],
  "translate_tabs_to_spaces": true,
  "tab_size": 2,
  "extensions": ["js", "jsx", "ts", "tsx"],
  "auto_complete_triggers": [
    {
      "characters": ".",
      "selector": "source.js - string - comment"
    },
    {
      "characters": "->",
      "selector": "source.js - string - comment"
    }
  ]
}
```

### 🌐 Web Files Settings

```json
{
  "rulers": [80, 120],
  "translate_tabs_to_spaces": true,
  "tab_size": 2,
  "word_wrap": true,
  "auto_complete": true,
  "auto_complete_triggers": [
    {
      "characters": "<",
      "selector": "text.html - source"
    },
    {
      "characters": " ",
      "selector": "text.html meta.tag - source - string.quoted"
    }
  ]
}
```

---

## 8. Themes e Color Schemes

### 🎨 Themes Recomendados

#### Dark Themes

```
Material Theme                # Material Design
Monokai Pro                   # Monokai melhorado
One Dark                      # Atom's One Dark
Dracula                       # Dracula theme
```

#### Light Themes

```
Ayu                          # Clean light theme
Solarized                    # Solarized theme
GitHub Theme                 # GitHub style
```

#### Custom Color Scheme (Monokai Customizado)

Criar arquivo: `Packages/User/MonokaiCustom.sublime-color-scheme`

```json
{
  "name": "Monokai Custom",
  "author": "Bruno Hiago",
  "variables": {
    "background": "#272822",
    "foreground": "#f8f8f2",
    "comment": "#75715e",
    "string": "#e6db74",
    "number": "#ae81ff",
    "keyword": "#f92672",
    "operator": "#f92672",
    "function": "#a6e22e",
    "class": "#66d9ef",
    "constant": "#fd971f"
  },
  "globals": {
    "background": "var(background)",
    "foreground": "var(foreground)",
    "caret": "var(foreground)",
    "line_highlight": "#3e3d32",
    "selection": "#49483e",
    "selection_border": "#49483e",
    "inactive_selection": "#414339",
    "misspelling": "#f92672",
    "shadow": "#00000080",
    "active_guide": "#9d550fb0",
    "stack_guide": "#9d550f40"
  },
  "rules": [
    {
      "name": "Comment",
      "scope": "comment",
      "foreground": "var(comment)",
      "font_style": "italic"
    },
    {
      "name": "String",
      "scope": "string",
      "foreground": "var(string)"
    },
    {
      "name": "Number",
      "scope": "constant.numeric",
      "foreground": "var(number)"
    },
    {
      "name": "Keyword",
      "scope": "keyword",
      "foreground": "var(keyword)",
      "font_style": "bold"
    },
    {
      "name": "Function",
      "scope": "entity.name.function",
      "foreground": "var(function)"
    },
    {
      "name": "Class",
      "scope": "entity.name.class",
      "foreground": "var(class)"
    }
  ]
}
```

---

## 9. Build Systems

### 🏗️ Build Systems Personalizados

#### Python Build System

```json
{
  "cmd": ["python3", "-u", "$file"],
  "file_regex": "^[ ]*File \"(...*?)\", line ([0-9]*)",
  "selector": "source.python",
  "encoding": "utf8",
  "variants": [
    {
      "name": "Python - Interactive",
      "cmd": ["python3", "-i", "-u", "$file"],
      "env": { "PYTHONIOENCODING": "utf-8" }
    },
    {
      "name": "Python - Syntax Check",
      "cmd": ["python3", "-m", "py_compile", "$file"]
    }
  ]
}
```

#### Node.js Build System

```json
{
  "cmd": ["node", "$file"],
  "file_regex": "^[ ]*File \"(...*?)\", line ([0-9]*)",
  "selector": "source.js",
  "encoding": "utf8",
  "variants": [
    {
      "name": "Node.js - Debug",
      "cmd": ["node", "--inspect", "$file"]
    },
    {
      "name": "NPM - Start",
      "cmd": ["npm", "start"],
      "working_dir": "$file_path"
    },
    {
      "name": "NPM - Test",
      "cmd": ["npm", "test"],
      "working_dir": "$file_path"
    }
  ]
}
```

#### HTML Build System (Live Server)

```json
{
  "cmd": ["python3", "-m", "http.server", "8000"],
  "working_dir": "$file_path",
  "selector": "text.html",
  "variants": [
    {
      "name": "Open in Browser",
      "cmd": [
        "python3",
        "-c",
        "import webbrowser; webbrowser.open('http://localhost:8000')"
      ]
    }
  ]
}
```

---

## 10. Configurações Avançadas

### 🔧 Configurações de Projeto

Criar arquivo `.sublime-project`:

```json
{
  "folders": [
    {
      "path": ".",
      "folder_exclude_patterns": [
        "node_modules",
        ".git",
        "dist",
        "build",
        "__pycache__",
        ".pytest_cache"
      ],
      "file_exclude_patterns": [
        "*.pyc",
        "*.pyo",
        "*.sublime-workspace",
        ".DS_Store"
      ]
    }
  ],
  "settings": {
    "tab_size": 2,
    "translate_tabs_to_spaces": true,
    "trim_trailing_white_space_on_save": true,
    "ensure_newline_at_eof_on_save": true
  },
  "build_systems": [
    {
      "name": "Project Build",
      "cmd": ["npm", "run", "build"],
      "working_dir": "${project_path}"
    }
  ]
}
```

### 🎯 Macros Personalizados

#### Duplicate Line Up

```json
[{ "command": "duplicate_line" }, { "command": "swap_line_up" }]
```

#### Insert Semicolon at End

```json
[
  { "command": "move_to", "args": { "to": "eol", "extend": false } },
  { "command": "insert", "args": { "characters": ";" } }
]
```

### 🔍 Custom Commands

```python
import sublime
import sublime_plugin

class InsertDateTimeCommand(sublime_plugin.TextCommand):
    def run(self, edit):
        import datetime
        now = datetime.datetime.now()
        timestamp = now.strftime("%Y-%m-%d %H:%M:%S")
        self.view.insert(edit, self.view.sel()[0].begin(), timestamp)

class OpenTerminalCommand(sublime_plugin.WindowCommand):
    def run(self):
        import subprocess
        import os

        if sublime.platform() == "windows":
            subprocess.Popen("start cmd", shell=True, cwd=os.path.dirname(self.window.active_view().file_name()))
        else:
            subprocess.Popen(["gnome-terminal"], cwd=os.path.dirname(self.window.active_view().file_name()))
```

---

## 11. Setup Automático

### 🚀 Script de Configuração Completa

```bash
#!/bin/bash

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se Sublime Text está instalado
if ! command -v subl &> /dev/null; then
    print_error "Sublime Text não está instalado"
    exit 1
fi

print_status "Configurando Sublime Text..."

# Detectar sistema operacional
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    ST_PATH="$HOME/.config/sublime-text/Packages/User"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    ST_PATH="$HOME/Library/Application Support/Sublime Text/Packages/User"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
    ST_PATH="$APPDATA/Sublime Text/Packages/User"
else
    print_error "Sistema operacional não suportado"
    exit 1
fi

# Criar backup das configurações existentes
if [ -f "$ST_PATH/Preferences.sublime-settings" ]; then
    print_status "Fazendo backup das configurações existentes..."
    cp "$ST_PATH/Preferences.sublime-settings" "$ST_PATH/Preferences.sublime-settings.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Baixar configurações
print_status "Baixando configurações..."
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/configs/sublime-preferences.json -o "$ST_PATH/Preferences.sublime-settings"
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/configs/sublime-keymap.json -o "$ST_PATH/Default.sublime-keymap"

# Instalar Package Control (se necessário)
if [ ! -f "$ST_PATH/../Installed Packages/Package Control.sublime-package" ]; then
    print_status "Instalando Package Control..."
    mkdir -p "$ST_PATH/../Installed Packages"
    curl -fsSL https://packagecontrol.io/Package%20Control.sublime-package -o "$ST_PATH/../Installed Packages/Package Control.sublime-package"
fi

# Lista de pacotes para instalar
packages=(
    "A File Icon"
    "AutoSetSyntax"
    "BracketHighlighter"
    "CSV"
    "FileDiffs"
    "IndentX"
    "Emmet"
    "HTML-CSS-JS Prettify"
    "Pretty JSON"
    "SideBarEnhancements"
    "GitGutter"
    "Terminal"
    "Material Theme"
    "Monokai Pro"
)

# Criar arquivo de pacotes para Package Control
print_status "Criando lista de pacotes..."
cat > "$ST_PATH/Package Control.sublime-settings" << EOF
{
    "bootstrapped": true,
    "in_process_packages": [],
    "installed_packages": [
$(printf '        "%s",\n' "${packages[@]}" | sed '$s/,$//')
    ]
}
EOF

print_status "Configuração do Sublime Text concluída!"
print_warning "Reinicie o Sublime Text para aplicar todas as configurações."
print_warning "O Package Control instalará automaticamente os pacotes na próxima inicialização."

# Criar estrutura para snippets
mkdir -p "$ST_PATH/Snippets"

# Criar snippet de exemplo
cat > "$ST_PATH/Snippets/console-log.sublime-snippet" << 'EOF'
<snippet>
    <content><![CDATA[
console.log('${1:label}:', ${1:variable});
]]></content>
    <tabTrigger>log</tabTrigger>
    <scope>source.js</scope>
    <description>Console log with label</description>
</snippet>
EOF

print_status "Snippets personalizados criados!"
```

### 📦 Instalação via um comando

```bash
# Download e execução do setup
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/setup-sublime.sh | bash
```

---

## ✅ Checklist de Verificação

### 🔍 Pós-Instalação

- [ ] Sublime Text instalado
- [ ] Package Control funcionando
- [ ] Todos os pacotes instalados
- [ ] Configurações aplicadas
- [ ] Atalhos funcionando
- [ ] Snippets carregados
- [ ] Build systems funcionando
- [ ] Theme aplicado
- [ ] Syntax highlighting funcionando
- [ ] Auto-complete ativo

### 🧪 Teste Rápido

1. Abrir arquivo JavaScript e digitar `log` + Tab
2. Testar `Ctrl+Alt+F` para formatação
3. Testar `Ctrl+P` para busca rápida
4. Verificar destaque de brackets
5. Testar terminal integrado

---

## 🔗 Links Úteis

- [Sublime Text Documentation](https://www.sublimetext.com/docs/)
- [Package Control](https://packagecontrol.io/)
- [Sublime Text Forum](https://forum.sublimetext.com/)
- [Package Development](https://docs.sublimetext.io/)
- [Color Scheme Documentation](https://www.sublimetext.com/docs/color_schemes.html)
- [Build Systems](https://www.sublimetext.com/docs/build_systems.html)

---

**🎉 Seu Sublime Text está otimizado e pronto para desenvolvimento profissional!**
