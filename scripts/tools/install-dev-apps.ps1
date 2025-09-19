#!/usr/bin/env pwsh

# install-dev-apps.ps1 - Script para instalar aplicativos no Windows via winget
# Este script deve ser executado no PowerShell do Windows
# Autor: Bruno Hiago
# Versão: 2.0
# Configurações via arquivo .env

# NOTA: Este é um script para ser executado no Windows PowerShell, não no WSL
# Para executar: .\install-dev-apps.ps1

# =============================================================================
# CARREGAMENTO DAS CONFIGURAÇÕES DO .ENV
# =============================================================================

function Load-EnvFile {
    param(
        [string]$EnvFilePath
    )
    
    $envVars = @{}
    
    if (Test-Path $EnvFilePath) {
        Write-ColoredText "📄 Carregando configurações de: $EnvFilePath" "Cyan"
        
        Get-Content $EnvFilePath | ForEach-Object {
            $line = $_.Trim()
            # Ignorar comentários e linhas vazias
            if ($line -and !$line.StartsWith('#') -and $line.Contains('=')) {
                $parts = $line -split '=', 2
                if ($parts.Count -eq 2) {
                    $key = $parts[0].Trim()
                    $value = $parts[1].Trim().Trim('"')
                    $envVars[$key] = $value
                }
            }
        }
    } else {
        Write-ColoredText "⚠️ Arquivo .env não encontrado. Usando configurações padrão." "Yellow"
        # Configurações padrão se não houver .env
        $envVars = @{
            "WINDOWS_ESSENTIAL_APPS" = "Microsoft.WindowsTerminal Microsoft.PowerToys Git.Git Docker.DockerDesktop Microsoft.VisualStudioCode SublimeHQ.SublimeText.4"
            "WINDOWS_BROWSERS" = "Google.Chrome Mozilla.Firefox Microsoft.Edge"
            "WINDOWS_DEV_TOOLS" = "Microsoft.VisualStudio.2022.Community JetBrains.IntelliJIDEA.Community Postman.Postman GitHub.GitHubDesktop NodeJS.NodeJS Python.Python.3.12 Oracle.JavaRuntimeEnvironment"
            "WINDOWS_COMMUNICATION" = "Microsoft.Teams SlackTechnologies.Slack Discord.Discord Zoom.Zoom WhatsApp.WhatsApp"
            "WINDOWS_PRODUCTIVITY" = "Notion.Notion Obsidian.Obsidian Microsoft.Office Adobe.Acrobat.Reader.64-bit"
            "WINDOWS_MEDIA" = "VideoLAN.VLC Spotify.Spotify GIMP.GIMP OBSProject.OBSStudio"
            "WINDOWS_UTILITIES" = "7zip.7zip WinRAR.WinRAR Rufus.Rufus Balena.Etcher CrystalDewWorld.CrystalDiskInfo"
            "WINDOWS_SECURITY" = "Malwarebytes.Malwarebytes Bitwarden.Bitwarden"
            "INSTALL_WINDOWS_ESSENTIAL" = "true"
            "INSTALL_WINDOWS_BROWSERS" = "true"
            "INSTALL_WINDOWS_DEV_TOOLS" = "false"
            "INSTALL_WINDOWS_COMMUNICATION" = "false"
            "INSTALL_WINDOWS_PRODUCTIVITY" = "false"
            "INSTALL_WINDOWS_MEDIA" = "false"
            "INSTALL_WINDOWS_UTILITIES" = "false"
            "INSTALL_WINDOWS_SECURITY" = "false"
        }
    }
    
    return $envVars
}

function Parse-AppList {
    param(
        [string]$AppString
    )
    
    if ([string]::IsNullOrWhiteSpace($AppString)) {
        return @()
    }
    
    return $AppString -split '\s+' | Where-Object { $_ -ne '' }
}

# Caregar configurações
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootDir = Split-Path -Parent (Split-Path -Parent $scriptDir)
$envFilePath = Join-Path $rootDir ".env"

$config = Load-EnvFile -EnvFilePath $envFilePath

# Criar estrutura de apps baseada no .env
$apps = @{
    "Essenciais" = Parse-AppList $config["WINDOWS_ESSENTIAL_APPS"]
    "Navegadores" = Parse-AppList $config["WINDOWS_BROWSERS"]
    "Desenvolvimento" = Parse-AppList $config["WINDOWS_DEV_TOOLS"]
    "Comunicação" = Parse-AppList $config["WINDOWS_COMMUNICATION"]
    "Produtividade" = Parse-AppList $config["WINDOWS_PRODUCTIVITY"]
    "Mídia" = Parse-AppList $config["WINDOWS_MEDIA"]
    "Utilitários" = Parse-AppList $config["WINDOWS_UTILITIES"]
    "Segurança" = Parse-AppList $config["WINDOWS_SECURITY"]
}

# Controles de instalação do .env
$installControls = @{
    "Essenciais" = $config["INSTALL_WINDOWS_ESSENTIAL"] -eq "true"
    "Navegadores" = $config["INSTALL_WINDOWS_BROWSERS"] -eq "true"
    "Desenvolvimento" = $config["INSTALL_WINDOWS_DEV_TOOLS"] -eq "true"
    "Comunicação" = $config["INSTALL_WINDOWS_COMMUNICATION"] -eq "true"
    "Produtividade" = $config["INSTALL_WINDOWS_PRODUCTIVITY"] -eq "true"
    "Mídia" = $config["INSTALL_WINDOWS_MEDIA"] -eq "true"
    "Utilitários" = $config["INSTALL_WINDOWS_UTILITIES"] -eq "true"
    "Segurança" = $config["INSTALL_WINDOWS_SECURITY"] -eq "true"
}

function Write-ColoredText {
    param(
        [string]$Text,
        [string]$Color = "White"
    )
    Write-Host $Text -ForegroundColor $Color
}

function Install-WingetApp {
    param(
        [string]$AppId,
        [string]$AppName
    )
    
    Write-ColoredText "📦 Instalando: $AppName" "Cyan"
    
    try {
        winget install --id $AppId --accept-package-agreements --accept-source-agreements --silent
        if ($LASTEXITCODE -eq 0) {
            Write-ColoredText "  ✅ $AppName instalado com sucesso" "Green"
        } else {
            Write-ColoredText "  ⚠️ Falha na instalação de $AppName" "Yellow"
        }
    }
    catch {
        Write-ColoredText "  ❌ Erro ao instalar $AppName" "Red"
    }
}

function Show-Menu {
    Clear-Host
    Write-ColoredText "═══════════════════════════════════════════" "Magenta"
    Write-ColoredText "    🚀 INSTALADOR DE APPS WINDOWS 🚀" "Magenta"
    Write-ColoredText "═══════════════════════════════════════════" "Magenta"
    Write-Host ""
    
    Write-ColoredText "📋 Configurações carregadas do arquivo .env" "Gray"
    Write-Host ""
    
    Write-ColoredText "Escolha uma categoria para instalar:" "Yellow"
    
    # Mostrar categorias com indicador de habilitado/desabilitado
    $menuItems = @(
        @{ Key = "1"; Name = "🔧 Essenciais"; Category = "Essenciais"; Apps = $apps["Essenciais"] }
        @{ Key = "2"; Name = "🌐 Navegadores"; Category = "Navegadores"; Apps = $apps["Navegadores"] }
        @{ Key = "3"; Name = "💻 Desenvolvimento"; Category = "Desenvolvimento"; Apps = $apps["Desenvolvimento"] }
        @{ Key = "4"; Name = "💬 Comunicação"; Category = "Comunicação"; Apps = $apps["Comunicação"] }
        @{ Key = "5"; Name = "📝 Produtividade"; Category = "Produtividade"; Apps = $apps["Produtividade"] }
        @{ Key = "6"; Name = "🎵 Mídia"; Category = "Mídia"; Apps = $apps["Mídia"] }
        @{ Key = "7"; Name = "🛠️ Utilitários"; Category = "Utilitários"; Apps = $apps["Utilitários"] }
        @{ Key = "8"; Name = "🔒 Segurança"; Category = "Segurança"; Apps = $apps["Segurança"] }
    )
    
    foreach ($item in $menuItems) {
        $status = if ($installControls[$item.Category]) { "✅" } else { "⚪" }
        $count = $item.Apps.Count
        Write-Host "$($item.Key)) $status $($item.Name) ($count apps)"
    }
    
    Write-Host ""
    Write-Host "9) 🚀 INSTALAR APENAS CATEGORIAS HABILITADAS (.env)"
    Write-Host "A) 🎯 INSTALAR TUDO (ignorar configurações .env)"
    Write-Host "C) ⚙️ MOSTRAR CONFIGURAÇÕES ATUAIS"
    Write-Host "0) ❌ Sair"
    Write-Host ""
    Write-ColoredText "💡 Dica: Configure suas preferências no arquivo .env" "Gray"
    Write-Host ""
}

function Show-Config {
    Clear-Host
    Write-ColoredText "⚙️ CONFIGURAÇÕES ATUAIS" "Cyan"
    Write-ColoredText "══════════════════════" "Cyan"
    Write-Host ""
    
    foreach ($category in $apps.Keys | Sort-Object) {
        $enabled = if ($installControls[$category]) { "✅ HABILITADO" } else { "⚪ DESABILITADO" }
        $appCount = $apps[$category].Count
        
        Write-ColoredText "� $category ($appCount apps) - $enabled" "Yellow"
        if ($apps[$category].Count -gt 0) {
            foreach ($app in $apps[$category]) {
                Write-Host "   • $app" -ForegroundColor Gray
            }
        } else {
            Write-Host "   (Nenhum app configurado)" -ForegroundColor Gray
        }
        Write-Host ""
    }
    
    Write-ColoredText "💡 Para alterar, edite o arquivo .env na raiz do projeto" "Cyan"
    Write-Host ""
}

function Install-Category {
    param(
        [string]$CategoryName,
        [array]$AppList
    )
    
    Write-ColoredText "🏗️ Instalando categoria: $CategoryName" "Blue"
    Write-Host ""
    
    foreach ($app in $AppList) {
        Install-WingetApp -AppId $app -AppName $app
    }
    
    Write-Host ""
    Write-ColoredText "✅ Categoria '$CategoryName' concluída!" "Green"
}

# Verificar se winget está disponível
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-ColoredText "❌ winget não encontrado!" "Red"
    Write-ColoredText "Instale o App Installer da Microsoft Store" "Yellow"
    exit 1
}

# Verificar se está executando como administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-ColoredText "⚠️ Recomendado executar como Administrador para melhor compatibilidade" "Yellow"
}

# Loop principal
do {
    Show-Menu
    $choice = Read-Host "Digite sua escolha (0-9, A, C)"
    
    switch ($choice.ToUpper()) {
        "1" { 
            if ($installControls["Essenciais"]) {
                Install-Category -CategoryName "Essenciais" -AppList $apps["Essenciais"]
            } else {
                Write-ColoredText "⚪ Categoria 'Essenciais' está desabilitada no .env" "Yellow"
            }
        }
        "2" { 
            if ($installControls["Navegadores"]) {
                Install-Category -CategoryName "Navegadores" -AppList $apps["Navegadores"]
            } else {
                Write-ColoredText "⚪ Categoria 'Navegadores' está desabilitada no .env" "Yellow"
            }
        }
        "3" { 
            if ($installControls["Desenvolvimento"]) {
                Install-Category -CategoryName "Desenvolvimento" -AppList $apps["Desenvolvimento"]
            } else {
                Write-ColoredText "⚪ Categoria 'Desenvolvimento' está desabilitada no .env" "Yellow"
            }
        }
        "4" { 
            if ($installControls["Comunicação"]) {
                Install-Category -CategoryName "Comunicação" -AppList $apps["Comunicação"]
            } else {
                Write-ColoredText "⚪ Categoria 'Comunicação' está desabilitada no .env" "Yellow"
            }
        }
        "5" { 
            if ($installControls["Produtividade"]) {
                Install-Category -CategoryName "Produtividade" -AppList $apps["Produtividade"]
            } else {
                Write-ColoredText "⚪ Categoria 'Produtividade' está desabilitada no .env" "Yellow"
            }
        }
        "6" { 
            if ($installControls["Mídia"]) {
                Install-Category -CategoryName "Mídia" -AppList $apps["Mídia"]
            } else {
                Write-ColoredText "⚪ Categoria 'Mídia' está desabilitada no .env" "Yellow"
            }
        }
        "7" { 
            if ($installControls["Utilitários"]) {
                Install-Category -CategoryName "Utilitários" -AppList $apps["Utilitários"]
            } else {
                Write-ColoredText "⚪ Categoria 'Utilitários' está desabilitada no .env" "Yellow"
            }
        }
        "8" { 
            if ($installControls["Segurança"]) {
                Install-Category -CategoryName "Segurança" -AppList $apps["Segurança"]
            } else {
                Write-ColoredText "⚪ Categoria 'Segurança' está desabilitada no .env" "Yellow"
            }
        }
        "9" {
            Write-ColoredText "🚀 Instalando apenas categorias HABILITADAS no .env..." "Magenta"
            $installedAny = $false
            foreach ($category in $apps.Keys) {
                if ($installControls[$category] -and $apps[$category].Count -gt 0) {
                    Install-Category -CategoryName $category -AppList $apps[$category]
                    $installedAny = $true
                }
            }
            if (-not $installedAny) {
                Write-ColoredText "⚠️ Nenhuma categoria está habilitada no .env" "Yellow"
            }
        }
        "A" {
            Write-ColoredText "🎯 Instalando TODAS as categorias (ignorando .env)..." "Magenta"
            foreach ($category in $apps.Keys) {
                if ($apps[$category].Count -gt 0) {
                    Install-Category -CategoryName $category -AppList $apps[$category]
                }
            }
        }
        "C" {
            Show-Config
        }
        "0" { 
            Write-ColoredText "👋 Saindo..." "Yellow"
            break 
        }
        default { 
            Write-ColoredText "❌ Opção inválida!" "Red"
        }
    }
    
    if ($choice -ne "0") {
        Write-Host ""
        Write-ColoredText "Pressione qualquer tecla para continuar..." "Gray"
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    }
} while ($choice -ne "0")

Write-ColoredText "🎉 Instalação concluída! Reinicie o sistema se necessário." "Green"