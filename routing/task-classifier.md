# Orca Task Classifier

The **Task Classifier** evaluates incoming tasks, subagent delegations, and autonomous loop steps to categorize their complexity, domain sensitivity, and operational constraints.

## Classification Dimensions

### 1. Task Domain
- `ARCH`: High-level architecture, topology, ADRs, interface contracts.
- `DESIGN`: UI/UX, visual tokens, layout wireframes, moodboards.
- `CODE_FRONTEND`: React, Next.js, HTML, CSS, DOM rendering.
- `CODE_BACKEND`: APIs, databases, queue processors, business logic.
- `AI_ML`: Model training, prompts, fine-tuning, RAG pipelines, evals.
- `DEVOPS`: Docker, CI/CD, cloud IaC, Kubernetes, networking.
- `QA_AUDIT`: Test authoring, visual inspection, security auditing, benchmark load testing.

### 2. Complexity Tier
- **Tier 1 (Trivial/Refactor)**: Syntax fixes, formatting, lint cleanup, single-file edits.
- **Tier 2 (Component/Feature)**: Discrete endpoint implementation, single UI component, unit test additions.
- **Tier 3 (Subsystem/Module)**: Multi-file feature, database migration with repository layer, RAG pipeline.
- **Tier 4 (System/Architectural)**: Cross-service contracts, full stack application setup, system redesigns.

### 3. Risk Profile
- `LOW`: Isolated unit tests, documentation, exploratory scripts.
- `MEDIUM`: Internal API endpoints, new UI components, non-destructive migrations.
- `HIGH`: Auth logic, cryptography, payment flows, destructive database operations, production infrastructure.
