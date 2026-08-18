# Orca Workspace Rules

These rules are automatically loaded by Antigravity for every session in the Orca workspace.

## Production Standards

Every piece of code produced in this workspace must meet these standards:

### Code Quality
- Zero lint errors, zero type errors, zero console warnings in production builds.
- No `console.log`, `print()`, or debug statements in production code.
- No commented-out code in production branches.
- No TODO/FIXME/HACK without linked tracking issues.
- All public functions and API endpoints have JSDoc/docstring documentation.

### Testing
- Unit test coverage ≥ 80% on business logic.
- Integration tests on all API endpoints.
- E2E tests on critical user journeys.
- Build must complete with zero errors.

### SEO (All Public Pages)
- Unique `<title>` (50–60 chars) and `<meta description>` (150–160 chars) per page.
- Single `<h1>` per page with logical heading hierarchy.
- Semantic HTML5 elements (`<header>`, `<main>`, `<nav>`, `<article>`, `<footer>`).
- JSON-LD structured data appropriate to page type.
- Open Graph and Twitter Card meta tags.
- Canonical URLs. Server-side rendering for public pages.

### Performance
- Lighthouse Performance ≥ 90, SEO ≥ 95, Accessibility ≥ 95.
- LCP < 2.5s, INP < 200ms, CLS < 0.1, TTFB < 200ms.
- Initial JS bundle < 200KB gzipped.
- Images in WebP/AVIF with responsive `srcset`.

### Security
- Never expose secrets, API keys, or credentials in source code.
- Never commit `.env` files or private keys.
- All user input validated server-side.
- Security headers: CSP, HSTS, X-Frame-Options, X-Content-Type-Options.
- Zero critical/high CVEs in dependencies.

### Conversion Rate Optimization
- Primary CTA visible above the fold on landing pages.
- Trust signals (testimonials, badges, logos) on conversion pages.
- Skeleton loading screens (not spinners).
- Inline, specific, actionable error messages.
- No dead-end empty states.

## Agent System Rules

- When working on an Orca project, always follow the lifecycle phases in GEMINI.md.
- When adopting a specialist agent role, read the full agent definition from `agents/<role>.md` first.
- Every handoff between phases must include: artifacts, acceptance criteria, and quality status.
- Evidence is mandatory. No task is complete without: git diff, test logs, and verification proof.
- Senior agents make decisions. Worker agents execute within boundaries. Workers escalate ambiguity — they do not improvise.

## Project Output Convention

Generated projects go to: `D:\OrcaProjects\<project-name>\`

The Orca workspace (`D:\Orca`) contains the operating system itself. Project outputs are always written to the OrcaProjects directory, never mixed with the OS files.
