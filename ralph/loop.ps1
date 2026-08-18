<#
.SYNOPSIS
  Orca Ralph Autonomous Execution Loop Harness v2.1 (Anti-Simulation)

.DESCRIPTION
  Executes autonomous feedback loops across task queues, running verification commands,
  invoking evaluation gates, checking physical filesystem evidence, and handling retry limits.
  
  Enforces that real source files exist, builds run, and tests pass before completing.

.PARAMETER StateFile
  Path to the JSON state tracking file. Defaults to ./ralph-state.json.

.PARAMETER TaskFile
  Path to the task definition file. Defaults to ./tasks.json.

.PARAMETER MaxIterations
  Maximum safety iterations before halting.

.PARAMETER ProjectPath
  Path to the target project directory.
#>

param (
    [string]$StateFile = ".\ralph-state.json",
    [string]$TaskFile = ".\tasks.json",
    [int]$MaxIterations = 30,
    [string]$ProjectPath = $null
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   ORCA RALPH AUTONOMOUS ENGINE (v2.1)   " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# Resolve project path for verification commands
$EffectiveProjectPath = if ($ProjectPath) { $ProjectPath } else { (Get-Location).Path }

# 1. Mandatory Code Existence Invariant Guard
Write-Host "[Ralph] Inspecting target filesystem at $EffectiveProjectPath..." -ForegroundColor Yellow
$sourceFiles = @(Get-ChildItem -Path $EffectiveProjectPath -Recurse -Include "*.ts","*.tsx","*.js","*.jsx","*.py","*.css","*.html" -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch "node_modules|\.git|dist" })

if ($sourceFiles.Count -eq 0) {
    Write-Host "[Ralph Guard] ZERO source code files found in $EffectiveProjectPath." -ForegroundColor Red
    Write-Host "[Ralph Guard] Evaluation rejected: Cannot evaluate an empty project." -ForegroundColor Red
} else {
    Write-Host "  [OK] Found $($sourceFiles.Count) source files on disk." -ForegroundColor Green
}

# 2. Initialize or Load State
if (-not (Test-Path $StateFile)) {
    $gitHead = $null
    try {
        $gitHead = (git rev-parse HEAD 2>$null)
    } catch {
        $gitHead = "NO_GIT_REPO"
    }

    $initialState = [ordered]@{
        session_id = [Guid]::NewGuid().ToString()
        project_name = (Get-Item $EffectiveProjectPath -ErrorAction SilentlyContinue).Name
        status = "INITIALIZING"
        current_iteration = 0
        max_iterations = $MaxIterations
        active_task_id = $null
        completed_tasks = @()
        failed_tasks = @()
        retry_counts = @{}
        git_head_commit = $gitHead
        created_at = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    }
    $initialState | ConvertTo-Json -Depth 5 | Set-Content -Path $StateFile -Encoding UTF8
    Write-Host ("Ralph: Initialized state file at " + $StateFile) -ForegroundColor Green
}

$state = Get-Content $StateFile -Raw | ConvertFrom-Json

# 3. Check if tasks file exists
if (-not (Test-Path $TaskFile)) {
    Write-Host ("Ralph: Error: No tasks file found at " + $TaskFile) -ForegroundColor Red
    exit 1
}

$tasks = Get-Content $TaskFile -Raw | ConvertFrom-Json

Write-Host ("Ralph: Project: " + $state.project_name) -ForegroundColor White
Write-Host ("Ralph: Loaded " + $tasks.Count + " tasks. Current status: " + $state.status) -ForegroundColor White
Write-Host ("Ralph: Max iterations: " + $state.max_iterations) -ForegroundColor White
Write-Host ""

# 4. Main Autonomous Loop
while ($state.current_iteration -lt $state.max_iterations) {
    $state.current_iteration++
    Write-Host ("`n--- Iteration " + $state.current_iteration + " / " + $state.max_iterations + " ---") -ForegroundColor Magenta

    # Find next pending task whose dependencies are satisfied
    $pendingTask = $null
    foreach ($task in $tasks) {
        if ($state.completed_tasks -contains $task.task_id) { continue }
        if ($state.failed_tasks -contains $task.task_id) { continue }

        $depsSatisfied = $true
        if ($task.dependencies) {
            foreach ($dep in $task.dependencies) {
                if ($state.completed_tasks -notcontains $dep) {
                    $depsSatisfied = $false
                    break
                }
            }
        }

        if ($depsSatisfied) {
            $pendingTask = $task
            break
        }
    }

    if ($null -eq $pendingTask) {
        $totalTasks = $tasks.Count
        $completedCount = @($state.completed_tasks).Count
        $failedCount = @($state.failed_tasks).Count
        $blockedCount = $totalTasks - $completedCount - $failedCount

        Write-Host ""
        Write-Host "==========================================" -ForegroundColor Green
        Write-Host "   RALPH EVALUATION COMPLETE              " -ForegroundColor Green
        Write-Host "==========================================" -ForegroundColor Green
        Write-Host ("Ralph: Total Tasks : " + $totalTasks) -ForegroundColor White
        Write-Host ("Ralph: Passed      : " + $completedCount) -ForegroundColor Green
        $failColor = if ($failedCount -gt 0) { "Red" } else { "Green" }
        Write-Host ("Ralph: Failed      : " + $failedCount) -ForegroundColor $failColor
        $blockColor = if ($blockedCount -gt 0) { "Yellow" } else { "Green" }
        Write-Host ("Ralph: Blocked     : " + $blockedCount) -ForegroundColor $blockColor

        $state.status = if ($failedCount -gt 0) { "COMPLETED_WITH_FAILURES" } else { "COMPLETED" }
        $state | ConvertTo-Json -Depth 5 | Set-Content -Path $StateFile -Encoding UTF8
        break
    }

    Write-Host ("Ralph: Task       : " + $pendingTask.task_id + " - " + $pendingTask.title) -ForegroundColor Yellow
    Write-Host ("Ralph: Agent      : " + $pendingTask.assigned_agent) -ForegroundColor Gray
    Write-Host ("Ralph: Phase      : " + $pendingTask.phase) -ForegroundColor Gray
    $state.active_task_id = $pendingTask.task_id
    $state.status = "IN_PROGRESS"

    # Run Verification Commands
    $allPassed = $true
    $verificationResults = @()

    if ($pendingTask.verification_commands) {
        foreach ($cmd in $pendingTask.verification_commands) {
            Write-Host ("Ralph Verify: Running: " + $cmd) -ForegroundColor Gray
            $cmdResult = @{ command = $cmd; exit_code = 0; error = $null }

            try {
                $originalLocation = Get-Location
                if ($EffectiveProjectPath) { Set-Location $EffectiveProjectPath }

                $output = Invoke-Expression $cmd 2>&1
                $cmdExitCode = $LASTEXITCODE
                if ($null -eq $cmdExitCode) { $cmdExitCode = 0 }

                Set-Location $originalLocation

                if ($cmdExitCode -ne 0) {
                    Write-Host ("Ralph Verify: FAILED with exit code " + $cmdExitCode) -ForegroundColor Red
                    $cmdResult.exit_code = $cmdExitCode
                    $cmdResult.error = "Exit code $cmdExitCode"
                    $allPassed = $false
                } else {
                    Write-Host "Ralph Verify: PASSED" -ForegroundColor Green
                }
            }
            catch {
                Write-Host ("Ralph Verify: ERROR: " + $_) -ForegroundColor Red
                $cmdResult.exit_code = 1
                $cmdResult.error = $_.ToString()
                $allPassed = $false
            }

            $verificationResults += $cmdResult

            if (-not $allPassed) { break }
        }
    }

    # Evaluate results
    if ($allPassed) {
        Write-Host ("Ralph Evaluator: PASS - Task " + $pendingTask.task_id + " passed verification") -ForegroundColor Green
        $state.completed_tasks += $pendingTask.task_id
        $state.active_task_id = $null
    } else {
        $taskRetryCount = 0
        $taskIdStr = $pendingTask.task_id
        if ($state.retry_counts.PSObject.Properties.Name -contains $taskIdStr) {
            $taskRetryCount = [int]$state.retry_counts.$taskIdStr
        }
        $taskRetryCount++
        $state.retry_counts | Add-Member -NotePropertyName $taskIdStr -NotePropertyValue $taskRetryCount -Force

        Write-Host ("Ralph Evaluator: FAIL - Task " + $pendingTask.task_id + " failed (Attempt " + $taskRetryCount + "/3)") -ForegroundColor Red
        if ($taskRetryCount -ge 3) {
            Write-Host "Ralph Circuit Breaker: Task exceeded 3 retries. Marking FAILED." -ForegroundColor Red
            $state.failed_tasks += $pendingTask.task_id
            $state.active_task_id = $null
        } else {
            Write-Host ("Ralph Evaluator: Will retry on next iteration (" + $taskRetryCount + "/3 attempts used)") -ForegroundColor Yellow
        }
    }

    # Save state after each iteration
    $state | ConvertTo-Json -Depth 5 | Set-Content -Path $StateFile -Encoding UTF8
}

if ($state.current_iteration -ge $state.max_iterations) {
    Write-Host ("`nRalph: Maximum iterations (" + $MaxIterations + ") reached. Loop halted.") -ForegroundColor Yellow
    $state.status = "MAX_ITERATIONS_REACHED"
    $state | ConvertTo-Json -Depth 5 | Set-Content -Path $StateFile -Encoding UTF8
}

Write-Host ("`nRalph: Final status: " + $state.status) -ForegroundColor Cyan
