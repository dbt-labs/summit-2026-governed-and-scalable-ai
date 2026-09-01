# Warlock workshop track

Trainees build the initial, minimally governed Alembic procurement solution here. This track is isolated from the completed starter-state models under `models/staging/`, `models/intermediate/`, and `models/marts/`; do not edit those models during the exercise.

Use the mirrored layer paths:

```text
models/warlock/staging/
models/warlock/intermediate/
models/warlock/marts/
```

Because dbt model names must be unique across the project, append `__warlock` to every model filename and use those suffixed names in `ref()` and properties YAML. For example: `stg_alembic_ops__suppliers__warlock.sql`, `int_potion_supply_cost__warlock.sql`, and `fct_brews__warlock.sql`. Warlock views and tables use the same `staging` and `marts` schemas as the canonical models; the suffix keeps relation names distinct.

Do not use `models/answer_key/` as an implementation source.
