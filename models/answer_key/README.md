# answer_key/ — expected reference solutions (disabled)

This directory contains the facilitator comparison implementation of the procurement and supply-cost slice. It is used after trainees build the Warlock and Wizard tracks; it is never implementation input.

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
- Expected models may reuse completed shared models such as `stg_abra_pos__potions` and `stg_alembic_ops__shops`.
- The expected architecture maps to the canonical Wizard names after removing `__expected`.

## Comparison use

Compare the Wizard track with this implementation only after participant work is complete. Focus on:

- the same four staging, two intermediate, and two mart nodes;
- equivalent lineage and grains;
- approved cost and null semantics;
- public columns, contracts, tests, and descriptions; and
- warehouse-backed validation behavior.

SQL formatting and expression shape may differ while remaining governed and equivalent.

If a facilitator needs to execute an expected model, enable the required closed answer-key dependency slice only in a separate branch or scratch schema. Keep the folder disabled in the trainee baseline.
