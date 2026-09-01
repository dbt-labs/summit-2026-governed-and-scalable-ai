# Trainer prompt: generate the governed source-to-mart plan

Use this prompt in a fresh Studio conversation after confirming:

- `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` does not exist;
- the active `planning-governed-source-to-mart` skill and its version 2 template exist under `.agents/skills/`;
- `models/wizard/` contains no unexplained implementation files;
- the human who owns material decisions and plan approval is available when the planner prompts back or presents the completed draft.

Copy and submit only the text below:

```text
Use `planning-governed-source-to-mart` to plan the Alembic procurement slice from scratch. Create the single build spec at `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` for implementation under `models/wizard/`.

The requested public products are:

- `dim_suppliers`, at one row per supplier, for procurement analysis;
- `fct_brews`, at one row per brew event, for production analysis, including estimated standard ingredient supply cost based on recipe quantities and current ingredient unit costs.

Preserve all brew events. Actual procurement cost, margin, production-to-sales allocation, and Semantic Layer additions are out of scope unless explicitly approved during planning.

Discover the required staging and intermediate lineage from active project conventions, source definitions, and warehouse evidence. Complete the version 2 pre-approval coherence gate before requesting approval. Do not inspect or use `training_assets/reference/` or `models/answer_key/`, create another planning artifact, or implement models. Keep the spec draft until all checks and decisions pass, and mark it approved only after explicit human approval.
```

The prompt supplies the human-requested products and business intent. The active skill, project conventions, source definitions, warehouse evidence, and human decisions determine the detailed specification. Run the build orchestrator in a separate conversation only after approval is recorded.
