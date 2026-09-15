# Author source-facing staging models

Use this skill when creating or materially changing a dbt model whose purpose is source-facing cleanup at the raw-table grain.

## Trigger and goal

**Trigger:** a new raw source table needs a thin cleanup model, or an existing `stg_<source>__<entity>` model needs a material rename, cast, normalization, or macro change.

**Goal:** publish one staging model that is a faithful, typed, renamed 1:1 view of exactly one source table, with properties and tests that prove the cleanup is trustworthy, so intermediate and mart layers can build on it without re-deriving raw-data quirks.

## Non-goals

- Do not join to another source or staging model. One staging model reads exactly one `source()`.
- Do not aggregate, deduplicate across grain, or otherwise change the row grain of the source table.
- Do not encode business logic, formulas, or cross-entity meaning — that belongs in intermediate or marts.
- Do not invent a rename, cast, or accepted value that isn't grounded in the actual source column and observed data.
- Do not use `models/answer_key/`, `training_assets/reference/`, or another facilitator asset as implementation input.

## Required context and evidence

Before writing or editing a staging model:

- inspect `AGENTS.md`, `docs/merlinco/STYLE_GUIDE.md`, and the approved build spec entry for this model when part of planned source-to-mart work;
- inspect the model's source declaration (the `_<source>__sources.yml` file in the same folder) for the exact source table/column names, and confirm the table isn't already staged elsewhere;

- inspect representative completed staging models in the same source folder (e.g. `models/staging/abra_pos/`) for naming, CTE structure, and macro usage conventions;
- inspect `macros/` for existing cleaning macros (`to_boolean`, `copper_to_gold`, `conform_region`, etc.) before writing new inline cleanup logic;
- profile the actual raw column values (case, whitespace, null rate, distinct categorical values, timestamp formats, boolean encodings) with a warehouse query — never assume the source is clean;
- confirm the configured materialization and schema for staging (`view`, `ai_staging` per `dbt_project.yml`) rather than setting one ad hoc.

## Output invariants

A completed staging model must:

- select from exactly one `source()`, never a `ref()` or a second source;
- preserve the source table's row grain — one output row per input row;
- use the `stg_<source>__<entity>` naming convention (Warlock variants append `__warlock` to the equivalent logical name);
- use an import CTE (`source as (select * from {{ source(...) }})`), optional transformation CTEs, a `final` CTE, then `select * from final`;
- rename columns to snake_case project conventions, cast every typed column to its real type (especially `*_at` timestamps to `timestamp_ntz`), and apply the shared cleaning macro rather than reimplementing it inline;
- lowercase/trim normalized categoricals consistently with how downstream `accepted_values` tests will check them;
- keep `*_copper` as the raw integer and add `*_gold` via `copper_to_gold()` when the source carries a copper-denominated price, rather than replacing the raw column;
- document every column in the model's properties YAML with a description grounded in observed behavior, plus `unique`/`not_null` on the primary key, `relationships` on every FK, and `accepted_values` on every normalized categorical reflecting the exact transformed values.

## Workflow

1. Confirm the target source table, output model name/path, and (for planned work) the spec's declared inputs, transformations, and output columns.
2. Profile the raw source: column list and types, null behavior, duplicate keys, categorical value inventory (exact case/whitespace), timestamp formats, boolean encodings.
3. Write the model using the import → transform → final CTE pattern, applying renames/casts/macros grounded in step 2 — not a plausible guess.
4. Write or update the properties YAML entry: description, PK tests, FK `relationships`, and `accepted_values` reflecting the *post-transformation* values observed in step 2.
5. Run `dbt parse` (structural check), then `dbt build --select +<model_name>+` (or the spec's bounded selector when orchestrated) to confirm the model executes and its tests pass against real warehouse data.
6. Re-check row count and grain: the staging model's row count should match the source table's row count (no accidental fanout or filtering) unless the spec explicitly documents a filter.

## Prompt-back conditions

Stop and ask for a focused human decision when:

- a raw categorical value doesn't map cleanly to any existing normalization convention (e.g. a new region abbreviation `conform_region` doesn't recognize);
- the source table appears to need a join, dedup, or grain change to be usable — that's intermediate work, not staging, and signals the request may be miscategorized;
- a source column's business meaning is ambiguous (e.g. an unlabeled status code) and no project documentation resolves it;
- an approved spec's declared transformation or test contradicts the actual observed source data.

State the evidence inspected, the options, a recommendation when one is supportable, and the narrowest question needed to proceed.

## Validation and completion evidence

A staging model is complete only when:

- it reads exactly one `source()` and preserves source grain;
- `dbt parse` succeeds and `dbt build --select +<model_name>+` executes the model and passes every attached test against real data;
- properties YAML documents every column with a description, and PK/FK/`accepted_values` tests reflect actual post-transformation values, not assumed ones;
- no plausible-but-unverified column, mapping, or macro call was introduced.

A clean parse or plausible-looking SQL is not sufficient evidence; the build and its tests must actually pass against warehouse data.

## Behavioral acceptance

**Scenario:** A new raw table `raw_alembic_ops.raw_suppliers` needs a `stg_alembic_ops__suppliers` model. The raw `status` column contains `Active`, `INACTIVE`, and a handful of blank strings; `onboarded_at` is a messy timestamp string like the other Alembic Ops tables.

Expected behavior:

- profile `status` and `onboarded_at` before writing SQL, discovering the blank-string values;
- lowercase/trim `status`, cast `onboarded_at` to `timestamp_ntz` using the same pattern as sibling `stg_alembic_ops__*` models;
- treat blank-string `status` as a data quality finding — prompt back on whether it should map to `null` or an explicit accepted value, rather than silently coercing it;
- write properties YAML with `accepted_values` limited to the values actually agreed upon, plus PK/FK tests;
- run `dbt build --select +stg_alembic_ops__suppliers+` and confirm it passes before calling the work done.

The scenario fails if the model joins another table, silently drops or reclassifies the blank status values without a decision, or the properties YAML asserts `accepted_values` that don't match observed data.

## Ownership and maintenance

**Primary owner:** analytics engineering.

Review this skill after a staging-layer defect reaches intermediate/marts, a new deliberate source quirk is introduced, a new shared cleaning macro is added, or project naming/testing conventions change.
