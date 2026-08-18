---
name: model-router
description: Model selection and cognitive resource allocation skill for the Orca Agent Operating System. Assigns the optimal foundation model to each task class based on a 14-dimension capability scoring matrix. Use this skill during Phase 0 alongside the team-builder skill.
---

# Orca Model Router — Cognitive Resource Allocation

This skill dynamically maps classified tasks to the optimal foundation model available in the Antigravity execution harness.

## When to Use

Use this skill during **Phase 0** after the team plan is assembled. For each task class in the plan, determine the primary model, fallback chain, and review strategy.

## Available Models

Reference: [routing/model-capability-matrix.yaml](file:///d:/Orca/routing/model-capability-matrix.yaml)

| Model | Tier | Context Window | Latency | Cost | Best For |
|-------|------|---------------|---------|------|----------|
| **Gemini 3.6 Flash** | High-Throughput | 1M tokens | Sub-second | Minimal | Fast code gen, visual inspection, testing, docs |
| **Gemini 3.5 Flash** | High-Throughput | 1M tokens | Sub-second | Minimal | Fallback for rate limits, low-risk syntax fixes |
| **Gemini 3.1 Pro** | Deep Analytical | 2M tokens | Moderate | Standard | System architecture, massive refactoring, AI design |
| **Claude Sonnet 4.6** | Advanced Code | 200K tokens | Fast | Standard | Precision coding, debugging, code review, TypeScript |
| **Claude Opus 4.6** | Deep Analytical | 200K tokens | Deep | Premium | Threat modeling, security audits, research, math |
| **GPT-OSS-120B** | Open Weights | 131K tokens | Fast | Minimal | Offline fallback, deterministic test evaluation |

## 14-Dimension Capability Scoring

Each model is scored on:
1. Planning
2. Architecture
3. Coding
4. Debugging
5. Code Review
6. Reasoning
7. Research
8. Long Context Analysis
9. UI/UX Reasoning
10. AI/ML Reasoning
11. Mathematical Reasoning
12. Documentation
13. Testing
14. Autonomous Execution

## Task Class Routing Table

For each task class, the model router determines the optimal model:

| Task Class | Primary Model | Fallbacks | Review Strategy | Default Risk |
|-----------|---------------|-----------|----------------|--------------|
| **requirements** | Gemini 3.1 Pro | Claude Sonnet 4.6, Gemini 3.6 Flash | Same-model fresh context | Medium |
| **architecture** | Gemini 3.1 Pro | Claude Opus 4.6, Claude Sonnet 4.6 | Cross-model (Claude Sonnet review) | High |
| **system_design** | Claude Sonnet 4.6 | Gemini 3.1 Pro, Gemini 3.6 Flash | Same-model fresh context | Medium |
| **frontend** | Claude Sonnet 4.6 | Gemini 3.6 Flash, Gemini 3.1 Pro | Cross-model (Gemini Flash review) | Medium |
| **backend** | Claude Sonnet 4.6 | Gemini 3.1 Pro, Gemini 3.6 Flash | Cross-model (Gemini Pro review) | High |
| **database** | Gemini 3.1 Pro | Claude Sonnet 4.6, Claude Opus 4.6 | Cross-model (Claude Sonnet review) | Critical |
| **ai** | Gemini 3.1 Pro | Claude Opus 4.6, Claude Sonnet 4.6 | Cross-model (Claude Sonnet review) | High |
| **ml** | Claude Sonnet 4.6 | Gemini 3.1 Pro, GPT-OSS-120B | Same-model fresh context | Medium |
| **dl** | Claude Sonnet 4.6 | Claude Opus 4.6, Gemini 3.1 Pro | Cross-model (Gemini Pro review) | High |
| **nlp** | Gemini 3.1 Pro | Claude Sonnet 4.6, Gemini 3.6 Flash | Same-model fresh context | Medium |
| **llm** | Claude Sonnet 4.6 | Gemini 3.1 Pro, Claude Opus 4.6 | Cross-model (Gemini Pro review) | High |
| **computer_vision** | Claude Sonnet 4.6 | Gemini 3.1 Pro, Gemini 3.6 Flash | Same-model fresh context | Medium |
| **devops** | Claude Sonnet 4.6 | Gemini 3.1 Pro, Gemini 3.6 Flash | Cross-model (Claude Opus review) | High |
| **security** | Claude Opus 4.6 | Gemini 3.1 Pro, Claude Sonnet 4.6 | Cross-model (Gemini Pro review) | Critical |
| **testing** | Gemini 3.6 Flash | Claude Sonnet 4.6, GPT-OSS-120B | Automated gate only | Low |
| **research** | Gemini 3.1 Pro | Claude Opus 4.6, Gemini 3.6 Flash | Same-model fresh context | Low |
| **ui_ux** | Gemini 3.6 Flash | Claude Sonnet 4.6, Gemini 3.1 Pro | Same-model fresh context | Medium |
| **documentation** | Gemini 3.6 Flash | Gemini 3.5 Flash, Gemini 3.1 Pro | None | Low |
| **review** | Claude Sonnet 4.6 | Claude Opus 4.6, Gemini 3.1 Pro | Same-model fresh context | High |
| **debugging** | Claude Sonnet 4.6 | Claude Opus 4.6, Gemini 3.6 Flash | Same-model fresh context | Medium |

## How to Use This in Practice

Since Antigravity uses a single active model per session, the model router's output serves as:

1. **Documentation**: The team plan records which model is ideal for each task, so the user knows which model to select via `/model` for each phase.

2. **Subagent Context**: When spawning subagents for parallel work, note the recommended model in the subagent instructions.

3. **Review Strategy Guidance**:
   - **Cross-model independent**: Suggests having a different model review the output (e.g., Claude codes, Gemini reviews).
   - **Same-model fresh context**: Re-evaluate in a fresh conversation with the same model.
   - **Automated gate only**: No model review needed — rely on automated test/build gates.

## Output: Model Assignment Manifest

Produce a model assignment section in the team plan:

```json
{
  "model_assignments": [
    {
      "phase": "PHASE_0",
      "task_class": "requirements",
      "agent_role": "requirement-analyzer",
      "recommended_model": "Gemini 3.1 Pro",
      "fallback_models": ["Claude Sonnet 4.6", "Gemini 3.6 Flash"],
      "review_strategy": "same_model_fresh_context",
      "risk_level": "medium"
    },
    {
      "phase": "PHASE_1",
      "task_class": "architecture",
      "agent_role": "senior-system-architect",
      "recommended_model": "Gemini 3.1 Pro",
      "fallback_models": ["Claude Opus 4.6"],
      "review_strategy": "cross_model_independent",
      "review_model": "Claude Sonnet 4.6",
      "risk_level": "high"
    }
  ]
}
```

## Integration with Ralph

When the Ralph evaluation loop detects repeated failures on a task:
1. First retry: Same model, fresh context.
2. Second retry: Escalate to the next fallback model.
3. Third retry (circuit breaker): Escalate to the deepest reasoning model (Claude Opus 4.6 or Gemini 3.1 Pro) or to the user.
