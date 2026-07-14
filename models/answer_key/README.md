# answer_key/ — reference solutions (disabled)

Complete, governed implementations of the procurement / supply-cost slice that the
hands-on lab asks you to build (see [../../docs/LAB_procurement_slice.md](../../docs/LAB_procurement_slice.md)).
They're here so you can **compare your own work** against a worked reference.

## Layout

Mirrors the main `models/` tree — `staging/`, `intermediate/`, `marts/`, each with its
own properties YAML:

```
answer_key/
├── staging/       stg_alembic_ops__*.sql  + _stg_alembic_ops.yml
├── intermediate/  int_potion_supply_cost.sql + _int.yml
└── marts/         dim_suppliers.sql, fct_brews.sql + _marts.yml
```

## How it's wired

- The whole folder is **disabled** in `dbt_project.yml` (`answer_key: +enabled: false`),
  so these models are parsed (valid, lintable SQL) but never built, and they stay out
  of the DAG, `dbt build`, docs, and the semantic layer.
- They use the **same model names** you'll build in `models/staging/` and `models/marts/`.
  dbt allows a disabled model and an enabled model to share a name, so building your own
  `dim_suppliers` / `fct_brews` / etc. will **not** collide with these.

## Using them

- **Read to compare:** just open the files.
- **Run one to compare output:** temporarily enable a single model, e.g.
  `dbt build -s dim_suppliers --vars '...'` after setting `+enabled: true` on it — but do
  this only when you do **not** also have your own enabled model of the same name (two
  enabled models with one name is a duplicate-name error). Easiest: enable/run the answer
  key in a separate branch or a scratch schema.

## Try not to peek first

The point of the lab is the build. If you're using an AI assistant, an optional guardrail
that hides this folder from it lives in
[../../.claude/settings.json.example](../../.claude/settings.json.example).

## Contents

| Layer | Models |
|---|---|
| staging | `stg_alembic_ops__suppliers`, `…__ingredients`, `…__potion_ingredients`, `…__brew_events` |
| intermediate | `int_potion_supply_cost` |
| marts | `dim_suppliers`, `fct_brews` |

`int_potion_supply_cost` documents a deliberate simplifying assumption (recipe/ingredient
unit handling) in its header — a good discussion point.
