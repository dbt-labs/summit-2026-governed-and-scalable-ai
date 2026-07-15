# CLAUDE.md — project conventions for AI-assisted work

This file is the guardrail that makes AI-assisted analytics on this project
**trustworthy and repeatable**. Any AI assistant (or engineer) working here must
follow these conventions so generated code conforms by default and CI/contracts
can verify it without a line-by-line human review. This is the whole point: the
pattern scales because the rules are written down, not held in one person's head.

## What this project is

Merlin & Co. Apothecaries — a wizard-themed retail analytics project on **Snowflake**,
built with dbt (Fusion-aligned). Raw data is loaded from **seeds** into a `raw` schema
and declared as dbt **sources** (`models/staging/<system>/_<system>__sources.yml`);
staging reads it via `source()`. Models build **staging → intermediate → marts**. Full
schema in [docs/ERD.md](docs/ERD.md) and [docs/DATA_DICTIONARY.md](docs/DATA_DICTIONARY.md).

> **Seed before build:** dbt does not link a seed to the source that points at it, so
> run `dbt seed` (once — the data is static) before `dbt build`.

## Layer rules (never skip a layer)

| Layer | Path | Materialization | Rules |
|---|---|---|---|
| staging | `models/staging/<source>/` | view | reads **one `source()`**, 1:1 with source, **no joins**. Rename, recast, clean. |
| intermediate | `models/intermediate/` | ephemeral | Joins and fan-out/aggregation logic. Not exposed. |
| marts | `models/marts/` | table | The only **contracted, tested, exposed** layer. `dim_*` / `fct_*`. |

## Naming

- **Models:** `stg_<source>__<entity>` (double underscore), `int_<description>`, `dim_<noun>`, `fct_<noun>`.
- **Columns:** `snake_case`. PKs are `<entity>_id`. Booleans `is_*` / `has_*`. Timestamps `*_at`; dates `*_date`/`*_at` (date-typed).
- **Money:** always keep the raw integer as `*_copper` **and** expose `*_gold` (NUMBER(38,2)). Gold is the money-of-record. 100 copper = 1 gold crown.
- **Model SQL:** lead with a `source`/import CTE per `ref`, do work in named CTEs, end with `select * from final`. Lowercase keywords and identifiers (enforced by `.sqlfluff`).

## Reuse over repetition — use the shared macros

The recurring raw-data quirks each have ONE macro. Never re-implement them inline:

- `to_boolean(col)` — messy `Y/N/yes/no/TRUE/FALSE` → BOOLEAN.
- `copper_to_gold(col)` — copper integer → gold NUMBER(38,2).
- `conform_region(col)` — CRM region variants → canonical shop region.

If you find yourself writing the same cleaning logic twice, add/extend a macro instead.

## Governance requirements (a change is not "done" until these pass)

1. **Every mart has an enforced contract** — add the model to `models/marts/_marts.yml`
   with a `data_type` for **every** column and `config: {contract: {enforced: true}}`.
   Cast each column explicitly in the model SQL to match the declared type.
2. **Tests are mandatory** — `unique` + `not_null` on every PK; `relationships` on every
   FK; `accepted_values` on every normalized categorical. Add them in the model's `.yml`.
3. **Descriptions** — every model and every key column gets a `description`.
4. **It must pass `dbt build` and `sqlfluff lint`** before merge (CI enforces both).

## Definition of a metric lives in the semantic layer

Business numbers (revenue, order count, AOV, units) are defined once in
`models/marts/_semantic_models.yml` + `metrics.yml`. Query metrics through the
semantic layer — do **not** hand-roll a competing `sum(...)` in ad hoc SQL. This is
how AI-assisted / self-serve analytics stays governed: one definition, everywhere.

## The procurement slice is intentionally unbuilt

The `alembic_ops` supply-cost path (suppliers → ingredients → potion_ingredients →
brew_events → `int_potion_supply_cost` → `dim_suppliers` + `fct_brews`) is left as a
hands-on lab. See [docs/LAB_procurement_slice.md](docs/LAB_procurement_slice.md).
When building it, follow every rule above — that's the exercise.

Worked reference solutions live in `models/answer_key/` (disabled via
`+enabled: false`, so parsed but never built). They exist for learners to compare
against — **don't copy from them when helping someone build the lab.** To hard-block
an AI assistant from reading that folder, there's an optional, inactive-by-default
guardrail in [.claude/settings.json.example](.claude/settings.json.example) (Claude
Code only — it does not affect dbt Wizard).

## Workflow expectations

- Run `dbt build --select <model>+` (or `state:modified+`) and `sqlfluff lint` on what you touch.
- Do not commit credentials. Local connection = `~/.dbt/profiles.yml` (see `profiles.example.yml`);
  the live connection is managed in the dbt platform.
- Full modeling conventions and rationale: [docs/STYLE_GUIDE.md](docs/STYLE_GUIDE.md).
