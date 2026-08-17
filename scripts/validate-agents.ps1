<#
.SYNOPSIS
  Validate Orca Agent Definitions

.DESCRIPTION
  Scans all markdown files in agents/ to ensure YAML frontmatter, naming,
  subagent flag, and required sections adhere to AGENT_RULES.md.
#>

param (
    [string]$AgentsDir = "$PSScriptRoot\..\agents"
)

$ErrorActionPreference = "Stop"
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "      ORCA AGENT VALIDATION ENGINE        " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

$agentFiles = Get-ChildItem -Path $AgentsDir -Filter "*.md"
$totalCount = $agentFiles.Count
$passedCount = 0
$failedCount = 0

Write-Host "Discovered $totalCount agent definitions in $AgentsDir`n" -ForegroundColor White

foreach ($file in $agentFiles) {
    $content = Get-Content -Path $file.FullName -Raw
    $errors = @()

    # 1. Frontmatter check
    if ($content -notmatch "^---\r?\n([\s\S]*?)\r?\n---") {
        $errors += "Missing YAML frontmatter (--- delimiters)"
    } else {
        $frontmatter = $matches[1]
        if ($frontmatter -notmatch "name:\s*([a-zA-Z0-9_-]+)") {
            $errors += "Missing 'name:' in frontmatter"
        }
        if ($frontmatter -notmatch "description:\s*(.+)") {
            $errors += "Missing 'description:' in frontmatter"
        }
        if ($frontmatter -notmatch "subagent:\s*true") {
            $errors += "Missing or invalid 'subagent: true' in frontmatter"
        }
    }

    # 2. Section check
    if ($content -notmatch "#\s+") {
        $errors += "Missing top-level H1 header"
    }
    if ($content -notmatch "##\s+Responsibilities") {
        $errors += "Missing '## Responsibilities' section"
    }
    if ($content -notmatch "##\s+Authority Boundaries") {
        $errors += "Missing '## Authority Boundaries' section"
    }

    if ($errors.Count -eq 0) {
        Write-Host "[PASS] $($file.Name)" -ForegroundColor Green
        $passedCount++
    } else {
        Write-Host "[FAIL] $($file.Name): $($errors -join ', ')" -ForegroundColor Red
        $failedCount++
    }
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "Validation Summary: $passedCount PASSED, $failedCount FAILED (Total: $totalCount)" -ForegroundColor $(if ($failedCount -eq 0) { "Green" } else { "Red" })
Write-Host "==========================================" -ForegroundColor Cyan

if ($failedCount -gt 0) {
    exit 1
}
