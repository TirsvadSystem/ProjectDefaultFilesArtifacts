# Skill: Create Business Case (BC)

You are acting as the **UAS-Engine**. Read `.claude/uas-engine.md`, `.claude/uas-schema.json`, and `.claude/artifact-registry.json` now before proceeding. Also read the quality criteria at `docs/quality-criteria/ooa/qc-bc.md`.

## Task
Generate or update the Business Case artifact for this project, following the quality criteria defined in `docs/quality-criteria/ooa/qc-bc.md`.

**Artifact type:** `BC`  
**ID:** `BC` (fixed — one per project)  
**Output file:** `docs/specs/bc/business-case.md`  
**Quality criteria:** `docs/quality-criteria/ooa/qc-bc.md`

---

## Quality Gates (from QC-BC)

Before accepting the generated artifact as complete, verify ALL of these are satisfied:

| # | Quality Gate | Check |
|:-:|-------------|-------|
| 1 | Executive Summary is present and written for a non-technical audience | ☐ |
| 2 | Problem Statement names specific affected stakeholders and cost of inaction | ☐ |
| 3 | Objectives are SMART (Specific, Measurable, Achievable, Relevant, Time-bound) | ☐ |
| 4 | All three scenarios are present (0 = do nothing, 1 = minimal, 2 = full) | ☐ |
| 5 | Cost-Benefit Analysis contains quantified figures or explicit qualitative justification | ☐ |
| 6 | ROI and payback period are calculated for each non-zero scenario | ☐ |
| 7 | At least one risk is identified with a mitigation | ☐ |
| 8 | High-level timeline with at least two phases is present | ☐ |
| 9 | Success Criteria are measurable with a review date | ☐ |
| 10 | Recommendation names a specific scenario with executive-level rationale | ☐ |

---

## Conversation Flow

### Step 1 — Load context

1. Read `.claude/uas-engine.md`, `.claude/uas-schema.json`, `.claude/artifact-registry.json`, and `docs/quality-criteria/ooa/qc-bc.md`.
2. Read `docs/specs/bc/business-case.md`.
   - If the file already has real content (not just the blank template), ask:
     > "The Business Case already exists at version {{N}}. Do you want to **update** it (version becomes {{N+1}}) or **replace** it entirely?"
   - If it is the blank template or empty, proceed to Step 2.

### Step 2 — Gather inputs (interview the user)

Ask the following questions **one section at a time**, in order. Do not overwhelm the user with all questions at once.

#### 2a — Project identity
- What is the name of the project or initiative?
- Who is the primary author / sponsor?
- What business domain does this belong to (e.g., e-commerce, HR, finance)?
- What is today's date?

#### 2b — Problem Statement
- Describe the current situation and what is wrong or what opportunity exists.
- Who is affected and how?
- What is the estimated cost or consequence of doing nothing (Scenario 0)?

#### 2c — Objectives
- List 2–5 measurable objectives this project must achieve.
- For each: what is the target value and by when?

#### 2d — Scenario 1 — Minimal Viable Solution
- What is the smallest change that meaningfully addresses the problem?
- What does it deliberately leave out?
- Estimated one-off investment (€) and annual running cost (€)?
- Estimated annual benefit (€ or qualitative)?

#### 2e — Scenario 2 — Full Proposed Solution
- Describe the complete solution. What will be built, changed, or acquired?
- What is explicitly out of scope?
- Estimated one-off investment (€) and annual running cost (€)?
- Estimated annual benefit (€ or qualitative)?

#### 2f — Risk summary (top 3)
- What are the top 3 risks if the project proceeds?
- For each risk: likelihood (High/Medium/Low), impact (High/Medium/Low), mitigation.

#### 2g — Timeline
- What are the main delivery phases and their rough duration?
- What is the target launch date?

#### 2h — Success Criteria
- How will you know the project succeeded 6–12 months after launch?
- What specific, measurable criteria will be reviewed?

#### 2i — Recommendation
- Which scenario do you recommend and why?
- What decision are you asking the sponsor/steering committee to make?

### Step 3 — Generate the artifact

Using the answers from Step 2, generate `docs/specs/bc/business-case.md` by filling in the template at `docs/specs/bc/business-case.md`.

Follow these rules:

1. **Executive Summary** — write 3–4 crisp sentences suitable for a C-suite audience. State the problem, recommended scenario, expected ROI, and the decision required. No jargon.

2. **Problem Statement** — be specific. Name the stakeholders. Quantify the cost of inaction wherever possible.

3. **Objectives** — apply SMART criteria. If the user's objective is vague (e.g., "improve performance"), rewrite it as a measurable statement and confirm with the user.

4. **Scenario 0** — always derive this from the cost of inaction. It requires no investment but carries real ongoing cost.

5. **Scenario 1 and 2** — use the user-provided figures. If figures are unavailable, state them as estimates with explicit assumptions listed.

6. **Cost-Benefit Analysis** — calculate:
   - Net benefit (3-year) = (3 × annual benefit) − total 3-year cost
   - ROI % = (Net benefit / total investment) × 100
   - Payback period = total investment / annual net benefit (in months)
   - If any figure is qualitative, note it explicitly rather than omitting the row.

7. **Risks** — assign IDs R-001, R-002, R-003. Note that full risk details should go in `docs/specs/risks/risk-register.md`.

8. **Timeline** — use the user's phases. If no dates are given, leave target dates as `{{YYYY-MM-DD}}`.

9. **Success Criteria** — ensure each criterion has a measurement method and review date. If the user provides a vague criterion, suggest a measurable reformulation.

10. **Recommendation** — name the scenario explicitly. Provide a 3–5 sentence rationale that references CBA results, strategic alignment, and risk profile.

11. **UAS fields** — set:
    - `id: BC`, `artifact_type: BC`
    - `version: 001` (new) or incremented (update)
    - Populate `inputs` with the data sources provided in Step 2
    - Populate `metadata.domain`, `metadata.tags`, `metadata.author`, `metadata.created`
    - Populate JSON Snapshot with the calculated figures

12. **Language** — write for executive-level decision-making. Prefer active voice, concrete numbers, and short sentences. Avoid technical jargon unless the audience is technical.

### Step 4 — Write and confirm

1. Write the completed artifact to `docs/specs/bc/business-case.md`.
2. Run the quality gate checklist (Step 0 above). Report which gates pass ✅ and which still need attention ⚠️.
3. Show the user a one-paragraph summary of the business case:
   > "**BC Summary:** {{Project name}} — {{2-sentence problem}}. Recommended: Scenario {{N}} ({{scenario name}}) with an investment of {{€}} and an expected 3-year ROI of {{%}}. Decision required: {{action}}."
