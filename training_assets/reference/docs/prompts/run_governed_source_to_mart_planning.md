# Trainer prompt: generate the governed source-to-mart plan

Use this prompt in a fresh Studio conversation after confirming:

- `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` does not exist;
- the active `planning-governed-source-to-mart` skill and its version 2 template exist under `.agents/skills/`;
- `models/wizard/` contains no unexplained implementation files;
- the human who owns material decisions and plan approval is available when the planner prompts back or presents the completed draft.

Copy and submit only the text below:

```text
Use `planning-governed-source-to-mart` to plan the Alembic procurement slice from scratch. Create the single build spec at `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` for implementation under `models/wizard/`.

Follow the active skill, use only project-owned evidence, and complete its version 2 pre-approval coherence gate before requesting approval. Do not inspect or use `training_assets/reference/` or `models/answer_key/`, create another planning artifact, or implement models. Keep the spec draft until all checks and decisions pass, and mark it approved only after explicit human approval.
```

The prompt is intentionally short enough to invoke the governed planner without duplicating it. The active skill, project-owned authority, warehouse evidence, and human decisions must determine the generated specification. Run the build orchestrator in a separate conversation only after approval is recorded.
