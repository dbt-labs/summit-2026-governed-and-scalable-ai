# answer_key/ — expected reference solutions (disabled)

Complete, governed implementations of the procurement / supply-cost slice that the
hands-on lab asks you to build.
They're here so you can **compare your own work** against a worked reference.

## Layout

Mirrors the main `models/` tree — `staging/`, `intermediate/`, `marts/`, each with its
own properties YAML:

```
answer_key/
├── staging/       stg_alembic_ops__*__expected.sql + _stg_alembic_ops.yml
├── intermediate/  int_potion_supply_cost__expected.sql + _int.yml
└── marts/         dim_suppliers__expected.sql, fct_brews__expected.sql + _marts.yml
```

## How it's wired

- The whole folder is **disabled** in `dbt_project.yml` (`answer_key: +enabled: false`),
  so these models are parsed but never built, and they stay out of the active DAG,
  `dbt build`, docs, and the semantic layer.
- Every answer-key model has a `__expected` suffix. The suffix makes this a closed,
  disabled comparison DAG and leaves unsuffixed names available for the active learner
  implementation.
- Answer-key models `ref()` other expected answer-key models. They may reference shared,
  pre-existing project models such as `stg_abra_pos__potions` and `stg_alembic_ops__shops`.

## Using them

- **Read to compare:** just open the files.
- **Run one to compare output:** temporarily enable the expected answer-key models in a
  separate branch or scratch schema, then select the suffixed name, for example
  `dbt build --select dim_suppliers__expected`. Do not enable them in the learner path.

## Try not to peek first

The point of the lab is the build. Keep this folder out of the trainee starting state
until the comparison/review moment.

## Contents

| Layer | Models |
|---|---|
| staging | `stg_alembic_ops__suppliers__expected`, `…__ingredients__expected`, `…__potion_ingredients__expected`, `…__brew_events__expected` |
| intermediate | `int_potion_supply_cost__expected` |
| marts | `dim_suppliers__expected`, `fct_brews__expected` |

`int_potion_supply_cost__expected` documents a deliberate simplifying assumption
(recipe/ingredient unit handling) in its header — a good discussion point.
