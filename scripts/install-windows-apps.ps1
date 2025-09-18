#!/bin/bash

# install-windows-apps.sh - Script para instalar aplicativos no Windows via winget
# Este script deve ser executado no PowerShell do Windows
# Autor: Bruno Hiago
# Versão: 1.0

# NOTA: Este é um script para ser executado no Windows PowerShell, não no WSL
# Para executar: .\install-windows-apps.ps1

$apps = @{
    "Essenciais" = @(
        "Microsoft.WindowsTerminal",
        "Microsoft.PowerToys",
        "Git.Git",
        "Docker.DockerDesktop",
        "Microsoft.VisualStudioCode",
        "SublimeHQ.SublimeText.4"
    )
    
    "Navegadores" = @(
        "Google.Chrome",
        "Mozilla.Firefox",
        "Microsoft.Edge"
    )
    
    "Desenvolvimento" = @(
        "Microsoft.VisualStudio.2022.Community",
        "JetBrains.IntelliJIDEA.Community",
        "Postman.Postman",
        "GitHub.GitHubDesktop",
        "NodeJS.NodeJS",
        "Python.Python.3.12",
        "Oracle.JavaRuntimeEnvironment"
    )
    
    "Comunicação" = @(
        "Microsoft.Teams",
        "SlackTechnologies.Slack",
        "Discord.Discord",
        "Zoom.Zoom",
        "WhatsApp.WhatsApp"
    )
    
    "Produtividade" = @(
        "Notion.Notion",
        "Obsidian.Obsidian",
        "Microsoft.Office",
        "Adobe.Acrobat.Reader.64-bit",
        "Notepad++.Notepad++"
    )
    
    "Mídia" = @(
        "VideoLAN.VLC",
        "Spotify.Spotify",
        "GIMP.GIMP",
        "OBSProject.OBSStudio"
    )
    
    "Utilitários" = @(
        "7zip.7zip",
        "WinRAR.WinRAR",
        "Rufus.Rufus",
        "Balena.Etcher",
        "CrystalDewWorld.CrystalDiskInfo"
    )
    
    "Segurança" = @(
        "Malwarebytes.Malwarebytes",
        "Bitwarden.Bitwarden"
    )
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
    
    Write-ColoredText "Escolha uma categoria para instalar:" "Yellow"
    Write-Host "1) 🔧 Essenciais (Terminal, PowerToys, Git, Docker, VS Code)"
    Write-Host "2)  🌐 Navegadores (Chrome, Firefox, Edge)"
    Write-Host "3) 💻 Desenvolvimento (Visual Studio, IntelliJ, Postman, etc)"
    Write-Host "4) 💬 Comunicação (Teams, Slack, Discord, Zoom)"
    Write-Host "5) 📝 Produtividade (Notion, Office, Notepad++)"
    Write-Host "6) 🎵 Mídia (VLC, Spotify, GIMP, OBS)"
    Write-Host "7) 🛠️ Utilitários (7zip, Rufus, CrystalDiskInfo)"
    Write-Host "8) 🔒 Segurança (Malwarebytes, Bitwarden)"
    Write-Host "9) 🚀 INSTALAR TUDO"
    Write-Host "0) ❌ Sair"
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
    $choice = Read-Host "Digite sua escolha (0-9)"
    
    switch ($choice) {
        "1" { Install-Category -CategoryName "Essenciais" -AppList $apps["Essenciais"] }
        "2" { Install-Category -CategoryName "Navegadores" -AppList $apps["Navegadores"] }
        "3" { Install-Category -CategoryName "Desenvolvimento" -AppList $apps["Desenvolvimento"] }
        "4" { Install-Category -CategoryName "Comunicação" -AppList $apps["Comunicação"] }
        "5" { Install-Category -CategoryName "Produtividade" -AppList $apps["Produtividade"] }
        "6" { Install-Category -CategoryName "Mídia" -AppList $apps["Mídia"] }
        "7" { Install-Category -CategoryName "Utilitários" -AppList $apps["Utilitários"] }
        "8" { Install-Category -CategoryName "Segurança" -AppList $apps["Segurança"] }
        "9" {
            Write-ColoredText "🚀 Instalando TODOS os aplicativos..." "Magenta"
            foreach ($category in $apps.Keys) {
                Install-Category -CategoryName $category -AppList $apps[$category]
            }
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