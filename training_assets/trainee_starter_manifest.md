# Trainee starter overlay manifest

## Purpose

This manifest defines the active repository state trainees should receive at the start of the Governed & Scalable AI-assisted Analytics with dbt workshop. It is the maintenance contract between the tested reference system in `training_assets/reference/`, the active root overlay, the two trainee model tracks, and the facilitator demo materials.

The active overlay is intentionally incomplete. Ready-made safety and workflow assets provide a dependable baseline, while visible `TODO(training)` gaps create the live governance-design exercises. Completed reference assets remain available to facilitators under `training_assets/reference/` and must not be silently copied into trainee work.

## Starting-state asset map

| Asset | Active trainee state | Workshop treatment | Tested reference |
|---|---|---|---|
| `AGENTS.md` | Sparse project context and layer rules with visible governance TODOs | Refine live in the governance demo | `training_assets/reference/AGENTS.md` |
| `SECURITY.md` | Ready training scaffold | Explain boundaries; organization-specific owners remain TODOs | `training_assets/reference/SECURITY.md` |
| `.agents/skills/building-governed-skills/` | Ready | Use to design and review task-oriented skills | Corresponding reference skill |
| `.agents/workflows/governed-dbt-change.md` | Ready | Explain and use during governed work | Corresponding reference workflow |
| `.agents/templates/dbt-change-plan.md` | Ready | Refine or use according to the streamlined workshop design | Corresponding reference template |
| `.agents/ROUTING.md` | Basic routes plus visible source/layer composition TODOs | Refine live | `training_assets/reference/.agents/ROUTING.md` |
| `models/warlock/` | Empty mirrored staging/intermediate/marts skeleton | Build the initial minimally governed baseline | Compare with Wizard behavior, not the answer key |
| `models/wizard/` | Empty mirrored staging/intermediate/marts skeleton | Build the governed Alembic implementation | `models/answer_key/` is facilitator-only comparison |
| Source onboarding and source-to-target resources | Intentionally absent | Build or simplify live before governed implementation | Corresponding reference assets |
| Staging, intermediate, and governed-mart skills | Intentionally absent | Build or simplify live with the skill-building standard | Corresponding reference skills/checklists |
| Governed-metrics skill | Minimal scaffold | Refine around approved semantic decisions | Corresponding reference skill/checklist |
| Governed-review and job-investigation skills | Ready baseline | Use in prepared showcases | Corresponding reference assets |
| `.github/pull_request_template.md` and `.github/CODEOWNERS` | Ready baseline | Walk through review and ownership controls | Corresponding reference assets |
| Governance scorecard | Reference only | Use as a scaling takeaway | `training_assets/reference/docs/governance_scorecard.md` |

## Intentional trainee gaps

The following active governance assets remain absent at workshop start until the refinement phase decides their final streamlined shape:

- `.agents/workflows/onboarding-source-system.md`
- `.agents/templates/source-to-target-design.md`
- `.agents/skills/authoring-staging-models/`
- `.agents/skills/authoring-intermediate-models/`
- `.agents/skills/authoring-governed-marts/`

The completed starter-state models must remain unchanged. Both trainee tracks start empty. Disabled comparison models remain under `models/answer_key/` with `__expected` names.

## Track naming and isolation

- Warlock models append `__warlock` to node names and use only Warlock refs for the newly created Alembic path.
- Wizard models use canonical unsuffixed target names and use only Wizard refs for the newly created Alembic path.
- Both tracks may reuse existing shared sources, macros, `stg_abra_pos__potions`, and `stg_alembic_ops__shops` where the approved lineage requires them.
- Both tracks use the standard `staging` and `marts` schemas; distinct node/relation names prevent collisions, and tags support track-level selection.

## TODO marker contract

Use the exact prefix `TODO(training):` for workshop gaps. Each marker must name one decision or artifact, point to inspectable evidence, be resolved in a named exercise or retained as organization-specific follow-up, and map to tested reference behavior.

## Starter-overlay validation

Before publishing or resetting the trainee branch, verify:

- [ ] Active ready assets exist and internal links resolve.
- [ ] Intentional governance gaps match the final demo sequence.
- [ ] Completed starter-state SQL/YAML is unchanged.
- [ ] `models/warlock/` and `models/wizard/` contain no trainee SQL/YAML.
- [ ] Disabled answer-key resources remain disabled and use `__expected` names.
- [ ] `dbt ls --resource-type model` contains no Warlock or Wizard trainee nodes.
- [ ] `dbt parse` passes.
- [ ] Track resource configs resolve without unused-path warnings once models are created.
- [ ] One ready skill is discoverable from the active `.agents/skills/` path.

## Maintenance

Update this manifest whenever a demo changes its starting state, a ready asset is added or removed, a reference skill changes materially, the track convention changes, or Platform skill-discovery behavior changes. Preserve the distinction between trainee output and facilitator-only references.
