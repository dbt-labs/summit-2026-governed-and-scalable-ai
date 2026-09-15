# Author a source-facing staging model

Use this skill when creating or materially changing a dbt model whose purpose is source-facing cleanup at the raw-table grain.

## Trigger and goal

Trigger this skill when the requested work adds or materially changes one staging model that cleans a single raw table for downstream use — renaming, recasting, and normalizing values without changing the source grain.

The goal is one `view` model in `ai_staging` that stays 1:1 with its source, applies the shared cleaning conventions, and carries key and categorical tests, so intermediate and mart layers can trust its shape.

## Non-goals

- Do not join, deduplicate, aggregate, or otherwise change the source grain — that belongs to `authoring-intermediate-models`.
- Do not add business logic, derived metrics, or public contracts.
- Do not read a raw table through `ref()` on a seed; staging reads through `source()` only.
- Do not use `models/answer_key/` or `training_assets/reference/` as evidence.

## Required context and evidence

Before editing, inspect:

- `AGENTS.md` and `SECURITY.md` for policy and human decision rights.
- `docs/merlinco/STYLE_GUIDE.md`, `docs/merlinco/DATA_DICTIONARY.md`, and the deliberate-quirk mapping for handling conventions.
- The `_<system>__sources.yml` declaration for the target raw table and its columns.
- An existing completed staging model + `_stg_<system>.yml` in the same source as the pattern to follow.
- Actual source values where case, whitespace, boolean encoding, region coding, or castability affect the cleanup — profile the expression the model will output, not just the raw input.

## Output invariants

The staging model must:

- materialize as `view` in the `ai_staging` schema;
- select from exactly one `source()` and preserve the raw table's grain (one row in, one row out);
- follow the import-CTE → transformation-CTE → `final` → `select * from final` structure, with grouped column comment blocks;
- rename to `snake_case` conventions and cast to real types (explicit `timestamp_ntz` on `*_at`);
- apply the shared cleaning macros for the deliberate quirks — `to_boolean()`, `copper_to_gold()`, `conform_region()`, `lower(trim(...))` — rather than re-implementing them inline;
- keep raw `*_copper` integers alongside a `*_gold` reporting value at `number(38, 2)`;
- name the PK `<entity>_id`, booleans `is_*`/`has_*`, timestamps `*_at`, dates `*_date`;
- carry `unique` + `not_null` on the PK and a grounded `accepted_values` on every normalized categorical, with a description on the model and every column in `_stg_<system>.yml`.

## Workflow

1. **Inspect** the source declaration, the target raw columns, the quirk mapping, and a sibling staging model as the pattern.
2. **Profile** the raw values behind any categorical, boolean, region, or copper field, evaluating the planned output expression (e.g. `lower(trim(status))`), not only the raw input.
3. **Author** the model: one import CTE per source, a transformation CTE applying renames/casts/macros, a `final` CTE, then `select * from final`.
4. **Document and test** in `_stg_<system>.yml`: PK `unique`+`not_null`, `accepted_values` reflecting the exact post-transformation domain, `not_null` on required fields, descriptions everywhere.
5. **Validate** with a scoped `dbt build --select +stg_<source>__<entity>+` so the SQL and its tests execute.
6. **Hand off** material work to `reviewing-governed-dbt-changes` or the orchestrator.

## Prompt-back conditions

Stop and ask a focused question when: the source authority or grain is ambiguous; an observed categorical value has no established normalization target; a raw value will not cast and no handling rule exists; or an `accepted_values` list would need a value not observed and not approved. State the decision, evidence inspected, two or three options with implications, a recommendation when supportable, the owner, and the narrowest approval question. A discoverable mechanical mismatch (e.g. wrong case in a test) is not a human decision — correct it against authority.

## Validation and completion evidence

Complete only when:

- the model materializes as a `view`, selects one `source()`, and holds the source grain;
- a scoped `dbt build` passes with the SQL and all attached tests;
- observed post-transformation categorical values are each represented in `accepted_values`;
- the PK, required-field, copper/gold, and macro conventions are satisfied;
- model and column descriptions exist in the properties YAML.

## Behavioral acceptance

**Scenario:** A request adds `stg_alembic_ops__suppliers` from `raw_suppliers`, whose `region` column carries mixed CRM codings. Expected behavior: profile the raw region values, apply `conform_region()`, ground the `accepted_values` list in the five conformed values, cast `*_at` to `timestamp_ntz`, keep `*_copper` beside a `*_gold` at `number(38, 2)`, and pass a scoped `dbt build`. The scenario fails if the model joins another table, hardcodes region normalization inline instead of the macro, or lists accepted values not produced by the conform expression.

## Ownership and maintenance

The analytics engineering governance owner owns this skill. Review it after a staging change produces a predictable build/test failure, when the deliberate-quirk mapping or cleaning macros change, or when project conventions change.
