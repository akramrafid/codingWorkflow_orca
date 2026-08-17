# Orca Agent Activation and Squad Formation Policy

This document defines the governance rules, capability inference algorithms, anti-bloat constraints, and gate-binding policies executed by the **Orca Dynamic Team Builder**.

---

## 1. Capability-Driven Activation Philosophy

Orca builds software using **Capability-Based Reasoning**, not naive keyword matching. 

A project prompt is an expression of user intent that implies a deep graph of technical, architectural, quality, and operational prerequisites. The Team Builder's duty is to analyze what must be true for the system to succeed in production, resolve the transitive closure of capabilities, and provision the minimal sufficient squad.

### The Three Anti-Bloat Laws:
1. **No Unjustified Activations**: An agent is never activated because "they exist in the catalog." Every activated agent must trace directly to a required capability in [capability-resolution.yaml](file:///D:/Orca/routing/capability-resolution.yaml).
2. **Domain Non-Contagion**: Capabilities in one domain do NOT activate unrelated specialists in another. An AI/RAG project does not activate Computer Vision; an E-Commerce web app does not activate NLP/LLM engineers unless explicitly required.
3. **Explicit Exclusion Requirement**: Every Team Plan must publish an `excluded_agents` manifest with concrete justifications explaining why unselected agents were excluded.

---

## 2. Dynamic Team Assembly Algorithm

```
┌─────────────────────────────────────────────────────────────┐
│             INPUT: Product Brief / Requirement Brief        │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 1: Semantic Intent Analysis & Domain Classification   │
│ Classify domain profile (saas, ai_rag, vision, ml, etc.)    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 2: Capability Extraction & Transitive Closure          │
│ Extract explicit capabilities → Traverse implied sub-caps   │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 3: Squad Deduplication & Role Segregation              │
│ Separate into Senior Leads, Specialists, and Support Roles   │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 4: Standby & Exclusion Filtering                       │
│ Partition unactivated agents into Optional vs Excluded      │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 5: Dependency DAG & Worktree Concurrency Grouping      │
│ Establish topological ordering; assign isolated worktrees   │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ STEP 6: Mandatory Review Gate Binding                       │
│ Attach Architecture, Brand, Security, QA, Perf, Deploy gates│
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ OUTPUT: Machine-Readable Team Plan (team-plan.json)         │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Mandatory Review Gate Binding Rules

Every generated Team Plan must bind review gates according to the capabilities active in the project:

| Active Capability / Change Type | Mandatory Gate | Owning Lead Agent | Veto Power |
| :--- | :--- | :--- | :---: |
| Any system architecture, ADR, or rendering decision | **Architecture Gate** | `senior-system-architect` | **YES** |
| Any user-facing UI, design tokens, or aesthetic assets | **Brand Gate** | `brand-guardian` | **YES** |
| Auth, RBAC, secrets, cryptography, or public endpoints | **Security Gate** | `senior-security-engineer` | **YES** |
| Any application code, API implementation, or data DAG | **QA Gate** | `senior-qa-architect` | **YES** |
| Web frontend rendering or high-throughput API endpoints | **Performance Gate** | `senior-performance-engineer` | **YES** |
| UI layouts, responsive breakpoints, or dark mode | **Visual QA Gate** | `visual-qa` | **YES** |
| Deployment to staging or production infrastructure | **Release Gate** | `senior-devops-engineer` | **YES** |

---

## 4. Squad Sizing Heuristics

The Team Builder assigns squads to one of four organizational tiers:

### Tier A: Lightweight Utility / CLI Tool
- **Target**: Standalone scripts, local CLI utilities, documentation generators.
- **Squad Size**: 3–4 agents.
- **Active Agents**: `requirement-analyzer`, `senior-system-architect`, `senior-backend-engineer`, `senior-qa-architect`.
- **Parallelism**: Single sequential track (`main`).

### Tier B: Modern Web Application / SaaS Platform
- **Target**: Production web applications, marketing sites, customer portals.
- **Squad Size**: 9–12 agents.
- **Active Agents**: System Architect, Product Manager, Product Designer, UI Designer, Brand Guardian, Frontend Engineer, Backend Engineer, Database Architect, Security Engineer, QA Architect, Performance Engineer, Visual QA, DevOps Engineer.
- **Parallelism**: 2 parallel implementation worktrees (`worktree/frontend`, `worktree/backend`) + 4-track verification.

### Tier C: Enterprise AI / ML / RAG System
- **Target**: RAG applications, vector search platforms, multi-agent AI assistants.
- **Squad Size**: 10–14 agents.
- **Active Agents**: System Architect, Product Manager, AI Engineer, LLM Engineer, NLP Engineer, Database Architect, Backend Engineer, Security Engineer, QA Architect, Performance Engineer, MLOps Engineer, DevOps Engineer.
- **Parallelism**: 3 parallel implementation worktrees (`worktree/ai`, `worktree/backend`, `worktree/devops`).

### Tier D: Multimodal / Deep Learning / Computer Vision Platform
- **Target**: Defect detection, video stream analytics, multimodal generative systems.
- **Squad Size**: 12–16 agents.
- **Active Agents**: System Architect, AI Engineer, Computer Vision Engineer / Generative AI Engineer, Deep Learning Engineer, Data Engineer, MLOps Engineer, Backend Engineer, Security Engineer, QA Architect, Performance Engineer, DevOps Engineer.
- **Parallelism**: 4 parallel implementation worktrees (`worktree/ai`, `worktree/data`, `worktree/backend`, `worktree/devops`).

---

## 5. Invariant Governance Rules

1. **Role Invariance**: A specialist agent (e.g. `senior-frontend-engineer`) can NEVER be granted lead approval authority over architectural ADRs or brand token locks.
2. **No Orphan Specialists**: Every specialist agent included in `specialist_agents` MUST have a designated `supervising_lead` in `senior_agents`.
3. **Escalation Feasibility**: Every active specialist must have an unambiguous escalation target for blocking issues.
4. **Verification Completeness**: No implementation track may exist without a corresponding verification path in Phase 5.
