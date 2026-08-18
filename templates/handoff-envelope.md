# Orca Handoff Envelope Template

Use this template for every inter-phase handoff in the Orca lifecycle. Copy and fill in the relevant sections.

---

## Handoff Envelope

```markdown
# Phase [N] → Phase [N+1] Handoff

**Handoff ID**: HO-[N]-[N+1]-[timestamp]
**Source Agent**: `<source-agent-name>`
**Target Agent(s)**: `<target-agent-name-1>`, `<target-agent-name-2>`
**Source Phase**: Phase [N] — [Phase Name]
**Target Phase**: Phase [N+1] — [Phase Name]
**Timestamp**: [YYYY-MM-DDTHH:MM:SSZ]
**Project**: [project-name]

---

## Produced Artifacts

| Artifact | Type | Location | Git SHA / Checksum |
|----------|------|----------|-------------------|
| [Name] | spec / code / test / design / config / report | [file:///path/to/file] | [sha] |

---

## Interface Contracts

- **Input Schemas**: [link to schema files]
- **API Definitions**: [link to OpenAPI/GraphQL specs]
- **Design Tokens**: [link to tokens.css]

---

## Acceptance Criteria for Next Phase

- [ ] AC-01: [Concrete, verifiable requirement]
- [ ] AC-02: [Concrete, verifiable requirement]
- [ ] AC-03: [Concrete, verifiable requirement]

**Verification Methods**: test | audit | visual_diff | benchmark | manual_review

---

## Quality Status

| Gate | Status | Notes |
|------|--------|-------|
| Architecture | PASSED / PENDING / N/A | |
| Brand | PASSED / PENDING / N/A | |
| Security | PASSED / PENDING / N/A | |
| QA | PASSED / PENDING / N/A | |
| Performance | PASSED / PENDING / N/A | |

---

## Assumptions & Blockers

### Assumptions
- [ASSUMPTION] [Description of assumption made due to missing info] — Review Owner: `<agent-name>`

### Blockers
- [UNKNOWN — requires clarification] [Description of blocker]

### Known Risks
- [RISK] [Description] — Mitigation: [strategy]

---

## Context for Target Agent

[Free-form instructions, context, or guidance for the target agent. Include any decisions made, trade-offs accepted, and specific implementation notes.]
```

---

## Common Handoff Workflows

### Handoff 0→1: Requirement Analyzer → Architecture Squad
- **Payload**: Capability Map, Technology Domain Matrix, Team Activation Manifest, Risk Register
- **Key Rule**: All missing information tagged with `[UNKNOWN — requires clarification]`

### Handoff 1→2: Architecture → Design Pipeline
- **Payload**: PRD, ADRs, SEO Specification, Conversion Blueprint, Rendering Strategy
- **Key Rule**: Rendering strategy (SSR/SSG/ISR) must be decided before design begins

### Handoff 2→3: Design Pipeline → Technical Design
- **Payload**: Locked CSS Design Tokens, High-fidelity UI specs, Component state matrices
- **Key Rule**: Brand Guardian must APPROVE before tokens are locked

### Handoff 3→4: Technical Design → Implementation
- **Payload**: OpenAPI 3.1 specs, Component contracts, Sequence diagrams, Error handling strategy
- **Key Rule**: Frontend and Backend branch simultaneously from locked contracts

### Handoff 4→5: Implementation → Verification
- **Payload**: Feature branch references, Pre-commit verification logs, Build artifacts
- **Key Rule**: All branches must pass lint/typecheck/test before verification begins

### Handoff 5→6: Verification → Ralph Loop
- **Payload**: Test reports, Lighthouse CI report, Visual QA screenshots, Security scan results
- **Key Rule**: All verification evidence must be machine-parseable for Ralph evaluation

### Handoff 6→7: Ralph → Deployment
- **Payload**: All-PASS evaluation report, Merged integration branch
- **Key Rule**: Human approval required for production deployment
