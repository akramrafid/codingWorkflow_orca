# Orca Ralph Autonomous Execution Policies

The **Ralph Loop** is the autonomous feedback-driven execution engine of Orca. It governs automated cycles of task execution, independent evaluation, test-driven feedback, retry loops, and safety circuit breakers.

Every iteration must bring the project closer to production readiness. Ralph does not just verify that code works — it verifies that code is fast, SEO-compliant, secure, conversion-optimized, tested, and deployable.

---

## Core Policies

### 1. Invariant: Evidence Over Assertion
- A task is NEVER considered complete simply because an agent asserts it is complete.
- Concrete evidence must be inspected by the Ralph Evaluator:
  - Passing test logs (unit, integration, build)
  - Lighthouse scores (Performance ≥ 90, SEO ≥ 95, Accessibility ≥ 95) for frontend tasks
  - Security scan results for backend/auth tasks
  - Visual screenshots for UI tasks
  - API response samples for backend tasks
- If evidence is missing, the task is automatically `FAIL` regardless of implementation quality.

### 2. Maximum Retry & Circuit Breakers
- **Per-Task Retries**: A task may fail evaluation a maximum of **3 times**.
- **Retry 1**: The Evaluator provides specific corrective guidance. The assigned agent self-corrects.
- **Retry 2**: The Evaluator includes additional context from prior failures. The agent must address all accumulated feedback.
- **Retry 3 (Final)**: If the task fails a third time:
  1. The task is marked `BLOCKED`.
  2. A diagnostic report is generated containing: all three failure reasons, hypothesized root causes, attempted fixes, and execution traces.
  3. The task is escalated to the [Senior System Architect](file:///d:/Orca/agents/senior-system-architect.md) for architectural review.
  4. If the architect determines human intervention is needed, execution pauses.
- **Runaway Prevention**: The entire Ralph session halts if `current_iteration` exceeds `max_iterations` (default: 30). A summary report is generated for human review.
- **Cascade Prevention**: If a blocked task has downstream dependents, all dependent tasks are marked `WAITING_ON_BLOCKED` rather than attempted.

### 3. State Preservation & Atomic Rollbacks
- State is committed to `ralph-state.json` at every step transition — before and after task execution.
- If an agent's changes cause regressions in unrelated modules:
  - The working branch is rolled back to the last known green commit (`git reset --hard <green-sha>`).
  - The failure context (which tests regressed, what the agent changed) is injected into the next iteration prompt.
  - The regression is logged in the diagnostic history for root cause analysis.
- Every state transition is append-only in the log — no destructive state overwrites.

### 4. Zero Assumption on Environment
- Commands are executed with strict timeout constraints (default: 300 seconds per command).
- Environment variables, test databases, and temporary artifacts are isolated per worktree.
- Commands that require network access must have configurable timeouts and retry logic.
- If a verification command hangs beyond timeout, the task fails with `TIMEOUT` status.

### 5. Production Readiness Progression
- Ralph tracks cumulative production readiness across all tasks using the checklist from [ARCHITECTURE.md](file:///d:/Orca/ARCHITECTURE.md).
- At the end of each iteration, the overall readiness score is updated:
  - **Performance**: Lighthouse Performance ≥ 90
  - **SEO**: All public pages have meta tags, structured data, and canonical URLs
  - **Security**: All endpoints validated, headers set, no exposed secrets
  - **Conversion**: CTAs present, trust signals placed, empty states handled
  - **Testing**: ≥80% coverage, E2E critical paths covered, zero lint/type errors
  - **Reliability**: Health check endpoint, structured logging, graceful shutdown
- The project is not considered `COMPLETED` until all readiness categories reach `PASS`.

### 6. Evaluation Order Priority
When evaluating a task with multiple criteria, the Evaluator checks in this order:
1. **Security** (if security fails, everything else is irrelevant)
2. **Core functionality** (does it work at all?)
3. **Testing** (is the implementation verified?)
4. **Performance** (is it fast enough?)
5. **SEO** (is it discoverable?)
6. **Conversion** (does it drive user action?)
7. **Code quality** (is it maintainable?)

This priority ensures critical failures are caught first, preventing wasted iteration on polish when fundamentals are broken.

### 7. Diagnostic Memory
- The Ralph loop maintains a `failure_history` array in state, recording every failed evaluation with:
  - Task ID
  - Iteration number
  - Failed criteria
  - Agent feedback provided
  - Attempted fix summary
- This history is injected into subsequent retry prompts so agents don't repeat the same failed approaches.
- If the same failure pattern appears across different tasks, Ralph flags it as a systemic issue requiring architectural review.
