# Author a public governed mart

Use this skill when creating or materially changing a public dbt dimension or fact consumed by analytics, BI, the Semantic Layer, or AI-assisted analysis.

## Trigger and goal

**Trigger:** a public dimension or fact must be created or materially changed — a new mart is needed, or an existing mart's columns, grain, contract, tests, or business meaning must change.

**Goal:** publish one mart with an explicit approved grain and key, built from the simplest approved upstream input, exposing exactly the approved columns in the approved order with contract-matching casts, an enforced contract, exact approved tests, and documentation of grain, meaning, units, nulls, and limitations — with evidence that it builds, satisfies its contract, and behaves as declared.

## Non-goals

- Do not perform joins across multiple inputs, fanout control, deduplication, or substantial aggregation in the mart — that logic belongs in intermediate models this mart consumes through the simplest possible `ref()`.
- Do not add a convenience column, metric, semantic object, or calculation that isn't in the approved spec, even if it looks harmless or useful.
- Do not change a public column's name, type, meaning, or presence without an approved migration path for existing consumers.
- Do not define or extend a semantic model, metric, or entity here; route that to `authoring-governed-metrics`.
- Do not use `models/answer_key/`, `training_assets/reference/`, or another facilitator asset as implementation input.
- Do not implement Warlock-track work through this skill; the Warlock isolation boundary in `AGENTS.md` governs that track separately and excludes this skill.

## Required context and evidence

Before writing or changing a mart, inspect:

- `AGENTS.md` and `SECURITY.md` for always-on policy and decision boundaries;
- `.agents/ROUTING.md` to confirm this is the right skill for the requested outcome;
- the applicable approved build spec, when this work is part of planned source-to-mart implementation — it controls the upstream input, grain, key, public columns and order, casts, contract, properties, and tests;
- `dbt_project.yml` for the configured mart materialization;
- the upstream intermediate or staging model this mart will `ref()`, confirming it is already at the approved public grain so the mart needs no additional join, dedup, or aggregation;
- existing mart contracts, properties YAML, and the semantic layer definitions in `models/marts/_marts.yml` and `models/marts/metrics.yml` (or the project's equivalent) to identify current consumers, entities, and metrics that depend on this mart;
- the project's mart SQL and properties-YAML conventions (explicit column selection, casts, contract enforcement) from representative completed marts and `docs/merlinco/STYLE_GUIDE.md`, where reading that path is not excluded by an active isolation boundary;
- actual warehouse evidence for the upstream input: grain, key uniqueness, null rates, and value ranges for every column being published.

If no approved spec applies, ground grain, column list, types, and business meaning in existing project convention and evidence, and prompt back on anything that can't be settled that way.

## Output invariants

The completed mart must:

- have one explicit, approved public grain and key, using the project's configured mart materialization;
- `ref()` the simplest approved upstream input — if the requested output would require joining multiple inputs, deduplicating, or aggregating beyond what the upstream model already does, that logic belongs in intermediate, not here;
- select and publish exactly the approved columns, in the approved order, with no extra column and no missing column;
- cast every public column explicitly to match its contracted data type;
- enforce the model contract, with every public column declaring a `data_type` matching its SQL cast;
- have properties YAML enumerating every public column with the exact approved tests and test arguments (primary key `unique`/`not_null`, foreign keys `relationships`, normalized categoricals `accepted_values`, required fields `not_null`, composite-grain uniqueness where relevant);
- document grain, business meaning, units, null behavior, and material limitations in the model and column descriptions;
- introduce no convenience column, metric, semantic object, or calculation outside the approved spec;
- follow the project's import-CTE → transformation-CTE → `final` CTE → explicit `select` (never `select * from final`) structure for the public interface.

## Workflow

1. **Confirm the grain and upstream input.** State the mart's approved grain and key, and confirm the single upstream model already produces that grain — check its row count against distinct keys in the warehouse. If it doesn't, stop; that's an intermediate-layer gap, not something to compensate for in the mart.
2. **Inventory current consumers.** Before touching an existing mart, check `models/marts/_marts.yml`, `models/marts/metrics.yml`, and any other semantic or BI references for entities, dimensions, measures, or metrics that depend on the columns you're about to change.
3. **Draft the approved column list.** Confirm the exact public columns, order, and contracted types against the approved spec, or against existing project convention when no spec applies. Do not add a column because it's available upstream and looks useful.
4. **Draft the model.** Use an import CTE for the single ref, a transformation CTE only for the approved casts/derivations, a `final` CTE, then an explicit `select` of the approved columns with casts matching the contract — never `select *` on the public interface.
5. **Draft properties and enforce the contract.** Add or update the mart's YAML entry: description covering grain, meaning, units, nulls, and limitations; a `data_type` and the exact approved tests for every public column; contract enforcement configuration.
6. **Validate.** Run `dbt parse` to confirm the contract and structure resolve, then a scoped `dbt build --select <mart>+` (or the spec's selector) so the mart, its contract, and its tests all execute.
7. **Check grain, keys, and calculations in the warehouse.** Confirm the built mart's row count and key uniqueness match the approved grain, spot-check any approved calculation against a manual value, and confirm no unplanned column made it into the output.
8. **Assess semantic and consumer impact.** If this mart backs a semantic model or metric, confirm those definitions still resolve correctly; if a public column changed or was removed, confirm the migration path for existing consumers is approved.
9. **Report.** Summarize the mart, its grain, upstream input, published columns, contract/test state, and validation evidence, including any deviation from an approved spec.

## Prompt-back conditions

Stop and ask for a focused human decision when:

- grain, public columns, business meaning, units, null treatment, or semantic scope lacks approval;
- a breaking interface change (removed/renamed/retyped column, changed grain) has no approved migration path for existing consumers;
- implementation would require an unplanned upstream model, a multi-input join inside the mart, or another material cost/performance decision;
- an approved spec exists but conflicts with the upstream model's actual grain, keys, or available columns;
- a request asks for a convenience column, metric, or calculation that isn't in the approved spec.

State the decision needed, the evidence inspected, two or three viable options with implications, a recommendation when the evidence supports one, the accountable owner (the data-product owner for public meaning and interface decisions), and the narrowest approval question. Do not resolve an unapproved ambiguity with a plausible-looking default.

## Validation and completion evidence

A mart is complete only when:

- `dbt parse` succeeds and the model contract resolves with no structural errors;
- a scoped `dbt build` executes the mart, its enforced contract, and its attached tests successfully;
- the SQL output's column order and casts exactly match the approved properties contract;
- a warehouse check confirms the public grain, key uniqueness/behavior, retention, relationships, accepted values, and required fields all hold, and any approved calculation matches an independent check;
- no unplanned public column, test, or semantic object was introduced;
- when this mart backs semantic definitions, those definitions and a representative consumer query were checked against the change.

A parse or a contract that merely compiles is not sufficient evidence — the build must actually execute against the warehouse and the tests must actually run.

## Behavioral acceptance

**Scenario:** A request asks to add a `customer_lifetime_value` column to an existing contracted `dim_wizards` mart by summing order totals directly inside the mart's SQL. No approved spec authorizes this column, and `dim_wizards`'s upstream `ref()` is a customer-grain intermediate model with no order-aggregation logic.

Expected behavior:

- recognize that computing a lifetime-value aggregate requires joining/aggregating order data that the current upstream model doesn't already provide at the mart's grain — this is out of scope for a mart-layer change;
- decline to add the column or the underlying aggregation directly in mart SQL, since that would both violate the "simplest upstream input, no joins/aggregation here" invariant and add an unapproved public column;
- prompt back: is `customer_lifetime_value` an approved business metric, should it live in an intermediate model or the semantic layer, and who owns that decision;
- take no action on the contract, columns, or tests until that decision is approved.

The scenario fails if the skill adds the column and an ad hoc aggregation directly into the mart, extends the contract without approval, or treats a plausible-sounding metric name as sufficient grounds to implement it.

## Ownership and maintenance

**Primary owner:** analytics engineering, with the accountable data-product owner approving public meaning and interface decisions.

Review this skill after a public-interface or semantic regression reaches a consumer undetected, a repeated prompt-back reveals an unclear grain/join boundary with intermediate models, a contract or testing-standard change, or a new semantic consumer pattern emerges.
