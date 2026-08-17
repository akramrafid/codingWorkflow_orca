# Orca Team Builder Specification

The **Team Builder** is the dynamic squad orchestrator of Orca. It consumes the structured capability output from the [Requirement Analyzer](file:///d:/Orca/agents/requirement-analyzer.md) and provisions the minimal optimal squad of senior agents and execution pipelines.

## Team Construction Algorithm

```
function BuildSquad(capabilityPlan):
    activeSquad = []
    
    // 1. Core Architecture is always evaluated
    activeSquad.add("senior-system-architect")
    
    // 2. Map domain triggers
    for domain in capabilityPlan.domains:
        activeSquad.addAll(CapabilityMatrix.getRequiredAgents(domain))
        
    // 3. Evaluate feature triggers
    for feature in capabilityPlan.features:
        activeSquad.addAll(CapabilityMatrix.getFeatureAgents(feature))
        
    // 4. If UI is involved, attach full Design Pipeline
    if capabilityPlan.requiresUI:
        activeSquad.addAll([
            "pinterest-researcher",
            "design-researcher",
            "ux-researcher",
            "senior-product-designer",
            "ui-designer",
            "brand-guardian",
            "visual-qa"
        ])
        
    // 5. Always attach QA & Security gates
    activeSquad.add("senior-qa-architect")
    activeSquad.add("senior-security-engineer")
    
    // 6. Deduplicate and return ordered execution manifest
    return DeduplicateAndOrder(activeSquad)
```

## Squad Output Manifest Format

When invoked, Team Builder outputs a `squad-manifest.json` containing:

```json
{
  "project": "project-name",
  "lead_architect": "senior-system-architect",
  "active_specialists": [
    "senior-system-architect",
    "senior-system-designer",
    "senior-backend-engineer",
    "senior-frontend-engineer",
    "brand-guardian",
    "senior-qa-architect",
    "senior-security-engineer"
  ],
  "gates": {
    "brand_gate": "brand-guardian",
    "security_gate": "senior-security-engineer",
    "qa_gate": "senior-qa-architect"
  },
  "worktree_topology": {
    "backend": "worktree/backend",
    "frontend": "worktree/frontend",
    "ai": "worktree/ai"
  }
}
```
