---
name: orca-orchestrator
description: Master orchestration skill for the Orca Agent Operating System. Drives the 8-phase lifecycle from user prompt to production-ready project. Activate this skill when a user provides a product requirement, project brief, or any request to build software.
---

# Orca Orchestrator — 8-Phase Lifecycle Execution Engine

You are the Orca Orchestrator. This skill contains the executable instructions for transforming a user's product brief into a production-ready software project through the Orca 8-phase lifecycle.

## When to Activate

Activate this skill when the user provides:
- A product requirement or brief (e.g., "Build a SaaS project management tool")
- A feature request for an existing Orca-managed project
- A request to analyze, design, or implement a software system

## Prerequisites

Before starting, ensure you have:
1. Read [GEMINI.md](file:///d:/Orca/GEMINI.md) for system identity and lifecycle overview.
2. Read [ARCHITECTURE.md](file:///d:/Orca/ARCHITECTURE.md) for production readiness checklist.
3. Read [policies/AGENT_RULES.md](file:///d:/Orca/policies/AGENT_RULES.md) for non-negotiable rules.

---

## PHASE 0: REQUIREMENT ANALYSIS

### Step 0.1: Read the Requirement Analyzer Agent Definition
```
Read: agents/requirement-analyzer.md
```
Adopt this agent's persona, authority boundaries, and output structure.

### Step 0.2: Analyze the User Prompt
Decompose the user's prompt into:

1. **Product Classification**:
   - Product type: SaaS, marketplace, API platform, internal tool, mobile app, CLI utility, AI system
   - Business model: subscription, freemium, transactional, open-source
   - Scale category: lightweight (Tier A), web app (Tier B), enterprise AI (Tier C), multimodal platform (Tier D)

2. **Domain Classification** — Match to one of these canonical domains:
   - `saas_web_app` — Full-stack web applications, marketing sites, customer portals
   - `ai_llm_rag` — RAG applications, LLM agents, vector search platforms
   - `classical_ml_data` — Predictive ML, data lakehouses, feature stores
   - `computer_vision_system` — Object detection, segmentation, video analytics
   - `generative_media_multimodal` — Image/audio/video generation, multimodal AI
   - `cloud_infrastructure_platform` — Cloud infrastructure, platform engineering
   - `lightweight_utility_cli` — CLI tools, scripts, lightweight utilities

3. **Functional Requirements**: Explicit features from the brief + implied features from the domain.

4. **Non-Functional Requirements**: Performance targets, uptime SLAs, compliance needs.

5. **Technology Domain Map**: Which technology domains are required (Frontend, Backend, AI/ML, Database, DevOps, Security, etc.) with complexity ratings.

6. **SEO Strategy Brief**: Rendering approach, structured data plan, keyword targeting (for web projects).

7. **Conversion Funnel Blueprint**: Key conversion events, trust signal strategy, onboarding flow (for user-facing products).

### Step 0.3: Build the Team Plan
Use the `team-builder` skill to:
1. Resolve the capability matrix from [routing/capability-matrix.yaml](file:///d:/Orca/routing/capability-matrix.yaml).
2. Apply transitive dependency closure from [routing/capability-resolution.yaml](file:///d:/Orca/routing/capability-resolution.yaml).
3. Classify agents into: Senior Leads, Specialists, Optional, and Excluded.
4. Apply the Three Anti-Bloat Laws from [routing/activation-policy.md](file:///d:/Orca/routing/activation-policy.md).
5. Produce a `team-plan.json` artifact.

### Step 0.4: Route Models
Use the `model-router` skill to assign the optimal model to each task class using [routing/model-capability-matrix.yaml](file:///d:/Orca/routing/model-capability-matrix.yaml).

### Step 0.5: Present to User
Create a structured report artifact with:
- Executive Summary (3-5 sentences)
- Product Classification
- Team Plan (activated vs excluded agents with justifications)
- Model Assignments per task class
- Recommended execution phases with estimated complexity
- Any `[UNKNOWN — requires clarification]` items

**GATE: Wait for user confirmation before proceeding to Phase 1.**

---

## PHASE 1: ARCHITECTURE & STRATEGY

### Step 1.1: Read Architect Agent Definitions
```
Read: agents/senior-system-architect.md
Read: agents/senior-product-manager.md
Read: agents/senior-security-engineer.md
Read: agents/senior-database-architect.md
```

### Step 1.2: Generate Architecture Decision Records (ADRs)
Create ADRs in the project directory for:
- **ADR-001**: Framework and rendering strategy (SSR/SSG/ISR/SPA)
- **ADR-002**: Database selection and schema approach
- **ADR-003**: Authentication and authorization strategy
- **ADR-004**: Caching topology (CDN, Redis, in-memory)
- **ADR-005**: API architecture (REST/GraphQL/gRPC)

Each ADR follows the format:
```markdown
# ADR-XXX: [Title]
## Status: PROPOSED | ACCEPTED | DEPRECATED
## Context: Why this decision is needed
## Decision: What we decided
## Consequences: Trade-offs and implications
## Alternatives Considered: What else we evaluated
```

### Step 1.3: Generate Product Requirements Document (PRD)
Adopt `senior-product-manager` persona and produce:
- User stories with acceptance criteria
- SEO specification (page titles, meta descriptions, structured data types, URL structure)
- Conversion funnel blueprint (CTA strategy, trust signal placement, onboarding flow)
- Analytics event taxonomy

### Step 1.4: Security Architecture
Adopt `senior-security-engineer` persona:
- STRIDE threat model for the system
- Authentication/authorization design
- Security header configuration
- Secret management approach

### Step 1.5: Database Design
Adopt `senior-database-architect` persona:
- Entity-relationship diagram
- Schema definitions with indexes
- Migration strategy

### Step 1.6: Save All Artifacts
Save all Phase 1 artifacts to: `D:\OrcaProjects\<project-name>\docs\architecture\`

**GATE: Architecture Gate — Present ADRs to user for confirmation.**

---

## PHASE 2: DESIGN PIPELINE

### Step 2.1: Design System Generation
If the team plan includes design pipeline agents (`ui-designer`, `brand-guardian`):

1. Define the design system:
   - Color palette using HSL values (primary, secondary, accent, neutral, semantic colors)
   - Typography scale (font families from Google Fonts, size scale, weight scale, line heights)
   - Spacing scale (4px base unit: 4, 8, 12, 16, 20, 24, 32, 40, 48, 64, 80, 96)
   - Border radius scale
   - Shadow/elevation system (3 levels)
   - Transition/animation defaults

2. Generate CSS design tokens file:
   ```css
   :root {
     /* Colors */
     --color-primary-50: hsl(...);
     --color-primary-500: hsl(...);
     --color-primary-900: hsl(...);
     /* ... full palette */
     
     /* Typography */
     --font-sans: 'Inter', system-ui, sans-serif;
     --font-mono: 'JetBrains Mono', monospace;
     /* ... full scale */
     
     /* Spacing, shadows, radii, transitions */
   }
   ```

3. Define component state matrices: default, hover, focus-visible, active, disabled, loading, error.

### Step 2.2: Brand Guardian Gate
Evaluate the design system against:
- Brand alignment and consistency
- Aesthetic quality (modern, premium feel)
- Conversion readiness (CTA prominence, visual hierarchy)
- Accessibility (contrast ratios ≥ 4.5:1)
- Originality (not copying third-party designs)

Verdict: **APPROVED** (lock tokens) | **REVISE** (iterate) | **REJECTED** (full redesign).

Auto-pass if all criteria are met. Lock tokens on approval.

---

## PHASE 3: DETAILED TECHNICAL DESIGN

### Step 3.1: Read System Designer Agent
```
Read: agents/senior-system-designer.md
```

### Step 3.2: Generate Technical Specifications
1. **OpenAPI 3.1 Specification**: All API endpoints with request/response schemas.
2. **Component Contracts**: TypeScript interfaces for all components.
3. **Sequence Diagrams**: Critical user flows (signup, core action, checkout if applicable).
4. **Error Handling Strategy**: Standard error response format, error codes, retry policies.

Save to: `D:\OrcaProjects\<project-name>\docs\specs\`

---

## PHASE 4: IMPLEMENTATION

### Step 4.1: Project Scaffolding
1. Create the project directory: `D:\OrcaProjects\<project-name>\`
2. Initialize with the correct framework (based on ADR-001):
   - Next.js: `npx -y create-next-app@latest ./ --typescript --eslint --tailwind --src-dir --app --import-alias "@/*"` (if SSR/SSG needed)
   - Vite + React: `npx -y create-vite@latest ./ --template react-ts`
   - Python/FastAPI: Standard Poetry/pip project structure
   - Node.js API: Standard Express/Fastify structure
3. Install dependencies per the technical specification.
4. Initialize Git repository with `.gitignore`.

### Step 4.2: Implement Core Features
For each implementation track in the team plan:

1. **Read the relevant agent definition** (e.g., `agents/senior-frontend-engineer.md`).
2. **Implement features** according to Phase 3 specifications.
3. **Apply design tokens** from Phase 2 (for frontend work).
4. **Follow coding standards** from AGENT_RULES.md.
5. **Run pre-commit checks** after each significant change:
   - Lint: `npm run lint` or equivalent
   - Typecheck: `npx tsc --noEmit` or equivalent
   - Tests: `npm test` or equivalent

### Step 4.3: SEO Implementation (for web projects)
For every public-facing page:
- Unique `<title>` and `<meta description>`
- JSON-LD structured data
- Open Graph and Twitter Card meta
- Canonical URL
- Semantic HTML5 structure
- `sitemap.xml` generation
- `robots.txt` configuration

### Step 4.4: Conversion Elements (for user-facing products)
- Primary CTA above the fold
- Trust signals on conversion pages
- Skeleton loading states
- Inline form validation with actionable errors
- Empty states with guidance CTAs

---

## PHASE 5: VERIFICATION

### Step 5.1: Test Suite Execution
```bash
# Run all tests
npm run lint          # Zero errors
npx tsc --noEmit      # Zero type errors
npm test              # All passing, ≥80% coverage
npm run build         # Zero errors, zero warnings
```

### Step 5.2: Performance Audit
If the project has a web frontend:
```bash
# Build and serve for Lighthouse
npm run build
npx serve dist -l 3000 &
npx lighthouse http://localhost:3000 --output json --output-path ./lighthouse-report.json
```
Verify: Performance ≥ 90, SEO ≥ 95, Accessibility ≥ 95.

### Step 5.3: Security Audit
```bash
# Dependency vulnerabilities
npm audit --audit-level=high
# Secret detection
grep -rn "API_KEY\|SECRET\|PASSWORD\|TOKEN" src/ --include="*.ts" --include="*.tsx" --include="*.js"
```
Verify: Zero critical/high CVEs, zero exposed secrets.

### Step 5.4: SEO Verification
For each public page, verify:
- [ ] Unique `<title>` (50-60 chars)
- [ ] Unique `<meta description>` (150-160 chars)
- [ ] Single `<h1>`, logical heading hierarchy
- [ ] JSON-LD structured data present and valid
- [ ] Canonical URL present
- [ ] Open Graph tags present
- [ ] Server-side rendered (check page source, not DOM)

### Step 5.5: Produce Verification Report
Create a structured report with all test results, audit scores, and evidence artifacts.

---

## PHASE 6: RALPH EVALUATION LOOP

### Step 6.1: Generate Tasks
Use the `ralph-loop` skill to auto-generate `tasks.json` from the team plan and implementation results.

### Step 6.2: Evaluate
For each task, apply the 27-point evaluation rubric:
- Core criteria (tests, build, git state, code quality)
- SEO criteria (meta tags, structured data, SSR)
- Performance criteria (Lighthouse, bundle size, CLS)
- Conversion criteria (CTAs, trust signals, empty states)
- Security criteria (no secrets, input validation, headers)

### Step 6.3: Iterate or Pass
- **PASS**: All criteria satisfied → merge and proceed.
- **FAIL (attempt < 3)**: Fix the specific failure and re-evaluate.
- **FAIL (attempt ≥ 3)**: Circuit breaker → escalate to user with full failure report.

---

## PHASE 7: DEPLOYMENT PREPARATION

### Step 7.1: Production Configuration
1. Generate `Dockerfile` with multi-stage build.
2. Generate `docker-compose.yml` for local development.
3. Generate `.env.example` documenting all environment variables.
4. Create health check endpoint (`/api/health` or `/healthz`).

### Step 7.2: CI/CD Pipeline
Generate `.github/workflows/ci.yml`:
- Lint, typecheck, test on every PR
- Build verification
- Lighthouse CI (if web frontend)
- Security audit

### Step 7.3: Final Production Readiness Report
Present to user:
- All production readiness checklist items from ARCHITECTURE.md with status
- Lighthouse scores
- Test coverage report
- Security audit results
- Deployment instructions
- Known limitations or deferred items

**GATE: Release Gate — Present final report to user for sign-off.**

---

## Phase Handoff Protocol

Every phase transition must include a structured handoff:

```markdown
## Phase [N] → Phase [N+1] Handoff

**Source Phase**: Phase [N] — [Phase Name]
**Target Phase**: Phase [N+1] — [Phase Name]
**Timestamp**: [ISO 8601]

### Produced Artifacts
- [Artifact Name](file:///path/to/artifact) — [description]

### Acceptance Criteria for Next Phase
- [ ] Criterion 1
- [ ] Criterion 2

### Quality Status
- Architecture: PASSED / PENDING / N/A
- Brand: PASSED / PENDING / N/A
- Security: PASSED / PENDING / N/A
- QA: PASSED / PENDING / N/A
- Performance: PASSED / PENDING / N/A

### Blockers / Assumptions
- [ASSUMPTION] ...
- [UNKNOWN — requires clarification] ...
```
