# Orca Agent Routing Policy

This document defines the formal protocols for dispatching tasks, managing handoffs, executing gates, and maintaining consensus across the Orca Agent Operating System.

## 1. Principles of Routing

1. **Strict Justification**: No specialist agent is activated without explicit requirement triggers defined in [capability-matrix.yaml](file:///d:/Orca/routing/capability-matrix.yaml).
2. **Hierarchical Authority**: Senior agents define specifications and sign off; worker subagents execute within isolated git branches/worktrees.
3. **Evidence-Based Gates**: Progress between lifecycle phases requires passing strict verification gates.

## 2. Dynamic Team Assembly Lifecycle

```
[ USER PROMPT / SPEC ]
          │
          ▼
[ Requirement Analyzer ] ───► Generates Capability Map & Squad Manifest
          │
          ▼
   [ Team Builder ] ────────► Initializes Dynamic Squad & Worktree Topology
          │
          ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 1: ARCHITECTURE                  │
│  Senior System Architect + Security + Cloud + DB Architect  │
│  Outputs: ADRs, System Blueprint, Data Models                │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 2: DESIGN GATE                   │
│  Pinterest -> Design Res -> UX -> Product Designer          │
│  GATE: Brand Guardian [APPROVE / REJECT]                    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 3: DETAILED DESIGN               │
│  Senior System Designer -> OpenAPI specs, Component Specs   │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 4: IMPLEMENTATION                │
│  Parallel Worktrees: Frontend, Backend, AI/ML Specialists   │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 5: VERIFICATION                  │
│  QA Architect (Unit/Integration) + Visual QA (Screenshots)  │
│  + Performance Engineer + Security Audit                    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│                      PHASE 6: RALPH LOOP                    │
│  Autonomous Evaluation -> PASS (Merge) / FAIL (Iterate)     │
└─────────────────────────────────────────────────────────────┘
```

## 3. Handoff Protocol

Every agent handoff must contain:
1. **Source Agent & Timestamp**
2. **Artifact Reference Links** (clickable markdown links)
3. **Explicit Contract / Input Data**
4. **Acceptance Criteria for Next Agent**
5. **Known Blockers / Assumptions**

## 4. Conflict Resolution & Escalation

- **Architectural Conflicts**: Senior System Architect makes final decision; documented in ADR.
- **Design / Brand Conflicts**: Brand Guardian makes final aesthetic decision.
- **Security Vulnerabilities**: Senior Security Engineer has veto power over any deployment.
- **Quality Failures**: Senior QA Architect blocks PR merge if evidence/tests fail.
