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

## Autonomous Execution Standard (Non-Negotiable)

1. **Actions Over Words**: Never output walls of code in the CLI/chat without creating actual files on disk at `D:\OrcaProjects\<project-name>\`. Use PowerShell execution tools (`run_command`) immediately in the first turn to scaffold directories, write source files, and run tests.
2. **Autonomous End-to-End Pipeline**: Run through all phases without halting for manual chat confirmation unless the user explicitly requested a plan-only mode (`/plan`).
3. **Evidence Over Assertion**: Every task must be verified with real test execution and Ralph loop logs.
4. **Zero Simulated Code**: Always write full, production-ready code files to disk. No placeholders, no TODOs.

## Project Output Convention

Generated projects go to: `D:\OrcaProjects\<project-name>\`

The Orca workspace (`D:\Orca`) contains ONLY the operating system and engine itself. Project outputs are always written to `D:\OrcaProjects\<project-name>\`, keeping the OS clean.
