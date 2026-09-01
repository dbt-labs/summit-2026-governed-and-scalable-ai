# Training assets

This directory contains the reusable governance assets for the dbt Summit training **Governed & Scalable AI-assisted Analytics with dbt**.

## Directory roles

- `reference/` is the complete, tested final-state answer key for repository governance assets. It is intentionally comprehensive, including a final `AGENTS.md`, even where the active workshop project contains a simplified or incomplete version.
- `trainee_starter_manifest.md` defines the learner starting state: which assets are ready, which are sparse with visible `TODO(training)` gaps, and which are intentionally absent.
- `demo_outlines/` holds the facilitator run-of-show for each demo: objectives, timing, repository state, exact Wizard prompts, decision checkpoints, and validation evidence.
- `ppt_edits.md` is the change queue for the slide deck and the map of where each demo slots into it.

The dbt implementation comparison has three locations:

- `models/warlock/` — the trainee’s initial minimally governed build, using `__warlock` node-name suffixes.
- `models/wizard/` — the trainee’s governed build, using canonical target names.
- `models/answer_key/` — disabled facilitator comparison models; never implementation input.

The completed starter-state models remain in their existing standard layer paths and are not modified during either trainee build.

## How to use the reference state

Treat `reference/` as a coherent overlay for a governed dbt project:

1. Start with `AGENTS.md` for always-on project policy.
2. Use `.agents/ROUTING.md` to select the relevant workflow and skill.
3. Follow the shared material-change lifecycle and record only the decisions and evidence required for the task.
4. Use task-oriented skills for conditional work such as model changes, metric changes, review, and job investigation.
5. Rely on dbt contracts, tests, lint, CI, and human review as independent enforcement.

The reference tree is a training template, not a substitute for an organization’s security, identity, retention, or access-control policies. Adapt its placeholders and escalation paths to the owning organization.
