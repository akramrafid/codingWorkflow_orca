# Global Agent Rules

These rules are non-negotiable. Every agent in the Orca system — senior or worker — must internalize and obey these rules at all times. Violation of any rule is grounds for task rejection by the Ralph Evaluator.

---

## 1. Understand Before Executing

Never begin significant implementation before understanding:

- The product requirements and user personas
- Constraints (budget, timeline, platform, compliance)
- Existing codebase, directory structure, and conventions
- The system architecture and relevant ADRs
- Acceptance criteria for the specific task
- The production readiness checklist in [ARCHITECTURE.md](file:///d:/Orca/ARCHITECTURE.md)

**Enforcement**: If an agent begins implementation without reading the PRD and relevant architecture documents, the Ralph Evaluator must issue an automatic `FAIL`.

---

## 2. Never Invent Project Requirements

If information is unavailable, explicitly mark it as `[UNKNOWN — requires clarification]`.

Do not silently assume requirements, user preferences, business rules, or technical constraints. Assumptions are the root cause of wasted iterations.

**If you must make a reasonable default**, document it prominently with `[ASSUMPTION]` tag and flag it for Product Manager review.

---

## 3. Senior Agents Are Decision Makers

- Workers execute tasks within the boundaries defined by their supervising senior agent.
- Senior agents design, approve, reject, and review within their domain.
- Workers must not make architectural, design, or security decisions without senior approval.
- When a worker encounters ambiguity, they escalate — they do not improvise.

---

## 4. Do Not Overwrite Another Agent's Work

- Use Git worktrees and feature branches for parallel work.
- Never force-push or rebase another agent's branch without explicit coordination.
- If two agents need to modify the same file, the senior architect must define merge order.
- Every branch must pass CI before merge.

---

## 5. Verify Everything

A task is not complete because an agent claims it is complete. Evidence is required.

**Minimum evidence for any completed task:**
- Command output logs showing passing verification commands
- Git diff showing exactly what changed
- No regressions in existing test suites
- Clean git status (no untracked debug files, no commented-out code)

---

## 6. Testing Standards

At minimum, every implementation task must run and pass:

- **Lint**: Zero warnings, zero errors (ESLint, Ruff, golangci-lint, or project equivalent)
- **Type checking**: Zero errors (TypeScript `tsc --noEmit`, mypy, or equivalent)
- **Unit tests**: ≥80% branch coverage on new/modified business logic
- **Integration tests**: Cover all new API endpoints and database interactions
- **Build**: Production build completes with zero errors and zero console warnings

Additional tests should be selected according to the project:
- **E2E tests** for user-facing flows (Playwright, Cypress)
- **Visual regression tests** for UI changes
- **Load tests** for performance-critical endpoints
- **Security scans** (SAST/DAST) for auth and data-handling code

---

## 7. UI & Frontend Standards

All UI work must be verified against:

- **Brand guidelines** locked by the Brand Guardian
- **UX requirements** defined by the Product Designer
- **Responsive behavior** across mobile (375px), tablet (768px), desktop (1280px), wide (1920px)
- **Accessibility**: WCAG 2.1 AA minimum — semantic HTML, keyboard navigation, ARIA labels, color contrast ≥ 4.5:1, focus indicators
- **Visual consistency**: Design token adherence (no hardcoded colors, no inline styles overriding tokens)

### SEO Requirements (Mandatory for All Public Pages)

- Server-side rendering (SSR) or static site generation (SSG) for all indexable pages
- Unique, keyword-targeted `<title>` tags (50-60 characters) and `<meta description>` (150-160 characters)
- Single `<h1>` per page containing the primary keyword naturally
- Logical heading hierarchy (`<h1>` → `<h2>` → `<h3>`, never skip levels)
- Semantic HTML5 elements: `<header>`, `<main>`, `<nav>`, `<article>`, `<section>`, `<footer>`
- JSON-LD structured data appropriate to page type (Organization, Product, BreadcrumbList, FAQ, HowTo, Article)
- Open Graph (`og:title`, `og:description`, `og:image`, `og:url`, `og:type`) and Twitter Card meta tags
- Canonical URL on every page (`<link rel="canonical">`)
- Self-referencing hreflang tags if multilingual
- Descriptive, keyword-rich anchor text for all internal links (never "click here" or "read more")
- Image `alt` attributes that are descriptive and contextually relevant
- `sitemap.xml` auto-generated and referenced in `robots.txt`
- `robots.txt` properly configured (no accidental `Disallow: /`)
- Page speed: Lighthouse SEO score ≥ 95

### Conversion Rate Optimization Requirements

- Primary call-to-action (CTA) visible above the fold on all landing/marketing pages
- CTAs use action-oriented, benefit-driven copy (e.g., "Start Free Trial" not "Submit")
- Trust signals on conversion pages: testimonials, partner logos, security badges, money-back guarantees
- Forms minimize required fields; use progressive disclosure for complex inputs
- Error messages are inline, specific, and guide correction (not generic "invalid input")
- Loading states use skeleton screens (not blank screens or generic spinners)
- Empty states include guidance and a CTA toward the next meaningful action
- Social proof (user counts, testimonials, ratings) on signup, pricing, and checkout pages
- Navigation is intuitive — user can reach any key page in ≤ 3 clicks from homepage
- Micro-animations provide feedback on interactions (button press, form submit, state change)

### Performance Requirements

- Lighthouse Performance score ≥ 90 on mobile simulation
- Largest Contentful Paint (LCP) < 2.5 seconds
- Interaction to Next Paint (INP) < 200 milliseconds
- Cumulative Layout Shift (CLS) < 0.1
- Time to First Byte (TTFB) < 200 milliseconds
- Total initial JavaScript bundle < 200KB gzipped
- Images served in WebP/AVIF format with responsive `srcset` and explicit `width`/`height` attributes
- Fonts preloaded with `font-display: swap` and subset to used character ranges
- Critical CSS inlined; non-critical CSS deferred
- Below-the-fold content lazy-loaded (`loading="lazy"`, dynamic `import()`)

---

## 8. AI/ML Standards

Every AI/ML task must explicitly define and document:

- **Dataset**: Source, size, format, licensing, bias considerations, train/val/test split ratios
- **Preprocessing**: Normalization, tokenization, augmentation, feature engineering pipeline
- **Model**: Architecture selection with justification, baseline comparisons
- **Training procedure**: Optimizer, learning rate schedule, batch size, number of epochs, hardware requirements
- **Evaluation**: Metric selection with justification (precision, recall, F1, BLEU, ROUGE, mAP, etc.)
- **Metrics**: Quantitative results table with confidence intervals
- **Reproducibility**: Random seeds, pinned dependency versions, containerized environment, model artifact versioning

**Additional for LLM/RAG systems:**
- Prompt templates versioned and regression-tested
- Hallucination rate benchmarked and tracked
- Token cost per request estimated and budgeted
- Retrieval quality measured (NDCG@k, MRR, recall@k)
- Guardrails tested (prompt injection, jailbreak, data leakage)

---

## 9. Security Standards

- Never expose secrets, API keys, tokens, or credentials in source code, logs, build output, or client bundles.
- Never commit `.env` files, private keys, or service account credentials to version control.
- Never perform destructive production operations (database drops, bulk deletes, infrastructure teardown) without explicit human authorization.
- All authentication endpoints must be rate-limited.
- All user input must be validated server-side (client-side validation is a UX convenience, not a security boundary).
- All state-changing API requests must have CSRF protection.
- Response headers must include: `Content-Security-Policy`, `Strict-Transport-Security`, `X-Frame-Options`, `X-Content-Type-Options`.
- Dependencies must be scanned for CVEs before every deployment; zero critical/high vulnerabilities allowed.
- Passwords must be hashed with bcrypt, scrypt, or Argon2 — never MD5 or SHA-1.
- JWTs must use RS256 or ES256, never HS256 with a weak secret.

---

## 10. Completion Standards

Never report SUCCESS without evidence. The Ralph Evaluator will reject any task that lacks:

- **Implementation evidence**: Git diff showing exactly what was added/modified/removed
- **Test evidence**: Command output logs from lint, typecheck, unit tests, integration tests, and build
- **Verification evidence**: Proof that acceptance criteria are met (screenshots for UI, API response samples for backend, metric tables for ML)
- **Regression evidence**: Full existing test suite continues to pass
- **Review status**: Senior agent sign-off where required (architecture, security, brand)
- **Git state**: Clean working directory, changes committed to the correct feature branch

---

## 11. Code Quality Standards

- No commented-out code in production branches.
- No `console.log`, `print()`, or debug statements in production builds.
- No TODO/FIXME/HACK comments without a linked tracking issue.
- All public functions and API endpoints must have JSDoc/docstring documentation.
- File and folder naming follows project conventions consistently.
- No duplicated business logic — extract shared utilities.
- Import order follows project convention (stdlib → third-party → internal → relative).

---

## 12. Documentation Standards

- Every new API endpoint must be documented in the OpenAPI spec.
- Every new database table/migration must be documented with purpose and relationships.
- Every new environment variable must be documented in a `.env.example` file.
- README.md must accurately reflect how to install, configure, run, and test the project.
- Architecture Decision Records (ADRs) must be created for every significant technical choice.
