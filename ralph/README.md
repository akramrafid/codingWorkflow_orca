# Orca Ralph Autonomous Execution Engine

Ralph is the closed-loop autonomous verification and execution runtime for the Orca Agent Operating System.

## Architecture & Workflow

```
[ Task DAG / tasks.json ]
          │
          ▼
┌─────────────────────────────────────────────────────────────┐
│                    RALPH EXECUTION LOOP                     │
│                                                             │
│  1. Check Dependency Resolution                             │
│  2. Dispatch Assigned Specialist Agent                      │
│  3. Execute Verification Commands (Tests, Lint, Build)      │
│  4. Invoke Ralph Evaluator (Pass/Fail Rubric)               │
│  5. Commit State to ralph-state.json                        │
│  6. Trigger Self-Correction Loop or Advance to Next Task    │
└─────────────────────────────────────────────────────────────┘
          │
    ┌─────┴─────┐
    ▼           ▼
 [ PASS ]    [ FAIL ]
    │           │
    ▼           ▼
  Merge     Retry (Max 3) -> Escalate / Circuit Break
```

## Running the Ralph Loop

Execute via PowerShell:

```powershell
.\ralph\loop.ps1 -StateFile .\ralph-state.json -TaskFile .\tasks.json -MaxIterations 30
```

## State & Task Schemas
- [state-schema.json](file:///d:/Orca/ralph/state-schema.json) — Defines session metadata, iteration counts, completed/failed tasks.
- [task-schema.json](file:///d:/Orca/ralph/task-schema.json) — Defines task contracts, acceptance criteria, verification commands, and assigned agents.
- [policies.md](file:///d:/Orca/ralph/policies.md) — Self-correction rules, circuit breakers, and safety boundaries.
- [evaluator.md](file:///d:/Orca/ralph/evaluator.md) — Objective evaluation rubric for task completion.
