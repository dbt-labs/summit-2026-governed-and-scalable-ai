# Training assets

This directory contains reusable governance assets for the dbt Summit training **Governed & Scalable AI-assisted Analytics with dbt**.

## Directory roles

- `reference/` is the facilitator-only, tested final-state reference for governance assets and the canonical approved Alembic build spec. It must not be used as trainee planning or implementation input.
- `trainee_starter_manifest.md` defines the learner starting state, live-created artifacts, and readiness gates.
- `demo_outlines/` holds the facilitator run-of-show, prompts, decision checkpoints, and expected evidence. These outlines are being realigned after the workflow and orchestrator stabilize.
- `ppt_edits.md` is the slide-deck change queue and will be updated last.

The dbt implementation comparison has three locations:

- `models/warlock/` — the trainee's initial minimally governed build, using `__warlock` node-name suffixes.
- `models/wizard/` — the trainee's governed build, using canonical target names.
- `models/answer_key/` — disabled facilitator comparison models; never implementation input.

The completed starter-state models remain in their existing standard layer paths and are not modified during either trainee build.

## Current governed exercise

1. Use active project documentation and warehouse evidence to create and approve one project-owned `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` with `planning-governed-source-to-mart`.
2. Use the active staging, intermediate, and mart execution skills. The trainer prompts remain available for demonstrating or reproducing skill authoring without making regeneration part of every orchestrator test.
3. Use `building-governed-source-to-mart` to implement the approved spec and update only its `verification` section.
4. Review the implementation against the approved spec with `reviewing-governed-dbt-changes`.
5. Rely on dbt contracts, tests, lint, warehouse checks, CI, and accountable human review as independent enforcement.

The reference tree is a training template, not a substitute for an organization's security, identity, retention, access-control, or production-action policies.
