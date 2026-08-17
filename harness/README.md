# Orca Harness Integration Layer

The **Harness Integration Layer** provides the execution abstraction that bridges the Orca Agent Operating System to underlying developer environments, CLI harnesses, and agent runtime platforms.

It ensures that Orca agents, governance rules, and model routing decisions remain completely independent of the execution environment.

---

## 1. 6-Dimensional Separation of Concerns

Orca cleanly separates the six fundamental primitives of autonomous execution:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. AGENT ROLE     │ Authority, persona, and rules           │
│                   │ (e.g., senior-frontend-engineer)        │
├───────────────────┼─────────────────────────────────────────┤
│ 2. MODEL          │ Cognitive reasoning engine              │
│                   │ (e.g., Gemini 3.1 Pro, Claude Sonnet 4.6)│
├───────────────────┼─────────────────────────────────────────┤
│ 3. HARNESS        │ Execution runtime & tool harness        │
│                   │ (Current: antigravity-cli)              │
├───────────────────┼─────────────────────────────────────────┤
│ 4. PROJECT        │ Target codebase workspace path          │
│                   │ (e.g., D:/Orca or /path/to/app)         │
├───────────────────┼─────────────────────────────────────────┤
│ 5. WORKTREE       │ Isolated Git worktree directory         │
│                   │ (e.g., worktree/frontend, worktree/ai)  │
├───────────────────┼─────────────────────────────────────────┤
│ 6. TASK           │ Discrete execution unit & prompt        │
│                   │ (task_id, risk_level, approval status)  │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Supported Execution Harnesses

Currently registered in [`harness/registry.yaml`](file:///D:/Orca/harness/registry.yaml):

* **`antigravity-cli`** (Google Antigravity CLI) — Native Windows/POSIX CLI environment providing subagent delegation, model selection, MCP tool integration, and background task management.

---

## 3. Directory Layout

```
harness/
├── README.md                  # Layer overview and architectural principles
├── registry.yaml              # Declarative registry of supported execution harnesses
├── harness-schema.json        # JSON Schema for task execution envelopes & execution manifests
├── antigravity-cli.md         # Antigravity CLI capabilities, commands, and adapter specification
└── antigravity-runner.ps1     # Safe, non-destructive execution runner (Dry-Run by default)
```

---

## 4. Safety & Non-Destructive Invariant

By default, all harness executions run in **`dry-run`** mode. The runner:
1. Validates all inputs (agent existence, model registration, project paths, risk levels).
2. Evaluates the governance authority matrix and required approval gates.
3. Prepares and prints the structured execution plan.
4. Never executes destructive file deletes, unapproved Git pushes, or production deployments.
