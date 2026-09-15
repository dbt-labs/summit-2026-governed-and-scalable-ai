# Author intermediate join and rollup models

Use this skill when creating or materially changing a dbt model that owns joins, deduplication, aggregation, enrichment, fanout control, or another approved grain change.

## Trigger and goal

**Trigger:** two or more staging/intermediate models need to be combined, rolled up, deduplicated, or reshaped to a new grain before a mart can publish them.

**Goal:** publish one ephemeral `int_<description>` model that performs exactly the approved joins/aggregations, lands at the correct declared grain with no unintended fanout, and is provably safe for a mart to select from directly.

## Non-goals

- Do not persist the model outside the project's configured `ephemeral` materialization for `models/intermediate/`.
- Do not publish this layer as a public interface — no contracts, no direct BI/semantic consumption. It exists to be composed into marts.
- Do not invent a join key, cardinality assumption, or aggregation formula that isn't grounded in profiled data or an approved spec.
- Do not silently drop or duplicate rows through an unintended fanout; either is a defect, not a stylistic choice.
- Do not use `models/answer_key/`, `training_assets/reference/`, or another facilitator asset as implementation input.

## Required context and evidence

Before writing or editing an intermediate model:

- inspect `AGENTS.md`, `docs/merlinco/STYLE_GUIDE.md`, and the approved build spec entry for this model when part of planned source-to-mart work;
- inspect every upstream `ref()`'d staging/intermediate model's properties YAML for its stated grain, PK, and FK relationships;
- inspect representative completed intermediate models (`models/intermediate/`) for CTE structure, `coalesce()`-guarded left-join rollups, and how they document grain in `_int.yml`;
- profile actual upstream data before joining: key uniqueness/duplication on each side of a join, match rate (rows with no match on either side), and whether a one-to-many relationship is expected or a defect;
- if aggregating, confirm the grouping keys and formula against a control total computed independently (e.g. sum of line items should equal a known order total) before trusting the rollup.

## Output invariants

A completed intermediate model must:

- use the `int_<description>` naming convention and the project's configured `ephemeral` materialization;
- declare and hold to one explicit output grain, stated in the properties YAML description and enforced by a `unique`/`not_null` test on the grain's key (or a composite-uniqueness test when no single column defines the grain);
- join only through validated FK relationships, using the join type (`left`/`inner`) that matches the approved retention behavior — e.g. preserve all orders with a `left join` to optional payment/line-item rollups rather than dropping unmatched orders via `inner join`;
- guard every aggregated or joined measure with `coalesce(..., 0)` (or the approved null-handling policy) so an unmatched left-join side doesn't silently produce nulls where a business zero is expected;
- perform all deduplication, aggregation, and fanout control explicitly in a named CTE — never rely on an incidental join order to avoid duplicate rows;
- use the import → transform (rollup/join) CTEs → `final` CTE → `select * from final` pattern, consistent with staging and marts;
- document the model's grain, PK, and any materially transformed columns in `_int.yml`, even though the properties are lighter-weight than a contracted mart's.

## Workflow

1. Confirm the declared output grain, upstream inputs, join keys, join types, and any aggregation/formula from the approved spec (or from the requested outcome when no spec is orchestrating this work).
2. Profile each upstream input: row count, key uniqueness, duplicate distribution, null rate on join keys, and the matched/unmatched population for each join.
3. If rolling up a one-to-many child table (e.g. payments per order), build a dedicated rollup CTE that aggregates to the parent grain *before* joining, rather than joining raw and aggregating in the same step — this makes fanout visible and testable.
4. Write the model's join/rollup logic, then the `final` CTE selecting the declared output columns in order.
5. Write or update `_int.yml` with the model's description (stating the grain explicitly) and grain-key tests.
6. Validate with a direct preview (`dbt show --select int_<description> --favor-state` or the dev preview) checking: row count matches the expected grain population, no unexpected nulls from a left join, and any control-total check reconciles.
7. Because this layer is ephemeral, its SQL only actually executes through a downstream materialized model — confirm full behavior by building the approved materialized mart(s) that consume it (`dbt build --select +<mart_name>+`), not compile alone.

## Prompt-back conditions

Stop and ask for a focused human decision when:

- a join's observed cardinality doesn't match the assumed relationship (e.g. a supposed one-to-one join produces duplicate parent rows) and it's unclear whether that reflects legitimate business fanout or a data defect;
- retention behavior is ambiguous — should orders with no payment be dropped or kept with a zero/null measure?;
- a formula, control total, or aggregation grouping is not specified precisely enough to compute a single unambiguous result;
- resolving a data quality issue would require a business decision about null treatment, unit conversion, or acceptable duplication.

State the evidence profiled, the options and their downstream implications, a recommendation when supportable, and the narrowest approval question.

## Validation and completion evidence

An intermediate model is complete only when:

- the declared grain is enforced by a passing uniqueness test and confirmed by row-count profiling, not just asserted in a description;
- every join's retention behavior and fanout risk were profiled and match the approved/expected design;
- aggregated measures reconcile against an independently computed control total where one is available;
- `dbt parse` succeeds and the model's behavior is proven by building the downstream materialized mart(s) that select from it;
- properties YAML documents grain, PK, and materially transformed columns.

Because the model is ephemeral, a standalone `dbt show`/preview is useful for iteration, but final completion evidence requires the downstream build to succeed end to end.

## Behavioral acceptance

**Scenario:** `int_order_items_with_order_context` needs a new column joining in `stg_alembic_ops__shops.region`. The join key is `orders.shop_id`, and profiling shows 3% of order rows have a `shop_id` with no matching row in `stg_alembic_ops__shops`.

Expected behavior:

- profile the unmatched population before writing the join and confirm whether it's a handful of decommissioned shops (acceptable) or a broader key mismatch (defect);
- use a `left join` so unmatched order-items are retained with a null region rather than silently dropped by an `inner join`;
- prompt back on whether a null `fulfillment_region` is acceptable for the unmatched 3%, or whether those should be flagged/excluded per business policy;
- keep the model's grain unchanged (one row per order-item) and add a test confirming no fanout was introduced by the new join;
- validate by building the downstream mart that selects from this intermediate model and confirming row counts match expectations.

The scenario fails if the join silently drops the unmatched 3% via an inner join, if row count changes unexpectedly (undetected fanout), or if completion is claimed from a compile/parse without building the downstream mart.

## Ownership and maintenance

**Primary owner:** analytics engineering.

Review this skill after an undetected fanout or dropped-row incident, a new aggregation/rollup pattern is introduced, or project grain/retention/testing conventions change.
