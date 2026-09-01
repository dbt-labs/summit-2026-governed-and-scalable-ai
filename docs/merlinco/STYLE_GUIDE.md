# Modeling style guide

The human-readable companion to [AGENTS.md](../../AGENTS.md). Same rules, with the
*why* — so both people and AI assistants produce the same code, and reviewers have
a shared standard to point at. Consistency is what lets this project scale: a
reviewer (or a contract test) can trust a new model because it looks like every
other model.

## Project shape

```text
seeds/medium_data/   portable raw CSV fixtures for facilitator/environment setup
models/
  staging/<source>/  completed source declarations and source-facing patterns
  intermediate/      completed join, fanout, and aggregation patterns
  marts/             completed contracted marts and semantic definitions
  warlock/            trainee baseline, mirrored staging/intermediate/marts
  wizard/             trainee governed build, mirrored staging/intermediate/marts
  answer_key/         disabled facilitator comparison implementation
macros/               shared cleaning logic
```

The completed standard-layer models are read-only workshop patterns. Trainees build the Alembic slice under `models/warlock/` and then `models/wizard/` without moving or modifying those existing models.

**Seeds vs. sources.** Workshop raw relations are pre-built, so trainees work through `source()` and do not need to load seeds. The committed seeds keep the project self-contained for facilitators provisioning another Snowflake account or reusing the project in another training. Staging still reads through `source()`, not `ref()` on a seed, because that reflects the production pattern and supports source-level metadata and tests.

## Layering, in detail

**Staging** is a thin, predictable cleanup layer. One model per raw table selects from exactly one `source()`. Rename to conventions, cast to real types, and apply shared cleaning macros. No joins or business logic.

**Intermediate** owns joins, deduplication, fanout control, aggregation, and grain changes. It is ephemeral so marts can remain readable without adding warehouse clutter.

**Marts** are public data products. Dimensions (`dim_`) describe entities; facts (`fct_`) record events at a stated grain. This is the contracted and tested layer intended for BI, semantic, and AI-assisted consumption.

Both trainee tracks mirror these layers and use the standard `staging` and `marts` schemas.

## Naming and structure

- Canonical Wizard models use `stg_<source>__<entity>`, `int_<description>`, `dim_<noun>`, and `fct_<noun>`.
- Warlock nodes append `__warlock` to the equivalent logical name solely because dbt node names must be unique within a project.
- Use import CTEs first, transformation CTEs as needed, a `final` CTE, then `select * from final`.
- Use `snake_case` and lowercase SQL keywords and identifiers.
- PKs use `<entity>_id`; booleans use `is_*`/`has_*`; timestamps use `*_at`; dates use `*_date` or a date-typed `*_at`.
- Keep `*_copper` raw integers and expose reporting currency as `*_gold` with `number(38, 2)`.

## Deliberate source quirks

The raw feed is intentionally messy so staging has real work. See [DATA_DICTIONARY.md](DATA_DICTIONARY.md#deliberate-data-quirks).

| Quirk | Handling |
|---|---|
| Timestamp columns (`*_at`) | Explicit `timestamp_ntz` casts in staging |
| Messy booleans (`Y/N/yes/no/TRUE/FALSE`) | `to_boolean()` |
| Copper integer prices | `copper_to_gold()` |
| Inconsistent CRM region coding | `conform_region()` |
| Mixed-case categoricals | `lower(trim(...))` in staging |

## Testing standard

- Every PK: `unique` and `not_null`.
- Every FK: `relationships`.
- Every normalized categorical: grounded `accepted_values`.
- Money and other required measures/fields: `not_null`.
- Composite grains: a combination-uniqueness test where no single-column key exists.

## Contracts

Wizard marts declare a `data_type` for every public column and enforce their contracts. SQL explicitly casts every public column to the matching type. Contract failures are independent evidence that an implementation drifted from its approved interface.

## Semantic Layer

Canonical metrics and semantic properties live in the existing mart properties and metric YAML. Reuse those definitions before proposing a new business number. Any Alembic semantic extension must be based on the validated Wizard mart and approved cost, unit, time, and null semantics.

## CI and enforcement

Repository workflow files are inert examples unless deliberately activated. Warehouse-backed builds, contracts, tests, and semantic validation run through the configured dbt Platform development or CI environment. Repository instructions guide behavior; dbt checks and accountable review enforce acceptance.
