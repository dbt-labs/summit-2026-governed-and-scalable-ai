# Trainer prompt: build the staging authoring skill

Copy and submit this prompt after discussing the staging-layer decisions with attendees.

```text
Use `building-governed-skills` to create a reusable execution skill at:

`.agents/skills/authoring-staging-models/SKILL.md`

Outcome:

Govern creating or materially changing a source-facing staging model.

Our output invariants:

- Read exactly one declared `source()` using the configured staging materialization.
- Preserve source grain and row retention.
- Perform only grounded renaming, casting, normalization, and approved macro reuse; no joins, aggregation, deduplication, or downstream business logic.
- Inspect actual source columns and values and never invent columns, mappings, null rules, or transformations.
- When an approved build spec exists, match its model path, source input, output columns, transformations, properties, and tests.
- Follow the project's staging SQL and properties-YAML conventions.

Human decision boundary:

- Stop when source authority, grain, key, or row-retention expectations are unsupported or contradictory.
- Stop when null handling, value mapping, unit conversion, or requested business logic lacks approval.
- Stop when the requested work belongs in an intermediate or mart model.

Completion evidence:

- A scoped dbt build executes the model and attached tests.
- Warehouse checks prove source-to-output grain, row retention, key behavior, and approved normalization.
- SQL output and properties YAML match the approved spec when one exists.

Primary owner: analytics engineering.
```
