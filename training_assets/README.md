# Training assets

This directory contains the reusable governance assets for the dbt Summit training **Governed & Scalable AI-assisted Analytics with dbt**.

## Directory roles

- `reference/` is the complete, tested final-state answer key for repository governance assets. It is intentionally comprehensive, including a final `AGENTS.md`, even where the active workshop project later contains a simplified or incomplete version.
- `trainee_starter_manifest.md` defines the learner starting state: which assets are ready, which are sparse with visible `TODO(training)` gaps, and which are intentionally absent. The starting state itself lives in the active repository root, not in a separate directory.
- `demo_outlines/` holds the facilitator run-of-show for each demo — objectives, timing, repository state, exact Wizard prompts, decision checkpoints, and validation evidence.
- `ppt_edits.md` is the change queue for the slide deck and the map of where each demo slots into it.

The dbt model answer key is separate: `models/answer_key/` contains the disabled final implementation of the `alembic_ops` procurement slice. Keep non-dbt governance assets out of that directory.

## How to use the reference state

Treat `reference/` as a coherent overlay for a governed dbt project:

1. Start with `AGENTS.md` for always-on project policy.
2. Use `.agents/ROUTING.md` to select the relevant workflow and skill.
3. Follow the workflow and planning template before material implementation.
4. Use task-oriented skills for conditional work such as model changes, metric changes, review, and job investigation.
5. Record decisions and validation evidence in the PR process; rely on dbt contracts, tests, lint, and CI as independent enforcement.

The reference tree is a training template, not a substitute for an organization’s security, identity, retention, or access-control policies. Adapt its placeholders and escalation paths to the owning organization.
