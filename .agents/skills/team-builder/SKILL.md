---
name: team-builder
description: Dynamic team assembly skill for the Orca Agent Operating System. Analyzes a user prompt, classifies the domain, resolves capabilities, and assembles the minimal optimal specialist squad with model assignments. Use this skill during Phase 0 of the Orca lifecycle.
---

# Orca Team Builder — Dynamic Squad Assembly

This skill transforms a user's product brief into a structured Team Plan by performing capability-based reasoning against the Orca agent catalog.

## When to Use

Use this skill during **Phase 0: Requirement Analysis** when you need to determine which specialist agents to activate and which to exclude.

## Required Inputs

- The user's product brief or requirement
- [routing/capability-matrix.yaml](file:///d:/Orca/routing/capability-matrix.yaml) — Domain-to-agent mapping
- [routing/capability-resolution.yaml](file:///d:/Orca/routing/capability-resolution.yaml) — Transitive capability closure
- [routing/activation-policy.md](file:///d:/Orca/routing/activation-policy.md) — Anti-bloat laws and sizing tiers
- [routing/agent-hierarchy.yaml](file:///d:/Orca/routing/agent-hierarchy.yaml) — Organizational structure

---

## Team Assembly Algorithm

### Step 1: Domain Classification

Read `routing/capability-matrix.yaml` and classify the user prompt into one primary domain:

| Domain ID | Typical Triggers |
|-----------|-----------------|
| `saas_web_app` | Web app, SaaS, e-commerce, landing page, dashboard, portal, marketing site |
| `ai_llm_rag` | RAG, chatbot, AI assistant, LLM, embeddings, vector search, agent system |
| `classical_ml_data` | Prediction, recommendation, analytics, data pipeline, feature store |
| `computer_vision_system` | Object detection, image classification, video analytics, OCR |
| `generative_media_multimodal` | Image generation, audio synthesis, video creation, multimodal |
| `cloud_infrastructure_platform` | Infrastructure, Kubernetes, Terraform, cloud migration |
| `lightweight_utility_cli` | CLI tool, script, utility, documentation generator |

If the project spans multiple domains (e.g., "SaaS app with AI chatbot"), identify the **primary domain** and add secondary capabilities.

### Step 2: Capability Extraction

From the classified domain, extract the required capabilities:

1. Read `routing/capability-matrix.yaml` to get `required_agents` and `optional_agents` for the domain.
2. Read `routing/capability-resolution.yaml` to resolve transitive dependencies (e.g., RAG requires vector DB which requires embedding pipeline which requires NLP).
3. Check `feature_triggers` in the capability matrix for additional agent activations based on specific keywords in the prompt.

### Step 3: Squad Sizing

Apply the squad sizing heuristics from `routing/activation-policy.md`:

- **Tier A (Lightweight)**: 3-4 agents. CLI tools, scripts, utilities.
- **Tier B (Web App)**: 9-12 agents. Full-stack web applications.
- **Tier C (Enterprise AI)**: 10-14 agents. AI/ML/RAG systems.
- **Tier D (Multimodal Platform)**: 12-16 agents. Deep learning, computer vision, generative AI.

### Step 4: Role Segregation

Classify each activated agent into one of three roles:

1. **Senior Leads** (`senior_agents`): Own decisions, approve/reject deliverables, define specifications.
   - Every team MUST include: `senior-system-architect` (or `senior-cloud-architect`), `senior-qa-architect`.
   
2. **Specialists** (`specialist_agents`): Execute tasks within boundaries defined by their supervising lead.
   - Every specialist MUST have a `supervising_lead` from the senior agents list.
   
3. **Optional/Standby** (`optional_agents`): Agents that may be activated if scope expands.
   - Include a `standby_condition` describing when they'd activate.

### Step 5: Exclusion Filtering (Anti-Bloat)

Apply the **Three Anti-Bloat Laws**:

1. **No Unjustified Activations**: Every activated agent must trace to a required capability.
2. **Domain Non-Contagion**: AI/RAG projects do NOT activate Computer Vision. Web apps do NOT activate NLP/LLM unless explicitly needed.
3. **Explicit Exclusion Manifest**: List every excluded agent with a concrete justification.

### Step 6: Dependency DAG

Build the execution dependency graph:
- Which agents depend on which upstream agents' artifacts?
- Which agents can run in parallel?
- What is the topological ordering?

### Step 7: Worktree Allocation

Assign parallel implementation groups to isolated worktrees:
- `worktree/frontend` — Frontend implementation
- `worktree/backend` — Backend/API implementation
- `worktree/ai` — AI/ML implementation
- `worktree/data` — Data engineering
- `worktree/devops` — Infrastructure and CI/CD

### Step 8: Gate Binding

Bind mandatory quality gates from `routing/activation-policy.md`:
- **Architecture Gate**: Always mandatory. Owner: `senior-system-architect`.
- **Brand Gate**: Mandatory if UI agents are activated. Owner: `brand-guardian`.
- **Security Gate**: Always mandatory. Owner: `senior-security-engineer`.
- **QA Gate**: Always mandatory. Owner: `senior-qa-architect`.
- **Performance Gate**: Mandatory if frontend or high-throughput API. Owner: `senior-performance-engineer`.
- **Release Gate**: Always mandatory. Owner: `senior-devops-engineer`.

---

## Output: Team Plan JSON

Produce a `team-plan.json` artifact following [routing/team-builder-schema.json](file:///d:/Orca/routing/team-builder-schema.json):

```json
{
  "project": "<project-slug>",
  "summary": "<1-2 sentence project description>",
  "domain_profile": "<domain_id>",
  "squad_tier": "A | B | C | D",
  "required_capabilities": [
    {
      "capability": "<capability_id>",
      "category": "<category>",
      "justification": "<why this capability is needed>"
    }
  ],
  "senior_agents": [
    {
      "agent": "<agent-slug>",
      "domain": "<domain>",
      "responsibility": "<what they own>"
    }
  ],
  "specialist_agents": [
    {
      "agent": "<agent-slug>",
      "supervising_lead": "<senior-agent-slug>",
      "deliverables": ["<deliverable-1>", "<deliverable-2>"]
    }
  ],
  "optional_agents": [
    {
      "agent": "<agent-slug>",
      "standby_condition": "<when to activate>"
    }
  ],
  "excluded_agents": [
    {
      "agent": "<agent-slug>",
      "exclusion_reason": "<why excluded>"
    }
  ],
  "dependencies": [
    {
      "agent": "<agent-slug>",
      "depends_on": ["<upstream-agent-1>"],
      "blocking_artifact": "<what must be produced first>"
    }
  ],
  "parallel_groups": [
    {
      "group_id": "<group_id>",
      "phase": "PHASE_4",
      "worktree": "worktree/<domain>",
      "agents": ["<agent-1>", "<agent-2>"]
    }
  ],
  "approval_gates": [
    {
      "gate_name": "<gate_name>",
      "owner_agent": "<agent-slug>",
      "mandatory": true,
      "criteria": ["<criterion-1>", "<criterion-2>"]
    }
  ],
  "execution_phases": [
    {
      "phase_id": "P0",
      "phase_name": "Requirement Analysis",
      "active_agents": ["requirement-analyzer"],
      "gate": "NONE"
    }
  ]
}
```

---

## Concrete Examples

Refer to the worked examples in [routing/team-builder.md](file:///d:/Orca/routing/team-builder.md):

1. **"Build a RAG-based customer support assistant"** → Tier C, 10-14 agents, AI/LLM focus, no design pipeline.
2. **"Build a manufacturing defect detection system"** → Tier D, 12-16 agents, Computer Vision focus, no LLM/NLP.
3. **"Build a Next.js e-commerce website"** → Tier B, 9-12 agents, full design pipeline, no AI/ML.
4. **"Build a lightweight CLI log parser"** → Tier A, 3-4 agents, minimal squad, zero overhead.
