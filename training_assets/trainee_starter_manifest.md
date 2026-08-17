# Trainee starter overlay manifest

## Purpose

This manifest defines the active repository state trainees should receive at the start of the Governed & Scalable AI-assisted Analytics with dbt workshop. It is the maintenance contract between the tested reference system in `training_assets/reference/`, the active root overlay, and the facilitator demo materials.

The active overlay is intentionally incomplete. Ready-made safety and workflow assets provide a dependable baseline, while visible `TODO(training)` gaps create the live governance-design exercises. Completed reference assets remain available to facilitators under `training_assets/reference/` and must not be silently copied into trainee work.

## Starting-state asset map

| Asset | Active trainee state | Workshop treatment | Tested reference |
|---|---|---|---|
| `AGENTS.md` | Sparse project context and layer rules with visible governance TODOs | Refine live in demo 02 | `training_assets/reference/AGENTS.md` |
| `SECURITY.md` | Ready training scaffold | Explain boundaries; organization-specific owners remain TODOs | `training_assets/reference/SECURITY.md` |
| `.agents/skills/building-governed-skills/` | Ready | Use to design and review task-oriented skills | Corresponding reference skill |
| `.agents/workflows/governed-dbt-change.md` | Ready | Explain and use during planning | Corresponding reference workflow |
| `.agents/templates/dbt-change-plan.md` | Ready | Complete for material changes | Corresponding reference template |
| `.agents/ROUTING.md` | Basic ready routes plus visible source/layer composition TODOs | Refine live in demo 02 | `training_assets/reference/.agents/ROUTING.md` |
| Source onboarding workflow and source-to-target template | Intentionally absent | Build live before Alembic implementation | Corresponding reference assets |
| Staging, intermediate, and governed-mart skills | Intentionally absent | Build live with the skill-building standard | Corresponding reference skills/checklists |
| Governed-metrics skill | Minimal scaffold with visible definition/validation TODOs | Refine around approved semantic decisions | Corresponding reference skill/checklist |
| Governed-review skill and rubric | Ready baseline | Use in the review showcase | Corresponding reference skill/rubric |
| Job-investigation skill and runbook | Ready baseline | Use in the operational showcase | Corresponding reference skill/runbook |
| `.github/pull_request_template.md` and `.github/CODEOWNERS` | Ready baseline | Walk through review and ownership controls | Corresponding reference assets |
| Governance scorecard | Reference only | Use as a scaling takeaway in demos 06 and 07 | `training_assets/reference/docs/governance_scorecard.md` |

## Intentional trainee gaps

The following active assets must remain absent at workshop start:

- `.agents/workflows/onboarding-source-system.md`
- `.agents/templates/source-to-target-design.md`
- `.agents/skills/authoring-staging-models/`
- `.agents/skills/authoring-intermediate-models/`
- `.agents/skills/authoring-governed-marts/`

The active Alembic procurement solution must also remain unbuilt. The only active Alembic model at workshop start is the pre-existing `stg_alembic_ops__shops`; completed comparison models remain disabled under `models/answer_key/` with `__expected` names.

## TODO marker contract

Use the exact prefix `TODO(training):` for workshop gaps. Each marker must:

1. name one decision or artifact trainees are expected to complete;
2. point to evidence they can inspect rather than supplying the answer;
3. be resolved in a named demo or explicitly retained as organization-specific follow-up; and
4. map to a tested section or behavior in `training_assets/reference/`.

Facilitator demo files should include a convergence map with the starting asset, evidence to inspect, decision checkpoint, exact Wizard prompt, target concepts, validation, reference comparison, and recovery path.

## Starter-overlay validation

Before publishing or resetting the trainee branch, verify:

- [ ] Active ready assets exist and all internal links resolve.
- [ ] Intentional source-onboarding and layer-skill gaps remain absent.
- [ ] `TODO(training)` markers match the demo sequence and reference targets.
- [ ] No active procurement staging, intermediate, `dim_suppliers`, or `fct_brews` solution exists.
- [ ] Disabled answer-key resources use `__expected` names and do not collide with trainee model names.
- [ ] `dbt ls --resource-type model` shows only `stg_alembic_ops__shops` in the active Alembic slice.
- [ ] `dbt parse` passes.
- [ ] One ready skill is discoverable from the active `.agents/skills/` path.
- [ ] Missing source/layer routes produce the intended training prompt rather than pretending a completed skill exists.

## Maintenance

Update this manifest whenever a demo changes its starting state, a ready asset is added or removed, a reference skill changes materially, or platform skill-discovery behavior changes. Preserve the distinction between active trainee policy and facilitator-only reference answers.
