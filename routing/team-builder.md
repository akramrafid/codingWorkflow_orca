# Orca Dynamic Team Builder Specification

The **Dynamic Team Builder** is the intelligent squad formulation and execution orchestration engine of the Orca Agent Operating System. It consumes raw project requirements or briefs from the [Requirement Analyzer](file:///D:/Orca/agents/requirement-analyzer.md) and constructs a strictly scoped, capability-justified, and dependency-ordered **Team Plan**.

The Team Builder enforces **Capability-Based Reasoning** rather than simple keyword matching, ensuring that every project receives the exact specialist squad it needs while strictly excluding unneeded agents.

---

## 1. Core Architecture & Reasoning Flow

```
[ USER PROMPT / PRODUCT BRIEF ]
             │
             ▼
┌─────────────────────────────────────────────────────────────┐
│ 1. SEMANTIC INTENT & CAPABILITY EXTRACTION                  │
│ Deconstruct brief into functional and technical intent.     │
│ Map to canonical capabilities in capability-resolution.yaml│
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 2. TRANSITIVE DEPENDENCY CLOSURE RESOLUTION                 │
│ Resolve implied sub-capabilities (e.g. RAG → Vector DB →    │
│ Embedding Pipeline → API Layer → Auth & Security).          │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 3. SQUAD DEDUPLICATION & ROLE SEGREGATION                   │
│ Assign activated agents into Decision Makers, Specialists,  │
│ and Support Roles adhering to agent-hierarchy.yaml.         │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 4. ANTI-BLOAT EXCLUSION FILTERING                           │
│ Explicitly classify unneeded agents into excluded_agents    │
│ with documented justifications.                             │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 5. DEPENDENCY DAG & WORKTREE CONCURRENCY ALLOCATION         │
│ Build execution sequence, merge hierarchy, and worktrees.   │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 6. MANDATORY QUALITY & SECURITY GATE BINDING                │
│ Bind Architecture, Brand, Security, QA, and Perf gates.    │
└──────────────────────────────┬──────────────────────────────┘
                               │
                               ▼
┌─────────────────────────────────────────────────────────────┐
│ 7. OUTPUT GENERATION (team-plan.json)                       │
│ Emits validated JSON adhering to team-builder-schema.json   │
└─────────────────────────────────────────────────────────────┘
```

---

## 2. Concrete Worked Examples

### Example 1: "Build a RAG-based customer support assistant"

#### Semantic Capability Inference:
- **Primary Domain**: `ai_llm_rag`
- **Extracted Capabilities**: `ai_systems_orchestration`, `llm_rag_and_agents`, `nlp_text_embeddings_retrieval`, `vector_database_indexing`, `api_backend_engineering`, `authentication_rbac_security`, `automated_testing_qa`, `backend_latency_budgeting`, `infrastructure_as_code`.
- **Excluded Capabilities**: Computer Vision, Multimodal Generative Media, Classical Tabular ML, Pinterest Design Research.

#### Generated Team Plan (`team-plan.json`):
```json
{
  "project": "rag-customer-support-assistant",
  "summary": "Enterprise RAG assistant with vector retrieval, hybrid search, hallucination guardrails, and secure API backend.",
  "domain_profile": "ai_llm_rag",
  "required_capabilities": [
    {
      "capability": "ai_systems_orchestration",
      "category": "ai_ml_data",
      "justification": "Multi-agent coordination, prompt routing, and safety guardrails"
    },
    {
      "capability": "llm_rag_and_agents",
      "category": "ai_ml_data",
      "justification": "Document chunking, RAG retrieval synthesis, and streaming response generation"
    },
    {
      "capability": "nlp_text_embeddings_retrieval",
      "category": "ai_ml_data",
      "justification": "Dense/sparse embeddings and semantic similarity ranking"
    },
    {
      "capability": "vector_database_indexing",
      "category": "backend_data",
      "justification": "pgvector / Qdrant vector storage and HNSW index management"
    },
    {
      "capability": "api_backend_engineering",
      "category": "backend_data",
      "justification": "REST/WebSocket API endpoints and middleware pipelines"
    },
    {
      "capability": "authentication_rbac_security",
      "category": "quality_security",
      "justification": "Customer auth, API rate limiting, and prompt injection defense"
    },
    {
      "capability": "mlops_model_serving_drift",
      "category": "ai_ml_data",
      "justification": "Inference latency optimization and retrieval drift monitoring"
    }
  ],
  "senior_agents": [
    {
      "agent": "senior-system-architect",
      "domain": "system_architecture",
      "responsibility": "Overall system topology, ADRs, and caching layer"
    },
    {
      "agent": "senior-product-manager",
      "domain": "product_and_growth",
      "responsibility": "Assistant personas, user stories, and acceptance criteria"
    },
    {
      "agent": "senior-ai-engineer",
      "domain": "artificial_intelligence_and_data",
      "responsibility": "AI architecture, evaluation harnesses, and guardrail policies"
    },
    {
      "agent": "senior-database-architect",
      "domain": "system_architecture",
      "responsibility": "Vector store schema, relational storage, and indexing"
    },
    {
      "agent": "senior-security-engineer",
      "domain": "quality_security_performance",
      "responsibility": "Security threat modeling, auth, and prompt injection defense"
    },
    {
      "agent": "senior-qa-architect",
      "domain": "quality_security_performance",
      "responsibility": "E2E testing, RAG retrieval accuracy benchmarks, and CI gates"
    },
    {
      "agent": "senior-performance-engineer",
      "domain": "quality_security_performance",
      "responsibility": "Inference TTFT and API p95 response time budgets"
    },
    {
      "agent": "senior-devops-engineer",
      "domain": "operations_and_infrastructure",
      "responsibility": "Containerized CI/CD pipeline and deployment"
    }
  ],
  "specialist_agents": [
    {
      "agent": "senior-system-designer",
      "supervising_lead": "senior-system-architect",
      "deliverables": ["OpenAPI 3.1 specifications", "WebSocket message contracts"]
    },
    {
      "agent": "senior-llm-engineer",
      "supervising_lead": "senior-ai-engineer",
      "deliverables": ["RAG pipeline", "Prompt templates", "Tool calling schemas"]
    },
    {
      "agent": "senior-nlp-engineer",
      "supervising_lead": "senior-ai-engineer",
      "deliverables": ["Chunking strategies", "Embedding generation", "Re-ranking modules"]
    },
    {
      "agent": "senior-backend-engineer",
      "supervising_lead": "senior-system-architect",
      "deliverables": ["FastAPI / NestJS endpoints", "Streaming handlers", "Auth middleware"]
    },
    {
      "agent": "senior-mlops-engineer",
      "supervising_lead": "senior-ai-engineer",
      "deliverables": ["vLLM serving configs", "Drift detection", "Latency benchmarks"]
    }
  ],
  "optional_agents": [
    {
      "agent": "senior-frontend-engineer",
      "standby_condition": "Activated if a standalone web chat interface is requested"
    },
    {
      "agent": "senior-ai-research-engineer",
      "standby_condition": "Activated if custom loss functions or novel retrieval models are required"
    }
  ],
  "excluded_agents": [
    { "agent": "senior-computer-vision-engineer", "exclusion_reason": "No image/video processing requirements" },
    { "agent": "senior-generative-ai-engineer", "exclusion_reason": "No image/audio/video generation requirements" },
    { "agent": "senior-machine-learning-engineer", "exclusion_reason": "No classical tabular ML requirements" },
    { "agent": "pinterest-researcher", "exclusion_reason": "No visual moodboard requirements" },
    { "agent": "design-researcher", "exclusion_reason": "No competitor UI benchmarking required" },
    { "agent": "ui-designer", "exclusion_reason": "API/AI backend project without custom UI design scope" },
    { "agent": "brand-guardian", "exclusion_reason": "No visual branding required" },
    { "agent": "visual-qa", "exclusion_reason": "No browser rendering to visually audit" }
  ],
  "dependencies": [
    {
      "agent": "senior-llm-engineer",
      "depends_on": ["senior-ai-engineer", "senior-nlp-engineer", "senior-database-architect"],
      "blocking_artifact": "Embedding schemas and vector database indexing"
    },
    {
      "agent": "senior-backend-engineer",
      "depends_on": ["senior-system-designer", "senior-llm-engineer"],
      "blocking_artifact": "OpenAPI contracts and RAG pipeline integration interface"
    }
  ],
  "parallel_groups": [
    {
      "group_id": "group_ai_core",
      "phase": "PHASE_4",
      "worktree": "worktree/ai",
      "agents": ["senior-llm-engineer", "senior-nlp-engineer", "senior-mlops-engineer"]
    },
    {
      "group_id": "group_backend_api",
      "phase": "PHASE_4",
      "worktree": "worktree/backend",
      "agents": ["senior-backend-engineer", "senior-database-architect"]
    }
  ],
  "approval_gates": [
    {
      "gate_name": "architecture_gate",
      "owner_agent": "senior-system-architect",
      "mandatory": true,
      "criteria": ["ADRs approved", "Vector DB choice justified", "Latency budget verified"]
    },
    {
      "gate_name": "security_gate",
      "owner_agent": "senior-security-engineer",
      "mandatory": true,
      "criteria": ["0 CVEs", "Prompt injection guardrails verified", "Secret handling secure"]
    },
    {
      "gate_name": "qa_gate",
      "owner_agent": "senior-qa-architect",
      "mandatory": true,
      "criteria": ["Unit & Integration tests passing", "RAG evaluation benchmarks passing", ">=80% coverage"]
    },
    {
      "gate_name": "release_gate",
      "owner_agent": "senior-devops-engineer",
      "mandatory": true,
      "criteria": ["CI/CD green", "Health check responding", "Human confirmation received"]
    }
  ],
  "execution_phases": [
    { "phase_id": "P0", "phase_name": "Requirement Analysis", "active_agents": ["requirement-analyzer"], "gate": "NONE" },
    { "phase_id": "P1", "phase_name": "Architecture & AI Strategy", "active_agents": ["senior-system-architect", "senior-product-manager", "senior-ai-engineer", "senior-security-engineer", "senior-database-architect"], "gate": "architecture_gate" },
    { "phase_id": "P3", "phase_name": "Detailed Technical Design", "active_agents": ["senior-system-designer"], "gate": "NONE" },
    { "phase_id": "P4", "phase_name": "Parallel Implementation", "active_agents": ["senior-llm-engineer", "senior-nlp-engineer", "senior-backend-engineer", "senior-mlops-engineer", "senior-devops-engineer"], "gate": "NONE" },
    { "phase_id": "P5", "phase_name": "Verification & Benchmarking", "active_agents": ["senior-qa-architect", "senior-performance-engineer", "senior-security-engineer"], "gate": "qa_gate" },
    { "phase_id": "P6", "phase_name": "Ralph Autonomous Loop", "active_agents": ["ralph-evaluator"], "gate": "NONE" },
    { "phase_id": "P7", "phase_name": "Deployment & Release", "active_agents": ["senior-devops-engineer"], "gate": "release_gate" }
  ]
}
```

---

### Example 2: "Build a manufacturing defect detection system"

#### Semantic Capability Inference:
- **Primary Domain**: `computer_vision_system`
- **Extracted Capabilities**: `computer_vision_analytics`, `deep_learning_neural_networks`, `streaming_etl_data_engineering`, `mlops_model_serving_drift`, `api_backend_engineering`, `automated_testing_qa`, `backend_latency_budgeting`, `infrastructure_as_code`.
- **Strictly Excluded Agents**: `senior-llm-engineer`, `senior-nlp-engineer`, `pinterest-researcher`, `brand-guardian`, `ui-designer`, `ux-researcher`.

---

### Example 3: "Build a Next.js e-commerce website"

#### Semantic Capability Inference:
- **Primary Domain**: `saas_web_app`
- **Extracted Capabilities**: `product_requirements_prd`, `seo_strategy_and_content`, `conversion_funnel_optimization`, `visual_brand_identity`, `wireframing_design_systems`, `high_fidelity_ui_design`, `ssr_ssg_frontend_engineering`, `api_backend_engineering`, `relational_data_modeling`, `core_web_vitals_optimization`, `visual_qa_audit`, `automated_testing_qa`, `authentication_rbac_security`, `infrastructure_as_code`.
- **Strictly Excluded Agents**: `senior-ai-engineer`, `senior-llm-engineer`, `senior-nlp-engineer`, `senior-deep-learning-engineer`, `senior-computer-vision-engineer`, `senior-generative-ai-engineer`, `senior-machine-learning-engineer`, `senior-ai-research-engineer`.

---

### Example 4: "Build a lightweight CLI log parser"

#### Semantic Capability Inference:
- **Primary Domain**: `lightweight_utility_cli`
- **Extracted Capabilities**: `api_backend_engineering`, `automated_testing_qa`.
- **Active Squad (Minimalist)**: `requirement-analyzer`, `senior-system-architect`, `senior-backend-engineer`, `senior-qa-architect`.
- **All other 25 agents are strictly excluded** to achieve zero overhead.

---

## 3. Authority Invariant Enforcement

The Team Builder guarantees:
1. **No Worker Usurpation**: Specialist engineers are never assigned as approval gate owners.
2. **Mandatory Domain Supervision**: Every specialist agent reports to an active Domain Lead.
3. **Traceable Escalation**: Every active agent has a concrete escalation route in [agent-hierarchy.yaml](file:///D:/Orca/routing/agent-hierarchy.yaml).
4. **Mandatory Release Gate**: No deployment may occur without [Senior DevOps Engineer](file:///D:/Orca/agents/senior-devops-engineer.md) sign-off.
