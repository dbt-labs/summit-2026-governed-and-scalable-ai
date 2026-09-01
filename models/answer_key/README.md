# answer_key/ — promoted governed reference solution (disabled)

This directory contains the facilitator comparison implementation of the Alembic procurement and supply-cost slice. It is a promoted snapshot of the reviewed Wizard workflow outcome and is used only after trainees complete their work; it is never planning or implementation evidence.

## Layout

```text
answer_key/
├── staging/       four stg_alembic_ops__*__expected models + properties YAML
├── intermediate/  int_potion_supply_cost__expected and int_brews_with_supply_cost__expected
└── marts/         dim_suppliers__expected and fct_brews__expected + properties YAML
```

## How it is wired

- The folder is disabled in `dbt_project.yml`, so these models stay out of the active DAG and normal builds.
- Every node has a `__expected` suffix, forming a closed comparison DAG without colliding with trainee nodes.
- Expected models reuse completed shared models where the governed Wizard implementation does, including `stg_abra_pos__potions`, `stg_alembic_ops__shops`, `dim_potions`, and `dim_shops`.
- Removing `__expected` from answer-key node names and internal refs yields the reviewed Wizard implementation.

## Promotion provenance

The promoted implementation matches the approved source-to-mart build spec in model inventory, lineage, grains, transformations, ordered outputs, properties, tests, contracts, cost semantics, null treatment, and semantic scope. Its active Wizard build passed scoped dbt execution, contracts, tests, SQL lint, and warehouse-backed acceptance checks before promotion.

Future answer-key changes should begin in the governed planning/build workflow and be promoted only after review. Do not improve this hidden copy independently; that would let the expected solution drift from an outcome trainees can generate through the documented workflow.

## Comparison use

Compare the Wizard track with this implementation only after participant work is complete. Focus on:

- the same four staging, two intermediate, and two mart nodes;
- equivalent lineage and grains;
- approved cost and null semantics;
- public columns, contracts, tests, and descriptions; and
- warehouse-backed validation behavior.

The expected implementation should differ from the promoted Wizard snapshot only by `__expected` node names and corresponding internal refs.

If a facilitator needs to execute an expected model, enable the required closed answer-key dependency slice only in a separate branch or scratch schema. Keep the folder disabled in the trainee baseline.
