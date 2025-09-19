# 🛠️ My Development Settings

**Complete developer setup** - Configurations, scripts, and documentation to quickly set up a professional development environment.

![GitHub](https://img.shields.io/badge/Windows-WSL2-blue)
![GitHub](https://img.shields.io/badge/Terminal-ZSH-green)
![GitHub](https://img.shields.io/badge/Editor-VSCode-blue)
![GitHub](https://img.shields.io/badge/License-MIT-yellow)

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/hiago19/my-settings.git
cd my-settings

# Complete automated setup with interactive menu
./scripts/setup.sh
```

## ⚙️ Custom Configuration

This project uses an **environment variables (.env) based configuration system** following industry standards.

### 🔧 How to Customize

1. **Copy the configuration template:**

   ```bash
   cp .env.example .env
   ```

2. **Edit your settings:**

   ```bash
   nano .env  # or code .env
   ```

3. **Run scripts normally:**
   ```bash
   ./scripts/setup.sh
   ```

## 🔄 Latest Versions

The system has been **optimized to always install the latest versions** of tools, ensuring compatibility and modern features:

### 🛠️ **Official Installation:**

- **FZF**: Installed via `git clone` from official repository _(full support for `--zsh`)_
- **Starship**: Installed via official script _(always the latest version)_
- **Oh My Zsh**: Installed via official GitHub script

### ⚡ **Benefits:**

- ✅ **Full compatibility** with modern features
- ✅ **Bug fixes** and security improvements
- ✅ **Optimized performance** of tools
- ✅ **Support for new functionality** (like `fzf --zsh`)

> **Note**: The system automatically detects if you already have an official version installed and avoids unnecessary reinstallations.

### 📋 Main Configuration Variables

| Variable                   | Description                          | Default             |
| -------------------------- | ------------------------------------ | ------------------- |
| `DEV_USER_NAME`            | Your full name                       | "Bruno Hiago"       |
| `DEV_USER_EMAIL`           | Email for Git                        | "bruno@example.com" |
| `INSTALL_VSCODE_ESSENTIAL` | Install essential VS Code extensions | `true`              |
| `INSTALL_VSCODE_LANGUAGE`  | Install language extensions          | `true`              |
| `INSTALL_DOCKER`           | Install Docker                       | `true`              |
| `FAST_MODE`                | Fast mode (skip heavy installations) | `false`             |

### 🎯 Customization Examples

**Minimalist mode:**

```env
INSTALL_VSCODE_LANGUAGE=false
INSTALL_VSCODE_TOOLS=false
INSTALL_DOCKER=false
FAST_MODE=true
```

**Full-stack developer mode:**

```env
INSTALL_VSCODE_ESSENTIAL=true
INSTALL_VSCODE_LANGUAGE=true
INSTALL_VSCODE_TOOLS=true
INSTALL_VSCODE_ADVANCED=true
```

### 🛠️ Configuration Utilities

```bash
# View current settings
./scripts/setup.sh  # Menu option 8

# Edit settings
nano .env  # or code .env

# Validate system
./scripts/tools/validate-system.sh

# Make backup
./scripts/tools/backup-configs.sh
```

## 📋 Table of Contents

- [📖 Complete Documentation](#-complete-documentation)
- [⚙️ Included Configurations](#️-included-configurations)
- [🔧 Installation Scripts](#-installation-scripts)
- [📁 Project Structure](#-project-structure)
- [🎯 Quick Installation](#-quick-installation)
- [🔗 Useful Links](#-useful-links)

---

## 📖 Complete Documentation

### 🖥️ [Terminal & WSL2 Setup](docs/TERMINAL_SETUP.md)

Complete terminal environment setup with WSL2, ZSH, Oh My Zsh, Starship, and essential CLI tools:

- ✅ WSL2 + Ubuntu
- ✅ ZSH + Oh My Zsh + Starship
- ✅ Git + SSH configured
- ✅ Node.js (NVM) + Python + Docker
- ✅ CLI Tools: bat, eza, zoxide, fzf, etc.

### 💻 [VS Code Setup](docs/VSCODE_SETUP.md)

Complete Visual Studio Code configuration for professional development:

- ✅ 40+ essential extensions
- ✅ Optimized settings.json
- ✅ Custom shortcuts
- ✅ Snippets for multiple languages
- ✅ Themes and customization

### 📝 [Sublime Text Setup](docs/SUBLIME_TEXT_SETUP.md)

Advanced Sublime Text configuration with packages and customizations:

- ✅ Package Control + essential packages
- ✅ Optimized settings
- ✅ Advanced shortcuts
- ✅ Custom snippets
- ✅ Build systems

### 🚀 [Useful Apps](docs/USEFUL_APPS.md)

Curated list of essential applications for developers:

- ✅ Productivity tools (PowerToys, Notion)
- ✅ Development (Docker, Postman, DBeaver)
- ✅ Design (Figma, OBS Studio)
- ✅ Automatic installation scripts

---

## ⚙️ Included Configurations

### 🐚 Terminal (ZSH)

```bash
# Optimized aliases
alias cat='batcat'
alias cd="z"
alias ls='eza -1 --color=always --git --icons --group-directories-first'
alias ll='eza -1 --tree --level=2 --icons --color=always --git --group-directories-first'

# Integrated tools
eval "$(starship init zsh)"    # Modern prompt
eval "$(zoxide init zsh)"      # Smart cd
eval "$(fzf --zsh)"           # Fuzzy finder
```

### 💻 VS Code (Main Extensions)

- **AI & Productivity:** GitHub Copilot, GitHub Copilot Chat
- **Themes:** GitHub Theme, VSCode Icons, Peacock
- **Web Dev:** Prettier, ESLint, Tailwind CSS, Live Server
- **Languages:** Python, TypeScript, React, Vue
- **Tools:** GitLens, Docker, REST Client, SonarLint

### 📝 Sublime Text (Essential Packages)

- **Visual:** A File Icon, Material Theme, BracketHighlighter
- **Productivity:** Emmet, SideBarEnhancements, GitGutter
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

## 🔧 Installation Scripts

### ⚙️ Complete Setup

```bash
# Complete environment setup (Interactive menu)
./scripts/setup.sh
```

### 🖥️ Terminal Setup

```bash
# Complete terminal setup (ZSH + Oh My Zsh + Starship)
./scripts/modules/terminal.sh
```

### 💻 VS Code Setup

```bash
# Complete VS Code setup (extensions + configurations)
./scripts/modules/vscode.sh
```

```bash
# Install only VS Code extensions
./scripts/tools/install-extensions.sh
```

### 🚀 Windows Apps

```powershell
# Instalar apps essenciais (PowerShell como Admin)
./scripts/tools/install-dev-apps.ps1
```

---

## 📁 Project Structure

```
my-settings/
├── 📄 README.md                     # This file
├── 📄 LICENSE                       # MIT License
├── 📄 .gitignore                    # Ignore unnecessary files
├── 📄 .env.example                  # Template with 63 configuration variables
├── 📄 .env                          # Your custom settings
├── 📁 docs/                         # Detailed documentation
│   ├── 📖 TERMINAL_SETUP.md         # Terminal/WSL2 Setup
│   ├── 📖 VSCODE_SETUP.md           # VS Code Setup
│   ├── 📖 SUBLIME_TEXT_SETUP.md     # Sublime Text Setup
│   ├── 📖 TROUBLESHOOTING.md        # Troubleshooting
│   └── 📖 USEFUL_APPS.md            # Recommended apps
├── 📁 scripts/                      # Modular script system
│   ├── 🎯 setup.sh                  # Main interface (interactive menu)
│   ├── 📁 core/                     # Robust base system
│   │   ├── 🏗️ bootstrap.sh          # Dependency orchestrator
│   │   ├── 🎨 colors.sh             # Color system and UI
│   │   ├── 🔧 utils.sh              # Utility functions
│   │   ├── ⚙️ env-loader.sh         # Smart .env loader
│   │   └── 📂 paths.sh              # Path manager
│   ├── 📁 modules/                  # Configuration modules
│   │   ├── 🖥️ terminal.sh           # Complete terminal setup
│   │   ├── 🖥️ vscode.sh             # Complete VS Code setup
│   │   └── 🖥️ complete.sh           # Complete general setup
│   └── 📁 tools/                    # Utility tools
│       ├── ⚙️ backup-configs.sh     # Automatic backup
│       ├── ⚙️ restore-configs.sh    # Restoration
│       ├── ⚙️ validate-system.sh    # System validation
│       ├── ⚙️ install-extensions.sh # VS Code extensions
│       └── 🪟 install-dev-apps.ps1  # Windows apps
└── 📁 configs/                      # Configuration templates
    ├── 📁 git/                      # Git configurations
    │   ├── gitconfig                # Global Git config
    │   └── gitignore_global         # Global gitignore
    ├── 📁 terminal/                 # Terminal configurations
    │   ├── zshrc                    # ZSH config
    │   └── starship.toml            # Starship config
    ├── 📁 vscode/                   # VS Code configurations
    │   ├── settings.json            # VS Code settings
    │   └── extensions.txt           # Extensions list
    └── 📁 sublime/                  # Sublime configurations
        └── sublime-preferences.json # Sublime preferences

```

---

## 🎯 Quick Installation

### 🔥 Complete Setup (Recommended)

```bash
git clone https://github.com/hiago19/my-settings.git
cd my-settings

# 2. Run complete setup
chmod +x scripts/setup.sh
./scripts/setup.sh
```

### 🎯 Individual Setup

#### Terminal (WSL2 + ZSH)

```bash
# Run locally
./scripts/modules/terminal.sh

# Or via curl
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/modules/terminal.sh | bash
```

#### VS Code

```bash
# Complete VS Code configuration
./scripts/modules/vscode.sh

# Or just install extensions
./scripts/tools/install-extensions.sh

# Or install extensions via wget
wget -O - https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/tools/install-extensions.sh | bash

# Apply settings
curl -fsSL https://raw.githubusercontent.com/hiago19/my-settings/main/configs/vscode-settings.json -o ~/.config/Code/User/settings.json
```

#### Windows Apps

```powershell
# PowerShell as Administrator
Set-ExecutionPolicy Bypass -Scope Process -Force
iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/hiago19/my-settings/main/scripts/install-dev-apps.ps1'))
```

---

## 🔄 Updates

### 🆙 Update Settings

```bash
cd my-settings
git pull origin main
./scripts/update-configs.sh
```

### 🔄 Sync with Repository

```bash
# Backup current settings
./scripts/backup-current-configs.sh

# Apply updated settings
./scripts/apply-configs.sh
```

---

## 🎨 Customization

### ⚙️ Modify ZSH Settings

```bash
# Edit configuration file
nano ~/.zshrc

# Reload settings
source ~/.zshrc
```

### 🎨 Customize VS Code

1. Open VS Code
2. `Ctrl+Shift+P` → "Preferences: Open Settings (JSON)"
3. Modify as needed
4. Save and restart

### 🔧 Add Apps

```bash
# Edit apps list
nano scripts/install-dev-apps.ps1

# Add new apps to the list
```

---

## 🤝 Contributing

### 📝 How to Contribute

1. Fork the project
2. Create a branch for your feature
3. Commit your changes
4. Push to the branch
5. Open a Pull Request

### 💡 Suggestions

- New useful apps
- Configuration improvements
- Bug fixes
- Additional documentation

---

## 📱 Compatibility

| System               | Status                 | Tested Version    |
| -------------------- | ---------------------- | ----------------- |
| Windows 10/11 + WSL2 | ✅ Fully Supported     | WSL2 Ubuntu 22.04 |
| Windows 10/11        | ✅ Partially Supported | Apps and VS Code  |
| Linux Ubuntu         | ✅ Supported           | 20.04+            |
| macOS                | ⚠️ Not tested          | -                 |

---

## 🔗 Useful Links

### 📚 Official Documentation

- [WSL2 Documentation](https://docs.microsoft.com/en-us/windows/wsl/)
- [Oh My Zsh](https://ohmyz.sh/)
- [Starship](https://starship.rs/)
- [VS Code](https://code.visualstudio.com/docs)
- [Sublime Text](https://www.sublimetext.com/docs/)

### 🛠️ Tools

- [Windows Terminal](https://github.com/microsoft/terminal)
- [PowerToys](https://github.com/microsoft/PowerToys)
- [FiraCode Nerd Font](https://github.com/ryanoasis/nerd-fonts)

### 🎯 Additional Resources

- [Awesome WSL](https://github.com/sirredbeard/Awesome-WSL)
- [Awesome Zsh](https://github.com/unixorn/awesome-zsh-plugins)
- [VS Code Extensions](https://marketplace.visualstudio.com/)

---

## 📄 License

This project is under the MIT license. See the [LICENSE](LICENSE) file for details.

---

## 👨‍💻 Author

**Bruno Hiago**

- GitHub: [@hiago19](https://github.com/hiago19)
- Email: [bhiago99@gmail.com](mailto:bhiago99@gmail.com)

---

## ⭐ Support the Project

If this project helped you, consider giving it a ⭐ on the repository!

---

**🚀 Happy Coding! Your development environment is ready for any challenge!**
