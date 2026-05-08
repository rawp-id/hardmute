# Hardmute TUI Multi-Agent Installer for Windows
# A lightweight execution protocol for AI agents.

$ErrorActionPreference = "Stop"

# Colors & Icons
$Check = "v"
$Unchecked = "o"
$Checked = "X"
$Info = "i"
$XMark = "x"
$Gear = "*"

function Show-Header($title) {
    Write-Host "========================================" -ForegroundColor Blue
    Write-Host "   $title" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Blue
}

# Define potential agent skill paths
$Agents = @(
    @{Name="Antigravity/Gemini"; Path="$HOME\.gemini\antigravity\skills"}
    @{Name="Claude Code"; Path="$HOME\.claude\skills"}
    @{Name="Windsurf"; Path="$HOME\.windsurf\skills"}
    @{Name="Cursor (Global)"; Path="$HOME\.cursor\skills"}
    @{Name="OpenAI Codex"; Path="$HOME\.codex\skills"}
    @{Name="Other Agents"; Path="$HOME\.agents\skills"}
)

$Skills = @("hardmute", "hardmute-info", "hardmute-detail", "hardmute-trace")

# Detection
$DetectedAgents = @()
foreach ($agent in $Agents) {
    $parentDir = Split-Path $agent.Path -Parent
    if (Test-Path $parentDir) {
        $DetectedAgents += $agent
    }
}

if ($DetectedAgents.Count -eq 0) {
    $DetectedAgents += $Agents[0]
}

# TUI Menu Helper
function Get-MultiSelection($title, $options) {
    $selections = @()
    foreach($o in $options) { $selections += $false }
    
    while($true) {
        Clear-Host
        Show-Header $title
        Write-Host "Enter number to toggle, 'a' for all, 'n' for none, or 'Enter' to confirm:`n" -ForegroundColor Gray
        
        for($i=0; $i -lt $options.Count; $i++) {
            $prefix = if ($selections[$i]) { "[X]" } else { "[ ]" }
            $color = if ($selections[$i]) { "Green" } else { "Gray" }
            Write-Host "  $($i+1). $prefix $($options[$i])" -ForegroundColor $color
        }
        
        Write-Host "`nSelection: " -NoNewline
        $input = Read-Host
        
        if ($input -eq "") { break }
        if ($input -eq "a") { for($i=0; $i -lt $options.Count; $i++) { $selections[$i] = $true }; continue }
        if ($input -eq "n") { for($i=0; $i -lt $options.Count; $i++) { $selections[$i] = $false }; continue }
        
        if ([int]::TryParse($input, [ref]$idx)) {
            if ($idx -gt 0 -and $idx -le $options.Count) {
                $selections[$idx-1] = -not $selections[$idx-1]
            }
        }
    }
    return $selections
}

# Source directory logic
$SrcDir = Join-Path (Get-Location) "skills"
if (-not (Test-Path $SrcDir)) {
    Clear-Host
    Write-Host "$Info Skills directory not found. Downloading..." -ForegroundColor Yellow
    $TempDir = Join-Path $env:TEMP ([Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $TempDir | Out-Null
    git clone --depth 1 https://github.com/rawp-id/hardmute.git $TempDir 2>$null
    $SrcDir = Join-Path $TempDir "skills"
}

# 1. Select Agents
$agentNames = $DetectedAgents | ForEach-Object { $_.Name }
$agentSelections = Get-MultiSelection "Select Agents" $agentNames

# 2. Select Skills
$skillSelections = Get-MultiSelection "Select Skills" $Skills

# Final Installation
$selectedAgents = @()
for($i=0; $i -lt $DetectedAgents.Count; $i++) { if($agentSelections[$i]) { $selectedAgents += $DetectedAgents[$i] } }

$selectedSkills = @()
for($i=0; $i -lt $Skills.Count; $i++) { if($skillSelections[$i]) { $selectedSkills += $Skills[$i] } }

if ($selectedAgents.Count -eq 0 -or $selectedSkills.Count -eq 0) {
    Write-Host "`n$XMark No agents or skills selected. Aborting." -ForegroundColor Red
    exit 0
}

Clear-Host
Show-Header "Installing Hardmute..."

foreach ($target in $selectedAgents) {
    Write-Host "`n$Gear Target: $($target.Name)" -ForegroundColor Cyan
    Write-Host "  Path: $($target.Path)"
    
    if (-not (Test-Path $target.Path)) {
        New-Item -ItemType Directory -Path $target.Path -Force | Out-Null
    }
    
    foreach ($skill in $selectedSkills) {
        $skillSrc = Join-Path $SrcDir $skill
        if (Test-Path $skillSrc) {
            Write-Host "  Installing $skill... " -NoNewline
            Copy-Item -Path $skillSrc -Destination $target.Path -Recurse -Force
            Write-Host "$Check" -ForegroundColor Green
        }
    }
}

Write-Host "`n========================================" -ForegroundColor Blue
Write-Host "   Multi-Agent Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Blue
Write-Host "`nEnjoy your noise-free execution environment." -ForegroundColor Cyan
