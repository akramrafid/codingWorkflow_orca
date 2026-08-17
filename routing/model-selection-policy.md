# Orca Model Selection and Dynamic Routing Policy

This document establishes the mathematical scoring engine, fallback hierarchies, review independence policies, and runtime discovery protocols governing model selection within the Google Antigravity CLI harness.

---

## 1. Separation of Concerns: Agent Role vs. Model vs. Harness

The Orca operating system strictly decouples the three layers of autonomous execution:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. AGENT ROLE (Domain Authority & Persona)                  │
│ Defines WHAT needs to be done, WHO has authority to approve,│
│ and WHICH governance policies must be obeyed.               │
│ Example: senior-llm-engineer, senior-security-engineer       │
└──────────────────────────────┬──────────────────────────────┘
                               │ Dispatched via Model Router
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. MODEL (Cognitive Reasoning Engine)                       │
│ Provides the raw intellect, context window, coding speed,   │
│ and reasoning depth to execute the task.                    │
│ Example: Gemini 3.1 Pro, Claude Sonnet 4.6, Gemini 3.6 Flash│
└──────────────────────────────┬──────────────────────────────┘
                               │ Hosted & Executed in
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. HARNESS (Execution Environment)                          │
│ Provides local tool-calling, file I/O, subprocess execution,│
│ and workspace lifecycle management.                         │
│ Example: antigravity-cli                                     │
└─────────────────────────────────────────────────────────────┘
```

**Rule**: An agent is NEVER permanently coupled to a single model. The router dynamically assigns the best available model to an agent role based on the specific task requirements.

---

## 2. Dynamic Task-to-Model Scoring Algorithm

Instead of static `agent -> model` lookups, the router evaluates candidate models using the **7-Factor Selection Function**:

$$\text{FinalScore}(M, T) = \text{BaseCapabilityScore}(M, T) + B_{\text{context}} + B_{\text{risk}} - P_{\text{latency}} - P_{\text{quota}} - P_{\text{churn}}$$

### Formula Components:

1. **Base Capability Score**:
   $$\text{BaseCapabilityScore}(M, T) = \sum_{d \in D} w_d(T) \cdot \text{Strength}_d(M)$$
   Where $D$ is the set of 14 capability dimensions (planning, architecture, coding, debugging, code_review, reasoning, research, long_context_analysis, ui_ux_reasoning, ai_ml_reasoning, mathematical_reasoning, documentation, testing, autonomous_execution), and $w_d(T)$ is the normalized weight for task class $T$.

2. **Context Window Bonus ($B_{\text{context}}$)**:
   - If estimated task tokens $> 150\text{k}$: $+2.5$ for models with $\ge 1\text{M}$ context (e.g. `Gemini 3.1 Pro`, `Gemini 3.6 Flash`).
   - If estimated task tokens $\le 50\text{k}$: $0.0$.

3. **Risk Profile Bonus ($B_{\text{risk}}$)**:
   - For `critical` or `high` risk tasks (auth, security, database migration, production IaC): $+2.0$ for Deep Analytical models (`Claude Opus 4.6`, `Claude Sonnet 4.6`, `Gemini 3.1 Pro`).

4. **Latency Budget Penalty ($P_{\text{latency}}$)**:
   - For interactive sub-second requirements (linting, rapid test iterations): $-3.0$ penalty on deep/slow reasoning models; $+2.0$ bonus on High-Throughput Fast models (`Gemini 3.6 Flash`, `Gemini 3.5 Flash`).

5. **Quota & Rate-Limit Penalty ($P_{\text{quota}}$)**:
   - Active rate-limit or high exhaustion state: $-\infty$ (triggers instant fallback).
   - Approaching quota threshold: $-2.0$.

6. **Model Churn Penalty ($P_{\text{churn}}$)**:
   - If model $M$ is already active in the current conversation worktree for Tier 1-2 tasks: $+1.0$ stickiness bonus to prevent unnecessary context switching.

---

## 3. Runtime Availability & Fallback Discovery

The router does not assume every registered model is perpetually online or unconstrained by rate limits.

```
┌─────────────────────────────────────────────────────────────┐
│                 SELECT PRIMARY MODEL                        │
│                 (Highest FinalScore)                        │
└──────────────────────────────┬──────────────────────────────┘
                               │
                Is Model Available & Unthrottled?
                               ├───────────────┐
                              YES              NO
                               │               ▼
                               │   ┌──────────────────────────┐
                               │   │ ACTIVATE FALLBACK 1      │
                               │   │ (From Task Fallback List)│
                               │   └───────────┬──────────────┘
                               │               │
                               │  Is Fallback 1 Available?
                               │       ┌───────┴───────┐
                               │      YES              NO
                               │       │               ▼
                               │       │   ┌──────────────────┐
                               │       │   │ ACTIVATE FALLBACK 2
                               │       │   └───────────┬──────┘
                               ▼       ▼               ▼
┌─────────────────────────────────────────────────────────────┐
│        PROCEED WITH EXECUTION IN ANTIGRAVITY CLI            │
└─────────────────────────────────────────────────────────────┘
```

### Cascade Rules:
1. **Primary Model Exhausted**: The router immediately shifts to the highest-ranked entry in `fallback_models` defined in [model-capability-matrix.yaml](file:///D:/Orca/routing/model-capability-matrix.yaml).
2. **Graceful Degradation**: If all Tier 4 deep reasoning models are rate-limited, the system falls back to Tier 2/3 high-throughput models with expanded prompting and multi-step verification harnesses rather than aborting.
3. **No External Harness Requirement**: All fallbacks operate natively within `antigravity-cli`.

---

## 4. Review Independence Policy (Four-Eyes Principle)

For high-stakes and production-bound implementations, the system enforces the **Four-Eyes Review Rule**: *The model that authored the code should not be the sole model that reviews and approves it.*

### Review Strategy Matrix:

| Risk Level | Task Classes | Primary Review Strategy | Fallback Strategy (Single Model Available) |
| :--- | :--- | :--- | :--- |
| **Critical** | `database`, `security` | **Cross-Model Independent**<br>(e.g. Authored by Claude Opus / Sonnet → Reviewed by Gemini 3.1 Pro) | **Same Model Fresh Context**<br>(Context cleared, prompted as adversarial auditor) + Human Gate |
| **High** | `architecture`, `backend`, `ai`, `llm`, `dl`, `devops`, `review` | **Cross-Model Independent**<br>(e.g. Authored by Claude Sonnet 4.6 → Reviewed by Gemini 3.1 Pro) | **Same Model Fresh Context** |
| **Medium** | `requirements`, `system_design`, `frontend`, `ml`, `nlp`, `computer_vision`, `ui_ux`, `debugging` | **Same Model Fresh Context** or **Cross-Model** (if active) | Automated Gate Only |
| **Low** | `testing`, `research`, `documentation` | **Automated Gate Only** / **None** | Automated Gate Only |

---

## 5. Model Stickiness vs. Switching Rules

To prevent cognitive churn and unnecessary token loading, the router applies strict stickiness thresholds:

1. **Stickiness Default**: During Phase 4 implementation within a single worktree, worker iterations (syntax fixes, unit test authoring, lint cleanup) remain with the active model.
2. **Switching Triggers**:
   - Transition across a Phase Gate (e.g. Phase 4 Implementation → Phase 5 Verification).
   - Task complexity tier escalation (e.g. Tier 2 feature task encounters architectural deadlock → escalates to Tier 4).
   - Ralph Evaluator second consecutive failure (automatically upgrades to higher reasoning tier).
   - Independent cross-model review requirement.

---

## 6. Human Approval Triggers

The Model Router automatically mandates `human_approval_required: true` when any of the following conditions are met:
1. Destruction or dropping of existing database tables or volumes.
2. Direct production deployment trigger in Phase 7.
3. Security CVE overrides or cryptographic standard alterations.
4. Circuit breaker trip after 3 failed autonomous Ralph iterations.
