# Project standards

This document summarizes the established conventions for the Analytics dbt Platform project (`merlinco_apothecaries`). The primary authorities are `AGENTS.md`, `docs/merlinco/STYLE_GUIDE.md`, `dbt_project.yml`, `.sqlfluff`, and the completed standard model layers.

## Project structure and layer responsibilities

| Layer | Naming | Materialization | Responsibility |
|---|---|---|---|
| Staging | `stg_<source>__<entity>` | View | One model per raw table. Rename, cast, normalize, and apply shared cleaning macros without joins or business logic. |
| Intermediate | `int_<description>` | Ephemeral | Joins, deduplication, fanout control, aggregation, enrichment, and grain changes. |
| Dimensions | `dim_<noun>` | Table | Public entity-oriented marts at an explicitly documented grain. |
| Facts | `fct_<noun>` | Table | Public event-oriented marts at an explicitly documented grain. |

Staging models read pre-built raw Snowflake relations through `source()`. Downstream models use `ref()`. Committed seeds are portable setup fixtures and are not direct staging inputs.

The completed models under `models/staging/`, `models/intermediate/`, and `models/marts/` are read-only workshop patterns. Workshop implementations belong under:

- `models/warlock/` for the intentionally minimally governed baseline. Every node name ends with `__warlock`.
- `models/wizard/` for the governed implementation using canonical model names.

The disabled `models/answer_key/` directory contains facilitator comparison models and is not an implementation input.

## Names and data types

- Use `snake_case` for model, CTE, column, macro, and test names.
- Use lowercase SQL keywords and identifiers.
- Primary and foreign keys use `<entity>_id` when the source has an ID. Stable business keys such as `potion_sku` may remain the key where appropriate.
- Boolean columns use `is_*` or `has_*` names.
- Timestamps use `*_at` and are explicitly cast to `timestamp_ntz` in staging.
- Dates use `*_date`, or a date-typed `*_at` when that is the established public interface.
- Raw copper values remain integer `*_copper` columns.
- Reporting currency uses `*_gold` and public mart columns use `number(38, 2)`.
- Normalized categorical values are trimmed and lowercased unless a canonical display value is defined, such as the conformed region names.

## SQL structure

Models follow a predictable CTE shape:

1. Import CTEs containing `source()` or `ref()` calls.
2. Transformation CTEs for the model's layer-specific work.
3. A `final` CTE.
4. `select * from final` as the terminal statement.

Additional conventions:

- Prefer CTEs over nested subqueries.
- Keep staging at the raw-table grain and select from exactly one source.
- Put joins and grain changes in intermediate models.
- Keep marts readable by composing tested intermediate logic.
- Document the output grain at the top of intermediate and mart SQL.
- Qualify columns in joins and wherever ambiguity is possible.
- Organize longer public select lists into logical groups such as IDs/FKs, attributes, measures, flags, and timestamps.
- Explicitly cast every public mart column to the type declared by its contract.
- Reuse shared macros instead of duplicating cleanup logic. Existing examples are `to_boolean`, `copper_to_gold`, and `conform_region`.
- Preserve the existing public column set unless an approved schema change specifically adds, removes, renames, or retypes a column.

## SQLFluff conventions

`.sqlfluff` configures:

- Snowflake SQL dialect and the dbt templater.
- A maximum line length of 100 characters.
- Four-space indentation.
- Lowercase keywords, identifiers, functions, and literals.
- Explicit table and column aliases.
- Consistent reference qualification.
- Joins without additional indentation and indented `using` clauses.

Rules `RF04` and `ST06` are intentionally excluded.

## Source cleanup

Known raw-data quirks are handled in staging:

| Raw condition | Standard handling |
|---|---|
| Timestamp strings | Explicit `timestamp_ntz` casts |
| Values such as `Y/N`, `yes/no`, and `TRUE/FALSE` | `to_boolean()` |
| Copper-denominated integer prices | Preserve copper and derive gold with `copper_to_gold()` |
| Inconsistent CRM region codes | `conform_region()` |
| Mixed-case categorical values | `lower(trim(...))` |

Business classifications and calculations do not belong in staging unless they are direct normalization of a source value.

## Testing standards

Tests are selected to prove keys, relationships, grain, and important business constraints:

- Every primary key: `unique` and `not_null`.
- Every modeled foreign key: `relationships` to the authoritative parent model.
- Every normalized categorical: a warehouse-grounded `accepted_values` test.
- Required money, timestamps, measures, and flags: `not_null` where null would violate the model contract.
- Composite grains without a single-column key: a combination-uniqueness test, typically from `dbt_utils`.

Tests use the modern `data_tests:` key in current mart properties. Generic test arguments are nested under `arguments:`.

Warehouse-backed acceptance checks should supplement schema tests for material work. These checks cover:

- Grain and duplicate detection.
- Record retention.
- Join cardinality and fanout.
- Null behavior.
- Categorical distributions.
- Currency and other business arithmetic.

## Contracts and documentation

Wizard marts are public data products and enforce contracts:

- Every public column has a declared `data_type`.
- SQL casts every column to the matching type.
- The model description states its purpose and grain.
- Key, relationship, business-rule, null, unit, and currency semantics are documented in dbt properties YAML.
- Column descriptions explain business meaning rather than repeating the column name.

Contract failures are treated as evidence of drift from the approved public interface. A public column rename, removal, or type change is a breaking change and requires explicit consumer-impact and migration planning.

## Semantic standards

Canonical semantic models, dimensions, entities, and metrics live with the mart properties and metric YAML. Existing governed definitions must be reused before introducing a new business number.

Semantic changes require agreement on:

- Metric formula and aggregation.
- Entity and join behavior.
- Time dimension and granularity.
- Units or currency.
- Null treatment.
- Consumer scope.

Representative governed queries and semantic validation are required when semantic definitions change.

## Schemas and environments

All modeled relations use the `apothecaries` database.

- Development and CI prefix custom schemas with the target schema, producing names such as `<target_schema>_ai_staging` and `<target_schema>_ai_marts`.
- Staging and production deployment environments use `ai_staging` and `ai_marts` directly.
- Intermediate models are ephemeral and do not create warehouse relations.

The custom behavior is implemented by `macros/generate_schema_name.sql`.

## Validation and change management

Validation should match the change:

- SQL model changes: scoped `dbt build` including required dependencies, attached tests, and affected downstream models.
- Test, contract, or dependency YAML changes: parse, then run the relevant scoped build.
- Project configuration changes: parse with a clean parse state.
- Material output changes: compare the changed model and downstream impact with production after a successful build.
- SQL changes: run the supported SQLFluff path.
- Semantic changes: validate semantic definitions and execute representative governed queries.
- Documentation-only changes: no dbt execution is required.

Governed Wizard work follows an evidence-backed workflow: plan, resolve material business decisions, obtain human approval, implement by layer, execute warehouse-backed verification, and complete independent review. Contracts, tests, CI controls, and review are not bypassed to make a change pass.

## Current configuration observations

- `dbt_utils` is the only declared package, constrained to `>=1.1.0,<2.0.0` and currently locked at `1.4.1`.
- The repo contains semantic model and metric definitions, while the dbt Platform project record currently reports that the Semantic Layer is not configured. This activation gap should be investigated before relying on platform metric serving.
- `dbt_project.yml` contains a top-level `flags:` block. dbt v2 Stable does not support `flags:` there, so the warning-suppression configuration requires migration cleanup.
- The README still uses the former “dbt Fusion” product name; current documentation should call the engine **dbt v2 Stable**.
