# Hardmute TUI Multi-Agent Installer for Windows
# A lightweight execution protocol for AI agents.

$ErrorActionPreference = "Stop"

function Show-Header($title) {
    Write-Host "========================================" -ForegroundColor Blue
    Write-Host "   $title" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Blue
}

$Agents = @(
    @{Name="Antigravity/Gemini"; Path="$HOME\.gemini\antigravity\skills"}
    @{Name="Claude Code";        Path="$HOME\.claude\skills"}
    @{Name="Windsurf";           Path="$HOME\.windsurf\skills"}
    @{Name="Cursor (Global)";    Path="$HOME\.cursor\skills"}
    @{Name="OpenAI Codex";       Path="$HOME\.codex\skills"}
    @{Name="Other Agents";       Path="$HOME\.agents\skills"}
)

$Skills        = @("hardmute", "hardmute-info", "hardmute-detail", "hardmute-trace", "hardmute-think")
$SkillVersions = @("Standard  - full rules, verbose enforcement", "Ultimate  - lightweight, priority/workflow core")

function Get-SingleSelection($title, $options) {
    $current = 0
    while ($true) {
        Clear-Host
        Show-Header $title
        Write-Host "Use [↑/↓] arrow keys or number, [Enter] to confirm:`n" -ForegroundColor Gray
        for ($i = 0; $i -lt $options.Count; $i++) {
            if ($i -eq $current) {
                Write-Host "  > $($i+1). $($options[$i])" -ForegroundColor Cyan
            } else {
                Write-Host "    $($i+1). $($options[$i])" -ForegroundColor Gray
            }
        }
        Write-Host "`nSelection (Enter to confirm current): " -NoNewline
        $input = Read-Host
        if ($input -eq "") { return $current }
        $idx = 0
        if ([int]::TryParse($input, [ref]$idx)) {
            if ($idx -ge 1 -and $idx -le $options.Count) { return ($idx - 1) }
        }
    }
}

function Get-MultiSelection($title, $options) {
    $selections = [bool[]]::new($options.Count)
    while ($true) {
        Clear-Host
        Show-Header $title
        Write-Host "Enter number to toggle, 'a' for all, 'n' for none, Enter to confirm:`n" -ForegroundColor Gray
        for ($i = 0; $i -lt $options.Count; $i++) {
            $mark  = if ($selections[$i]) { "[X]" } else { "[ ]" }
            $color = if ($selections[$i]) { "Green" } else { "Gray" }
            Write-Host "  $($i+1). $mark $($options[$i])" -ForegroundColor $color
        }
        Write-Host "`nSelection: " -NoNewline
        $input = Read-Host
        if ($input -eq "") {
            $any = $false
            foreach ($s in $selections) { if ($s) { $any = $true; break } }
            if (-not $any) { $selections[0] = $true }
            return $selections
        }
        if ($input -eq "a") { for ($i = 0; $i -lt $options.Count; $i++) { $selections[$i] = $true };  continue }
        if ($input -eq "n") { for ($i = 0; $i -lt $options.Count; $i++) { $selections[$i] = $false }; continue }
        $idx = 0
        if ([int]::TryParse($input, [ref]$idx)) {
            if ($idx -ge 1 -and $idx -le $options.Count) {
                $selections[$idx - 1] = -not $selections[$idx - 1]
            }
        }
    }
}

# Source directory
$TempDir = $null
$BaseDir = Join-Path (Get-Location) ""
$SrcBase = Join-Path $BaseDir "skills"

if (-not (Test-Path $SrcBase)) {
    Clear-Host
    Write-Host "* Skills directory not found. Downloading..." -ForegroundColor Yellow
    $TempDir = Join-Path $env:TEMP ([Guid]::NewGuid().ToString())
    New-Item -ItemType Directory -Path $TempDir | Out-Null
    git clone --depth 1 https://github.com/rawp-id/hardmute.git $TempDir 2>$null
    $BaseDir = $TempDir
    $SrcBase = Join-Path $TempDir "skills"
}

# 1. Select Skill Version
$versionIdx = Get-SingleSelection "Select Skill Version" $SkillVersions
if ($versionIdx -eq 1) {
    $SrcDir = Join-Path $BaseDir "ultimate-skills"
} else {
    $SrcDir = $SrcBase
}

# 2. Select Agents
$agentNames    = $Agents | ForEach-Object { $_.Name }
$agentSels     = Get-MultiSelection "Select Agents to Install" $agentNames

# 3. Select Skills
$skillSels     = Get-MultiSelection "Select Skills to Install" $Skills

# Resolve selections
$selectedAgents = @()
for ($i = 0; $i -lt $Agents.Count; $i++) { if ($agentSels[$i]) { $selectedAgents += $Agents[$i] } }

$selectedSkills = @()
for ($i = 0; $i -lt $Skills.Count; $i++) { if ($skillSels[$i]) { $selectedSkills += $Skills[$i] } }

if ($selectedAgents.Count -eq 0 -or $selectedSkills.Count -eq 0) {
    Write-Host "`nx No agents or skills selected. Aborting." -ForegroundColor Red
    exit 0
}

Clear-Host
Show-Header "Installing Hardmute..."

foreach ($target in $selectedAgents) {
    Write-Host "`n* Target: $($target.Name)" -ForegroundColor Cyan
    Write-Host "  Path: $($target.Path)"
    if (-not (Test-Path $target.Path)) {
        New-Item -ItemType Directory -Path $target.Path -Force | Out-Null
    }
    foreach ($skill in $selectedSkills) {
        $skillSrc = Join-Path $SrcDir $skill
        if (Test-Path $skillSrc) {
            Write-Host "  Installing $skill... " -NoNewline
            Copy-Item -Path $skillSrc -Destination $target.Path -Recurse -Force
            Write-Host "v" -ForegroundColor Green
        } else {
            Write-Host "  x Skill '$skill' not found in $SrcDir" -ForegroundColor Red
        }
    }
}

Write-Host "`n========================================" -ForegroundColor Blue
Write-Host "   Installation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Blue
Write-Host "`nEnjoy your noise-free execution environment." -ForegroundColor Cyan
