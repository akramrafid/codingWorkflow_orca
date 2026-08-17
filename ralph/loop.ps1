<#
.SYNOPSIS
  Orca Ralph Autonomous Execution Loop Harness

.DESCRIPTION
  Executes autonomous feedback loops across task queues, running verification commands,
  invoking evaluation gates, and handling retry limits and rollbacks.

.PARAMETER StateFile
  Path to the JSON state tracking file. Defaults to ./ralph-state.json.

.PARAMETER TaskFile
  Path to the task definition file. Defaults to ./tasks.json.

.PARAMETER MaxIterations
  Maximum safety iterations before halting.
#>

param (
    [string]$StateFile = ".\ralph-state.json",
    [string]$TaskFile = ".\tasks.json",
    [int]$MaxIterations = 30
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   ORCA RALPH AUTONOMOUS ENGINE (v1.0)   " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# 1. Initialize or Load State
if (-not (Test-Path $StateFile)) {
    $initialState = @{
        session_id = [Guid]::NewGuid().ToString()
        project_name = (Get-Item .).Name
        status = "INITIALIZING"
        current_iteration = 0
        max_iterations = $MaxIterations
        active_task_id = $null
        completed_tasks = @()
        failed_tasks = @()
        retry_counts = @{}
        git_head_commit = (git rev-parse HEAD 2>$null)
    }
    $initialState | ConvertTo-Json -Depth 5 | Set-Content -Path $StateFile -Encoding UTF8
    Write-Host "[Ralph] Initialized state file at $StateFile" -ForegroundColor Green
}

$state = Get-Content $StateFile -Raw | ConvertFrom-Json

# Check if tasks file exists
if (-not (Test-Path $TaskFile)) {
    Write-Host "[Ralph] No tasks file found at $TaskFile. Awaiting task generation from Requirement Analyzer." -ForegroundColor Yellow
    exit 0
}

$tasks = Get-Content $TaskFile -Raw | ConvertFrom-Json

Write-Host "[Ralph] Loaded $($tasks.Count) tasks. Current status: $($state.status)" -ForegroundColor White

# 2. Main Autonomous Loop
while ($state.current_iteration -lt $state.max_iterations) {
    $state.current_iteration++
    Write-Host "`n--- Iteration $($state.current_iteration) / $($state.max_iterations) ---" -ForegroundColor Magenta

    # Find next pending task whose dependencies are satisfied
    $pendingTask = $null
    foreach ($task in $tasks) {
        if ($state.completed_tasks -contains $task.task_id) { continue }
        if ($state.failed_tasks -contains $task.task_id) { continue }

        $depsSatisfied = $true
        foreach ($dep in $task.dependencies) {
            if ($state.completed_tasks -notcontains $dep) {
                $depsSatisfied = $false
                break
            }
        }

        if ($depsSatisfied) {
            $pendingTask = $task
            break
        }
    }

    if ($null -eq $pendingTask) {
        Write-Host "[Ralph] All executable tasks completed or pending external resolution." -ForegroundColor Green
        $state.status = "COMPLETED"
        $state | ConvertTo-Json -Depth 5 | Set-Content -Path $StateFile -Encoding UTF8
        break
    }

    Write-Host "[Ralph] Executing Task: $($pendingTask.task_id) - $($pendingTask.title)" -ForegroundColor Yellow
    Write-Host "[Ralph] Assigned Agent: $($pendingTask.assigned_agent)" -ForegroundColor Gray
    $state.active_task_id = $pendingTask.task_id
    $state.status = "IN_PROGRESS"

    # Run Verification Commands
    $allPassed = $true
    foreach ($cmd in $pendingTask.verification_commands) {
        Write-Host "[Ralph Verify] Running: $cmd" -ForegroundColor Gray
        try {
            Invoke-Expression $cmd
            if ($LASTEXITCODE -ne 0) {
                Write-Host "[Ralph Verify] Command failed with exit code $LASTEXITCODE" -ForegroundColor Red
                $allPassed = $false
                break
            }
        }
        catch {
            Write-Host "[Ralph Verify] Error executing command: $_" -ForegroundColor Red
            $allPassed = $false
            break
        }
    }

    # Evaluate results
    if ($allPassed) {
        Write-Host "[Ralph Evaluator] Task $($pendingTask.task_id) PASSED verification." -ForegroundColor Green
        $state.completed_tasks += $pendingTask.task_id
        $state.active_task_id = $null
    } else {
        $taskRetryCount = 0
        if ($state.retry_counts.PSObject.Properties[$pendingTask.task_id]) {
            $taskRetryCount = [int]$state.retry_counts.$($pendingTask.task_id)
        }
        $taskRetryCount++
        $state.retry_counts | Add-Member -NotePropertyName $pendingTask.task_id -NotePropertyValue $taskRetryCount -Force

        Write-Host "[Ralph Evaluator] Task $($pendingTask.task_id) FAILED (Attempt $taskRetryCount/3)." -ForegroundColor Red
        if ($taskRetryCount -ge 3) {
            Write-Host "[Ralph Circuit Breaker] Task exceeded 3 retries. Marking FAILED." -ForegroundColor Red
            $state.failed_tasks += $pendingTask.task_id
            $state.active_task_id = $null
        }
    }

    # Save state
    $state.git_head_commit = (git rev-parse HEAD 2>$null)
    $state | ConvertTo-Json -Depth 5 | Set-Content -Path $StateFile -Encoding UTF8
}

Write-Host "`n[Ralph] Loop execution ended with status: $($state.status)" -ForegroundColor Cyan
