# Training assets

This directory contains the reusable governance assets for the dbt Summit training **Governed & Scalable AI-assisted Analytics with dbt**.

## Directory roles

- `reference/` is the complete, tested final-state answer key for repository governance assets. It is intentionally comprehensive, including a final `AGENTS.md`, even where the active workshop project later contains a simplified or incomplete version.
- `starter/` will hold the learner starting state after the reference assets have passed their acceptance scenarios.
- `lab_guides/` will hold facilitator and participant materials once the starter-state gaps and expected outputs are fixed.

The dbt model answer key is separate: `models/answer_key/` contains the disabled final implementation of the `alembic_ops` procurement slice. Keep non-dbt governance assets out of that directory.

## How to use the reference state

Treat `reference/` as a coherent overlay for a governed dbt project:

1. Start with `AGENTS.md` for always-on project policy.
2. Use `.agents/ROUTING.md` to select the relevant workflow and skill.
3. Follow the workflow and planning template before material implementation.
4. Use task-oriented skills for conditional work such as model changes, metric changes, review, and job investigation.
5. Record decisions and validation evidence in the PR process; rely on dbt contracts, tests, lint, and CI as independent enforcement.

The reference tree is a training template, not a substitute for an organization’s security, identity, retention, or access-control policies. Adapt its placeholders and escalation paths to the owning organization.

See `docs/training_materials/training_asset_delivery_plan.md` for the asset catalog, acceptance criteria, and workshop sequencing.
