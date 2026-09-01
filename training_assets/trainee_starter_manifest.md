# Trainee starter overlay manifest

## Purpose

This manifest defines the active repository state trainees receive for the Governed & Scalable AI-assisted Analytics with dbt workshop. It is the maintenance contract between active policy and skills, live-created workshop artifacts, facilitator-only references, and the two trainee model tracks.

The starter includes a coherent governance path and deliberate execution readiness gates. Facilitator references remain under `training_assets/reference/` and must never be copied into trainee planning or implementation.

## Starting-state asset map

| Asset | Active trainee state | Workshop treatment | Facilitator reference |
|---|---|---|---|
| `AGENTS.md` | Ready governed policy with authoritative sources, lifecycle, prompt-backs, and skill governance | Explain as always-on policy | `training_assets/reference/AGENTS.md` |
| `SECURITY.md` | Ready training scaffold | Explain boundaries; organization-specific owners remain placeholders | `training_assets/reference/SECURITY.md` |
| `.agents/ROUTING.md` | Ready outcome-oriented routes and readiness gates | Use throughout planning, skill creation, build, and review | Matching reference routing |
| `planning-governed-source-to-mart` | Ready | Create and approve the active Alembic build spec | Matching reference skill and template |
| `building-governed-source-to-mart` | Ready | Stop until the spec is approved and all three layer skills exist; then orchestrate implementation | Matching reference skill |
| `building-governed-skills` | Ready | Use to revise, evaluate, merge, or retire reusable execution skills; trainer prompts can reproduce the authoring exercise | Matching reference skill |
| `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` | Intentionally absent | Create live through planning; this is the sole persistent source-to-mart planning and verification artifact | Canonical approved reference spec |
| Staging, intermediate, and governed-mart skills | Ready canonical versions | Use directly for orchestrator tests; trainer prompts remain facilitator reproducibility assets | Matching promoted reference skills |
| Governed-metrics skill | Trainee scaffold with visible TODOs | Refine only when the semantic-governance exercise remains in scope | Completed reference skill/checklist |
| Governed-review and job-investigation skills | Ready | Use for review and operational showcases | Matching reference assets |
| `.github/pull_request_template.md` and `.github/CODEOWNERS` | Ready | Record approved artifact, evidence, AI assistance, and accountable review | Matching reference assets |
| `models/warlock/` | Empty mirrored layer skeleton | Build the initial minimally governed baseline | Compare behavior, not answer-key SQL |
| `models/wizard/` | Empty mirrored layer skeleton | Build only from the active approved spec and active layer skills | `models/answer_key/` remains facilitator-only |

The old generic governed-change workflow, dbt change plan, source-onboarding workflow, source-to-target design, and layer checklists are retired. They are absent from both active and reference governance trees.

## Intentional live-created asset

Before governed implementation can begin, trainees create `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` through the planning skill and obtain approval for every required decision.

The build orchestrator must stop if the active spec is missing or unapproved, or if an active layer skill becomes unavailable. A missing active asset is never permission to inspect `training_assets/reference/` or `models/answer_key/`.

## Track naming and isolation

- Warlock models append `__warlock`; Wizard models use canonical unsuffixed names.
- New Warlock refs remain within the Warlock track; new Wizard refs remain within the Wizard track.
- Both tracks may reuse declared sources, shared macros, `stg_abra_pos__potions`, and `stg_alembic_ops__shops` where the active approved spec requires them.
- Both tracks use the standard `staging` and `marts` schemas; distinct relation names and tags preserve isolation.

## TODO marker contract

`TODO(training):` is reserved for a deliberate exercise gap that maps to a named activity and tested reference behavior. The root `AGENTS.md` no longer uses TODOs because its authority, lifecycle, human decision boundaries, and skill governance are established policy. Organization-specific owner/contact placeholders in `SECURITY.md` remain adoption work, not workshop design gaps.

## Starter-overlay validation

Before publishing or resetting the trainee branch, verify:

- [ ] Active `AGENTS.md`, `SECURITY.md`, routing, planning, build-orchestration, skill-building, review, and job-investigation assets exist and links resolve.
- [ ] The active Alembic build spec is absent, while all three canonical active layer skills are present.
- [ ] Retired generic workflows, plans, source-to-target templates, and layer checklists are absent.
- [ ] Completed starter SQL/YAML is unchanged.
- [ ] `models/warlock/` and `models/wizard/` contain no trainee SQL/YAML.
- [ ] Disabled answer-key resources remain disabled and facilitator-only.
- [ ] `dbt ls --resource-type model` contains no Warlock or Wizard trainee nodes.
- [ ] `dbt parse --no-partial-parse` passes; empty track config warnings are expected until trainee models exist.
- [ ] The planning route can create one approved spec without implementation.
- [ ] The build route stops cleanly when the spec or any layer skill is missing.

## Maintenance

Update this manifest whenever workshop sequencing, readiness gates, active skills, reference assets, track conventions, or Platform skill-discovery behavior changes. Keep demo outlines and slides synchronized only after the governed workflow and orchestrator acceptance behavior are stable.
