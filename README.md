# ProjectDefaultFilesArtifacts

Default files for software projects — includes AI Claude skills, spec artifact templates, validation tools, and quality criteria.

## 📋 Table of Contents

- [📁 Repository Structure](#-repository-structure)
- [📄 Specification Artifacts](#-specification-artifacts)
  - [💼 Business Case](#-business-case)
  - [🗺️ Business Model Canvas](#️-business-model-canvas)
  - [⚠️ Risk Register](#️-risk-register)
  - [✅ FURPS+](#-furps)
  - [📊 KPI Catalog](#-kpi-catalog)
  - [📖 Glossary](#-glossary)
  - [🏁 Milestones & Gateways](#-milestones--gateways)
  - [🧩 Domain Model](#-domain-model)
  - [🗄️ Entity Relationship Diagram](#️-entity-relationship-diagram)
  - [📌 Architecture Decision Records](#-architecture-decision-records)
  - [🔄 Use Cases](#-use-cases)
- [🔍 Quality Criteria](#-quality-criteria)
- [🤖 Validation Tools](#-validation-tools)
- [⚙️ GitHub Actions CI](#️-github-actions-ci)

---

## 📁 Repository Structure

```
/
├── docs/
│   ├── quality-criteria/          # Quality criteria definitions (added later)
│   └── specs/
│       ├── bc/                    # Business Case
│       ├── bmc/                   # Business Model Canvas
│       ├── risks/                 # Risk Register
│       ├── furps/                 # FURPS+ Requirements
│       ├── kpi/                   # KPI Catalog
│       ├── glossary/              # Project Glossary
│       ├── milestones-gateways/   # Milestones & Gateways
│       ├── domain-model/          # Domain Model
│       ├── erd/                   # Entity Relationship Diagram
│       ├── adr/                   # Architecture Decision Records
│       └── use-cases/             # Use Case artifacts
│           ├── uc001-create-order/ # example
│           ├── uc002-cancel-order/ # example
│           └── uc{{use-case-number}}-{{use-case-name}}/   # Template
│
├── .github/
│   └── workflows/
│       └── artifact-quality.yml   # CI quality checker
│
└── tools/
    └── validators/                # Validator shell scripts
```

---

## 📄 Specification Artifacts

All specification artifacts live under `docs/specs/`.

### 💼 Business Case

**Path:** [`docs/specs/bc/business-case.md`](docs/specs/bc/business-case.md)

Describes the justification for the project — problem statement, proposed solution, costs, benefits, and strategic alignment.

---

### 🗺️ Business Model Canvas

**Path:** [`docs/specs/bmc/business-model-canvas.md`](docs/specs/bmc/business-model-canvas.md)

Structured overview of the business model covering value propositions, customer segments, channels, revenue streams, and key resources.

---

### ⚠️ Risk Register

**Path:** [`docs/specs/risks/risk-register.md`](docs/specs/risks/risk-register.md)

Catalogue of identified risks with likelihood, impact, mitigation strategies, and owners.

---

### ✅ FURPS+

**Path:** [`docs/specs/furps/furps-plus.md`](docs/specs/furps/furps-plus.md)

Non-functional requirements organized by Functionality, Usability, Reliability, Performance, Supportability, and the FURPS+ extensions (Design, Implementation, Interface, Physical).

---

### 📊 KPI Catalog

**Path:** [`docs/specs/kpi/kpi-catalog.md`](docs/specs/kpi/kpi-catalog.md)

Key Performance Indicators with definitions, measurement methods, targets, and owners.

---

### 📖 Glossary

**Path:** [`docs/specs/glossary/glossary.md`](docs/specs/glossary/glossary.md)

Shared project vocabulary — terms, definitions, and synonyms used consistently across all artifacts.

---

### 🏁 Milestones & Gateways

**Path:** [`docs/specs/milestones-gateways/milestones.md`](docs/specs/milestones-gateways/milestones.md)

Project milestones, delivery gates, entry/exit criteria, and target dates.

---

### 🧩 Domain Model

**Path:** [`docs/specs/domain-model/domain-model.md`](docs/specs/domain-model/domain-model.md)

Conceptual model of the business domain — entities, relationships, and core business rules expressed as a UML class diagram (Mermaid).

---

### 🗄️ Entity Relationship Diagram

**Path:** [`docs/specs/erd/erd.md`](docs/specs/erd/erd.md)

Logical data model showing tables, columns, data types, and relationships (Mermaid ERD).

---

### 📌 Architecture Decision Records

**Path:** [`docs/specs/adr/`](docs/specs/adr/)

| File | Description |
|------|-------------|
| [`ADR-001-example.md`](docs/specs/adr/ADR-001-example.md) | Example ADR 1 |
| [`ADR-002-example.md`](docs/specs/adr/ADR-002-example.md) | Example ADR 2 |
| [`ADR-XXX-title.md`](docs/specs/adr/ADR-XXX-title.md) | Template for new ADRs |

Each ADR captures a significant architectural decision: context, decision, consequences, and status.

---

### 🔄 Use Cases

**Path:** [`docs/specs/use-cases/`](docs/specs/use-cases/)

Each use case is a self-contained folder with the following artifacts:

| File | Artifact | Description |
|------|----------|-------------|
| `use-case.md` | Use Case Specification | Actor, preconditions, main flow, alternate flows |
| `ssd.md` | System Sequence Diagram | External interactions between actor and system |
| `sd.md` | Sequence Diagram | Internal object-level interactions |
| `oc.md` | Operation Contract | Pre/post-conditions for each system operation |
| `dcd.md` | Design Class Diagram | Implementation-level class structure |
| `domain-model-view.md` | Domain Model View | Subset of the domain model relevant to this use case |
| `erd-view.md` | ERD View | Subset of the ERD relevant to this use case |

**Example use cases:**

- [`uc001-create-order/`](docs/specs/use-cases/uc001-create-order/)
- [`uc002-cancel-order/`](docs/specs/use-cases/uc002-cancel-order/)

**Template:** [`uc{{use-case-number}}-{{use-case-name}}/`](docs/specs/use-cases/uc{{use-case-number}}-{{use-case-name}}/)

---

## 🔍 Quality Criteria

**Path:** [`docs/quality-criteria/`](docs/quality-criteria/)

Quality criteria definitions for each artifact type will be added here. These drive the CI quality checker and validator scripts.

---

## 🤖 Validation Tools

**Path:** [`tools/validators/`](tools/validators/)

Shell scripts that validate each artifact type against its quality criteria:

| Script | Validates |
|--------|-----------|
| [`bc-validator.sh`](tools/validators/bc-validator.sh) | Business Case |
| [`bmc-validator.sh`](tools/validators/bmc-validator.sh) | Business Model Canvas |
| [`risk-validator.sh`](tools/validators/risk-validator.sh) | Risk Register |
| [`furps-validator.sh`](tools/validators/furps-validator.sh) | FURPS+ |
| [`kpi-validator.sh`](tools/validators/kpi-validator.sh) | KPI Catalog |
| [`glossary-validator.sh`](tools/validators/glossary-validator.sh) | Glossary |
| [`milestone-validator.sh`](tools/validators/milestone-validator.sh) | Milestones & Gateways |
| [`domain-validator.sh`](tools/validators/domain-validator.sh) | Domain Model |
| [`ssd-validator.sh`](tools/validators/ssd-validator.sh) | System Sequence Diagrams |
| [`sd-validator.sh`](tools/validators/sd-validator.sh) | Sequence Diagrams |
| [`oc-validator.sh`](tools/validators/oc-validator.sh) | Operation Contracts |
| [`dcd-validator.sh`](tools/validators/dcd-validator.sh) | Design Class Diagrams |
| [`erd-validator.sh`](tools/validators/erd-validator.sh) | ERD |
| [`adr-validator.sh`](tools/validators/adr-validator.sh) | Architecture Decision Records |
| [`traceability-validator.sh`](tools/validators/traceability-validator.sh) | Cross-artifact traceability |

---

## ⚙️ GitHub Actions CI

**Path:** [`.github/workflows/artifact-quality.yml`](.github/workflows/artifact-quality.yml)

Automated CI pipeline that runs all validators on every pull request and push to `main`, ensuring artifact quality gates are met before merging.
