<#
.SYNOPSIS
    Synchronizes custom AI agent skills to local configurations on Windows.
.DESCRIPTION
    Supports CodeBuddy, Antigravity, and Claude/Agents.
    Uses NTFS Directory Junctions (no Administrator privileges required).
.PARAMETER CodeBuddy
    Explicitly sync to CodeBuddy (~/.codebuddy/skills).
.PARAMETER Gemini
    Explicitly sync to Antigravity (~/.gemini/config/skills).
.PARAMETER Agents
    Explicitly sync to Agents / Claude (~/.agents/skills).
.PARAMETER All
    Sync to all supported environments.
.EXAMPLE
    .\skills\sync.ps1
.EXAMPLE
    .\skills\sync.ps1 -CodeBuddy
.EXAMPLE
    .\skills\sync.ps1 -All
#>

[CmdletBinding()]
param (
    [Alias("c")]
    [switch]$CodeBuddy,

    [Alias("g", "antigravity")]
    [switch]$Gemini,

    [switch]$Agents,

    [Alias("a")]
    [switch]$All,

    [Alias("h")]
    [switch]$Help
)

if ($Help) {
    Get-Help $MyInvocation.MyCommand.Path -Detailed
    exit 0
}

$ErrorActionPreference = "Stop"

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir
$SkillsDir = Join-Path $RepoRoot "skills"

# Standard home directory on Windows ($HOME or $env:USERPROFILE)
$UserHome = if ($env:USERPROFILE) { $env:USERPROFILE } else { $HOME }

$CodeBuddySkills = Join-Path $UserHome ".codebuddy\skills"
$GeminiSkills = Join-Path $UserHome ".gemini\config\skills"
$AgentsSkills = Join-Path $UserHome ".agents\skills"

$TargetDirs = [System.Collections.Generic.List[string]]::new()

function Add-TargetDirectory([string]$Path) {
    if (-not (Test-Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force | Out-Null
    }
    $resolved = (Resolve-Path $Path).Path
    if (-not $TargetDirs.Contains($resolved)) {
        $TargetDirs.Add($resolved)
    }
}

# 1. Handle explicit parameters
if ($All) {
    Add-TargetDirectory $CodeBuddySkills
    Add-TargetDirectory $GeminiSkills
    Add-TargetDirectory $AgentsSkills
} else {
    if ($CodeBuddy) { Add-TargetDirectory $CodeBuddySkills }
    if ($Gemini)    { Add-TargetDirectory $GeminiSkills }
    if ($Agents)    { Add-TargetDirectory $AgentsSkills }
}

# 2. Auto-detection if no explicit parameter was provided
if ($TargetDirs.Count -eq 0) {
    # Check CodeBuddy
    $cbRoot = Join-Path $UserHome ".codebuddy"
    if ((Test-Path $cbRoot) -or (Test-Path $CodeBuddySkills) -or (Get-Command codebuddy -ErrorAction SilentlyContinue)) {
        Add-TargetDirectory $CodeBuddySkills
    }

    # Check Antigravity / Gemini
    $geminiRoot = Join-Path $UserHome ".gemini\config"
    if ((Test-Path $geminiRoot) -or (Test-Path $GeminiSkills)) {
        Add-TargetDirectory $GeminiSkills
    }

    # Check Agents / Claude
    $agentsRoot = Join-Path $UserHome ".agents"
    if ((Test-Path $agentsRoot) -or (Test-Path $AgentsSkills)) {
        Add-TargetDirectory $AgentsSkills
    }

    # Fallback if brand new machine
    if ($TargetDirs.Count -eq 0) {
        Write-Host "[i] No existing AI agent directories found. Preparing standard targets..." -ForegroundColor Cyan
        Add-TargetDirectory $CodeBuddySkills
        Add-TargetDirectory $GeminiSkills
        Add-TargetDirectory $AgentsSkills
    }
}

Write-Host "==================================================" -ForegroundColor Cyan
Write-Host " Synchronizing Agent Skills to Local Environment (Windows)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
Write-Host "Source: $SkillsDir"
foreach ($t in $TargetDirs) {
    Write-Host "Target: $t" -ForegroundColor Yellow
}
Write-Host "--------------------------------------------------"

$SyncedCount = 0
$SkillFolders = Get-ChildItem -Path $SkillsDir -Directory | Where-Object { -not $_.Name.StartsWith(".") }

foreach ($folder in $SkillFolders) {
    $skillName = $folder.Name
    $skillSource = $folder.FullName

    foreach ($targetDir in $TargetDirs) {
        $destLink = Join-Path $targetDir $skillName

        # Check existing destination
        if (Test-Path $destLink) {
            $item = Get-Item -Path $destLink -Force
            # Check if it's already a reparse point (junction or symlink)
            if ($item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) {
                # Already a link, recreate cleanly
                try {
                    [System.IO.Directory]::Delete($destLink)
                } catch {
                    Remove-Item -Path $destLink -Recurse -Force
                }
            } else {
                # Real directory - backup first
                $timestamp = Get-Date -Format "yyyyMMddHHmmss"
                $backupDir = "${destLink}.bak.${timestamp}"
                Write-Host "[!] Existing real folder found at $destLink. Moving to $backupDir" -ForegroundColor DarkYellow
                Move-Item -Path $destLink -Destination $backupDir -Force
            }
        }

        # Create Junction (standard on Windows NTFS, requires no admin privileges)
        $created = $false
        try {
            New-Item -ItemType Junction -Path $destLink -Target $skillSource -Force | Out-Null
            $created = $true
        } catch {
            # Fallback to SymbolicLink (if developer mode enabled) or Directory Copy
            try {
                New-Item -ItemType SymbolicLink -Path $destLink -Target $skillSource -Force | Out-Null
                $created = $true
            } catch {
                Write-Host "[!] Junction/Symlink failed (cross-drive?). Copying directory instead..." -ForegroundColor Yellow
                Copy-Item -Path $skillSource -Destination $destLink -Recurse -Force
                $created = $true
            }
        }

        if ($created) {
            Write-Host "[✓] Linked: $skillName -> $destLink" -ForegroundColor Green
        }
    }
    $SyncedCount++
}

Write-Host "--------------------------------------------------"
Write-Host "Done! Successfully synchronized $SyncedCount skill(s)." -ForegroundColor Green
Write-Host "Supported environments (CodeBuddy / Antigravity / Agents) will automatically discover them."
