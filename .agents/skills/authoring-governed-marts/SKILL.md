# Author a governed mart

Use this skill when creating or materially changing a public dbt dimension or fact consumed by analytics, BI, the Semantic Layer, or AI-assisted analysis.

## Trigger and goal

Trigger this skill when the requested work publishes or materially changes a public data product — a `dim_` describing an entity or a `fct_` recording events at a stated grain.

The goal is one contracted `table` in `ai_marts` that inherits its grain from upstream, casts every public column to its declared type, enforces its contract, and carries full key/relationship/categorical tests and descriptions, so downstream consumers can trust it.

## Non-goals

- Do not re-change grain, re-join, or re-aggregate — that is the intermediate layer's job; marts inherit a stated grain and cast/contract it.
- Do not introduce a new business number or metric that competes with an existing semantic definition; reuse contracted columns.
- Do not select from a `source()`; marts read intermediate (or staging where no intermediate is needed) via `ref()`.
- Do not use `models/answer_key/` or `training_assets/reference/` as evidence.

## Required context and evidence

Before editing, inspect:

- `AGENTS.md`, `SECURITY.md`, and `docs/merlinco/STYLE_GUIDE.md` for policy, contract, and semantic rules.
- The approved build spec (when part of planned work) for the public interface, types, and grain.
- The upstream intermediate/staging model supplying this mart, and its stated grain.
- An existing completed mart + `_marts.yml` (and `_semantic_models.yml` where relevant) as the pattern.
- `docs/merlinco/ERD.md` for the FK relationships this mart must test.
- Warehouse checks confirming grain, retention, cardinality, null behavior, accepted values, and copper→gold arithmetic on the projected output.

## Output invariants

The mart must:

- materialize as `table` in the `ai_marts` schema and be named `dim_<noun>` or `fct_<noun>`;
- reference inputs through `ref()` and inherit the upstream stated grain without re-changing it;
- follow the import-CTE → transformation-CTE → `final` → `select * from final` structure, casting every public column to its contracted type in the `final` CTE;
- set `config.contract.enforced: true` and declare a `data_type` for every public column in `_marts.yml`, in output order;
- carry `unique` + `not_null` on the PK; a `relationships` test via `ref()` on every FK; grounded `accepted_values` on every categorical; and `not_null` on money and other required measures;
- use a combination-uniqueness test where no single-column key exists;
- keep `*_copper`/`*_gold` (at `number(38, 2)`) and boolean/timestamp conventions consistent;
- carry a description on the model and every public column, with semantic definitions reusing the contracted columns rather than redefining business numbers.

## Workflow

1. **Inspect** the upstream model's grain, the approved interface (spec or existing pattern), the ERD relationships, and a sibling mart + `_marts.yml`.
2. **Author** the SQL: import CTEs, minimal shaping, and a `final` CTE that explicitly casts every public column to its contracted type; do not re-change grain.
3. **Declare the contract and tests** in `_marts.yml`: enumerate every public column in order with its `data_type`, set `contract.enforced: true`, and attach PK, FK `relationships`, `accepted_values`, and required-field tests with descriptions.
4. **Validate** with a scoped `dbt build --select +<mart>+` so the contract and tests execute against real data, then run warehouse checks for grain, retention, nulls, accepted values, and copper→gold arithmetic.
5. **Check semantics** — when semantic definitions change, validate them and confirm they reuse contracted columns.
6. **Hand off** to `reviewing-governed-dbt-changes`.

## Prompt-back conditions

Stop and ask a focused question when: the public interface (columns, types, or breaking changes to consumers) is unresolved; the grain the mart should expose is ambiguous; a metric/business-number definition, unit, or null treatment is not established by authority; or a contract change would break downstream consumers without an approved migration. State the decision, evidence inspected, two or three options with implications, a recommendation when supportable, the owner, and the narrowest approval question. A contract type that merely needs to match the SQL cast is a mechanical fix, not a human decision.

## Validation and completion evidence

Complete only when:

- the mart is a contracted `table` with `contract.enforced: true` and a `data_type` for every public column matching its `final`-CTE cast;
- a scoped `dbt build --select +<mart>+` passes with the contract and all tests;
- PK uniqueness/not-null, every FK `relationships` test, categorical `accepted_values`, and required-field `not_null` pass;
- warehouse checks confirm grain, retention, cardinality, nulls, and copper→gold arithmetic;
- semantic definitions (when changed) validate and reuse contracted columns;
- model and public-column descriptions exist in `_marts.yml`.

## Behavioral acceptance

**Scenario:** A request publishes `fct_order_items` from `int_order_items_with_order_context` at one row per order item. Expected behavior: inherit the order-item grain, cast every public column in `final`, enforce the contract with declared types, add `unique`+`not_null` on the item key, `relationships` tests for `order_id → ref('fct_orders')` and `potion_sku → ref('dim_potions')`, `not_null` on `line_revenue_gold`, and pass a scoped `dbt build` plus a warehouse grain check. The scenario fails if the mart re-aggregates or re-joins to change grain, omits a contract type, or ships an FK without a `relationships` test.

## Ownership and maintenance

The analytics engineering governance owner owns this skill; data-product and metric owners approve public interfaces and business meaning. Review it after a contract or test failure reveals interface drift, when a consumer or semantic definition changes, or when project contract conventions change.
