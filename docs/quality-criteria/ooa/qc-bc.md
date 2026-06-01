# Quality Criteria: Business Case (BC)

## Metadata
| Key | Value |
|-----|-------|
| Id | QC-BC |
| Artifact | BC — Business Case |
| Cross-reference | *Applying UML and Patterns* — Craig Larman |
| UAS artifact-type | `BC` |
| Skill command | `/create-bc` |

### Change Log
| Date | Version | Description | Author |
|------|:-------:|-------------|--------|
| 2026-03-29 | 001 | Initial creation | Tirsvad |
| 2026-05-30 | 002 | Aligned to UAS standard; added scenario model, CBA rules, executive language guide | Tirsvad |

---

## Purpose
The Business Case (BC) is a structured document that justifies the initiation of a project or task. It presents the rationale, expected benefits, costs, risks, and alternatives, providing the evidence base for executive decision-making and investment prioritisation.

---

## Quality Criteria

### 1. Clarity and Structure
- The BC must be well-organised with clearly labelled sections in the prescribed order.
- Language must be **executive-level**: active voice, no unexplained jargon, concrete numbers preferred over vague statements.
- The Executive Summary must stand alone — a decision-maker should be able to read it and understand the recommendation without reading the full document.
- Maximum reading time for the Executive Summary: **2 minutes**.

### 2. Completeness
All of the following sections must be present and non-empty:

| # | Required Section | Minimum Content |
|:-:|-----------------|-----------------|
| 1 | **Executive Summary** | Problem, recommendation, expected ROI, decision required |
| 2 | **Problem Statement** | Background, named stakeholders, cost of inaction |
| 3 | **Objectives** | ≥ 2 SMART objectives with target values and dates |
| 4 | **Options & Alternatives** | All three scenarios: 0 (do nothing), 1 (minimal), 2 (full) |
| 5 | **Cost-Benefit Analysis** | Investment table, benefit table, ROI, payback period |
| 6 | **Risks & Assumptions** | ≥ 1 risk with likelihood, impact, and mitigation |
| 7 | **Timeline** | ≥ 2 delivery phases with durations |
| 8 | **Success Criteria** | ≥ 1 criterion with measurement method and review date |
| 9 | **Recommendation** | Named scenario, evidence-based rationale, decision checkbox |

### 3. Scenario Model
- **Scenario 0 (Do Nothing / Baseline):** Always present. Documents the consequences and ongoing cost of inaction. No investment required.
- **Scenario 1 (Minimal Viable Solution):** Smallest change that meaningfully addresses the problem. Clearly states what it leaves unresolved.
- **Scenario 2 (Full Proposed Solution):** Complete solution. Explicitly states what is out of scope.
- Each scenario with investment must have an estimated cost, estimated benefit, and ROI.

### 4. Cost-Benefit Analysis Rules
- All cost and benefit figures must be provided or explicitly stated as qualitative with a justification.
- ROI formula: `(Net 3-year benefit / Total investment) × 100`
- Payback period: `Total investment / Annual net benefit` (in months)
- Assumptions section required if any figure is estimated.
- Currency must be stated consistently.

### 5. Objectives — SMART Test
Each objective is assessed against:
| Criterion | Test |
|-----------|------|
| **S**pecific | Is the objective unambiguous? |
| **M**easurable | Is there a KPI or metric? |
| **A**chievable | Is the target realistic? |
| **R**elevant | Does it trace to the problem statement? |
| **T**ime-bound | Is there a target date? |

### 6. Relevance
- All content must be specific to the project. Generic boilerplate without project-specific data fails this criterion.
- Financial figures must reference the actual project budget or clearly state they are placeholder estimates.

### 7. Consistency
- Objectives must be traceable to the benefits in the CBA.
- The recommended scenario must be the one with the best risk-adjusted return per the CBA.
- Success Criteria must relate to the stated Objectives.
- Risks in the BC must be consistent with (or a subset of) entries in `docs/specs/risks/risk-register.md`.

### 8. Evidence-Based
- Claims must be supported by data, stakeholder input, or clearly labelled assumptions.
- Stakeholder interviews, market research, or financial data must be listed in the `inputs` field of the YAML frontmatter.

---

## Automated Validation
The `tools/validators/bc-validator.sh` script checks:

| Check | Rule |
|-------|------|
| YAML frontmatter | `id: BC`, `artifact_type: BC`, `version` matches `^\d{3}$` |
| Required sections | All 9 sections listed above are present as `##` headings |
| Scenario 0 | `### Scenario 0` heading is present |
| Scenario 1 | `### Scenario 1` heading is present |
| Scenario 2 | `### Scenario 2` heading is present |
| JSON Snapshot | `## JSON Snapshot` block is present and `id` is `"BC"` |
| Inputs | `inputs` array has ≥ 1 entry |
| Traceability | `metadata.traceability` block is present |

---

## Definition of Done
A Business Case artifact is **complete** when:
- [ ] All 9 required sections are present and non-empty
- [ ] All three scenarios are documented
- [ ] CBA contains either quantified figures or explicit qualitative justifications
- [ ] At least 2 SMART objectives are defined
- [ ] At least 1 risk with mitigation is documented
- [ ] The recommendation names a specific scenario with rationale
- [ ] `bc-validator.sh` exits with code `0`
- [ ] Reviewed and approved by the product owner and/or project manager
