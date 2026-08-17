# Orca Agent Routing Policy

This document defines the formal protocols for dispatching tasks, managing handoffs, executing quality gates, and maintaining production readiness across the Orca Agent Operating System.

Every routing decision serves one goal: deliver software that is industry-standard, SEO-optimized, conversion-ready, fast, and production-deployable.

---

## 1. Principles of Routing

1. **Strict Justification**: No specialist agent is activated without explicit requirement triggers defined in [capability-matrix.yaml](file:///d:/Orca/routing/capability-matrix.yaml).
2. **Hierarchical Authority**: Senior agents define specifications and sign off; worker subagents execute within isolated git branches/worktrees.
3. **Evidence-Based Gates**: Progress between lifecycle phases requires passing strict verification gates. No gate is skippable.
4. **Production-Ready Default**: Every agent assumes the output will serve real users in production. There is no "we'll optimize later" — performance, SEO, and security are implemented from the start.
5. **Conversion Awareness**: Every user-facing page must have a clear purpose and measurable call-to-action. Dead-end pages are treated as bugs.

---

## 2. Dynamic Team Assembly Lifecycle

```
[ USER PROMPT / PRODUCT REQUIREMENT ]
          │
          ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 0: ANALYSIS                      │
│  Requirement Analyzer                                        │
│  Outputs: Capability Map, SEO Strategy, Conversion Funnel,   │
│           Team Activation Manifest, Risk Register            │
│  ★ GATE: All unknowns flagged before proceeding              │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 1: ARCHITECTURE                  │
│  Senior System Architect + Security + Cloud + DB Architect  │
│  Outputs: ADRs, System Blueprint, Rendering Strategy (SSR/  │
│           SSG/ISR), Caching Topology, Data Models,           │
│           Performance Budgets, Security Architecture         │
│  ★ GATE: ADRs reviewed, rendering strategy decided           │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 1.5: PRODUCT STRATEGY            │
│  Senior Product Manager                                      │
│  Outputs: PRD, SEO Specification (page titles, meta desc,    │
│           structured data plan, URL structure), Conversion    │
│           Funnel Blueprint, Analytics Event Taxonomy,         │
│           User Story Backlog with acceptance criteria         │
│  ★ GATE: PRD includes SEO + CRO strategy sections            │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 2: DESIGN PIPELINE               │
│  Pinterest Researcher → Design Researcher → UX Researcher   │
│  Senior Product Designer → UI Designer                      │
│  ★ MANDATORY GATE: Brand Guardian                            │
│    Evaluates: Brand alignment, aesthetic quality, conversion │
│    readiness (CTA prominence, trust signals, visual flow),   │
│    accessibility contrast ratios                             │
│    Verdict: APPROVED / CHANGES REQUIRED / REJECTED           │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 3: DETAILED TECHNICAL DESIGN     │
│  Senior System Designer                                      │
│  Outputs: OpenAPI 3.1 specs, Component contracts, Sequence   │
│           diagrams, Error handling strategy, Caching specs    │
│  ★ GATE: API contracts reviewed by Backend + Frontend leads  │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 4: PARALLEL IMPLEMENTATION       │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐   │
│  │ Frontend  │  │ Backend  │  │  AI/ML   │  │  DevOps  │   │
│  │ Worktree  │  │ Worktree │  │ Worktree │  │ Worktree │   │
│  ├──────────┤  ├──────────┤  ├──────────┤  ├──────────┤   │
│  │ SSR/SSG  │  │ APIs     │  │ Models   │  │ CI/CD    │   │
│  │ SEO meta │  │ Caching  │  │ RAG      │  │ Docker   │   │
│  │ CRO UI   │  │ Auth     │  │ Training │  │ IaC      │   │
│  │ Perf     │  │ Sitemap  │  │ Evals    │  │ Monitors │   │
│  └──────────┘  └──────────┘  └──────────┘  └──────────┘   │
│  Each worktree: pre-commit hooks (lint, typecheck, test)    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 5: VERIFICATION                  │
│                                                              │
│  ┌─── QA Architect ─────────────────────────────────────┐   │
│  │ Unit tests (≥80% coverage)                            │   │
│  │ Integration tests (all API endpoints)                 │   │
│  │ E2E tests (critical user journeys)                    │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌─── Visual QA ────────────────────────────────────────┐   │
│  │ Screenshots at 375px, 768px, 1280px, 1920px          │   │
│  │ Visual diff against approved designs                  │   │
│  │ Dark mode verification                                │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌─── Performance Engineer ─────────────────────────────┐   │
│  │ Lighthouse CI (Performance ≥90, SEO ≥95, A11y ≥95)   │   │
│  │ Load tests (API p95 < 200ms)                          │   │
│  │ Bundle size analysis (< 200KB gzipped initial)        │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                              │
│  ┌─── Security Engineer ────────────────────────────────┐   │
│  │ SAST/DAST scan (zero critical/high CVEs)             │   │
│  │ Security header verification                          │   │
│  │ Secret leak detection                                 │   │
│  └───────────────────────────────────────────────────────┘   │
│                                                              │
│  ★ GATE: Production Readiness Checklist (ARCHITECTURE.md)   │
│    ALL categories must PASS: Performance, SEO, Security,     │
│    Conversion, Testing, Reliability                          │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 6: RALPH AUTONOMOUS LOOP         │
│                                                              │
│  Ralph Evaluator verifies every task against:               │
│  • Core criteria (tests, build, git state)                  │
│  • SEO criteria (meta tags, structured data, SSR)           │
│  • Performance criteria (Lighthouse, bundle size, CLS)      │
│  • Conversion criteria (CTAs, trust signals, empty states)  │
│  • Security criteria (headers, validation, no secrets)      │
│                                                              │
│  Verdict: PASS → merge | FAIL → retry (max 3) → escalate   │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 7: DEPLOYMENT                    │
│  Senior DevOps Engineer deploys via CI/CD pipeline          │
│  Strategy: Blue/Green or Canary (zero downtime)             │
│  Post-deploy verification:                                   │
│  • Health check endpoint responding                         │
│  • Error rate baseline established                          │
│  • Lighthouse production audit                              │
│  • Google Search Console submission (sitemap)               │
│  ★ GATE: Human approval for production (unless unattended)  │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. Handoff Protocol

Every agent handoff must contain:

1. **Source Agent & Timestamp**: Who produced this artifact and when.
2. **Artifact Reference Links**: Clickable markdown links to all produced files.
3. **Explicit Contract / Input Data**: Structured input the next agent needs.
4. **Acceptance Criteria for Next Agent**: What must be true for the next phase to pass.
5. **Known Blockers / Assumptions**: Documented unknowns or assumptions with `[ASSUMPTION]` tags.
6. **Quality Context**: Current production readiness status (which checklist items are satisfied, which remain).

---

## 4. SEO & Performance Routing Rules

- Every task involving public-facing pages MUST route through SEO criteria in the Ralph Evaluator.
- Every frontend task MUST include Lighthouse CI as a verification command.
- If a task creates new URLs, the Senior Backend Engineer must update sitemap generation.
- If a task modifies existing URLs, redirect rules (301) must be implemented before the old URL goes dead.
- If structured data is required for a page type, it must be implemented before the task can pass.
- Performance budgets (LCP < 2.5s, INP < 200ms, CLS < 0.1) are enforced automatically — not advisory.

---

## 5. Conflict Resolution & Escalation

| Conflict Type | Final Authority | Documentation |
| :--- | :--- | :--- |
| Architectural decisions | Senior System Architect | ADR required |
| Visual design & brand | Brand Guardian | Brand Gate verdict |
| Security vulnerabilities | Senior Security Engineer | Veto power over deployment |
| Quality failures | Senior QA Architect | Blocks PR merge |
| SEO strategy | Senior Product Manager | SEO Specification update |
| Performance budgets | Senior Performance Engineer | Lighthouse CI enforcement |
| Product scope | Senior Product Manager | PRD amendment |

---

## 6. Emergency Protocols

- **Critical Security Vulnerability Discovered**: Senior Security Engineer has immediate veto. All deployment pipelines halt. Fix is expedited through a dedicated hotfix branch bypassing normal queue.
- **Production Performance Regression**: Senior Performance Engineer triggers rollback to last known fast deployment. Root cause analysis required before re-deployment.
- **SEO Regression (Indexing Loss)**: If Google Search Console reports indexing errors after deployment, rollback URL changes and investigate. SEO regressions are treated as P0 bugs.
