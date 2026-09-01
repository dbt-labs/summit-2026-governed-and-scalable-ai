# Trainee starter overlay manifest

## Purpose

This manifest defines the repository state trainees receive for the Governed & Scalable AI-assisted Analytics with dbt workshop. Facilitator references remain under `training_assets/reference/` and must never be copied into trainee planning or implementation.

## Starting-state asset map

| Asset | Active trainee state | Workshop treatment | Facilitator reference |
|---|---|---|---|
| `AGENTS.md` | Ready safety/workflow policy with three bounded discovery TODOs | Complete TODOs 1–3 in Demo 3 from project evidence | `training_assets/reference/AGENTS.md` |
| `SECURITY.md` | Ready training scaffold | Explain boundaries; organization-specific owners remain placeholders | `training_assets/reference/SECURITY.md` |
| `.agents/ROUTING.md` | Ready routes that expose missing layer-skill prerequisites | Inspect in Demo 4 and use throughout | Matching reference routing |
| `building-governed-skills` | Ready | Use in demos 5–6 to create the three layer skills | Matching reference skill |
| `planning-governed-source-to-mart` | Ready | Introduce in Demo 4; create and approve the Alembic spec in Demo 7 | Matching reference skill and template |
| `building-governed-source-to-mart` | Ready | Introduce in Demo 4; enforce readiness and build in Demo 7 | Matching reference skill |
| `authoring-staging-models` | Intentionally absent | Build with the trainer in Demo 5 | Canonical reference skill |
| `authoring-intermediate-models` | Intentionally absent | Trainees build in Demo 6 | Canonical reference skill |
| `authoring-governed-marts` | Intentionally absent | Trainees build in Demo 6 | Canonical reference skill |
| `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` | Intentionally absent | Create live in Demo 7; sole planning and verification artifact | Canonical approved reference spec |
| Governed review and job-investigation skills | Ready | Use for review and facilitator showcases | Matching reference assets |
| `.github/pull_request_template.md` and `.github/CODEOWNERS` | Ready root-owned controls | Discuss traceability, ownership, and scale | No duplicate facilitator reference |
| `models/warlock/` | Empty mirrored layer skeleton | Build the intentionally under-governed baseline in Demo 2 | Compare behavior, not answer-key SQL |
| `models/wizard/` | Empty mirrored layer skeleton | Build only after the spec and all layer skills are ready | `models/answer_key/` remains facilitator-only |

The retired generic governed-change workflow, dbt change plan, source-onboarding workflow, source-to-target design, and layer checklists remain absent.

## Intentional workshop progression

1. Demo 2 creates the Warlock baseline before the discovery TODOs and layer skills are complete.
2. Demo 3 fills exactly three `TODO(training):` sections in root `AGENTS.md` from project evidence.
3. Demo 4 discovers that routing and the build orchestrator require three missing layer skills.
4. Demos 5–6 create those skills with `building-governed-skills`.
5. Demo 7 creates and approves the single Alembic build spec, then runs the orchestrator in a fresh conversation.
6. Demo 8 reviews the implementation and verification evidence against that same spec.

## Track naming and isolation

- Warlock models append `__warlock`; Wizard models use canonical unsuffixed names.
- New Warlock refs remain within the Warlock track; new Wizard refs remain within the Wizard track.
- Both tracks may reuse declared sources, shared macros, `stg_abra_pos__potions`, and `stg_alembic_ops__shops` where the active approved spec requires them.
- Both tracks use the standard staging and marts schemas; distinct relation names and tags preserve isolation.

## TODO marker contract

Root `AGENTS.md` contains exactly three deliberate `TODO(training):` markers covering: project map/authority; layer/grain/naming/SQL patterns; and documentation/testing/contracts/evidence. They must be resolved from active project evidence before governed planning and implementation. Organization-specific owner placeholders in `SECURITY.md` are adoption work, not workshop TODOs.

## Starter-overlay validation

Before publishing or resetting the trainee branch, verify:

- [ ] Root `AGENTS.md` has exactly three training TODOs and the complete reference policy remains under `training_assets/reference/AGENTS.md`.
- [ ] The active Alembic build spec is absent.
- [ ] The three active layer skills are absent while planning, orchestration, skill-building, review, and job-investigation skills remain present.
- [ ] Retired generic workflows, plans, source-to-target templates, and layer checklists are absent.
- [ ] Completed starter SQL/YAML is unchanged.
- [ ] `models/warlock/` and `models/wizard/` contain no trainee SQL/YAML.
- [ ] Disabled answer-key resources remain disabled and facilitator-only.
- [ ] `dbt ls --resource-type model` contains no Warlock or Wizard trainee nodes.
- [ ] `dbt parse --no-partial-parse` passes; empty track config warnings are expected.
- [ ] The orchestrator stops cleanly while the spec or any layer skill is missing.

## Maintenance

Update this manifest whenever workshop sequencing, readiness gates, active skills, reference assets, track conventions, or Platform skill discovery changes. Keep slides synchronized only after the demo plans are stable.
