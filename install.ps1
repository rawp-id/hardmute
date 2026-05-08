# Hardmute Multi-Agent Installation Script for Windows
# A lightweight execution protocol for AI agents.

$ErrorActionPreference = "Stop"

# Icons and Colors
$Check = "v"
$Info = "i"
$XMark = "x"
$Gear = "*"

Write-Host "========================================" -ForegroundColor Blue
Write-Host "   Hardmute Multi-Agent Installer (Win)" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Blue

# Define potential agent skill paths
$Agents = @{
    "Antigravity/Gemini" = "$HOME\.gemini\antigravity\skills"
    "Claude Code"        = "$HOME\.claude\skills"
    "Windsurf"           = "$HOME\.windsurf\skills"
    "Cursor (Global)"    = "$HOME\.cursor\skills"
    "OpenAI Codex"       = "$HOME\.codex\skills"
    "Other Agents"       = "$HOME\.agents\skills"
}

$Skills = @("hardmute", "hardmute-info", "hardmute-detail", "hardmute-trace")
$DetectedTargets = @()

# Source directory logic
$SrcDir = Join-Path (Get-Location) "skills"
if (-not (Test-Path $SrcDir)) {
    Write-Host "$Info Skills directory not found locally. Attempting remote download..." -ForegroundColor Yellow
    $TempDir = Join-Path $env:TEMP ([Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $TempDir | Out-Null
    
    try {
        git clone --depth 1 https://github.com/rawp-id/hardmute.git $TempDir 2>$null
        $SrcDir = Join-Path $TempDir "skills"
    } catch {
        Write-Host "$XMark Error: Git clone failed. Please install Git or run from repo root." -ForegroundColor Red
        exit 1
    }
}

if (-not (Test-Path $SrcDir)) {
    Write-Host "$XMark Error: Cannot find 'skills' directory." -ForegroundColor Red
    exit 1
}

# Detection phase
Write-Host "Detecting compatible agents..." -ForegroundColor White
foreach ($name in $Agents.Keys) {
    $path = $Agents[$name]
    $parentDir = Split-Path $path -Parent
    if (Test-Path $parentDir) {
        Write-Host "  $Check Found $name" -ForegroundColor Green
        $DetectedTargets += @{Path = $path; Name = $name}
    }
}

if ($DetectedTargets.Count -eq 0) {
    Write-Host "$Info No known agents detected. Defaulting to Gemini path." -ForegroundColor Yellow
    $DetectedTargets += @{Path = $Agents["Antigravity/Gemini"]; Name = "Antigravity/Gemini"}
}

# Installation phase
Write-Host "`nStarting installation..." -ForegroundColor White

foreach ($target in $DetectedTargets) {
    Write-Host "`n$Gear Target: $($target.Name)" -ForegroundColor Cyan
    Write-Host "  Path: $($target.Path)"
    
    if (-not (Test-Path $target.Path)) {
        New-Item -ItemType Directory -Path $target.Path -Force | Out-Null
    }
    
    foreach ($skill in $Skills) {
        $skillSrc = Join-Path $SrcDir $skill
        if (Test-Path $skillSrc) {
            Write-Host "  Installing $skill... " -NoNewline
            Copy-Item -Path $skillSrc -Destination $target.Path -Recurse -Force
            Write-Host "$Check" -ForegroundColor Green
        } else {
            Write-Host "  $XMark Skill '$skill' not found" -ForegroundColor Red
        }
    }
}

Write-Host "`n========================================" -ForegroundColor Blue
Write-Host "   Multi-Agent Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Blue
Write-Host "`nYou can now use hardmute modes in your agents:"
Write-Host "  /hardmute        - Silent execution"
Write-Host "  /hardmute-info   - Minimal info"
Write-Host "  /hardmute-detail - Execution details"
Write-Host "  /hardmute-trace  - Debug on failure"
Write-Host "`nEnjoy your noise-free execution environment." -ForegroundColor Cyan
