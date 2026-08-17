# Orca Parallelism and Concurrency Rules

This document establishes the concurrency models, Git worktree isolation topologies, sequential dependencies, and conflict resolution protocols for multi-agent parallel execution in the Orca Agent Operating System.

---

## 1. Principles of Parallel Execution

1. **Contract-First Concurrency**: Agents may only execute in parallel once upstream interface contracts (OpenAPI specs, database schemas, CSS design tokens) are locked and approved.
2. **Worktree Isolation**: Parallel agents operate in dedicated, isolated Git worktrees (`worktree/<domain>`). No two agents write to the same branch or dirty working directory simultaneously.
3. **Deterministic Merge Ordering**: Merges to the integration branch follow a strictly defined topology to prevent merge conflicts and schema skew.
4. **Independent Verifiability**: Every parallel branch must be independently testable with passing pre-commit hooks (lint, typecheck, unit tests) prior to integration.
5. **Dynamic Concurrency Scaling**: Concurrency dynamically scales to match project complexity — a lightweight script involves zero parallel overhead, while a multi-tier platform spins up isolated parallel tracks.

---

## 2. Phase-by-Phase Concurrency Matrix

| Lifecycle Phase | Concurrency Mode | Active Agents | Prerequisites / Inputs | Outputs & Handoff |
| :--- | :--- | :--- | :--- | :--- |
| **Phase 0: Discovery** | **Sequential** | `requirement-analyzer` | Raw user brief, constraints | Capability Map, Squad Activation Manifest |
| **Phase 1: Architecture & Strategy** | **Parallel Track** | `senior-system-architect`<br>`senior-product-manager`<br>`senior-security-engineer`<br>`senior-database-architect`<br>`senior-cloud-architect` | Capability Map from Phase 0 | PRD, ADRs, Threat Model, ERDs, Cloud Blueprint |
| **Phase 2A: Design Research** | **Parallel Track** | `pinterest-researcher`<br>`design-researcher`<br>`ux-researcher` | PRD and style keywords | Moodboards, Competitor UI analysis, Personas |
| **Phase 2B: Design Synthesis** | **Sequential Pipeline** | `senior-product-designer` →<br>`ui-designer` →<br>`brand-guardian` (GATE) | Research reports from Phase 2A | High-fidelity UI specs, **Locked CSS Design Tokens** |
| **Phase 3: Detailed Tech Design** | **Sequential Bridge** | `senior-system-designer` | ADRs, ERDs, and locked design tokens | **Locked OpenAPI 3.1 & Component Contracts** |
| **Phase 4: Parallel Implementation** | **High-Concurrency Isolated Worktrees** | `senior-frontend-engineer`<br>`senior-backend-engineer`<br>`senior-data-engineer`<br>`senior-devops-engineer`<br>AI/ML Specialists (`senior-llm-engineer`, `senior-deep-learning-engineer`, etc.) | Locked API contracts and CSS tokens | Feature branches with passing local tests |
| **Phase 5: Verification Track** | **Parallel Audit Track** | `senior-qa-architect`<br>`visual-qa`<br>`senior-performance-engineer`<br>`senior-security-engineer` | Integrated feature preview build | Master Test Report, Screenshot Dossier, Lighthouse CI, SAST/DAST Report |
| **Phase 6: Ralph Autonomous Loop** | **Sequential Evaluator** | Ralph Evaluator | Consolidated verification evidence | Merge clearance or iteration directives |
| **Phase 7: Production Release** | **Sequential Pipeline** | `senior-devops-engineer` | All gates PASSED | Production Canary/Blue-Green deployment |

---

## 3. Worktree Topology and Merge Sequencing

### Worktree Allocation Scheme

```
repo-root/ (master)
  ├── .worktrees/
  │     ├── worktree-backend/      (branch: feat/backend-api)     ── senior-backend-engineer
  │     ├── worktree-frontend/     (branch: feat/frontend-ui)     ── senior-frontend-engineer
  │     ├── worktree-ai/           (branch: feat/ai-ml-service)   ── AI/ML Specialists
  │     ├── worktree-data/         (branch: feat/data-pipeline)   ── senior-data-engineer
  │     └── worktree-devops/       (branch: feat/infra-cicd)      ── senior-devops-engineer
```

### Deterministic Merge Hierarchy

When Phase 4 implementations finish, branches must merge into the `staging` integration branch in the following sequence:

```
Step 1: Database & Data Schema  (senior-database-architect / senior-data-engineer)
         │  Migrations applied and verified against test database
         ▼
Step 2: Backend Services & APIs (senior-backend-engineer)
         │  API endpoints verified against OpenAPI contracts with mock database
         ▼
Step 3: AI / ML Services        (senior-ai-engineer / specialists)
         │  Model serving and inference endpoints integrated with backend
         ▼
Step 4: Frontend UI             (senior-frontend-engineer)
         │  SSR/SSG pages connected to backend endpoints and design tokens
         ▼
Step 5: DevOps & CI/CD          (senior-devops-engineer)
         │  Deployment descriptors, container definitions, and monitoring
         ▼
Step 6: Integration Test Suite  (senior-qa-architect)
            Full verification runs on unified codebase
```

---

## 4. Concurrency Guardrails & Conflict Resolution

1. **Shared File Lockout**:
   - `package.json` / `go.mod` / `pyproject.toml`: Dependency additions must be coordinated or added during Phase 1/3 scaffolding. If two agents modify dependencies simultaneously, the `senior-system-architect` resolves version locks.
   - Database Migrations: Migration timestamp numbering is sequential. The `senior-database-architect` assigns migration sequence numbers to prevent ordering collisions.
   - Design Tokens (`tokens.css`): Exclusively authored and locked by `brand-guardian` / `ui-designer`. Frontend engineers consume tokens as read-only variables.

2. **Integration Conflict Protocol**:
   - If a merge conflict arises during Phase 5 integration, the `senior-system-architect` arbitrates the resolution.
   - Under no circumstances may an agent force-push (`git push --force`) or overwrite another agent's worktree.

---

## 5. Dynamic Concurrency Scaling

The Orca operating system dynamically adapts concurrency based on project profile:

### Profile A: Lightweight / Single-Domain Project (e.g., CLI tool, Static Landing Page)
- **Active Agents**: 3–5 agents (e.g., `requirement-analyzer` → `senior-system-architect` → `senior-frontend-engineer` → `senior-qa-architect`).
- **Concurrency**: Fully sequential. Zero worktree branching overhead.

### Profile B: Full-Stack Web Application (e.g., SaaS Platform)
- **Active Agents**: 10–12 agents.
- **Concurrency**: Standard 2-track parallel implementation (`worktree-backend` + `worktree-frontend`) and 4-track verification.

### Profile C: Enterprise AI / ML Multimodal Platform
- **Active Agents**: 15–20+ agents.
- **Concurrency**: Full 5-track parallel implementation (`backend`, `frontend`, `ai`, `data`, `devops`) with asynchronous ML training/eval pipelines and automated continuous testing.
