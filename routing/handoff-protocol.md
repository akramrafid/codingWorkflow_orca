# Orca Agent Handoff Protocol

This document defines the formal protocols, structured data contracts, quality gates, and rejection-recovery lifecycles governing all inter-agent communication, delegation, and artifact transitions across the Orca Agent Operating System.

Every handoff must be deterministic, auditable, and backed by verifiable evidence.

---

## 1. Universal Handoff Envelope Specification

Whenever an agent transitions work to another agent or triggers a downstream phase, it must emit a structured **Handoff Envelope** in Markdown or JSON format adhering to the following schema:

```yaml
handoff_envelope:
  version: "1.0.0"
  timestamp: "YYYY-MM-DDTHH:MM:SSZ"
  source_agent: "<agent-name>"
  target_agent: "<agent-name>"
  current_phase: "PHASE_X"
  target_phase: "PHASE_Y"
  
  artifacts:
    - name: "Artifact Title"
      uri: "file:///D:/Orca/path/to/artifact.ext"
      type: "spec | code | test | design | config | report"
      checksum_or_git_sha: "<git-sha-or-hash>"
      
  contracts:
    input_schemas: ["file:///D:/Orca/path/to/schema.json"]
    interface_definitions: ["file:///D:/Orca/path/to/openapi.yaml"]
    token_definitions: ["file:///D:/Orca/path/to/tokens.css"]

  acceptance_criteria:
    - id: "AC-01"
      description: "Concrete requirement that target agent must verify or satisfy"
      verification_method: "test | audit | visual_diff | benchmark"

  assumptions_and_blockers:
    assumptions:
      - tag: "[ASSUMPTION]"
        description: "Explicit assumption made due to missing upstream info"
        review_owner: "<agent-name>"
    blockers:
      - tag: "[UNKNOWN — requires clarification]"
        description: "Known blocker requiring resolution"

  quality_status:
    architecture_status: "PASSED | PENDING | NOT_APPLICABLE"
    brand_status: "PASSED | PENDING | NOT_APPLICABLE"
    security_status: "PASSED | PENDING | NOT_APPLICABLE"
    qa_status: "PASSED | PENDING | NOT_APPLICABLE"
    performance_status: "PASSED | PENDING | NOT_APPLICABLE"
```

---

## 2. Phase-by-Phase Handoff Workflows

```
PHASE 0: Discovery
  └─► requirement-analyzer
        ├─► Handoff 0.1 ─► senior-system-architect (Phase 1)
        └─► Handoff 0.2 ─► senior-product-manager (Phase 1.5)

PHASE 1 & 1.5: Architecture & Product Strategy
  ├─► senior-system-architect (ADRs, rendering, caching, data models)
  └─► senior-product-manager (PRD, SEO spec, CRO funnel, user stories)
        └─► Handoff 1.0 ─► Design Pipeline & senior-system-designer (Phase 2 & 3)

PHASE 2: Design Pipeline & Brand Gate
  └─► pinterest-researcher ─► design-researcher ─► ux-researcher
        ─► senior-product-designer ─► ui-designer
              └─► Handoff 2.0 (GATE) ─► brand-guardian (APPROVE / REVISE / REJECT)
                    └─► Handoff 2.1 (Locked Tokens) ─► senior-frontend-engineer

PHASE 3: Detailed Technical Design
  └─► senior-system-designer
        └─► Handoff 3.0 (API Contracts) ─► Implementation Tracks (Phase 4)

PHASE 4: Parallel Implementation
  ├─► senior-frontend-engineer (Worktree: worktree/frontend)
  ├─► senior-backend-engineer  (Worktree: worktree/backend)
  ├─► AI/ML Specialists        (Worktree: worktree/ai)
  └─► senior-devops-engineer   (Worktree: worktree/devops)
        └─► Handoff 4.0 ─► Verification Track (Phase 5)

PHASE 5: Integration & Verification Track (Parallel Audits)
  ├─► senior-qa-architect       (Unit, Integration, E2E, SEO suites)
  ├─► visual-qa                 (4 Viewport screenshots, visual diffs, dark mode)
  ├─► senior-performance-engineer (Lighthouse CI, load tests, bundle analysis)
  └─► senior-security-engineer  (SAST/DAST scans, secret detection, headers)
        └─► Handoff 5.0 ─► Ralph Autonomous Loop (Phase 6)

PHASE 6: Ralph Autonomous Evaluation Loop
  └─► Ralph Evaluator (Pass / Fail / Retry Loop)
        └─► Handoff 6.0 ─► senior-devops-engineer (Phase 7 Deployment)

PHASE 7: Production Deployment
  └─► senior-devops-engineer (Canary/Blue-Green Deploy, health checks)
        └─► Human Release Sign-Off
```

### Detailed Handoff Contracts

#### Handoff 0.1 / 0.2: Requirement Analyzer → System Architect & Product Manager
- **Source**: `requirement-analyzer`
- **Targets**: `senior-system-architect`, `senior-product-manager`
- **Payload**: Capability Map, Technology Domain Matrix, SEO Strategy Brief, Conversion Funnel Assessment, Team Activation Manifest, Initial Risk Register.
- **Contract Rule**: All missing information must be tagged with `[UNKNOWN — requires clarification]`. Never fabricate requirements.

#### Handoff 1.0: Strategy & Architecture → Design Pipeline & Detailed Design
- **Sources**: `senior-system-architect`, `senior-product-manager`
- **Targets**: `senior-product-designer`, `senior-system-designer`, `pinterest-researcher`, `ux-researcher`
- **Payload**: PRD with User Story Acceptance Criteria, SEO Specification (titles, meta, structured data types), Conversion Blueprint (CTA priorities, trust signals), Architecture Decision Records (ADRs), Rendering Strategy (SSR/SSG/ISR).

#### Handoff 2.0 (MANDATORY GATE): UI Designer → Brand Guardian
- **Source**: `ui-designer` (supported by `senior-product-designer`)
- **Target**: `brand-guardian`
- **Payload**: High-fidelity visual specifications, CSS Design Tokens (`--color-primary`, `--font-family`, `--shadow-elevation`, etc.), Component state matrices, Mobile/Desktop responsive layouts.
- **Gate Evaluation**:
  - `APPROVED`: Tokens locked into CSS file. Handoff to `senior-frontend-engineer` authorized.
  - `CHANGES REQUIRED`: Detailed defect log returned to `ui-designer`.
  - `REJECTED`: Design fundamentally fails aesthetic bar or plagiarizes third-party styles; full redesign initiated.

#### Handoff 3.0: Detailed Design → Parallel Implementation Squad
- **Source**: `senior-system-designer`
- **Targets**: `senior-frontend-engineer`, `senior-backend-engineer`, `senior-data-engineer`, AI/ML Specialists
- **Payload**: OpenAPI 3.1 specifications, GraphQL schemas, database entity models from `senior-database-architect`, sequence diagrams, error response standards.
- **Contract Rule**: Frontend and Backend worktrees branch simultaneously from this locked contract.

#### Handoff 4.0: Implementation Worktrees → Verification Track
- **Sources**: `senior-frontend-engineer`, `senior-backend-engineer`, AI Specialists, `senior-devops-engineer`
- **Targets**: `senior-qa-architect`, `visual-qa`, `senior-performance-engineer`, `senior-security-engineer`
- **Payload**: Feature branch references, pre-commit verification logs (clean lint, zero type errors), build artifacts, deployed preview environments.

#### Handoff 5.0: Verification Track → Ralph Loop & Release Gate
- **Sources**: QA, Visual QA, Performance, and Security Leads
- **Targets**: Ralph Autonomous Loop, `senior-devops-engineer`
- **Payload**: Consolidated Master Test Report, Lighthouse CI Report (Perf ≥ 90, SEO ≥ 95), Visual QA Sign-off across 4 viewports, SAST/DAST Clean Scan Report.

---

## 3. Dynamic Specialist Activation & Request Protocol

Specialists are not pre-assigned blindly. When a senior agent discovers that a task requires deep domain capability, it issues an **Agent Activation Request**:

```markdown
### Agent Activation Request
- **Requesting Agent**: `<requesting-agent>`
- **Requested Specialist**: `<specialist-agent>`
- **Domain Trigger**: `authentication_rbac | vector_search_rag | streaming_etl | fine_tuning | visual_identity_redesign | computer_vision | generative_media`
- **Task Scope**: Specific deliverable required from specialist
- **Input Artifacts**: Links to upstream specifications
- **Target Worktree**: `worktree/<domain>`
```

### Supported Dynamic Request Routes:
- `senior-ai-engineer` ──requests──► `senior-llm-engineer` | `senior-nlp-engineer` | `senior-deep-learning-engineer` | `senior-generative-ai-engineer` | `senior-computer-vision-engineer` | `senior-ai-research-engineer` | `senior-mlops-engineer`
- `senior-system-architect` ──requests──► `senior-cloud-architect` | `senior-database-architect` | `senior-system-designer`
- `senior-backend-engineer` ──requests──► `senior-database-architect` (query tuning/migrations) | `senior-security-engineer` (auth review)
- `senior-frontend-engineer` ──requests──► `ui-designer` (missing component states) | `visual-qa` (preview verification)
- `senior-devops-engineer` ──requests──► `senior-cloud-architect` (IaC topology) | `senior-mlops-engineer` (cluster serving)

---

## 4. Rejection and Revision Loops

When a verification gate or senior lead rejects a deliverable, the following **Rejection Protocol** executes:

```
┌─────────────────────────────────────────────────────────────┐
│                    GATE REJECTION EVENT                     │
│  Rejecting Agent issues structured REJECTION NOTICE         │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                   ITERATION COUNTER CHECK                   │
│  Task Iteration < 3?                                         │
├──────────────────────────────┬──────────────────────────────┤
│             YES              │              NO              │
│  Route back to source agent  │  CIRCUIT BREAKER TRIGGERED   │
│  with actionable revisions   │  Escalate to Human / Lead    │
└──────────────────────────────┴──────────────────────────────┘
```

### Rejection Notice Format

```markdown
## [GATE REJECTION] <Gate Name> — Iteration <N>/3

- **Rejecting Authority**: `<agent-name>`
- **Rejected Artifact**: `[<artifact-name>](<file-uri>)`
- **Source Agent**: `<agent-name>`
- **Defect Classification**: `CRITICAL_SECURITY | QUALITY_REGRESSION | BRAND_VIOLATION | PERF_BUDGET_BREACH | ARCH_DEVIATION | SEO_DEFECT`

### Specific Failure Points:
1. **[Requirement]**: Explanation of failure with reproducible log/screenshot/diff.
2. **[Remediation Directive]**: Unambiguous, step-by-step instruction on how to correct the issue.

### Resubmission Prerequisites:
- Specific verification command or audit that must pass before resubmitting.
```

### Escalation Hierarchy on Rejection:
1. **Iteration 1 & 2**: Iterative rework by the assigned specialist.
2. **Iteration 3 (Circuit Breaker)**: Rework is halted. Task escalates to the supervising Domain Lead (e.g. `senior-system-architect` for technical flaws, `brand-guardian` for visual flaws, `senior-security-engineer` for CVEs).
3. **Unresolved Domain Lead Conflict**: Escalate to Human Operator with complete trajectory and issue summary.

---

## 5. Evidence & Completion Manifest Standards

No agent may sign off or mark a task complete without the **Orca Completion Manifest**:

1. **Implementation Evidence**: Clean Git diff showing exact modifications.
2. **Test Evidence**: Terminal execution logs showing zero errors across lint, typecheck, unit, and integration tests.
3. **SEO & Performance Evidence**: Lighthouse CI score report (Performance ≥ 90, SEO ≥ 95), valid sitemap.xml, SSR HTML verification.
4. **Visual Evidence**: Viewport screenshots (375px, 768px, 1280px, 1920px) confirming design fidelity and dark mode correctness.
5. **Security Evidence**: Dependency vulnerability audit report showing 0 critical/high CVEs, security header verification.
