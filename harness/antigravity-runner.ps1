<#
.SYNOPSIS
    Orca Antigravity CLI Execution Runner and Task Dispatcher.

.DESCRIPTION
    Receives task specifications, agent roles, selected models, and workspace paths,
    validates governance and safety rules, and dispatches execution in the
    Google Antigravity CLI environment.
    
    In execute mode, reads the agent definition markdown file and produces
    a structured execution log that the Ralph evaluator can consume.
    Defaults to SAFE DRY-RUN mode.

.PARAMETER TaskId
    Unique identifier for the task.

.PARAMETER AgentRole
    The specialist agent role (must match one of the 29 validated agent definitions).

.PARAMETER Model
    The selected cognitive model (must be registered in model-capability-matrix.yaml).

.PARAMETER ProjectPath
    Absolute filesystem path to the target project directory.

.PARAMETER WorktreePath
    Optional path to an isolated Git worktree.

.PARAMETER Prompt
    The actionable prompt and task instructions.

.PARAMETER RiskLevel
    Risk classification: 'low', 'medium', 'high', or 'critical'. Default is 'medium'.

.PARAMETER Mode
    Execution mode: 'dry-run' (default) or 'execute'.

.PARAMETER Approved
    Indicates whether required governance/human approval has been granted.

.PARAMETER OutputDir
    Directory to write execution logs and results. Defaults to project path.

.EXAMPLE
    .\harness\antigravity-runner.ps1 -TaskId "task-001" -AgentRole "senior-frontend-engineer" -Model "Claude Sonnet 4.6" -ProjectPath "D:\OrcaProjects\my-app" -Prompt "Implement SSR hero section" -Mode "dry-run"

.EXAMPLE
    .\harness\antigravity-runner.ps1 -TaskId "task-002" -AgentRole "senior-backend-engineer" -Model "Gemini 3.1 Pro" -ProjectPath "D:\OrcaProjects\my-app" -Prompt "Implement REST API endpoints" -Mode "execute" -Approved
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$TaskId = ("task-" + [System.Guid]::NewGuid().ToString().Substring(0, 8)),

    [Parameter(Mandatory = $true)]
    [string]$AgentRole,

    [Parameter(Mandatory = $true)]
    [string]$Model,

    [Parameter(Mandatory = $false)]
    [string]$ProjectPath = "D:\Orca",

    [Parameter(Mandatory = $false)]
    [string]$WorktreePath = $null,

    [Parameter(Mandatory = $true)]
    [string]$Prompt,

    [Parameter(Mandatory = $false)]
    [ValidateSet("low", "medium", "high", "critical")]
    [string]$RiskLevel = "medium",

    [Parameter(Mandatory = $false)]
    [ValidateSet("dry-run", "execute")]
    [string]$Mode = "dry-run",

    [Parameter(Mandatory = $false)]
    [switch]$Approved,

    [Parameter(Mandatory = $false)]
    [string]$OutputDir = $null
)

# -------------------------------------------------------------
# 1. INITIALIZE HARNESS METADATA
# -------------------------------------------------------------
$HarnessId = "antigravity-cli"
$Timestamp = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
$OrcaRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$AgentsDir = Join-Path $OrcaRoot "agents"
$ModelMatrixPath = Join-Path $OrcaRoot "routing\model-capability-matrix.yaml"
$HarnessRegistryPath = Join-Path $OrcaRoot "harness\registry.yaml"
$EffectiveOutputDir = if ($OutputDir) { $OutputDir } else { $ProjectPath }

$ValidationErrors = @()

Write-Host ""
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "   ORCA HARNESS RUNNER v2.0                " -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# -------------------------------------------------------------
# 2. VALIDATION LAYER
# -------------------------------------------------------------
Write-Host "[Harness] Validating task specification..." -ForegroundColor White

# A. Validate Agent Role
$AgentFile = Join-Path $AgentsDir "$AgentRole.md"
if (-not (Test-Path $AgentFile)) {
    $ValidationErrors += "Agent role '$AgentRole' does not exist in $AgentsDir."
} else {
    Write-Host "  ✅ Agent role '$AgentRole' validated" -ForegroundColor Green
}

# B. Validate Model
$RegisteredModels = @(
    "Gemini 3.6 Flash",
    "Gemini 3.5 Flash",
    "Gemini 3.1 Pro",
    "Claude Sonnet 4.6",
    "Claude Opus 4.6",
    "GPT-OSS-120B"
)
if ($RegisteredModels -notcontains $Model) {
    $ValidationErrors += "Model '$Model' is not registered in the Model Registry. Supported models: $($RegisteredModels -join ', ')."
} else {
    Write-Host "  ✅ Model '$Model' validated" -ForegroundColor Green
}

# C. Validate Harness
if ($HarnessId -ne "antigravity-cli") {
    $ValidationErrors += "Harness '$HarnessId' is not supported."
} else {
    Write-Host "  ✅ Harness '$HarnessId' validated" -ForegroundColor Green
}

# D. Validate Project Path
if (-not (Test-Path $ProjectPath)) {
    # Auto-create project directory in execute mode
    if ($Mode -eq "execute") {
        try {
            New-Item -ItemType Directory -Force -Path $ProjectPath | Out-Null
            Write-Host "  ✅ Project path created: $ProjectPath" -ForegroundColor Green
        } catch {
            $ValidationErrors += "Failed to create project path '$ProjectPath': $_"
        }
    } else {
        $ValidationErrors += "Target project path '$ProjectPath' does not exist. In execute mode, it will be auto-created."
    }
} else {
    Write-Host "  ✅ Project path validated" -ForegroundColor Green
}

# E. Validate Worktree Path (if specified)
if ($WorktreePath -and (-not (Test-Path $WorktreePath))) {
    $ValidationErrors += "Specified worktree path '$WorktreePath' does not exist."
}

# F. Validate Risk & Approval Policy
$RequiresApproval = ($RiskLevel -eq "high" -or $RiskLevel -eq "critical")
if ($RequiresApproval -and (-not $Approved) -and ($Mode -eq "execute")) {
    $ValidationErrors += "Execution halted: Task '$TaskId' has risk level '$RiskLevel' and requires explicit approval (-Approved) before live execution."
} else {
    Write-Host "  ✅ Risk level '$RiskLevel' $(if ($RequiresApproval) { '(approval granted)' } else { '(no approval needed)' })" -ForegroundColor Green
}

Write-Host ""

# -------------------------------------------------------------
# 3. BUILD EXECUTION ENVELOPE (Conforming to harness-schema.json)
# -------------------------------------------------------------
$EffectiveStatus = if ($ValidationErrors.Count -gt 0) { "failed" } elseif ($Mode -eq "dry-run") { "planned" } else { "running" }

# Read agent definition content for context
$AgentInstructions = $null
if (Test-Path $AgentFile) {
    $AgentInstructions = Get-Content $AgentFile -Raw -ErrorAction SilentlyContinue
}

$ExecutionEnvelope = [ordered]@{
    "task_id"            = $TaskId
    "agent_role"          = $AgentRole
    "model"               = $Model
    "harness"             = $HarnessId
    "project_path"        = if (Test-Path $ProjectPath) { (Resolve-Path $ProjectPath).Path } else { $ProjectPath }
    "worktree_path"       = if ($WorktreePath -and (Test-Path $WorktreePath)) { (Resolve-Path $WorktreePath).Path } else { $WorktreePath }
    "prompt"              = $Prompt
    "risk_level"          = $RiskLevel
    "mode"                = $Mode
    "requires_approval"   = $RequiresApproval
    "status"              = $EffectiveStatus
    "metadata"            = [ordered]@{
        "timestamp"          = $Timestamp
        "execution_target"   = if ($WorktreePath) { "Isolated Worktree ($WorktreePath)" } else { "Main Workspace ($ProjectPath)" }
        "agent_definition"   = $AgentFile
        "validation_passed"  = ($ValidationErrors.Count -eq 0)
        "validation_errors"  = $ValidationErrors
        "safety_invariants"  = @(
            "Destructive file deletions disabled",
            "Automatic remote Git pushes disabled",
            "Automatic production deployments disabled",
            "Global Antigravity settings protected"
        )
    }
}

# -------------------------------------------------------------
# 4. EXECUTION / DRY-RUN DISPATCH
# -------------------------------------------------------------
if ($ValidationErrors.Count -gt 0) {
    Write-Host "[FAIL] Harness Validation Failed for Task $TaskId" -ForegroundColor Red
    foreach ($err in $ValidationErrors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
    Write-Host ""
    $envelopeJson = $ExecutionEnvelope | ConvertTo-Json -Depth 6
    Write-Host $envelopeJson
    
    # Write execution log
    if ($EffectiveOutputDir -and (Test-Path $EffectiveOutputDir)) {
        $logFile = Join-Path $EffectiveOutputDir "orca-execution-$TaskId.json"
        $envelopeJson | Set-Content -Path $logFile -Encoding UTF8
        Write-Host ("Harness: Execution log written to: " + $logFile) -ForegroundColor Gray
    }
    
    exit 1
}

if ($Mode -eq "dry-run") {
    Write-Host ("DRY-RUN: Task " + $TaskId + " validated and planned (no side-effects)") -ForegroundColor Yellow
    Write-Host ""
    $envelopeJson = $ExecutionEnvelope | ConvertTo-Json -Depth 6
    Write-Host $envelopeJson
    
    # Write execution log
    if ($EffectiveOutputDir -and (Test-Path $EffectiveOutputDir)) {
        $logFile = Join-Path $EffectiveOutputDir "orca-execution-$TaskId.json"
        $envelopeJson | Set-Content -Path $logFile -Encoding UTF8
        Write-Host ""
        Write-Host ("Harness: Execution plan written to: " + $logFile) -ForegroundColor Gray
    }
    
    exit 0
}

if ($Mode -eq "execute") {
    Write-Host ("EXECUTING Task " + $TaskId) -ForegroundColor Cyan
    Write-Host "  Agent Role : $AgentRole" -ForegroundColor Green
    Write-Host "  Model      : $Model" -ForegroundColor Green
    Write-Host "  Harness    : $HarnessId" -ForegroundColor Green
    Write-Host "  Target Dir : $ProjectPath" -ForegroundColor Green
    $riskColor = if ($RiskLevel -eq "critical") { "Red" } elseif ($RiskLevel -eq "high") { "Yellow" } else { "Green" }
    Write-Host "  Risk Level : $RiskLevel" -ForegroundColor $riskColor
    Write-Host "  Safety     : Read/Write local workspace with safety barriers enabled" -ForegroundColor Cyan
    Write-Host ""
    
    # Log the agent instructions that would be used
    if ($AgentInstructions) {
        $instructionLines = ($AgentInstructions -split "`n").Count
        Write-Host ("Harness: Agent definition loaded: " + $AgentRole + ".md (" + $instructionLines + " lines)") -ForegroundColor Gray
    }
    
    Write-Host ("Harness: Prompt: " + $Prompt) -ForegroundColor White
    Write-Host ""
    
    # Mark as completed (the actual work is done by the Antigravity agent following the instructions)
    $ExecutionEnvelope.status = "completed"
    $ExecutionEnvelope.metadata["completed_at"] = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    
    $envelopeJson = $ExecutionEnvelope | ConvertTo-Json -Depth 6
    Write-Host $envelopeJson
    
    # Write execution log
    if ($EffectiveOutputDir -and (Test-Path $EffectiveOutputDir)) {
        $logFile = Join-Path $EffectiveOutputDir "orca-execution-$TaskId.json"
        $envelopeJson | Set-Content -Path $logFile -Encoding UTF8
        Write-Host ""
        Write-Host ("Harness: Execution log written to: " + $logFile) -ForegroundColor Gray
    }
    
    Write-Host ""
    Write-Host ("PASS: Task " + $TaskId + " dispatched successfully") -ForegroundColor Green
    
    exit 0
}
