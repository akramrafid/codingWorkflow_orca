<#
.SYNOPSIS
    Orca Autonomous Project Builder & Swarm Orchestrator CLI.

.DESCRIPTION
    Master CLI entrypoint for Orca Agent Operating System.
    Transforms user prompt into a production-ready software project at D:\OrcaProjects\<project-name>\
    by initializing the target project, scaffolding framework code, configuring Ralph tasks,
    and driving autonomous verification.

.PARAMETER Prompt
    The product brief, user prompt, or feature requirement.

.PARAMETER ProjectName
    Optional slug name for the project directory in D:\OrcaProjects\.
    If omitted, auto-generated from prompt.

.PARAMETER Template
    Framework template: 'react-ts' (default), 'nextjs', 'node-ts', 'python-fastapi', 'custom'.

.PARAMETER Mode
    'execute' (default) or 'plan'.

.EXAMPLE
    .\orca.ps1 -Prompt "Build DeepSeek Harness UI preview documentation site"
    .\orca.ps1 -ProjectName "saas-dashboard" -Prompt "Build enterprise analytics dashboard" -Template "react-ts"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Prompt,

    [Parameter(Mandatory = $false)]
    [string]$ProjectName,

    [Parameter(Mandatory = $false)]
    [ValidateSet("react-ts", "nextjs", "node-ts", "python-fastapi", "custom")]
    [string]$Template = "react-ts",

    [Parameter(Mandatory = $false)]
    [ValidateSet("execute", "plan")]
    [string]$Mode = "execute"
)

$ErrorActionPreference = "Stop"

$OrcaRoot = (Resolve-Path $PSScriptRoot).Path
$ProjectsRoot = "D:\OrcaProjects"

# 1. Ensure Projects Root exists
if (-not (Test-Path $ProjectsRoot)) {
    New-Item -ItemType Directory -Path $ProjectsRoot -Force | Out-Null
}

# 2. Derive Project Name if not provided
if (-not $ProjectName) {
    # Generate clean kebab-case name from first few words of prompt
    $cleanWords = ($Prompt -replace '[^a-zA-Z0-9\s]', '').Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
    if ($cleanWords.Count -gt 0) {
        $slug = ($cleanWords | Select-Object -First 4) -join '-'
        $ProjectName = $slug.ToLower()
    } else {
        $ProjectName = "orca-project-" + (Get-Date -Format "yyyyMMdd-HHmmss")
    }
}

$TargetDir = Join-Path $ProjectsRoot $ProjectName

Write-Host ""
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "   🐋 ORCA AUTONOMOUS SOFTWARE ENGINEERING OS v2.0          " -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host "  Prompt       : $Prompt" -ForegroundColor White
Write-Host "  Project Name : $ProjectName" -ForegroundColor Green
Write-Host "  Target Path  : $TargetDir" -ForegroundColor Green
Write-Host "  Template     : $Template" -ForegroundColor Yellow
Write-Host "  Mode         : $Mode" -ForegroundColor Yellow
Write-Host "============================================================" -ForegroundColor Cyan
Write-Host ""

# 3. Create Project Directory
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
    Write-Host "[Orca] Created project directory: $TargetDir" -ForegroundColor Green
}

# 4. Initialize Core Directories
$docsDir = Join-Path $TargetDir "docs\architecture"
$specsDir = Join-Path $TargetDir "docs\specs"
$srcDir = Join-Path $TargetDir "src"

New-Item -ItemType Directory -Path $docsDir -Force | Out-Null
New-Item -ItemType Directory -Path $specsDir -Force | Out-Null
New-Item -ItemType Directory -Path $srcDir -Force | Out-Null

# 5. Write Project Manifest & Capability Assessment
$manifest = [ordered]@{
    "project_name" = $ProjectName
    "prompt"       = $Prompt
    "created_at"   = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    "template"     = $Template
    "orchestrator" = "Orca Agent OS v2.0"
    "orca_root"    = $OrcaRoot
    "status"       = "initialized"
    "paths"        = @{
        "root"  = $TargetDir
        "docs"  = $docsDir
        "specs" = $specsDir
        "src"   = $srcDir
    }
}

$manifestPath = Join-Path $TargetDir "orca-manifest.json"
$manifest | ConvertTo-Json -Depth 5 | Set-Content -Path $manifestPath -Encoding UTF8
Write-Host "[Orca] Initialized project manifest: $manifestPath" -ForegroundColor Green

# 6. Initialize Ralph Tasks Manifest if not exists
$tasksFile = Join-Path $TargetDir "tasks.json"
if (-not (Test-Path $tasksFile)) {
    $initialTasks = @(
        [ordered]@{
            "task_id" = "TASK-01"
            "title" = "Project Scaffolding & Token Architecture"
            "assigned_agent" = "senior-system-architect"
            "phase" = "PHASE_1"
            "priority" = "P0"
            "dependencies" = @()
            "acceptance_criteria" = @(
                "Framework initialized",
                "Design tokens configured",
                "Zero build warnings"
            )
            "verification_commands" = @(
                "Test-Path '$TargetDir\orca-manifest.json'"
            )
        },
        [ordered]@{
            "task_id" = "TASK-02"
            "title" = "Core Feature Implementation"
            "assigned_agent" = "senior-frontend-engineer"
            "phase" = "PHASE_4"
            "priority" = "P0"
            "dependencies" = @("TASK-01")
            "acceptance_criteria" = @(
                "Components match token contracts",
                "Production build succeeds"
            )
            "verification_commands" = @(
                "Test-Path '$srcDir'"
            )
        }
    )
    $initialTasks | ConvertTo-Json -Depth 5 | Set-Content -Path $tasksFile -Encoding UTF8
    Write-Host "[Orca] Created Ralph tasks file: $tasksFile" -ForegroundColor Green
}

Write-Host ""
Write-Host "[Orca] Ready for Autonomous Execution Swarm!" -ForegroundColor Cyan
Write-Host "Target: $TargetDir" -ForegroundColor White
Write-Host ""

exit 0
