# Project standards and patterns

This scratch pad summarizes the conventions visible in the project-owned configuration, documentation, macros, and completed standard model layers. It excludes the intentionally ungoverned Warlock workspace, disabled answer-key models, generated files, and facilitator reference assets.

## Project structure and authority

- `AGENTS.md` defines the always-on governance and human decision boundaries for AI-assisted work.
- `.agents/ROUTING.md` maps governed tasks to the smallest applicable skill and readiness gate.
- `SECURITY.md` defines data-handling, access, production-action, and escalation boundaries.
- `docs/merlinco/STYLE_GUIDE.md` defines modeling, naming, testing, contract, and SQL conventions.
- `dbt_project.yml` defines resource paths, schemas, materializations, and project variables.
- Approved project-owned build specifications govern requested source-to-mart outcomes when the governed workflow requires one.
- `models/answer_key/` and `training_assets/reference/` are facilitator-only assets and are not implementation evidence.
- `models/warlock/` is an intentionally ungoverned workshop baseline with its own isolation rules.
- `models/wizard/` is the trainee workspace for governed implementations.
- Completed models under `models/staging/`, `models/intermediate/`, and `models/marts/` are read-only project patterns.

## Source systems and domains

The project models a potion retail business across three source systems:

- **Abracadabra POS (`abra_pos`)**: potions, orders, order items, and payment attempts.
- **Grimoire CRM (`grimoire_crm`)**: customers/wizards, guilds, and SCD2 guild memberships.
- **Alembic Ops (`alembic_ops`)**: shops, suppliers, ingredients, recipes, and brew events.

Raw workshop relations are represented as dbt sources. Committed seeds are portable setup fixtures; staging models read through `source()`, not `ref()` to seeds.

## Layer responsibilities

### Staging

- Path: `models/staging/<source_system>/`.
- Naming: `stg_<source_system>__<entity>`.
- Materialization: view.
- Grain: one model per raw source table, preserving the raw table grain.
- Reads from exactly one `source()`.
- Owns source-facing cleanup: renaming, type casting, trimming, categorical normalization, boolean cleanup, timestamp parsing, and currency conversion.
- Does not own joins, deduplication, aggregation, or business-level grain changes.

### Intermediate

- Path: `models/intermediate/`.
- Naming: `int_<descriptive_business_transformation>`.
- Materialization: ephemeral.
- Owns joins, deduplication, fanout control, aggregation, enrichment, SCD reduction, and explicit grain changes.
- Model names and descriptions should make the resulting grain or transformation clear.
- Marts consume intermediate models so public SQL remains readable and repeated logic stays centralized.

### Marts

- Path: `models/marts/`.
- Naming: `dim_<plural_noun>` for dimensions and `fct_<plural_noun>` for facts.
- Materialization: table.
- Dimensions describe entities; facts represent events at a clearly stated grain.
- Marts are public data products intended for BI, the Semantic Layer, and AI-assisted analytics.
- Public columns are explicitly projected and cast to stable Snowflake types.
- Every mart enforces a dbt contract, with matching `data_type` declarations in YAML.

## SQL structure

Models follow a predictable CTE shape:

1. Import CTEs first, named after the referenced resource or entity.
2. Transformation CTEs next, each owning a focused step.
3. A final CTE containing the intended output columns and grain.
4. `select * from final` (or the final staging cleanup CTE) as the terminal statement.

Additional conventions:

- Use `ref()` for dbt dependencies and `source()` for raw relations.
- Do not hardcode relation names in model SQL.
- Use lowercase SQL keywords and snake_case identifiers.
- Prefer readable CTEs over nested subqueries.
- Qualify columns in joins and make join cardinality and grain preservation explicit.
- Keep IDs first, then attributes, measures, flags, and timestamps where practical.
- Marts use explicit projections and casts even when import CTEs use `select *`.

## Naming and typing

- Primary keys use `<entity>_id`; stable natural identifiers such as `potion_sku` are retained where appropriate.
- Boolean columns use `is_*` or `has_*`.
- Timestamps use `*_at`; dates use `*_date` or an explicitly date-typed `*_at` field.
- Raw money is retained as integer `*_copper`.
- Reporting currency is exposed as `*_gold` with `number(38, 2)`.
- Mart contracts use explicit Snowflake types such as `varchar`, `integer`, `boolean`, `date`, `timestamp_ntz`, and `number(38, 2)`.

## Shared cleanup patterns

Reusable source-cleaning logic lives in `macros/`:

- `to_boolean()` normalizes mixed boolean encodings and returns null for unknown values so tests can expose bad inputs.
- `copper_to_gold()` converts copper integers to gold using decimal arithmetic and two-decimal rounding.
- `conform_region()` maps known CRM variants to canonical shop-region labels while allowing unknown values to surface in accepted-values tests.
- `generate_schema_name()` keeps developer and CI schemas isolated while allowing configured custom schemas in deployment environments.

## Documentation standards

- Model descriptions state purpose and grain.
- Column descriptions explain business meaning, units, nullability, normalization, and key behavior where relevant.
- Source YAML documents source systems, raw tables, keys, and known data quirks.
- Documentation belongs in standard dbt properties YAML alongside models and columns.
- Comments in SQL explain grain, fanout control, non-obvious joins, and business-sensitive calculations rather than restating syntax.

## Testing standards

- Every primary key has `unique` and `not_null` tests.
- Every foreign key has a `relationships` test against the appropriate parent model.
- Normalized categorical fields have warehouse-grounded `accepted_values` tests.
- Money and other required measures have `not_null` tests.
- Composite grains use a combination-uniqueness test when no single-column key represents the grain.
- Tests are independent enforcement of declared behavior; they are not disabled merely to make a build pass.

## Contracts and public interfaces

- Public marts enforce contracts.
- Every public column has a declared `data_type`, and mart SQL casts to that type explicitly.
- Public grain, names, types, null behavior, and semantic meaning are human-owned decisions.
- Renaming, removing, or retyping a consumed public column is treated as a breaking change and requires impact assessment and an approved migration approach.

## Semantic Layer conventions

- Governed metrics and semantic properties live with mart properties and metric YAML.
- Existing canonical definitions are reused before introducing another version of the same business number.
- Metrics declare clear labels, descriptions, aggregation behavior, expressions, and time dimensions.
- Ratio or derived metrics reference governed component metrics instead of duplicating business logic.
- New semantic definitions require approved meaning for formulas, units, time semantics, dimensions, null treatment, and consumer scope.
- Semantic changes require validation with representative governed queries and downstream-impact review.

## Materialization and schema conventions

- Staging models: views in the configured staging schema.
- Intermediate models: ephemeral.
- Mart models: tables in the configured marts schema.
- Development and CI schemas remain isolated through `generate_schema_name()`.
- Project variables define reusable boundaries such as the date-spine start and end dates.
- Materialization, performance, cost, and production-impact decisions remain human-owned when not already established by approved project standards.

## Validation and review

- Parse validates project and YAML structure.
- SQL or model changes are validated with a scoped `dbt build` that executes changed nodes, applicable ancestors/dependents, contracts, and tests.
- Changes affecting warehouse output should be compared with the deferred production baseline when available.
- Warehouse checks establish grain, retention, join cardinality, null behavior, accepted values, and arithmetic correctness.
- SQLFluff is configured for Snowflake and dbt templating, lowercase SQL, explicit aliases, and consistent references.
- Material changes require evidence-backed review against the applicable approved artifact and project rubric.
- Authorized humans retain approval, merge, deployment, production, and business-meaning decisions.

## Current project caveats observed during inspection

- Source database and schema values are environment-specific and currently differ from the locations described in project documentation.
- Source freshness is not configured.
- Some public mart columns are missing descriptions, required-field tests, or FK relationship tests.
- Repository CI currently checks CODEOWNERS coverage but does not visibly run dbt builds, tests, contracts, semantic validation, or SQLFluff.
- The project parses and the standard dependency slice builds successfully on dbt v2 Stable 2.0.1: 20 models and 107 data tests, with no failures or warnings during this inspection.
