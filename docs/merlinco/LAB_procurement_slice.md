# Hands-on lab: build the procurement / supply-cost slice with AI

This is the one `source → mart` vertical left **unbuilt** on purpose. In the session
we plan, design, and build it **with dbt Wizard** — and watch the project's
guardrails (conventions in [AGENTS.md](../../AGENTS.md), contracts, tests, CI, the
semantic layer) keep the AI's output trustworthy without us hand-reviewing every line.
That is the thesis of "Governed & Scalable AI-assisted Analytics with dbt" in one exercise.

## What already exists

The four raw tables are already declared as **sources** (and PK-tested) in
`models/staging/alembic_ops/_alembic_ops__sources.yml`, and loaded by `dbt seed`. Build
staging on top of them with `source('alembic_ops', '<table>')`:

- `raw_suppliers` — regional ingredient suppliers, with a reliability rating.
- `raw_ingredients` — ingredients, each sourced from one supplier, with a unit cost.
- `raw_potion_ingredients` — recipe bridge; composite key `(potion_sku, ingredient_id)`.
- `raw_brew_events` — production batches (which potion, which shop, quality check, duration).

Nothing downstream depends on this slice, so the project builds green without it.

## What to build (target lineage)

```
raw_suppliers ────► stg_alembic_ops__suppliers ─────────────────┐
raw_ingredients ──► stg_alembic_ops__ingredients ──┐            │
raw_potion_ingredients ► stg_alembic_ops__potion_ingredients ─┐ │
                                                              ▼ ▼
                                          int_potion_supply_cost  ──► fct_brews (cost per batch)
                                                              │
raw_brew_events ──► stg_alembic_ops__brew_events ─────────────┘
                                                              │
                                          stg_alembic_ops__suppliers ──► dim_suppliers
```

- **Staging** (add to `models/staging/alembic_ops/`, register in `_stg_alembic_ops.yml`):
  `stg_alembic_ops__suppliers`, `stg_alembic_ops__ingredients`,
  `stg_alembic_ops__potion_ingredients`, `stg_alembic_ops__brew_events`.
  Use the shared macros — `to_boolean()` on `is_hazardous`, `copper_to_gold()` on
  `unit_cost_copper`, `lower(trim())` on the mixed-case units — and cast `brewed_at`
  directly to `timestamp_ntz` in staging.
- **Intermediate:** `int_potion_supply_cost` — roll each recipe up to a cost-to-brew per
  potion: `sum(potion_ingredients.quantity * ingredients.unit_cost)`. **Design decision to
  discuss:** how to handle unit mismatches between recipe and ingredient units.
- **Marts:**
  - `dim_suppliers` — supplier dimension (contracted, tested).
  - `fct_brews` — one row per brew batch. **Design decision to discuss:** the grain, and
    whether to join in supply cost per batch (batch_size × per-unit potion cost) and the
    ~1% null `brew_duration_minutes`.

## Definition of done (the guardrails the AI must satisfy)

1. Every new mart is in a `.yml` with an **enforced contract** (typed columns) + tests
   (PK `unique`/`not_null`, FK `relationships`, categorical `accepted_values`).
2. `dbt build --select +fct_brews +dim_suppliers` passes.
3. `sqlfluff lint` passes.
4. Optionally: add `supply_cost` measures/metrics to the semantic layer so margin
   (revenue − supply cost) is a governed metric.

## Talking points during the build

- Start with `AGENTS.md` and the task workflow—watch Wizard produce conforming code because the rules and decision checkpoints are written down.
- Break a contract on purpose (change a type) and show the build failing loudly.
- Contrast: "one analyst writing this once" vs. "a pattern any teammate or agent can repeat safely."
