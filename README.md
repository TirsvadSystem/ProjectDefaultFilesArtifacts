# Default files for project. It includes AI skills and quality criteria

Default files for software projects — includes AI Claude skills, spec artifact templates, validation tools, and quality criteria.

## 📋 Table of Contents

- [📁 Repository Structure](#-repository-structure)
- [📚 Artifact Registry](#-artifact-registry)
- [🎛️ Unified Artifact Structure (UAS)](#-unified-artifact-structure-uas)
- [📄 Specification Artifacts](#-specification-artifacts)
  - [💼 Business Case](#-business-case)
  - [🗺️ Business Model Canvas](#️-business-model-canvas)
  - [⚠️ Risk Register](#️-risk-register)
  - [✅ FURPS+](#-furps+)
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
├── .claude/
│   ├── artifact-registry.json     # Centralized artifact registry (schema hub)
│   ├── uas-engine.md              # Artifact generation rules and templates
│   ├── uas-schema.json            # JSON schema for artifact validation
│   └── commands/                  # Claude slash commands (one per artifact type)
│       ├── create-bc.md           # /create-bc
│       ├── create-bmc.md          # /create-bmc
│       ├── create-risks.md        # /create-risks
│       ├── create-furps.md        # /create-furps
│       ├── create-kpi.md          # /create-kpi
│       ├── create-glossary.md     # /create-glossary
│       ├── create-milestones.md   # /create-milestones
│       ├── create-domain-model.md # /create-domain-model
│       ├── create-erd.md          # /create-erd
│       ├── create-adr.md          # /create-adr [NNN title]
│       └── create-use-case.md     # /create-use-case [NNN name] [artifact]
│
└── tools/
    └── validators/                # Validator shell scripts
```

---

## 📚 Artifact Registry

The **centralized artifact registry** at [`.claude/artifact-registry.json`](.claude/artifact-registry.json) is the single source of truth for every artifact type in this project.

It defines, for each artifact:
- **Name, description, and purpose**
- **Identification rules** — exact `id` format and regex pattern
- **Template and example file paths**
- **Dependency graph** — which artifacts feed into which
- **Required sections** — what content the artifact must contain
- **Validator script** — which tool checks it in CI

### Artifact Overview

| Artifact | ID format | Skill command | Depends on |
|----------|-----------|---------------|------------|
| Business Case | `BC` | `/create-bc` | — |
| Business Model Canvas | `BMC` | `/create-bmc` | BC |
| Risk Register | `RISKS` | `/create-risks` | BC |
| FURPS+ | `FURPS` | `/create-furps` | BC |
| KPI Catalog | `KPI` | `/create-kpi` | BC, BMC |
| Glossary | `GLOSSARY` | `/create-glossary` | — |
| Milestones & Gateways | `MILESTONES` | `/create-milestones` | BC, RISKS |
| Domain Model | `DM` | `/create-domain-model` | GLOSSARY |
| ERD | `ERD` | `/create-erd` | DM, GLOSSARY |
| Architecture Decision Record | `ADR001`, `ADR002`… | `/create-adr [NNN title]` | — |
| Use Case Specification | `UC001`, `UC002`… | `/create-use-case [NNN name]` | GLOSSARY, DM |
| System Sequence Diagram | `UC001-SSD`… | `/create-use-case [NNN name] ssd` | UC{NNN} |
| Operation Contract | `UC001-OC`… | `/create-use-case [NNN name] oc` | UC{NNN}-SSD |
| Domain Model View | `UC001-DM`… | `/create-use-case [NNN name] dm` | DM, UC{NNN} |
| Design Class Diagram | `UC001-DCD`… | `/create-use-case [NNN name] dcd` | UC{NNN}-OC, UC{NNN}-DM |
| Sequence Diagram | `UC001-SD`… | `/create-use-case [NNN name] sd` | UC{NNN}-DCD |
| ERD View | `UC001-ERD`… | `/create-use-case [NNN name] erd` | ERD, UC{NNN}-OC |

### Dependency Order

Artifacts should be created in this order to ensure each one can reference its inputs:

```
GLOSSARY → BC → BMC
               → RISKS → MILESTONES
               → FURPS
               → KPI
         → DM  → ERD
               → UC{NNN} → UC{NNN}-SSD → UC{NNN}-OC → UC{NNN}-DM → UC{NNN}-DCD → UC{NNN}-SD
                                                                                 → UC{NNN}-ERD
ADR{NNN} (independent — created as decisions arise)
```

---

## 🎛️ Unified Artifact Structure (UAS)

All specification artifacts follow the **Unified Artifact Structure Standard (UAS)**, enforced by three files in `.claude/`:

| File | Purpose |
|------|--------|
| [`.claude/artifact-registry.json`](.claude/artifact-registry.json) | **Single source of truth** — lists every artifact type, its ID format, templates, examples, dependencies, and validator |
| [`.claude/uas-engine.md`](.claude/uas-engine.md) | **Generation rules** — identification table, versioning rules, output template, and section guide per artifact type |
| [`.claude/uas-schema.json`](.claude/uas-schema.json) | **JSON Schema** — validates artifact metadata and content snapshots; enforces ID patterns per type |

**How it works:**

1. **`uas-engine.md`** tells the generator **what** to produce:
   - Each artifact must have a unique `id` per type (e.g., `BC`, `UC001`, `ADR001`)
   - Version must be 3-digit zero-padded (`001`, `002`, not `v1.0.0`)
   - Must list all inputs (documents, decisions, assumptions)
   - Must include traceability links to related artifacts
   - Must include a `JSON Snapshot` block at the end

2. **`uas-schema.json`** tells the generator **how to validate**:
   - All artifacts must conform to this JSON schema
   - CI/CD tools can automatically validate artifacts against it
   - Enforces ID patterns, version formats, and required fields

**Why it matters:**

- ✅ **Consistency** — Every artifact follows the same structure
- ✅ **Validation** — CI can automatically check compliance
- ✅ **Traceability** — Artifacts are linked together
- ✅ **Automation** — Easy to integrate with tools and workflows

For detailed rules and templates, see [`uas-engine.md`](.claude/uas-engine.md).

### Artifact Output Structure

All artifacts use a consistent structure with the following fields:

| Field | Description | Example |
|-------|-------------|----------|
| `id` | Unique identifier per artifact type | `BC`, `UC001`, `ADR001` |
| `artifact_type` | Artifact type code | `BC`, `BMC`, `RISKS` |
| `title` | Human-readable title | `Business Case` |
| `version` | 3-digit version number | `001` |
| `purpose` | One or two sentences explaining the artifact | `Describes the business justification...` |
| `inputs` | List of documents, decisions, assumptions used | `Requirements doc v2.1` |
| `metadata.domain` | Business/technical domain | `ecommerce` |
| `metadata.tags` | Searchable tags | `#ecommerce`, `#ordering` |
| `metadata.author` | Creator of this artifact version | `Jane Doe` |
| `metadata.created` | ISO 8601 date | `2026-05-31` |
| `metadata.traceability.relates_to` | Related artifact IDs | [`ADR001`, `BC`] |
| `metadata.traceability.supersedes` | Replaced artifact IDs | `[]` |

### Artifact Content Sections

Different artifact types require different sections:

| Type | Required Sections |
|------|-------------------|
| BC | Problem Statement, Proposed Solution, Costs \& Benefits, Strategic Alignment, Recommendation |
| BMC | Key Partners, Key Activities, Key Resources, Value Propositions, Customer Relationships, Channels, Customer Segments, Cost Structure, Revenue Streams |
| RISKS | Risk Table (ID, Description, Likelihood, Impact, Mitigation, Owner, Status) |
| FURPS | Functionality, Usability, Reliability, Performance, Supportability, Design Constraints, Implementation Constraints, Interface Constraints, Physical Constraints |
| KPI | KPI Table (ID, Name, Description, Formula, Target, Owner, Frequency) |
| GLOSSARY | Term Table (Term, Definition, Synonyms, Source) |
| MILESTONES | Milestone Table (ID, Name, Target Date, Entry Criteria, Exit Criteria, Owner, Status) |
| DOMAIN_MODEL | Mermaid `classDiagram`, entity descriptions |
| ERD | Mermaid `erDiagram`, table descriptions |
| ADR | Status, Context, Decision, Consequences |
| UC_SPEC | Actors, Preconditions, Main Flow, Alternate Flows, Exception Flows, Postconditions |
| UC_SSD | Mermaid `sequenceDiagram` (actor ↔ system boundary only) |
| UC_SD | Mermaid `sequenceDiagram` (full internal object interactions) |
| UC_OC | Operation Contract Table (Operation, Preconditions, Postconditions) |
| UC_DCD | Mermaid `classDiagram` (implementation classes, methods, attributes) |
| UC_DOMAIN_MODEL_VIEW | Mermaid `classDiagram` (domain entities relevant to this UC only) |
| UC_ERD_VIEW | Mermaid `erDiagram` (tables relevant to this UC only) |

### JSON Snapshot

Every artifact ends with a machine-readable JSON Snapshot:

```json
{
  "id": "UC001",
  "artifact_type": "UC_SPEC",
  "version": "001",
  "content_snapshot": {
    "actors": ["Customer", "Admin"],
    "preconditions": ["User is authenticated"],
    "tags": ["#ordering", "#customer"]
  }
}
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

**Schema Validation:**

All artifacts generated by the UAS engine include a `JSON Snapshot` block at the end that validates against [`uas-schema.json`](.claude/uas-schema.json). This enables:

- Automatic validation in CI/CD pipelines
- Machine-readable indexing and search
- Consistent metadata extraction

---

## ⚙️ GitHub Actions CI

**Path:** [`.github/workflows/artifact-quality.yml`](.github/workflows/artifact-quality.yml)

Automated CI pipeline that runs all validators on every pull request and push to `main`, ensuring artifact quality gates are met before merging.
