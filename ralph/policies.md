# Orca Ralph Autonomous Execution Policies

The **Ralph Loop** is the autonomous feedback-driven execution engine of Orca. It governs automated cycles of task execution, independent evaluation, test-driven feedback, retry loops, and safety circuit breakers.

## Core Policies

### 1. Invariant: Evidence Over Assertion
- A task is NEVER considered complete simply because an agent asserts it is complete.
- Concrete evidence (passing test logs, clean build output, visual verification) must be inspected by the Evaluator.

### 2. Maximum Retry & Circuit Breakers
- **Per-Task Retries**: A task may fail evaluation a maximum of **3 times**.
- On the 3rd failure:
  1. The task is marked `BLOCKED`.
  2. A diagnostic report is generated with failed hypotheses and execution traces.
  3. The task is escalated to the [Senior System Architect](file:///d:/Orca/agents/senior-system-architect.md) for architectural review or human escalation.
- **Runaway Prevention**: The entire Ralph session halts if `current_iteration` exceeds `max_iterations` (default: 30).

### 3. State Preservation & Atomic Rollbacks
- State is committed to `ralph-state.json` at every step transition.
- If an agent's changes cause regressions in unrelated modules:
  - The working branch is rolled back to the last known green commit.
  - The failure context is injected into the next iteration prompt.

### 4. Zero Assumption on Environment
- Commands are executed with strict timeout constraints.
- Environment variables, test databases, and temporary artifacts are isolated per worktree.
