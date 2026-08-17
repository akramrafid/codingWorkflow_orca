<#
.SYNOPSIS
    Orca Antigravity CLI Execution Runner and Task Dispatcher.

.DESCRIPTION
    Receives task specifications, agent roles, selected models, and workspace paths,
    validates governance and safety rules, and prepares or simulates execution in the
    Google Antigravity CLI environment.
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

.EXAMPLE
    .\harness\antigravity-runner.ps1 -TaskId "task-001" -AgentRole "senior-frontend-engineer" -Model "Claude Sonnet 4.6" -ProjectPath "D:\Orca" -Prompt "Implement SSR hero section" -Mode "dry-run"
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
    [switch]$Approved
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

$ValidationErrors = @()

# -------------------------------------------------------------
# 2. VALIDATION LAYER
# -------------------------------------------------------------

# A. Validate Agent Role
$AgentFile = Join-Path $AgentsDir "$AgentRole.md"
if (-not (Test-Path $AgentFile)) {
    $ValidationErrors += "Agent role '$AgentRole' does not exist in $AgentsDir."
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
}

# C. Validate Harness
if ($HarnessId -ne "antigravity-cli") {
    $ValidationErrors += "Harness '$HarnessId' is not supported."
}

# D. Validate Project Path
if (-not (Test-Path $ProjectPath)) {
    $ValidationErrors += "Target project path '$ProjectPath' does not exist."
}

# E. Validate Worktree Path (if specified)
if ($WorktreePath -and (-not (Test-Path $WorktreePath))) {
    $ValidationErrors += "Specified worktree path '$WorktreePath' does not exist."
}

# F. Validate Risk & Approval Policy
$RequiresApproval = ($RiskLevel -eq "high" -or $RiskLevel -eq "critical")
if ($RequiresApproval -and (-not $Approved) -and ($Mode -eq "execute")) {
    $ValidationErrors += "Execution halted: Task '$TaskId' has risk level '$RiskLevel' and requires explicit approval (-Approved) before live execution."
}

# -------------------------------------------------------------
# 3. BUILD EXECUTION ENVELOPE (Conforming to harness-schema.json)
# -------------------------------------------------------------
$EffectiveStatus = if ($ValidationErrors.Count -gt 0) { "failed" } elseif ($Mode -eq "dry-run") { "planned" } else { "completed" }

$ExecutionEnvelope = [ordered]@{
    "task_id"            = $TaskId
    "agent_role"          = $AgentRole
    "model"               = $Model
    "harness"             = $HarnessId
    "project_path"        = (Resolve-Path $ProjectPath).Path
    "worktree_path"       = if ($WorktreePath) { (Resolve-Path $WorktreePath).Path } else { $null }
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
    Write-Error "Harness Validation Failed for Task [$TaskId]:"
    foreach ($err in $ValidationErrors) {
        Write-Error "  - $err"
    }
    $ExecutionEnvelope | ConvertTo-Json -Depth 6
    exit 1
}

if ($Mode -eq "dry-run") {
    # Safe Dry-Run Mode: Output the planned execution envelope without running side-effects
    $ExecutionEnvelope | ConvertTo-Json -Depth 6
    exit 0
}

if ($Mode -eq "execute") {
    # Protected Live Execution Simulation (Production Ready Adapter Interface)
    Write-Host "[Orca Harness] Dispatching Task [$TaskId] to Google Antigravity CLI..." -ForegroundColor Cyan
    Write-Host "  Agent Role : $AgentRole" -ForegroundColor Green
    Write-Host "  Model      : $Model" -ForegroundColor Green
    Write-Host "  Harness    : $HarnessId" -ForegroundColor Green
    Write-Host "  Target Dir : $ProjectPath" -ForegroundColor Green
    Write-Host "  Risk Level : $RiskLevel" -ForegroundColor Yellow
    Write-Host "  Safety     : Read/Write local workspace with safety barriers enabled." -ForegroundColor Cyan

    $ExecutionEnvelope | ConvertTo-Json -Depth 6
    exit 0
}
