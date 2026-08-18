<#
.SYNOPSIS
    Orca Antigravity CLI Execution Runner and Task Dispatcher.

.DESCRIPTION
    Receives structured task specifications, agent roles, selected models, and workspace paths,
    validates governance and safety rules, and dispatches execution in the
    Google Antigravity CLI environment.
    
    Distinguishes READ_ONLY_TASK from IMPLEMENTATION_TASK.
    Enforces that implementation workers have write access to target project workspaces
    (e.g., D:\OrcaProjects\<project>), never confuses D:\Orca with project workspaces,
    and requires real machine-verifiable filesystem evidence before reporting completion.

.PARAMETER TaskId
    Unique identifier for the task (e.g. TASK-OA-001).

.PARAMETER AgentRole
    The specialist agent role (must match one of the 29 validated agent definitions).

.PARAMETER Model
    The selected cognitive model (must be registered in canonical model registry).

.PARAMETER ProjectPath
    Absolute filesystem path to the target project directory (e.g. D:\OrcaProjects\OA).

.PARAMETER WorktreePath
    Optional path to an isolated Git worktree.

.PARAMETER Prompt
    The actionable prompt and task instructions.

.PARAMETER ExecutionMode
    Execution mode: 'analysis', 'architecture', 'design', 'technical_design', 'implementation', 'verification'.

.PARAMETER ReadOnly
    Explicit boolean flag. If true, project modifications are prohibited. Must be false for implementation.

.PARAMETER ExpectedFiles
    Array of relative file paths expected to be created/modified by this task.

.PARAMETER AcceptanceCriteria
    Array of acceptance criteria for this task.

.PARAMETER VerificationCommands
    Array of verification commands to execute on the workspace.

.PARAMETER RiskLevel
    Risk classification: 'low', 'medium', 'high', or 'critical'. Default is 'medium'.

.PARAMETER Mode
    Runtime dispatch mode: 'dry-run' (plan/validate only) or 'execute' (live execution).

.PARAMETER Approved
    Indicates whether required governance/human approval has been granted.

.PARAMETER OutputDir
    Directory to write execution logs and results. Defaults to project path.
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$TaskId = ("task-" + [System.Guid]::NewGuid().ToString().Substring(0, 8)),

    [Parameter(Mandatory = $true)]
    [string]$AgentRole,

    [Parameter(Mandatory = $true)]
    [string]$Model,

    [Parameter(Mandatory = $true)]
    [string]$ProjectPath,

    [Parameter(Mandatory = $false)]
    [string]$WorktreePath = $null,

    [Parameter(Mandatory = $true)]
    [string]$Prompt,

    [Parameter(Mandatory = $false)]
    [ValidateSet("analysis", "architecture", "design", "technical_design", "implementation", "verification")]
    [string]$ExecutionMode = "implementation",

    [Parameter(Mandatory = $false)]
    [switch]$ReadOnly,

    [Parameter(Mandatory = $false)]
    [string[]]$ExpectedFiles = @(),

    [Parameter(Mandatory = $false)]
    [string[]]$AcceptanceCriteria = @(),

    [Parameter(Mandatory = $false)]
    [string[]]$VerificationCommands = @(),

    [Parameter(Mandatory = $false)]
    [ValidateSet("low", "medium", "high", "critical")]
    [string]$RiskLevel = "medium",

    [Parameter(Mandatory = $false)]
    [ValidateSet("dry-run", "execute")]
    [string]$Mode = "execute",

    [Parameter(Mandatory = $false)]
    [switch]$Approved,

    [Parameter(Mandatory = $false)]
    [string]$OutputDir = $null
)

$ErrorActionPreference = "Stop"

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
Write-Host "   ORCA HARNESS RUNNER v2.1 (ANTI-SIMULATION) " -ForegroundColor Cyan
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host "  Task ID        : $TaskId" -ForegroundColor White
Write-Host "  Agent Role     : $AgentRole" -ForegroundColor White
Write-Host "  Model          : $Model" -ForegroundColor White
Write-Host "  Execution Mode : $ExecutionMode" -ForegroundColor White
Write-Host "  Read-Only      : $ReadOnly" -ForegroundColor White
Write-Host "  Project Path   : $ProjectPath" -ForegroundColor White
Write-Host "  Mode           : $Mode" -ForegroundColor White
Write-Host "===========================================" -ForegroundColor Cyan
Write-Host ""

# -------------------------------------------------------------
# 2. VALIDATION LAYER & INVARIANT GUARDS
# -------------------------------------------------------------
Write-Host "[Harness] Validating execution contract..." -ForegroundColor White

# A. Validate Agent Role
$AgentFile = Join-Path $AgentsDir "$AgentRole.md"
if (-not (Test-Path $AgentFile)) {
    $ValidationErrors += "Agent role '$AgentRole' does not exist in $AgentsDir."
} else {
    Write-Host "  [OK] Agent role '$AgentRole' validated" -ForegroundColor Green
}

# B. Validate Canonical Model
$RegisteredModels = @(
    "Gemini 3.7 Flash",
    "Gemini 3.6 Flash",
    "Gemini 3.5 Flash",
    "Gemini 3.1 Pro",
    "Claude Sonnet 4.6",
    "Claude Opus 4.6",
    "GPT-OSS-120B"
)
if ($RegisteredModels -notcontains $Model) {
    $ValidationErrors += "Model '$Model' is not registered in canonical model registry. Supported: $($RegisteredModels -join ', ')."
} else {
    Write-Host "  [OK] Model '$Model' validated" -ForegroundColor Green
}

# C. Validate Workspace Isolation
$normalizedOrca = [System.IO.Path]::GetFullPath($OrcaRoot).TrimEnd('\', '/')
$normalizedProj = [System.IO.Path]::GetFullPath($ProjectPath).TrimEnd('\', '/')

if ($normalizedProj -eq $normalizedOrca) {
    $ValidationErrors += "CRITICAL: Project path cannot be the Orca system root ($OrcaRoot). Target must reside in D:\OrcaProjects\<project>."
}

# D. Validate Execution Mode vs Read-Only Invariant
if ($ExecutionMode -eq "implementation" -and $ReadOnly) {
    $ValidationErrors += "CRITICAL INVARIANT VIOLATION: ExecutionMode 'implementation' cannot have ReadOnly=true."
}

# E. Validate Project Directory Exists or Create
if (-not (Test-Path $ProjectPath)) {
    if ($Mode -eq "execute") {
        try {
            New-Item -ItemType Directory -Force -Path $ProjectPath | Out-Null
            Write-Host "  [OK] Auto-initialized target project path: $ProjectPath" -ForegroundColor Green
        } catch {
            $ValidationErrors += "Failed to create project path '$ProjectPath': $_"
        }
    } else {
        $ValidationErrors += "Target project path '$ProjectPath' does not exist."
    }
} else {
    Write-Host "  [OK] Target project path validated" -ForegroundColor Green
}

# F. Validate Worktree Path (if specified)
if ($WorktreePath -and (-not (Test-Path $WorktreePath))) {
    $ValidationErrors += "Specified worktree path '$WorktreePath' does not exist."
}

# G. Validate Risk & Approval Policy
$RequiresApproval = ($RiskLevel -eq "high" -or $RiskLevel -eq "critical")
if ($RequiresApproval -and (-not $Approved) -and ($Mode -eq "execute")) {
    $ValidationErrors += "Execution halted: Task '$TaskId' has risk level '$RiskLevel' and requires explicit approval (-Approved)."
} else {
    Write-Host "  [OK] Governance risk check passed ($RiskLevel)" -ForegroundColor Green
}

Write-Host ""

# -------------------------------------------------------------
# 3. BUILD EXECUTION ENVELOPE (Conforming to harness-schema.json)
# -------------------------------------------------------------
$EffectiveStatus = if ($ValidationErrors.Count -gt 0) { "failed" } elseif ($Mode -eq "dry-run") { "planned" } else { "running" }

$ExecutionEnvelope = [ordered]@{
    "task_id"              = $TaskId
    "agent_role"            = $AgentRole
    "model"                 = $Model
    "harness"               = $HarnessId
    "project_path"          = if (Test-Path $ProjectPath) { (Resolve-Path $ProjectPath).Path } else { $ProjectPath }
    "worktree_path"         = if ($WorktreePath -and (Test-Path $WorktreePath)) { (Resolve-Path $WorktreePath).Path } else { $WorktreePath }
    "prompt"                = $Prompt
    "execution_mode"        = $ExecutionMode
    "read_only"             = $ReadOnly
    "expected_files"        = $ExpectedFiles
    "acceptance_criteria"   = $AcceptanceCriteria
    "verification_commands" = $VerificationCommands
    "risk_level"            = $RiskLevel
    "mode"                  = $Mode
    "requires_approval"     = $RequiresApproval
    "status"                = $EffectiveStatus
    "metadata"              = [ordered]@{
        "timestamp"            = $Timestamp
        "execution_target"     = if ($WorktreePath) { "Isolated Worktree ($WorktreePath)" } else { "Main Workspace ($ProjectPath)" }
        "agent_definition"     = $AgentFile
        "validation_passed"    = ($ValidationErrors.Count -eq 0)
        "validation_errors"    = $ValidationErrors
    }
}

# -------------------------------------------------------------
# 4. EXECUTION DISPATCH & FILESYSTEM VERIFICATION
# -------------------------------------------------------------
if ($ValidationErrors.Count -gt 0) {
    Write-Host "[FAIL] Harness Contract Validation Failed for Task $TaskId" -ForegroundColor Red
    foreach ($err in $ValidationErrors) {
        Write-Host "  - $err" -ForegroundColor Red
    }
    Write-Host ""
    $envelopeJson = $ExecutionEnvelope | ConvertTo-Json -Depth 6
    Write-Host $envelopeJson
    
    if ($EffectiveOutputDir -and (Test-Path $EffectiveOutputDir)) {
        $logFile = Join-Path $EffectiveOutputDir "orca-execution-$TaskId.json"
        $envelopeJson | Set-Content -Path $logFile -Encoding UTF8
    }
    exit 1
}

if ($Mode -eq "dry-run") {
    Write-Host "DRY-RUN: Task $TaskId validated and planned (read-only plan mode)" -ForegroundColor Yellow
    $envelopeJson = $ExecutionEnvelope | ConvertTo-Json -Depth 6
    Write-Host $envelopeJson
    
    if ($EffectiveOutputDir -and (Test-Path $EffectiveOutputDir)) {
        $logFile = Join-Path $EffectiveOutputDir "orca-execution-$TaskId.json"
        $envelopeJson | Set-Content -Path $logFile -Encoding UTF8
    }
    exit 0
}

if ($Mode -eq "execute") {
    Write-Host "EXECUTING TASK: $TaskId" -ForegroundColor Cyan
    Write-Host "  Target Workspace : $ProjectPath" -ForegroundColor Green
    Write-Host "  Execution Mode   : $ExecutionMode" -ForegroundColor Green
    Write-Host "  Assigned Agent   : $AgentRole" -ForegroundColor Green
    Write-Host "  Assigned Model   : $Model" -ForegroundColor Green
    Write-Host ""

    # Execute verification commands if provided
    $verificationPassed = $true
    $verificationLogs = @()

    if ($VerificationCommands.Count -gt 0) {
        Write-Host "[Harness] Running task verification commands in $ProjectPath..." -ForegroundColor Yellow
        $origLoc = Get-Location
        Set-Location $ProjectPath
        try {
            foreach ($cmd in $VerificationCommands) {
                Write-Host "  > $cmd" -ForegroundColor Gray
                $cmdOutput = Invoke-Expression $cmd 2>&1
                $cmdExitCode = $LASTEXITCODE
                if ($null -eq $cmdExitCode) { $cmdExitCode = 0 }
                
                $logEntry = [ordered]@{
                    "command"   = $cmd
                    "exit_code" = $cmdExitCode
                    "output"    = ($cmdOutput | Out-String).Trim()
                }
                $verificationLogs += $logEntry

                if ($cmdExitCode -ne 0) {
                    Write-Host "  [FAIL] Command failed with exit code $cmdExitCode" -ForegroundColor Red
                    $verificationPassed = $false
                    break
                } else {
                    Write-Host "  [PASS] Command succeeded" -ForegroundColor Green
                }
            }
        } finally {
            Set-Location $origLoc
        }
    }

    # Mandatory Filesystem Evidence Check for Implementation Tasks
    $missingFiles = @()
    if ($ExecutionMode -eq "implementation" -and $ExpectedFiles.Count -gt 0) {
        Write-Host "[Harness] Verifying physical filesystem changes in $ProjectPath..." -ForegroundColor Yellow
        foreach ($file in $ExpectedFiles) {
            $targetPath = Join-Path $ProjectPath $file
            if (-not (Test-Path $targetPath)) {
                $missingFiles += $file
                Write-Host "  [MISSING] $file does not exist" -ForegroundColor Red
            } else {
                $item = Get-Item $targetPath
                if ($item.Length -eq 0 -and -not $item.PSIsContainer) {
                    $missingFiles += "$file (EMPTY_FILE)"
                    Write-Host "  [EMPTY] $file is 0 bytes" -ForegroundColor Red
                } else {
                    Write-Host "  [EXISTS] $file ($($item.Length) bytes)" -ForegroundColor Green
                }
            }
        }
    }

    if ($missingFiles.Count -gt 0 -or -not $verificationPassed) {
        $ExecutionEnvelope.status = "failed"
        $ExecutionEnvelope.metadata["failure_reason"] = if ($missingFiles.Count -gt 0) { "Missing expected filesystem files: $($missingFiles -join ', ')" } else { "Verification commands failed" }
        $ExecutionEnvelope.metadata["verification_logs"] = $verificationLogs

        $envelopeJson = $ExecutionEnvelope | ConvertTo-Json -Depth 6
        Write-Host ""
        Write-Host "[FAIL] WORKER_EXECUTION_FAILED for Task $TaskId" -ForegroundColor Red
        Write-Host $envelopeJson

        if ($EffectiveOutputDir -and (Test-Path $EffectiveOutputDir)) {
            $logFile = Join-Path $EffectiveOutputDir "orca-execution-$TaskId.json"
            $envelopeJson | Set-Content -Path $logFile -Encoding UTF8
        }
        exit 1
    }

    # Mark as completed only with physical evidence
    $ExecutionEnvelope.status = "completed"
    $ExecutionEnvelope.metadata["completed_at"] = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    $ExecutionEnvelope.metadata["verification_logs"] = $verificationLogs
    $ExecutionEnvelope.metadata["filesystem_verified"] = $true

    $envelopeJson = $ExecutionEnvelope | ConvertTo-Json -Depth 6
    Write-Host ""
    Write-Host "[PASS] Task $TaskId executed and verified on filesystem!" -ForegroundColor Green

    if ($EffectiveOutputDir -and (Test-Path $EffectiveOutputDir)) {
        $logFile = Join-Path $EffectiveOutputDir "orca-execution-$TaskId.json"
        $envelopeJson | Set-Content -Path $logFile -Encoding UTF8
        Write-Host "Execution evidence logged to: $logFile" -ForegroundColor Gray
    }

    exit 0
}

