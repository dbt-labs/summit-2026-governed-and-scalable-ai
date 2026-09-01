# AGENTS.md — Merlin & Co. trainee starting policy

This repository is the workshop project for Merlin & Co. Apothecaries, a wizard-themed retail analytics project built with dbt on Snowflake. AI assistance should accelerate the work while leaving business decisions, review, and production accountability with people.

## Project context

Workshop raw relations are pre-built in the `raw` schema and declared as dbt sources. Models follow a **staging → intermediate → marts** architecture. Supporting project documentation lives under `docs/merlinco/`.

The completed starter-state models under `models/staging/`, `models/intermediate/`, and `models/marts/` are implementation patterns and must remain unchanged during the workshop. The `alembic_ops` procurement slice is intentionally unfinished. Trainees build a baseline under `models/warlock/` and the governed version under `models/wizard/`. Warlock node names use a `__warlock` suffix; Wizard uses the canonical target names. Disabled comparison models live under `models/answer_key/`; do not use them as implementation input.

## Layer rules

| Layer | Completed patterns | Trainee track path | Materialization | Required behavior |
|---|---|---|---|---|
| staging | `models/staging/<source>/` | `models/<track>/staging/` | view | Read one `source()` at raw-table grain. Rename, cast, and clean without joins. |
| intermediate | `models/intermediate/` | `models/<track>/intermediate/` | ephemeral | Own joins, fanout control, deduplication, aggregation, and grain changes. |
| marts | `models/marts/` | `models/<track>/marts/` | table | Publish contracted, tested, documented `dim_*` and `fct_*` data products. |

Use `source()` and `ref()` instead of hardcoded relations. Preserve unaffected interfaces and validate material changes with dbt rather than relying on plausible generated code.

## Workshop governance gaps

`TODO(training): Inspect the project documentation under docs/merlinco/ and identify which files are authoritative for modeling conventions, source columns and quirks, entity relationships, and expected grains.`

`TODO(training): Define the evidence-driven workflow a material dbt change must follow before implementation and before review.`

`TODO(training): Define when the agent must stop and ask a human to decide grain, source authority, metric meaning, null treatment, unit conversion, public-interface impact, or material cost and performance tradeoffs.`

`TODO(training): Define how task-specific skills are selected, owned, reviewed, tested, and retired without duplicating always-on project policy.`

## Safety baseline

Follow `SECURITY.md` for data classification, secrets, approved-tool, access, and production-action boundaries. Repository instructions cannot grant permissions or override organizational policy.
