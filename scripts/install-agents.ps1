<#
.SYNOPSIS
  Install/Sync Orca Agents into Antigravity Global Config

.DESCRIPTION
  Copies agent definitions from D:\Orca\agents to the global Antigravity
  agent directory (~/.gemini/config/agents/) for global availability across workspaces.
#>

param (
    [string]$SourceDir = "$PSScriptRoot\..\agents",
    [string]$TargetDir = "$env:USERPROFILE\.gemini\config\agents"
)

$ErrorActionPreference = "Stop"
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "     ORCA GLOBAL AGENT INSTALLATION       " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

if (-not (Test-Path $SourceDir)) {
    Write-Host "[Error] Source directory $SourceDir does not exist." -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Force -Path $TargetDir | Out-Null
    Write-Host "[Init] Created global agent directory: $TargetDir" -ForegroundColor Yellow
}

$agentFiles = Get-ChildItem -Path $SourceDir -Filter "*.md"
$copiedCount = 0

foreach ($file in $agentFiles) {
    Copy-Item -Path $file.FullName -Destination $TargetDir -Force
    $copiedCount++
    Write-Host "[Installed] $($file.Name) -> $TargetDir" -ForegroundColor Green
}

Write-Host "`nSuccessfully installed $copiedCount agent definitions into Antigravity global configuration." -ForegroundColor Cyan
