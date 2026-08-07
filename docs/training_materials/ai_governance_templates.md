# AI governance template map

This is the training inventory for a governed, scalable AI-assisted analytics workflow in dbt Platform. The goal is not to create files for their own sake. Each asset creates a specific control: it guides Wizard with durable context, requires a human decision where judgment matters, or independently enforces correctness after implementation.

## Operating principle

> **Skills and `AGENTS.md` are executable team policy in practice. Ownership, version control, review requirements, change logs, and periodic pruning matter as much as writing them once.**

Treat this set as a starter scaffold. Teams should adopt the smallest useful version first, measure where AI-assisted work still fails or causes rework, then refine it like any other production system.

## Control map

| Control type | Asset | What it does | Suggested location | Workshop treatment |
|---|---|---|---|---|
| Always-on project context | `AGENTS.md` | Defines domain context, source-of-truth documentation, layer rules, naming, mandatory validation, and prohibited shortcuts. | Repository root | Audit/refine |
| Layer baseline | Layer rules in `AGENTS.md` + style guide | States what every staging, intermediate, and mart model must do. This is always-on context, not a separate skill per layer. | `AGENTS.md`; `docs/merlinco/STYLE_GUIDE.md` | Existing pattern; explain |
| Task routing | Routing map | Maps a request to the relevant workflow and skill so the right instructions are loaded predictably. | `.agents/ROUTING.md` | Build live |
| Skill authoring | Skill-building skill | Gives the team a repeatable way to create a focused skill: scope, triggers, required evidence, prompt-backs, references, and validation. | `.agents/skills/building-governed-skills/SKILL.md` | Ready; audit live |
| Staging implementation | Staging-model authoring skill | Builds source declarations and 1:1 staging models: source tests, casts, renames, cleanup, macros, and source profiling. | `.agents/skills/authoring-staging-models/SKILL.md` | Build live |
| Intermediate implementation | Intermediate-model authoring skill | Handles joins, deduplication, fanout control, aggregation, and grain changes before marts. | `.agents/skills/authoring-intermediate-models/SKILL.md` | Build live |
| Governed data products | Mart-authoring skill | Builds public dimensions/facts with stated grain, contracts, tests, descriptions, and interface-impact review. | `.agents/skills/authoring-governed-marts/SKILL.md` | Build live |
| Governed metrics | Semantic-layer authoring skill | Requires an agreed business definition, grain, entities/dimensions, metric type, validation, and consumer impact review before changing metrics. | `.agents/skills/authoring-governed-metrics/SKILL.md` | Scaffold/refine |
| Source-system orchestration | Source-system onboarding workflow | Chains staging → intermediate → marts → semantic as required by the source-to-target plan; it does not assume every layer is needed for every table. | `.agents/workflows/onboarding-source-system.md` | Build live |
| Workflow control | Explore → Plan → Implement → Verify runbook | Makes the shared lifecycle explicit for any material dbt change. | `.agents/workflows/governed-dbt-change.md` | Ready; explain |
| Human decision checkpoint | Generic change plan | Captures intended grain, source authority, business assumptions, contract impact, acceptance criteria, and validation before edits. | `.agents/templates/dbt-change-plan.md` | Ready; use live |
| Source-to-target design checkpoint | Source-system design template | Maps raw tables to staging, required intermediate grain changes, marts, semantic definitions, open business decisions, and validation. | `.agents/templates/source-to-target-design.md` | Build live |
| Reusable detail | Skill reference files | Hold focused examples, checklists, and local conventions without bloating core skills. | `.agents/skills/<skill>/references/` | Optional |
| Sensitive-data boundary | Security/data-handling policy | States data classifications, prohibited contexts/actions, escalation path, and links to organization policy. | `SECURITY.md` or policy repository; linked from `AGENTS.md` | Discuss |
| Change traceability | AI-assisted PR template/label | Records whether Wizard assisted, what decisions a human made, what evidence was reviewed, and what validation passed. | `.github/pull_request_template.md`; repository labels | Scaffold/demo |
| Ownership | `CODEOWNERS` | Requires appropriate reviewers for governance assets, semantic definitions, critical marts, and CI configuration. | `.github/CODEOWNERS` | Build or review |
| Automated enforcement | dbt contracts and data tests | Blocks schema drift and invalid data independently of the author. | Model properties YAML, especially `models/marts/_marts.yml` | Existing proof point |
| Automated enforcement | SQLFluff + parse CI | Catches syntax, configuration, and style problems before merge. | `.github/workflows/` | Existing proof point |
| Warehouse-backed verification | dbt Platform CI | Builds affected nodes and runs warehouse-backed tests before promotion. | dbt Platform job configuration | Demo/pre-record |
| Governed consumption | Semantic models and metrics | Defines the business numbers and dimensions that analytics consumers and AI should use. | `models/marts/_semantic_models.yml`; `models/marts/metrics.yml` | Extend in final lab |
| Runtime action boundary | RBAC and approval mode | Controls who can use Wizard, edit files, approve actions, deploy, or diagnose jobs. | dbt Platform account/project settings | Discuss/demo |
| Operational recovery | Job-troubleshooting skill/runbook | Standardizes how Wizard investigates a failed run and when it stops for a human. | `.agents/skills/`; `docs/runbooks/` | Job-debug lab |
| Measurement and upkeep | Governance scorecard + review cadence | Tracks validation rate, reviewer findings, failure patterns, skill reuse, stale assets, and improvement actions. | `docs/` or team operating repository | Discuss |
| Cross-project scaling | Native package-skill distribution | Shares standardized skills across dbt projects once supported as a first-class capability. | dbt Platform / package distribution | Mention as upcoming |
| Beyond-platform extension | MCP tool policy | Defines which external tools may access governed metrics versus raw SQL, with least-privilege access and evidence expectations. | External MCP configuration plus repository policy | Mention only; point to MCP training |

## Source-system workflow composition

Use the source-system onboarding workflow to compose the relevant layer skills rather than relying on a source-specific skill:

```text
Explore source system and existing project patterns
        ↓
Approve source-to-target design and open business decisions
        ↓
Staging skill for every required raw table
        ↓
Intermediate skill when joins, aggregation, dedupe, fanout control, or grain change is needed
        ↓
Mart skill for public dimensions/facts, contracts, tests, and documentation
        ↓
Semantic skill when a governed entity, dimension, measure, or metric is added or changed
        ↓
Review and verification with build, lint, CI, and recorded evidence
```

A simple one-to-one dimension may project a single staging model. Any public mart that needs joins, aggregation, deduplication, fanout control, or grain changes must consume a named intermediate model instead of implementing that logic directly.

## Prompt-back policy

Prompt-backs are the practical expression of human-in-the-loop design. They should be defined once in the planning/workflow template and repeated in any skill that can encounter them.

Wizard must stop, state the uncertainty, and request a decision when any of the following is unresolved:

1. **Grain or cardinality:** the intended row grain, join type, or fanout behavior is unclear.
2. **Source authority:** multiple sources or models could be the system of record.
3. **Metric definition:** a requested metric conflicts with, duplicates, or materially changes a governed metric.
4. **Business meaning:** a classification, status mapping, null treatment, unit conversion, or other business rule lacks an agreed definition.
5. **Breaking change:** a public model contract, column, type, semantic entity, or downstream interface would change.
6. **Data access or sensitivity:** the task could expose restricted data or requires permissions beyond the current role.
7. **Material performance/cost tradeoff:** the implementation needs a warehouse-cost, materialization, or freshness decision not already encoded in project policy.

A good prompt-back includes: the decision needed, the evidence inspected, viable options and their implications, and the narrowest question needed to proceed.

## Required planning artifact

Before Wizard implements a material dbt change, create a concise plan with:

- Request and intended business outcome.
- Sources, upstream models, and documentation inspected.
- Target models and the grain of each output.
- Proposed transformations, joins, and reusable macros.
- Human decisions and explicit assumptions.
- Contract, test, documentation, semantic-layer, and downstream impact.
- Acceptance criteria and the exact build/test/lint selector that will validate the work.
- Evidence captured after verification and any remaining follow-up.

**Plan thoroughly, execute once.** Reviewers should approve the intended grain, definitions, and acceptance criteria before spending time reviewing generated implementation details.

## Recommended build order for the workshop

1. Establish/refresh `AGENTS.md` and layer conventions.
2. Use the skill-building skill to create focused, task-oriented skills.
3. Add routing so skill selection is predictable.
4. Add the source-system workflow and source-to-target design template.
5. Add review, ownership, and traceability scaffolding.
6. Use the system to plan and build the `alembic_ops` procurement slice.
7. Prove independent enforcement with contracts/tests/CI and extend the Semantic Layer only after business definitions are agreed.

## What stays out of this workshop

The dbt MCP Server, Snowflake Cortex, Runlayer/plugins, enterprise identity architecture, and organization-wide AI observability are important extensions. This training establishes the dbt-native foundation those integrations should consume: versioned context, clear decision rights, enforceable data products, governed metrics, and auditable human ownership.
