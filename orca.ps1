<#
.SYNOPSIS
    Orca Autonomous Project Builder & Swarm Orchestrator CLI v2.1 (Anti-Simulation)

.DESCRIPTION
    Master CLI entrypoint for Orca Agent Operating System.
    Transforms user prompt and design specifications into a production-ready software project at D:\OrcaProjects\<project-name>\
    by initializing the target project, scaffolding framework code, configuring Ralph tasks,
    and driving autonomous verification with physical filesystem enforcement.

.PARAMETER Prompt
    The product brief, user prompt, or feature requirement.

.PARAMETER ProjectName
    Optional slug name for the project directory in D:\OrcaProjects\.
    If omitted, auto-generated from prompt.

.PARAMETER Template
    Framework template: 'react-ts' (default), 'nextjs', 'node-ts', 'python-fastapi', 'custom'.

.PARAMETER Mode
    'execute' (default) or 'plan'.
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
Write-Host "   🐋 ORCA AUTONOMOUS SOFTWARE ENGINEERING OS v2.1          " -ForegroundColor Cyan
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

# 4. Check if project is initialized
$isInitialized = (Test-Path (Join-Path $TargetDir "package.json")) -or (Test-Path (Join-Path $TargetDir "requirements.txt"))
if (-not $isInitialized) {
    Write-Host "[Orca] PROJECT_STATUS = NOT_INITIALIZED. Creating directory structure..." -ForegroundColor Yellow
}

# 5. Initialize Core Directories
$docsDir = Join-Path $TargetDir "docs\architecture"
$specsDir = Join-Path $TargetDir "docs\specs"
$srcDir = Join-Path $TargetDir "src"

New-Item -ItemType Directory -Path $docsDir -Force | Out-Null
New-Item -ItemType Directory -Path $specsDir -Force | Out-Null
New-Item -ItemType Directory -Path $srcDir -Force | Out-Null

# 6. Write Project Manifest
$manifest = [ordered]@{
    "project_name" = $ProjectName
    "prompt"       = $Prompt
    "created_at"   = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    "template"     = $Template
    "orchestrator" = "Orca Agent OS v2.1"
    "orca_root"    = $OrcaRoot
    "status"       = if ($isInitialized) { "initialized" } else { "scaffolding_required" }
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

# 7. Initialize Ralph Tasks Manifest
$tasksFile = Join-Path $TargetDir "tasks.json"
if (-not (Test-Path $tasksFile)) {
    $initialTasks = @(
        [ordered]@{
            "task_id" = "TASK-OA-001"
            "title" = "Project Foundation and Framework Scaffolding"
            "assigned_agent" = "senior-system-architect"
            "phase" = "PHASE_4"
            "priority" = "P0"
            "dependencies" = @()
            "acceptance_criteria" = @(
                "package.json and build configs exist in project root",
                "TypeScript and Tailwind configured",
                "Clean directory structure"
            )
            "verification_commands" = @(
                "Test-Path '$TargetDir\package.json'",
                "Test-Path '$TargetDir\vite.config.ts'"
            )
        },
        [ordered]@{
            "task_id" = "TASK-OA-002"
            "title" = "Design Token System Implementation"
            "assigned_agent" = "senior-frontend-engineer"
            "phase" = "PHASE_4"
            "priority" = "P0"
            "dependencies" = @("TASK-OA-001")
            "acceptance_criteria" = @(
                "CSS tokens match design.md foundations (#000000 surface, #ffffff border, #afafaf secondary)",
                "Typography scale and 4px spacing scale defined",
                "WCAG 2.2 AA contrast compliance"
            )
            "verification_commands" = @(
                "Test-Path '$TargetDir\src\styles\tokens.css'"
            )
        },
        [ordered]@{
            "task_id" = "TASK-OA-003"
            "title" = "Agent Domain Models and Datasets"
            "assigned_agent" = "senior-system-designer"
            "phase" = "PHASE_4"
            "priority" = "P0"
            "dependencies" = @("TASK-OA-001")
            "acceptance_criteria" = @(
                "All 29 Orca agents defined with full authority metadata",
                "TypeScript type definitions for agents, domains, and tokens"
            )
            "verification_commands" = @(
                "Test-Path '$TargetDir\src\data\agents.ts'"
            )
        },
        [ordered]@{
            "task_id" = "TASK-OA-004"
            "title" = "UI Component Primitives and Shell"
            "assigned_agent" = "senior-frontend-engineer"
            "phase" = "PHASE_4"
            "priority" = "P0"
            "dependencies" = @("TASK-OA-002", "TASK-OA-003")
            "acceptance_criteria" = @(
                "Button, Card, Input, Badge, Tabs, Modal primitives implemented",
                "All components have state matrices (default, hover, focus, active, disabled)",
                "Header and Sidebar navigation implemented"
            )
            "verification_commands" = @(
                "Test-Path '$TargetDir\src\components\layout\AppLayout.tsx'"
            )
        },
        [ordered]@{
            "task_id" = "TASK-OA-005"
            "title" = "Interactive Views & Pages Implementation"
            "assigned_agent" = "senior-frontend-engineer"
            "phase" = "PHASE_4"
            "priority" = "P0"
            "dependencies" = @("TASK-OA-004")
            "acceptance_criteria" = @(
                "Agent Directory page with real-time search and filter",
                "Team Setup Builder with domain selection and manifest export",
                "Token Inspector with live token values",
                "Prompt Routing Simulator playground"
            )
            "verification_commands" = @(
                "Test-Path '$TargetDir\src\pages\AgentDirectory.tsx'",
                "Test-Path '$TargetDir\src\pages\TeamBuilder.tsx'"
            )
        },
        [ordered]@{
            "task_id" = "TASK-OA-006"
            "title" = "Testing Suite and Quality Verification"
            "assigned_agent" = "senior-qa-architect"
            "phase" = "PHASE_5"
            "priority" = "P0"
            "dependencies" = @("TASK-OA-005")
            "acceptance_criteria" = @(
                "Unit tests for agents, tokens, and components",
                "TypeScript compilation succeeds with zero errors",
                "Build completes with zero warnings"
            )
            "verification_commands" = @(
                "Test-Path '$TargetDir\src\tests\agents.test.ts'"
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
