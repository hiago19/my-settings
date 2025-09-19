# 📝 Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto adere ao [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Não Lançado]

### 🔧 Adicionado

- Sistema de versionamento e changelog
- Testes de validação automática
- CI/CD pipeline básico

### 🐛 Corrigido

- Adicionado `set -euo pipefail` em todos os scripts para failfast
- Removido diretório problemático `"$HOME/`
- Melhorado tratamento de erros em funções críticas

### 🔄 Modificado

- Documentação atualizada com novos recursos
- Scripts PowerShell agora leem configurações do .env

## [3.0.0] - 2025-09-19

### 🔧 Adicionado

- Sistema modular com arquitetura core/modules/tools
- Configuração centralizada via arquivo .env
- Script PowerShell integrado com configurações .env
- Instalação oficial de FZF e outras ferramentas
- Sistema de backup e restore automático
- Validação de sistema antes da instalação

### 🔄 Modificado

- Refatoração completa da arquitetura de scripts
- Eliminação de redundância entre arquivos
- Melhoria na interface do menu interativo
- Documentação reestruturada e atualizada

### 🐛 Corrigido

- Problemas de compatibilidade com FZF versão mais recente
- Configuração do .zshrc para suporte adequado ao fzf --zsh
- Resolução de problemas de path nos scripts

## [2.0.0] - 2025-09-18

### 🔧 Adicionado

- Suporte completo ao WSL2
- Instalação automática de extensões VS Code
- Configuração automática do Git
- Sistema de cores e UI melhorado

### 🔄 Modificado

- Scripts reorganizados em estrutura modular
- Melhorado sistema de logs e feedback

## [1.0.0] - 2025-09-17

### 🔧 Adicionado

- Setup inicial básico do projeto
- Scripts de instalação para terminal e VS Code
- Configurações básicas para desenvolvimento
- Documentação inicial

---

## Tipos de Mudanças

- 🔧 **Adicionado** para novas funcionalidades
- 🔄 **Modificado** para mudanças em funcionalidades existentes
- 🗑️ **Removido** para funcionalidades removidas
- 🐛 **Corrigido** para correção de bugs
- 🔒 **Segurança** para vulnerabilidades de segurança

## Links

- [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/)
- [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
