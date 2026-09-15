# Analytics project overview

## Purpose and modeled domain

The dbt Platform project is named **Analytics**; the dbt project declared in `dbt_project.yml` is `merlinco_apothecaries` version `1.0.0`. It is a Snowflake-backed training project for **Merlin & Co. Apothecaries**, a fictional 15-shop potion retailer operating across five regions.

The project models three source systems and 12 raw tables:

- **Abracadabra POS:** potions, orders, order items, and payments.
- **Grimoire CRM:** customers (wizards), guilds, and guild memberships.
- **Alembic Ops:** shops, suppliers, ingredients, potion recipes, and brew events.

The completed Kimball-style analytics layer covers wizard, potion, shop, and date dimensions plus order, order-item, and payment facts. The procurement and supply-cost vertical is intentionally left as workshop work: supplier and brew marts supported by ingredient, recipe, supplier, and brew-event staging and intermediate logic.

## Project organization

Configured resource paths are conventional, with one important seed constraint:

- Models: `models/`
- Macros: `macros/`
- Tests: `tests/`
- Snapshots: `snapshots/`
- Analyses: `analyses/`
- Seeds: `seeds/medium_data/` only, because filenames collide across data-size tiers

The model layers and materializations are:

- `models/staging/`: views in database `apothecaries`; development and CI resolve the schema as `<target_schema>_ai_staging`, while staging/production use `ai_staging` directly. These models perform thin, source-facing cleanup at the raw-table grain.
- `models/intermediate/`: ephemeral models for joins, fanout control, enrichment, and aggregation.
- `models/marts/`: tables in database `apothecaries`; development and CI resolve the schema as `<target_schema>_ai_marts`, while staging/production use `ai_marts` directly. These are contracted, tested dimensions and facts.
- `models/warlock/`: intentionally minimally governed workshop baseline, tagged `warlock`; model names must end in `__warlock`.
- `models/wizard/`: governed workshop implementation, tagged `wizard`, using canonical target names.
- `models/answer_key/`: disabled facilitator reference models that are parsed but never built.

The custom `generate_schema_name` macro explains why configured schemas resolve with the target prefix. Shared cleanup macros include `to_boolean`, `copper_to_gold`, and `conform_region`.

## Packages

`packages.yml` declares only `dbt-labs/dbt_utils`, constrained to `>=1.1.0,<2.0.0`. `package-lock.yml` currently pins **dbt_utils 1.4.1**.

## Notable configuration

- The connection profile is `merlinco_apothecaries`; dbt Platform supplies the actual connection through environment settings.
- `date_spine_start` is `2023-01-01` and `date_spine_end` is `2027-01-01`, providing the configured range for `dim_dates`.
- Seeds are globally disabled. The committed medium-sized CSVs are portable setup fixtures; workshop runs use pre-built Snowflake raw relations.
- Seed columns are intentionally loaded as text, with quoting disabled, so staging owns cleanup of mixed-case values, dual timestamp formats, messy booleans, and currency conversion.
- `target/` and `dbt_packages/` are clean targets and should never be edited as durable source files.
- SQLFluff uses the Snowflake dialect and dbt templater, enforces lowercase SQL, explicit aliases, four-space indentation, and a 100-character line limit.
- Mart semantic definitions exist in `models/marts/_semantic_models.yml` and `models/marts/metrics.yml`.

## Additional observations

1. **Semantic Layer activation gap:** semantic model and metric YAML exists in the repo, but the dbt Platform project record reports `has_semantic_layer: false`. The definitions may not be activated or configured in the platform environment.
2. **v2 Stable compatibility issue:** `dbt_project.yml` contains a top-level `flags:` block used to silence `UnusedResourceConfigPath`. dbt v2 Stable does not support `flags:` in `dbt_project.yml`, so this is likely a parse/migration issue and should be removed or handled through supported invocation/environment configuration.
3. **Terminology drift:** the README still describes the engine as “dbt Fusion.” The current product name is **dbt v2 Stable**.
4. **Governance is part of the architecture:** material Wizard work follows an evidence-backed plan, human approval, implementation by layer, scoped builds and warehouse checks, and independent review. Warlock work is deliberately isolated from those governed assets.
5. **Training data scale:** the configured medium tier contains roughly 15,000 orders, 51,000 order items, and 5,000 customers.
6. **Designed analytical storylines:** the fixtures encode growth, potion seasonality, regional differences, high-value “whale” customers, and strong home-region purchasing behavior.
