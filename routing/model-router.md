# Orca Model Router

The **Orca Model Router** is the cognitive resource allocation engine of the Orca Agent Operating System. It dynamically maps classified tasks to the optimal foundation model hosted within the **Google Antigravity CLI** execution harness.

The router strictly decouples **Agent Roles**, **Foundation Models**, and **Harnesses**, ensuring that tasks are dynamically routed based on capability requirements, reasoning depth, risk level, latency budgets, and review independence.

---

## 1. Core Architectural Concepts

```
┌─────────────────────────────────────────────────────────────┐
│ 1. AGENT ROLE                                               │
│ Defines domain authority, governance rules, and persona.   │
│ (e.g. senior-llm-engineer, senior-security-engineer)        │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. MODEL ROUTER ENGINE                                      │
│ Scores candidates across 14 capability dimensions.          │
│ Determines primary model, fallbacks, and review strategy.   │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. COGNITIVE MODEL                                          │
│ Selected LLM (e.g. Gemini 3.1 Pro, Claude Sonnet 4.6).      │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. EXECUTION HARNESS                                        │
│ Runtime environment: antigravity-cli                        │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Model Registry & Cognitive Profiles

| Model Identifier | Primary Tier | Context Window | Latency Profile | Primary Strengths |
| :--- | :--- | :--- | :--- | :--- |
| **`Gemini 3.6 Flash`** | High-Throughput Fast | 1,048,576 tokens | Sub-second | Fast code generation, UI/UX visual inspection, rapid testing, documentation |
| **`Gemini 3.5 Flash`** | High-Throughput Fast | 1,048,576 tokens | Sub-second | Low-risk worker execution, syntax refactoring, rate-limit fallback |
| **`Gemini 3.1 Pro`** | Deep Analytical Reasoning | 2,097,152 tokens | Moderate | System architecture, ADRs, massive repository refactoring, AI systems design |
| **`Claude Sonnet 4.6`** | Advanced Code & Reasoning | 200,000 tokens | Fast | Precision multi-file coding, complex debugging, independent code review |
| **`Claude Opus 4.6`** | Deep Analytical Reasoning | 200,000 tokens | Deep | Threat modeling, zero-trust security, theoretical ML algorithms, circuit breaker analysis |
| **`GPT-OSS-120B`** | Open-Weights Foundation | 131,072 tokens | Fast | Offline fallback, deterministic test assertion evaluation, continuous monitoring |

---

## 3. Concrete Routing Decision Examples

### Example 1: System Architecture & ADR Generation
- **Task Class**: `architecture`
- **Agent Role**: `senior-system-architect`
- **Assessed Risk**: `high`
- **Output Manifest**:
```json
{
  "task_id": "task-arch-001",
  "task_class": "architecture",
  "agent_role": "senior-system-architect",
  "harness": "antigravity-cli",
  "risk_level": "high",
  "selected_model": "Gemini 3.1 Pro",
  "selection_reason": "High-reasoning foundation required for full repository context ingestion and multi-tier architectural ADR synthesis.",
  "fallback_models": [
    { "model": "Claude Opus 4.6", "priority": 1, "condition": "quota_exhausted" },
    { "model": "Claude Sonnet 4.6", "priority": 2, "condition": "high_latency" }
  ],
  "review_required": true,
  "review_strategy": {
    "mode": "cross_model_independent",
    "review_model": "Claude Sonnet 4.6",
    "review_agent": "senior-system-architect"
  },
  "human_approval_required": false,
  "routing_metrics": {
    "estimated_context_tokens": 180000,
    "latency_budget": "interactive",
    "reasoning_tier": "tier_4_deep_analytical"
  }
}
```

---

### Example 2: Frontend SSR & Conversion Component Implementation
- **Task Class**: `frontend`
- **Agent Role**: `senior-frontend-engineer`
- **Assessed Risk**: `medium`
- **Output Manifest**:
```json
{
  "task_id": "task-fe-014",
  "task_class": "frontend",
  "agent_role": "senior-frontend-engineer",
  "harness": "antigravity-cli",
  "risk_level": "medium",
  "selected_model": "Claude Sonnet 4.6",
  "selection_reason": "Top-tier code generation accuracy for complex React/Next.js SSR state management, accessibility, and CSS token integration.",
  "fallback_models": [
    { "model": "Gemini 3.6 Flash", "priority": 1, "condition": "quota_exhausted" },
    { "model": "Gemini 3.1 Pro", "priority": 2, "condition": "context_exceeded" }
  ],
  "review_required": true,
  "review_strategy": {
    "mode": "cross_model_independent",
    "review_model": "Gemini 3.6 Flash",
    "review_agent": "visual-qa"
  },
  "human_approval_required": false,
  "routing_metrics": {
    "estimated_context_tokens": 45000,
    "latency_budget": "interactive",
    "reasoning_tier": "tier_3_advanced"
  }
}
```

---

### Example 3: Critical Database Migration with Row-Level Security
- **Task Class**: `database`
- **Agent Role**: `senior-database-architect`
- **Assessed Risk**: `critical`
- **Output Manifest**:
```json
{
  "task_id": "task-db-008",
  "task_class": "database",
  "agent_role": "senior-database-architect",
  "harness": "antigravity-cli",
  "risk_level": "critical",
  "selected_model": "Gemini 3.1 Pro",
  "selection_reason": "Deep data modeling reasoning and zero-downtime SQL migration validation.",
  "fallback_models": [
    { "model": "Claude Opus 4.6", "priority": 1, "condition": "quota_exhausted" },
    { "model": "Claude Sonnet 4.6", "priority": 2, "condition": "syntax_validation_error" }
  ],
  "review_required": true,
  "review_strategy": {
    "mode": "cross_model_independent",
    "review_model": "Claude Sonnet 4.6",
    "review_agent": "senior-security-engineer"
  },
  "human_approval_required": true,
  "routing_metrics": {
    "estimated_context_tokens": 60000,
    "latency_budget": "batch_relaxed",
    "reasoning_tier": "tier_4_deep_analytical"
  }
}
```

---

### Example 4: Rapid Autonomous Unit Test Iteration
- **Task Class**: `testing`
- **Agent Role**: `senior-qa-architect`
- **Assessed Risk**: `low`
- **Output Manifest**:
```json
{
  "task_id": "task-test-042",
  "task_class": "testing",
  "agent_role": "senior-qa-architect",
  "harness": "antigravity-cli",
  "risk_level": "low",
  "selected_model": "Gemini 3.6 Flash",
  "selection_reason": "High-throughput sub-second response time for rapid test suite execution and boilerplate generation.",
  "fallback_models": [
    { "model": "Gemini 3.5 Flash", "priority": 1, "condition": "quota_exhausted" },
    { "model": "GPT-OSS-120B", "priority": 2, "condition": "offline_fallback" }
  ],
  "review_required": false,
  "review_strategy": {
    "mode": "automated_gate_only",
    "review_model": "NONE",
    "review_agent": "NONE"
  },
  "human_approval_required": false,
  "routing_metrics": {
    "estimated_context_tokens": 15000,
    "latency_budget": "sub_second",
    "reasoning_tier": "tier_1_fast"
  }
}
```

---

## 4. Integration with Autonomous Lifecycle

- **Task Classifier**: Pre-classifies task domain, complexity tier, and risk level, feeding structured inputs into the scoring engine.
- **Team Builder**: Allocates candidate specialist agents who are subsequently paired with optimal models by the router.
- **Ralph Evaluator**: Monitors execution logs and test assertions; on repeated test failure, signals the router to escalate the reasoning tier to a deeper fallback model.
