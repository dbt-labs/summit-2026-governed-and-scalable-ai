# Author an intermediate join/grain-change model

Use this skill when creating or materially changing a dbt model that owns joins, deduplication, aggregation, enrichment, fanout control, or another approved grain change.

## Trigger and goal

**Trigger:** a model must be created or materially changed that combines, deduplicates, aggregates, or enriches inputs — or otherwise changes grain between staging and a public mart.

**Goal:** produce one intermediate model whose input grain, output grain, key, join cardinality, record retention, and fanout control are stated explicitly before any SQL is written, implemented through `ref()`-declared inputs at the configured ephemeral materialization, with evidence that the resulting grain, keys, and arithmetic behave as declared.

## Non-goals

- Do not perform source-facing renaming, casting, or normalization that belongs in staging — consume already-cleaned staging output through `ref()`.
- Do not publish a public, contracted interface here; that belongs in a mart.
- Do not invent a join key, retention rule, deduplication priority, allocation method, null-handling rule, unit conversion, or business formula that isn't grounded in evidence or an approved decision.
- Do not resolve a many-to-many join with an arbitrary dedup, `distinct`, or unvalidated bridge; treat it as blocked until an approved strategy exists.
- Do not use `models/answer_key/`, `training_assets/reference/`, or another facilitator asset as implementation input.
- Do not implement Warlock-track work through this skill; the Warlock isolation boundary in `AGENTS.md` governs that track separately and excludes this skill.

## Required context and evidence

Before writing or changing an intermediate model, inspect:

- `AGENTS.md` and `SECURITY.md` for always-on policy and decision boundaries;
- `.agents/ROUTING.md` to confirm this is the right skill for the requested outcome;
- the applicable approved build spec, when this work is part of planned source-to-mart implementation — it controls refs, joins, formulas, output columns, properties, and tests;
- `dbt_project.yml` for the configured intermediate materialization;
- the upstream staging/intermediate models this model will `ref()`, including their declared grain, keys, and any existing tests;
- the project's intermediate SQL and properties-YAML conventions (naming, CTE structure, join/aggregation patterns) from representative completed intermediate models and `docs/merlinco/STYLE_GUIDE.md`, where reading that path is not excluded by an active isolation boundary;
- actual warehouse evidence for every input: key cardinality, duplicate distribution, null rates, and a sample of the join or aggregation in isolation before trusting it inside the full model.

If no approved spec applies, ground every join, retention, and formula decision in inspected evidence and existing project convention, and prompt back on anything that evidence can't settle.

## Output invariants

The completed intermediate model must:

- declare every input with `ref()`, never a raw table reference or `source()`;
- use the project's configured ephemeral materialization;
- state input grain(s), output grain, output key, join cardinality, record-retention rule, and fanout control before or alongside the SQL (in a comment, properties description, or spec) so a reviewer can check the SQL against the stated intent;
- keep every join, deduplication, aggregation, and grain change inside this layer — never deferred to a mart;
- contain no many-to-many join unless an approved bridge, allocation, or pre-aggregation strategy is in place to control fanout;
- aggregate at exactly the approved output grain — no coarser or finer grouping than declared;
- use an evidence-backed, deterministic key and ordering for any deduplication (e.g., a documented "latest wins" or "highest-priority status wins" rule), never an arbitrary `distinct` or unordered `row_number()`;
- when an approved build spec exists, match its refs, join conditions, formulas, output column list and order, properties entries, and tests exactly;
- follow the project's import-CTE → transformation-CTE → `final` CTE → `select * from final` structure;
- have matching properties YAML with tests that prove the declared grain (e.g., a uniqueness test on the output key or composite grain) and any required-field or relationship tests the project's testing standard calls for.

## Workflow

1. **State the grain contract first.** Before writing SQL, write down: each input's grain and key, the join(s) and their cardinality, the target output grain and key, the retention rule (what happens to unmatched, duplicate, or failed/inactive records), and any fanout-control mechanism. If this can't be stated from available evidence or approval, stop here.
2. **Profile every input.** Query each `ref()`-able upstream model to confirm actual key uniqueness, duplicate counts, null rates on join keys, and value ranges relevant to any formula. Don't assume a staging model's declared grain is correct — verify it.
3. **Validate join cardinality before writing the join.** For each join, confirm empirically whether it's one-to-one, one-to-many, or many-to-many. If many-to-many and no approved bridge/allocation/aggregation strategy exists, stop and prompt back rather than writing the join.
4. **Draft the model.** Aggregate a many-side input to the required grain before joining when the output must preserve a one-side grain. Apply only approved formulas, null treatment, and unit conversions. Use import CTEs, transformation CTEs, a `final` CTE, then `select * from final`. If an approved spec exists, match its refs, joins, formulas, and output columns exactly.
5. **Draft properties.** Add or update the model's YAML entry with a description of the grain contract and tests that would fail if the grain broke (uniqueness on the key or composite grain, relationship tests where useful, not-null on required fields).
6. **Validate through a materialized downstream node.** Because this layer is ephemeral, run `dbt parse` for structure, then a scoped `dbt build --select <this_model>+` (or the spec's selector) so it executes as part of a materialized downstream model and its tests run.
7. **Check grain, retention, and arithmetic in the warehouse.** Compare row counts and key uniqueness against the stated contract, confirm join match rates match expectations (no unexplained row multiplication or loss), and spot-check any aggregated or derived measure against a manual calculation on a sample.
8. **Report.** Summarize the model, its grain contract, inputs, join/aggregation logic, tests added, and validation evidence, including any deviation from an approved spec.

## Prompt-back conditions

Stop and ask for a focused human decision when:

- available keys or cardinalities cannot support the requested output grain;
- retention (what happens to unmatched, duplicate, failed, or inactive records), deduplication priority, allocation method, null treatment, unit conversion, or a business formula lacks approval or evidence;
- a join is many-to-many and no approved bridge, allocation, or aggregation strategy exists to control fanout;
- a materialization or cost tradeoff (e.g., whether this ephemeral model's cost profile is acceptable once composed into a mart) lacks an approved control;
- an approved spec exists but conflicts with observed input grain, keys, or cardinality.

State the decision needed, the evidence inspected, two or three viable options with implications, a recommendation when the evidence supports one, the accountable owner, and the narrowest approval question. Do not resolve an unapproved ambiguity with a plausible-looking default.

## Validation and completion evidence

An intermediate model is complete only when:

- `dbt parse` succeeds with no structural errors;
- a scoped `dbt build` executes this model's logic through an executable, materialized downstream node and its attached tests pass;
- a warehouse check confirms the declared output grain and key uniqueness, join match rates against expectations, and no unexplained fanout;
- retention behavior (which records are kept, dropped, or deduplicated) was checked against the approved rule, not assumed;
- any aggregated or derived measure was validated against a manual or independent calculation on a sample;
- when an approved build spec exists, refs, joins, formulas, SQL output columns/order, and properties YAML (descriptions, tests, arguments) match it exactly.

A parse, a plausible-looking join, or an ephemeral model that has never actually executed through a downstream build is not sufficient evidence.

## Behavioral acceptance

**Scenario:** A request asks for a model that enriches orders with their payment attempts. Orders and payments are both staging models; a single order can have multiple payment attempts (failed retries plus one eventual success), and the required output grain is one row per order.

Expected behavior:

- profile the payments model and discover the one-to-many order-to-payment relationship before writing any join;
- recognize this as a case requiring pre-aggregation (rolling payments up to one row per order) rather than a direct join, since a direct join would fan out the order grain;
- state the retention rule explicitly — e.g., whether failed attempts are counted, summarized, or dropped — and prompt back if that rule isn't already evidenced by project convention or approval;
- implement the aggregation to the approved order grain, join it to orders as one-to-one, and add a uniqueness test on the order key;
- validate through a scoped build against a materialized downstream model and confirm in the warehouse that output row count equals distinct order count with no fanout;
- refuse to ship a naive join that would silently multiply order rows by payment-attempt count.

The scenario fails if the skill joins payments directly to orders without pre-aggregating, invents a retention rule for failed payments without grounding or approval, or claims completion without a build that actually executes the aggregation and join.

## Ownership and maintenance

**Primary owner:** analytics engineering.

Review this skill after a grain or fanout defect reaches a mart undetected, a repeated prompt-back reveals an unclear join or retention boundary, a new join pattern or bridge strategy is approved, or project intermediate conventions change.
