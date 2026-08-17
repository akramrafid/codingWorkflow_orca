# Orca Agent Operating System — Master Architecture

Orca is an autonomous engineering organization that transforms product requirements into production-ready, industry-standard software. Every system Orca produces must meet the quality bar of a venture-backed startup shipping to paying customers on day one.

---

## System Mission

When a user inputs a product requirement, Orca must deliver software that is:

1. **Industry Standard** — Clean architecture, typed code, comprehensive tests, CI/CD, zero known vulnerabilities.
2. **SEO Optimized** — Server-side rendering or static generation, semantic HTML5, structured data (JSON-LD), Open Graph/Twitter meta, canonical URLs, sitemap.xml, robots.txt, Core Web Vitals passing Google's "Good" threshold.
3. **Conversion Rate Optimized** — Strategic CTAs above the fold, trust signals, social proof patterns, urgency/scarcity when appropriate, frictionless onboarding flows, A/B-testable component architecture.
4. **Fast** — Sub-200ms server response (TTFB), LCP < 2.5s, INP < 200ms, CLS < 0.1, optimized images (WebP/AVIF with srcset), code-split bundles, edge caching, lazy loading below the fold.
5. **Production Ready** — Environment-based configuration, health check endpoints, structured logging (JSON), error tracking integration, graceful shutdown, database connection pooling, rate limiting, CORS, CSP headers, automated backups, rollback capability.

---

## Lifecycle Phases

Every project follows this mandatory execution lifecycle:

```
PHASE 0: REQUIREMENT ANALYSIS
     │  Requirement Analyzer extracts capability map
     │  Senior Product Manager authors PRD with SEO/CRO strategy
     ▼
PHASE 1: ARCHITECTURE
     │  Senior System Architect produces ADRs and system blueprint
     │  Senior Security Engineer conducts threat model
     │  Senior Database Architect designs schema and indexes
     ▼
PHASE 2: DESIGN PIPELINE
     │  Pinterest Researcher → Design Researcher → UX Researcher
     │  Senior Product Designer synthesizes wireframes + design system
     │  UI Designer produces high-fidelity specs with conversion patterns
     │  ★ GATE: Brand Guardian (APPROVE / REJECT / REVISE)
     ▼
PHASE 3: DETAILED TECHNICAL DESIGN
     │  Senior System Designer produces OpenAPI specs, component contracts
     │  Senior Frontend Engineer defines SEO rendering strategy (SSR/SSG/ISR)
     ▼
PHASE 4: PARALLEL IMPLEMENTATION
     │  Frontend, Backend, AI/ML specialists work in isolated git worktrees
     │  Each worktree has automated pre-commit hooks (lint, typecheck, test)
     ▼
PHASE 5: INTEGRATION & VERIFICATION
     │  Senior QA Architect runs full test suite (unit, integration, E2E)
     │  Visual QA captures screenshots across viewports
     │  Senior Performance Engineer runs load tests and Lighthouse audits
     │  Senior Security Engineer runs SAST/DAST scans
     │  ★ GATE: Production Readiness Checklist (see below)
     ▼
PHASE 6: RALPH AUTONOMOUS LOOP
     │  Evidence-based evaluation → PASS (merge) / FAIL (iterate)
     │  Circuit breaker after 3 failures per task
     ▼
PHASE 7: DEPLOYMENT & MONITORING
     │  Senior DevOps Engineer deploys via CI/CD with canary/blue-green
     │  Observability stack confirms health
     │  ★ GATE: Human approval for production (unless unattended mode)
```

---

## Agent Authority

- Senior agents own decisions within their domain. They design, approve, reject, and review.
- Worker agents execute tasks delegated by senior agents within isolated branches.
- Architectural changes require approval from the Senior System Architect.
- Security-sensitive changes require the Senior Security Engineer's sign-off.
- Visual/brand changes require the Brand Guardian's sign-off.
- Production deployment requires DevOps approval and human approval unless explicitly configured otherwise.

## Source of Truth

| Artifact | Authority |
| :--- | :--- |
| Application code | Git (version-controlled, branched, PR-reviewed) |
| Product requirements | PRD authored by Senior Product Manager |
| Architecture decisions | Architecture Decision Records (ADRs) |
| Autonomous task state | Ralph `ralph-state.json` |
| Brand identity | Brand Guidelines locked by Brand Guardian |
| API contracts | OpenAPI/GraphQL specs authored by Senior System Designer |
| SEO strategy | SEO Specification authored by Senior Product Manager + Frontend Engineer |

## Design Principles

1. **Original Design**: External designs (Pinterest, Dribbble, competitors) are inspiration only. The system must generate original designs aligned with the project's brand guidelines. Never reproduce third-party designs.
2. **Simplest Sufficient Architecture**: Do not introduce microservices, Kubernetes, or distributed infrastructure without justified requirements. Monolith-first unless proven otherwise.
3. **Evidence Over Assertion**: No task is complete because an agent says so. Passing tests, clean builds, and visual proof are required.
4. **Progressive Enhancement**: Ship a working MVP first, then iterate. Every iteration must pass the full verification suite before merge.
5. **Conversion-Driven UI**: Every user-facing page must have a clear purpose, a measurable call-to-action, and zero dead-end states.

---

## Production Readiness Checklist

Before any deployment to production, the following must be verified:

### Performance
- [ ] Lighthouse Performance score ≥ 90
- [ ] LCP < 2.5s on mobile 4G simulation
- [ ] INP < 200ms
- [ ] CLS < 0.1
- [ ] TTFB < 200ms (server response)
- [ ] Total JS bundle < 200KB gzipped (initial load)
- [ ] All images served as WebP/AVIF with responsive `srcset`

### SEO
- [ ] Every page has unique `<title>` and `<meta name="description">`
- [ ] Single `<h1>` per page with logical heading hierarchy
- [ ] Semantic HTML5 elements (`<header>`, `<main>`, `<nav>`, `<article>`, `<footer>`)
- [ ] JSON-LD structured data (Organization, Product, BreadcrumbList, FAQ as applicable)
- [ ] Open Graph and Twitter Card meta tags on every page
- [ ] Canonical URLs on every page
- [ ] `sitemap.xml` generated and submitted
- [ ] `robots.txt` configured
- [ ] All internal links use descriptive anchor text (no "click here")
- [ ] Zero broken internal links (validated by crawler)
- [ ] Server-side rendering or static generation for all public pages

### Conversion Rate Optimization
- [ ] Primary CTA visible above the fold on landing pages
- [ ] Trust signals present (testimonials, logos, certifications, security badges)
- [ ] Form fields minimized (ask only what's necessary)
- [ ] Error messages are inline, specific, and actionable
- [ ] Loading states provide visual feedback (skeleton screens, not spinners)
- [ ] Empty states guide users toward next action
- [ ] Onboarding flow completable in < 60 seconds
- [ ] Social proof elements on key conversion pages
- [ ] Exit-intent or value reinforcement on checkout/signup flows

### Security
- [ ] All dependencies scanned for CVEs (zero critical/high)
- [ ] Authentication endpoints rate-limited
- [ ] CSRF protection on all state-changing endpoints
- [ ] CSP, HSTS, X-Frame-Options, X-Content-Type-Options headers set
- [ ] Secrets in environment variables, never in source code
- [ ] Input validation on every endpoint (server-side, not just client-side)

### Reliability
- [ ] Health check endpoint (`/healthz` or `/api/health`) returning 200
- [ ] Graceful shutdown handling (SIGTERM)
- [ ] Database connection pooling configured
- [ ] Structured JSON logging with correlation IDs
- [ ] Error tracking integration (Sentry, Datadog, or equivalent)
- [ ] Automated database backups with tested restore procedure

### Testing
- [ ] Unit test coverage ≥ 80% on business logic
- [ ] Integration tests covering all API endpoints
- [ ] E2E tests covering critical user journeys (signup, purchase, core workflow)
- [ ] Visual regression tests on key pages across 3 viewports
- [ ] Zero lint errors, zero type errors, zero console warnings in production build
