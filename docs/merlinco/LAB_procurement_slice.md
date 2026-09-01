# Hands-on lab: build the procurement / supply-cost slice with AI

This is the one `source → mart` vertical left **unbuilt** on purpose. Trainees build it twice without changing the completed starter-state models:

1. **Warlock baseline:** an initial, minimally governed implementation under `models/warlock/`.
2. **Wizard build:** a governed implementation under `models/wizard/` after the workshop resources and business decisions are in place.

The comparison demonstrates how repository guidance, human decision rights, contracts, tests, and warehouse-backed validation change the reliability and reviewability of AI-assisted work.

## What already exists

The raw tables are declared as sources in `models/staging/alembic_ops/_alembic_ops__sources.yml`, and their relations are pre-built in the workshop environment. Both tracks reuse those declarations through `source('alembic_ops', '<table>')`:

- `raw_suppliers` — regional ingredient suppliers, with a reliability rating.
- `raw_ingredients` — ingredients, each sourced from one supplier, with a unit cost.
- `raw_potion_ingredients` — recipe bridge; composite key `(potion_sku, ingredient_id)`.
- `raw_brew_events` — production batches with potion, shop, quality, and duration attributes.

The completed project models stay under the standard layer paths and are read-only workshop patterns. Disabled comparison models live under `models/answer_key/` and are not implementation input.

## Canonical governed target lineage

```text
stg_alembic_ops__potion_ingredients
+ stg_alembic_ops__ingredients
  -> int_potion_supply_cost              -- one row per potion SKU

stg_alembic_ops__brew_events
+ int_potion_supply_cost
  -> int_brews_with_supply_cost          -- one row per brew batch

stg_alembic_ops__suppliers
  -> dim_suppliers                       -- one row per supplier

int_brews_with_supply_cost
  -> fct_brews                           -- one row per brew batch
```

The Wizard implementation uses those canonical names under the mirrored paths:

```text
models/wizard/staging/
models/wizard/intermediate/
models/wizard/marts/
```

The Warlock implementation mirrors the same layers under `models/warlock/` and appends `__warlock` to each node name so both tracks can coexist in one dbt project and the same staging/mart schemas.

## Target behavior and decisions

- **Staging:** create supplier, ingredient, recipe-component, and brew-event models. Reuse `to_boolean()` for `is_hazardous`, `copper_to_gold()` for ingredient cost, `lower(trim())` for mixed-case units and quality values, and cast `brewed_at` to `timestamp_ntz`.
- **Intermediate:** roll recipe components to one estimated standard potion supply cost per potion SKU, then enrich each brew batch without changing brew grain.
- **Marts:** publish a contracted supplier dimension and brew-batch fact. Keep multi-input joins in intermediate.
- **Human decisions:** explicitly resolve unit comparability, standard-versus-actual cost meaning, nullable brew duration, public output grain, and any Semantic Layer extension. Margin and production-to-sales allocation require separate approved definitions.

## Definition of done for the governed track

1. The canonical lineage contains four staging models, two intermediates, `dim_suppliers`, and `fct_brews` under `models/wizard/`.
2. Every Wizard mart has an enforced contract, complete column types, descriptions, and grounded PK/FK/categorical/required-field tests.
3. `dbt build --select +fct_brews +dim_suppliers` passes.
4. Grain, null preservation, cost arithmetic, and accepted values are checked against warehouse results.
5. SQLFluff or the supported CI lint path passes.
6. Any semantic extension uses the approved estimated-standard-cost and null-duration definitions; margin remains out of scope unless separately approved.

## Comparison focus

Compare the two tracks on lineage, layer boundaries, source grounding, tests, contracts, descriptions, assumptions, validation evidence, and review effort. SQL text may differ while still implementing an equivalent approved design.
