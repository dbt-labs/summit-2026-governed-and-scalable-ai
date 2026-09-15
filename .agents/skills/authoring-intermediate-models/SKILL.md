# Author an intermediate model

Use this skill when creating or materially changing a dbt model that owns joins, deduplication, aggregation, enrichment, fanout control, or another approved grain change.

## Trigger and goal

Trigger this skill when the requested work combines or reshapes staging outputs — joining parent context, deduplicating, aggregating, or otherwise changing grain — before a mart consumes it.

The goal is one `ephemeral` model that performs the join/dedupe/aggregation cleanly, controls fanout, and states its resulting grain explicitly, so marts stay readable without re-changing grain.

## Non-goals

- Do not add source-facing cleanup that belongs in staging, or public contracts/semantics that belong in marts.
- Do not persist the model or select from a `source()`; intermediate reads staging through `ref()`.
- Do not silently change grain — an unstated fanout is a defect, not a style choice.
- Do not use `models/answer_key/` or `training_assets/reference/` as evidence.

## Required context and evidence

Before editing, inspect:

- `AGENTS.md`, `SECURITY.md`, and `docs/merlinco/STYLE_GUIDE.md` for policy and layering rules.
- `docs/merlinco/ERD.md` and the data dictionary for keys, cardinalities, and relationships.
- The upstream staging models (via `ref()`) that supply this model's inputs.
- An existing completed intermediate model as the pattern.
- Warehouse profiles of the join keys — matched and unmatched populations, duplicate behavior, and fanout risk — at the grains involved.

## Output invariants

The intermediate model must:

- materialize as `ephemeral` (never persisted);
- reference every input through `ref()` on a staging (or upstream intermediate) model;
- follow the import-CTE → transformation-CTE → `final` → `select * from final` structure, one import CTE per upstream ref;
- state its resulting grain explicitly (in a header comment and the model description) and hold exactly that grain — one row per stated key;
- control fanout on every join, so a join adding context does not multiply rows unless the stated grain intends it;
- keep `snake_case` naming, `*_copper`/`*_gold` pairing, and boolean/timestamp conventions consistent with upstream;
- name the model `int_<description>` describing what it produces.

## Workflow

1. **Inspect** the upstream staging models, the ERD relationships, and a sibling intermediate model as the pattern.
2. **Profile** the join keys in the warehouse: cardinality on each side, unmatched rows, and whether any join fans out the stated grain.
3. **Decide the grain** explicitly and confirm the keys support it; choose join type and fanout control (dedupe, aggregate, or pre-collapse) accordingly.
4. **Author** the model with import CTEs, the join/dedupe/aggregation transformation, a `final` CTE, then `select * from final`.
5. **Validate** through a materialized downstream node — intermediate is ephemeral, so build a dependent mart with `dbt build --select +int_<description>+` (which compiles the ephemeral SQL into its consumer) and confirm the resulting row count matches the stated grain.
6. **Hand off** material work to `reviewing-governed-dbt-changes` or the orchestrator.

## Prompt-back conditions

Stop and ask a focused question when: the intended output grain is unresolved or contradicts the keys; a join fans out and no approved dedupe/aggregation rule exists; record retention (which unmatched rows to keep or drop) is a business decision; or an aggregation formula/definition is not established by authority. State the decision, evidence inspected, two or three options with implications, a recommendation when supportable, the owner, and the narrowest approval question. A mechanically resolvable fanout with an established rule is not a human decision — fix it.

## Validation and completion evidence

Complete only when:

- the model is `ephemeral` and references inputs via `ref()`;
- the stated grain is declared and a warehouse row-count/uniqueness check at that grain confirms it;
- fanout is controlled — join cardinality checks show no unintended row multiplication;
- a downstream `dbt build` compiles the ephemeral model and passes;
- naming, currency, and structural conventions match upstream.

## Behavioral acceptance

**Scenario:** A request builds `int_order_items_with_order_context` by joining order-level context onto order items. Expected behavior: profile the order-item to order cardinality (many-to-one), confirm the join holds one row per order item, state that grain in the header and description, and validate via a downstream mart build with a row-count check equal to the order-item count. The scenario fails if the join fans out order items, the grain is left unstated, or the model is materialized as a table/view.

## Ownership and maintenance

The analytics engineering governance owner owns this skill. Review it after an intermediate change produces an unintended fanout or grain defect, when ERD relationships change, or when project layering conventions change.
