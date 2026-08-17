# Orca Model Router

The **Model Router** intelligently maps classified tasks to the optimal LLM engine or specialized reasoning harness based on context window requirements, reasoning depth, code generation speed, and tool-calling capabilities.

## Model Assignment Matrix

| Task Domain & Complexity | Recommended Engine Profile | Primary Capabilities Leveraged |
| :--- | :--- | :--- |
| **System Architecture & ADRs** (Tier 4) | High-Reasoning Foundation (e.g. Gemini 3.7 / Claude 3.7 Sonnet Thinking) | Deep architectural synthesis, massive context ingestion, multi-tier dependency reasoning |
| **UI Design & Brand Guardian Gate** | Multimodal Vision Foundation | Screenshot visual diff analysis, color token verification, aesthetic grading |
| **Complex Code Implementation** (Tier 3-4) | Advanced Code Generation Model | Multi-file cohesion, strict type checking, robust error handling |
| **Rapid Worker Execution** (Tier 1-2) | High-Throughput Fast Model (e.g. Flash / Fast models) | Sub-second latency, deterministic single-file edits, linting, unit test boilerplate |
| **Security Auditing & Threat Modeling** | Deep Analytical Reasoning Engine | Edge case discovery, vulnerability path analysis, zero-trust verification |
| **Autonomous Ralph Evaluation Loop** | Deterministic Evaluator Harness | Strict schema validation, test evidence evaluation, invariant checking |

## Dynamic Routing Heuristics

1. **Context Window Strategy**: Tasks requiring cross-repository code ingestion (>100k tokens) route to high-context engines.
2. **Deterministic Fallbacks**: If a high-throughput fast model fails verification twice in the Ralph loop, the task is automatically escalated to a deeper reasoning model.
3. **Multimodal Routing**: Any task producing visual artifacts (screenshots, mockups) routes through vision-capable model endpoints for Visual QA.
