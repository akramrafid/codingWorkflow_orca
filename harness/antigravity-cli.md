# Google Antigravity CLI Harness Specification

This document details the architecture, native capabilities, slash commands, tool-calling mechanisms, and safety protocols for the **Google Antigravity CLI** (`antigravity-cli`) execution harness.

---

## 1. Harness Overview

Google Antigravity CLI is an advanced agentic development environment and execution harness designed for autonomous software engineering.

### Execution Environment Characteristics:
- **Platform**: Windows PowerShell / POSIX Shell.
- **Provider Infrastructure**: Google AI Pro foundation reasoning endpoints.
- **Workspace Model**: Directory-bound project sessions with support for multi-workspace mapping and Git worktrees.
- **Tooling Engine**: Native file manipulation, terminal command execution, subagent orchestration, and Model Context Protocol (MCP) integrations.

---

## 2. Documented Native Capabilities & Slash Commands

| Capability / Command | Scope & Operational Function |
| :--- | :--- |
| **`/agents` & Custom Agents** | Discovers, loads, and manages specialized agent personas defined in Markdown (`agents/*.md`). Supports declarative prompt scoping and authority boundaries. |
| **`/model` & Selection** | Dynamically switches or assigns the cognitive reasoning foundation (e.g. Gemini 3.7 / 3.6 Flash / 3.1 Pro, Claude Sonnet / Opus 4.6). |
| **`/permissions`** | Inspects and configures tool-calling execution boundaries, user confirmation policies, and workspace isolation rules. |
| **`/tasks` & Background Execution** | Manages asynchronous background tasks, monitors subprocess outputs, and handles stdin/stdout streaming without blocking loops. |
| **`/mcp` & Protocol Tools** | Dynamically discovers and invokes lazy-loaded or eagerly-loaded Model Context Protocol servers (e.g. Stitch UI designer, vector databases). |
| **`/usage`** | Real-time token consumption metrics, context window tracking, and rate-limit diagnostics. |
| **`/plan`, `/grill-me`, `/learn`** | Interactive planning, requirements alignment interviews, and memory persistence mechanisms. |
| **Background Subagents** | Concurrently spawns isolated subagent reasoning conversations via `invoke_subagent` with reactive message wakeup. |

---

## 3. Harness Adapter Execution Protocol

The Antigravity Harness Adapter operates via the following execution contract:

```
[ INCOMING TASK SPECIFICATION ]
             │
             ▼
┌─────────────────────────────────────────────────────────────┐
│ 1. VALIDATION LAYER                                         │
│ • Validate agent exists in agents/                          │
│ • Validate model is registered in model-capability-matrix   │
│ • Validate project path and optional worktree path exist    │
│ • Validate risk level & evaluate required approval gates    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. DRY-RUN / PLAN PREPARATION                               │
│ • Synthesize agent role instructions with task prompt       │
│ • Bind selected model and context parameters                │
│ • Emit machine-readable execution manifest JSON             │
└──────────────────────────────┬──────────────────────────────┘
                               │
            Mode == "execute" AND Approved?
                               ├───────────────┐
                              YES              NO
                               │               ▼
                               │   ┌──────────────────────────┐
                               │   │ SAFE TERMINATION         │
                               │   │ Return dry-run plan only │
                               │   └──────────────────────────┘
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. LIVE EXECUTION ADAPTER (Protected)                       │
│ • Launch task in target workspace/worktree                  │
│ • Enforce strict safety invariants (no push/deploy/delete)  │
│ • Capture command logs and execution diffs                  │
│ • Output completion status and evidence manifest            │
└─────────────────────────────────────────────────────────────┘
```

---

## 4. Safety & Invariant Rules

1. **Dry-Run by Default**: All executions default to `dry-run` mode. Live execution requires explicit `mode = "execute"` and resolution of all required approval gates.
2. **No Invented CLI Flags**: The runner strictly adheres to documented Antigravity CLI features and does not fabricate non-existent command-line options.
3. **No Automatic Destructive Operations**:
   - Never automatically drop database tables or delete directories.
   - Never automatically force-push to remote Git repositories.
   - Never deploy to production infrastructure without human sign-off.
   - Never alter global Antigravity configuration files (`~/.gemini/antigravity-cli`).
