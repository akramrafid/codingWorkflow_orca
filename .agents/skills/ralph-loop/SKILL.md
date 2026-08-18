---
name: ralph-loop
description: Ralph autonomous evaluation loop integration skill for the Orca Agent Operating System. Auto-generates tasks.json from the team plan, runs verification commands, evaluates against the 27-point rubric, and handles retry logic with circuit breakers. Use this skill during Phase 6 of the Orca lifecycle.
---

# Orca Ralph Loop — Autonomous Evaluation & Verification

This skill integrates the Ralph autonomous evaluation loop into the Orca lifecycle. It bridges the gap between implementation (Phase 4-5) and deployment (Phase 7) by providing evidence-based task verification.

## When to Use

Use this skill during **Phase 6** after implementation and initial verification are complete.

## Reference Documents

- [ralph/evaluator.md](file:///d:/Orca/ralph/evaluator.md) — 27-point evaluation rubric
- [ralph/policies.md](file:///d:/Orca/ralph/policies.md) — Circuit breaker and retry policies
- [ralph/state-schema.json](file:///d:/Orca/ralph/state-schema.json) — State tracking schema
- [ralph/task-schema.json](file:///d:/Orca/ralph/task-schema.json) — Task definition schema

---

## Step 1: Generate tasks.json

Transform the team plan and implementation results into a `tasks.json` file that the Ralph loop can process.

### Task Generation Algorithm

For each implementation deliverable in the team plan:

1. **Identify the task**: What was implemented? (e.g., "Hero section component", "Auth API endpoints", "Database schema")
2. **Assign the agent**: Which agent was responsible?
3. **Define verification commands**: What commands prove it works?
4. **Define acceptance criteria**: What must be true for the task to pass?
5. **Set dependencies**: Which tasks must pass first?

### Task Schema

Each task in `tasks.json` follows this structure:

```json
[
  {
    "task_id": "TASK-001",
    "title": "Project scaffolding and framework initialization",
    "assigned_agent": "senior-frontend-engineer",
    "phase": "PHASE_4",
    "priority": "P0",
    "dependencies": [],
    "acceptance_criteria": [
      "Project directory created at D:\\OrcaProjects\\<project-name>",
      "Framework initialized with TypeScript support",
      "Git repository initialized with .gitignore",
      "Dependencies installed successfully"
    ],
    "verification_commands": [
      "Test-Path 'D:\\OrcaProjects\\<project-name>\\package.json'",
      "cd 'D:\\OrcaProjects\\<project-name>' ; npm run build"
    ]
  },
  {
    "task_id": "TASK-002",
    "title": "Design token CSS implementation",
    "assigned_agent": "senior-frontend-engineer",
    "phase": "PHASE_4",
    "priority": "P0",
    "dependencies": ["TASK-001"],
    "acceptance_criteria": [
      "CSS custom properties defined for all design tokens",
      "Color palette uses HSL values",
      "Typography scale uses modern Google Fonts",
      "Dark mode tokens defined"
    ],
    "verification_commands": [
      "Test-Path 'D:\\OrcaProjects\\<project-name>\\src\\tokens.css'",
      "cd 'D:\\OrcaProjects\\<project-name>' ; npx tsc --noEmit"
    ]
  }
]
```

### Standard Task Categories

Generate tasks for each applicable category:

#### Core Infrastructure Tasks
- `TASK-SCAFFOLD`: Project scaffolding
- `TASK-TOKENS`: Design token implementation
- `TASK-DB-SCHEMA`: Database schema and migrations
- `TASK-AUTH`: Authentication and authorization

#### Frontend Tasks (if applicable)
- `TASK-LAYOUT`: Layout components (header, footer, sidebar, navigation)
- `TASK-PAGES`: Page components (home, about, dashboard, etc.)
- `TASK-SEO`: SEO implementation (meta tags, structured data, sitemap)
- `TASK-CRO`: Conversion elements (CTAs, trust signals, forms)
- `TASK-A11Y`: Accessibility compliance (WCAG 2.1 AA)
- `TASK-RESPONSIVE`: Responsive design (375px, 768px, 1280px, 1920px)

#### Backend Tasks (if applicable)
- `TASK-API`: API endpoint implementation
- `TASK-MIDDLEWARE`: Middleware (auth, rate limiting, CORS, error handling)
- `TASK-CACHE`: Caching layer implementation

#### AI/ML Tasks (if applicable)
- `TASK-MODEL`: Model implementation/integration
- `TASK-PIPELINE`: Data/inference pipeline
- `TASK-EVAL`: Model evaluation and benchmarking

#### Quality Tasks
- `TASK-UNIT-TESTS`: Unit test suite (≥80% coverage)
- `TASK-INTEGRATION-TESTS`: Integration test suite
- `TASK-E2E-TESTS`: End-to-end test suite
- `TASK-SECURITY`: Security audit and hardening
- `TASK-PERF`: Performance optimization and Lighthouse compliance

#### DevOps Tasks
- `TASK-DOCKER`: Containerization
- `TASK-CICD`: CI/CD pipeline
- `TASK-DEPLOY`: Deployment configuration

---

## Step 2: Initialize Ralph State

Create `ralph-state.json`:

```json
{
  "session_id": "<generated-uuid>",
  "project_name": "<project-name>",
  "status": "INITIALIZING",
  "current_iteration": 0,
  "max_iterations": 30,
  "active_task_id": null,
  "completed_tasks": [],
  "failed_tasks": [],
  "retry_counts": {}
}
```

---

## Step 3: Execute Verification Loop

For each pending task (in dependency order):

### 3.1: Run Verification Commands
Execute each command in the task's `verification_commands` array:

```powershell
# Example verification
cd "D:\OrcaProjects\<project-name>"
npm run lint        # Must exit with code 0
npx tsc --noEmit    # Must exit with code 0
npm test            # Must exit with code 0
npm run build       # Must exit with code 0
```

### 3.2: Evaluate Against 27-Point Rubric

Read [ralph/evaluator.md](file:///d:/Orca/ralph/evaluator.md) and evaluate the task against all applicable criteria:

**Core Criteria (Always Required)**:
1. ✅ Verification commands exit code 0
2. ✅ Test logs: 0 errors, 0 unexpected skips
3. ✅ Acceptance criteria explicitly fulfilled
4. ✅ Git state clean
5. ✅ No regressions
6. ✅ Zero lint/type/console errors

**SEO Criteria (Frontend/Public Pages)**:
7-12. Meta tags, headings, structured data, SSR, canonical URLs, Open Graph

**Performance Criteria (Frontend)**:
13-16. Lighthouse ≥ 90, bundle < 200KB, image optimization, no CLS

**Conversion Criteria (Landing/Marketing)**:
17-20. CTA presence, trust signals, empty states, error UX

**Security Criteria (Backend/Auth)**:
21-24. No secrets, input validation, rate limiting, security headers

**Backend Performance (API)**:
25-27. Response time, health check, structured logging

### 3.3: Determine Verdict

```
IF all applicable criteria PASS:
  → verdict = "PASS"
  → Add task_id to completed_tasks
  → Proceed to next task

ELSE IF retry_count < 3:
  → verdict = "FAIL"
  → Increment retry_count
  → Log specific failures with corrective guidance
  → Fix the specific failures
  → Re-run verification

ELSE (retry_count >= 3):
  → verdict = "CIRCUIT_BREAKER"
  → Add task_id to failed_tasks
  → Escalate to user with full failure report
```

---

## Step 4: Produce Evaluation Report

After all tasks are processed, produce a structured Ralph Evaluation Report:

```markdown
# Ralph Evaluation Report — <project-name>

## Summary
- **Total Tasks**: N
- **Passed**: X
- **Failed**: Y (circuit breaker)
- **Status**: COMPLETED | PARTIAL | BLOCKED

## Task Results

| Task ID | Title | Verdict | Attempts | Notes |
|---------|-------|---------|----------|-------|
| TASK-001 | Project scaffolding | ✅ PASS | 1/3 | — |
| TASK-002 | Design tokens | ✅ PASS | 2/3 | Fixed HSL syntax on retry |
| TASK-003 | API endpoints | ❌ FAIL | 3/3 | Circuit breaker: auth middleware timeout |

## Failed Task Details
### TASK-003: API endpoints
- **Failure Point**: Criterion 25 — API p95 > 200ms (measured: 340ms)
- **Root Cause**: N+1 query in user listing endpoint
- **Corrective Action**: Add eager loading for user relationships
- **Escalation**: Requires senior-database-architect review

## Production Readiness Scorecard
- SEO: ✅ PASS
- Performance: ⚠️ PARTIAL (1 endpoint over budget)
- Security: ✅ PASS
- Conversion: ✅ PASS
- Testing: ✅ PASS
```

---

## Integration with PowerShell Loop

The `ralph/loop.ps1` script can also be run standalone for automated verification:

```powershell
# Generate tasks.json first (done by this skill), then run:
cd D:\Orca
.\ralph\loop.ps1 -StateFile "D:\OrcaProjects\<project-name>\ralph-state.json" -TaskFile "D:\OrcaProjects\<project-name>\tasks.json" -MaxIterations 30
```

The loop will process tasks, run verification commands, and track state. The skill provides the intelligence layer (rubric evaluation, corrective guidance); the PowerShell script provides the execution loop.
