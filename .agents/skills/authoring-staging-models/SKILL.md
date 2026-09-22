# Author a source-facing staging model

Use this skill when creating or materially changing a dbt model whose purpose is source-facing cleanup at the raw-table grain.

## Trigger and goal

**Trigger:** a staging model must be created or materially changed — a new source table needs a `stg_` model, or an existing one needs a rename, cast, normalization, or macro change.

**Goal:** produce one staging model that reads exactly one declared `source()`, preserves that source's grain and row retention, and applies only grounded renaming, casting, normalization, and approved macro reuse — with matching properties YAML and evidence that it builds and behaves as declared.

## Non-goals

- Do not join, aggregate, deduplicate, or otherwise change grain. That belongs in an intermediate model.
- Do not invent a business rule, null-handling policy, unit conversion, or value mapping that isn't grounded in observed source data or an approved decision.
- Do not select from more than one `source()` in a single model, or read from another model via `ref()` in place of the declared source.
- Do not use `models/answer_key/`, `training_assets/reference/`, or another facilitator asset as implementation input.
- Do not implement Warlock-track work through this skill; the Warlock isolation boundary in `AGENTS.md` governs that track separately and excludes this skill.

## Required context and evidence

Before writing or changing a staging model, inspect:

- `AGENTS.md` and `SECURITY.md` for always-on policy and decision boundaries;
- `.agents/ROUTING.md` to confirm this is the right skill for the requested outcome;
- the applicable approved build spec, when this work is part of planned source-to-mart implementation — it controls model path, source input, output columns, transformations, properties, and tests;
- the target source's active declaration (`source()` name, table, and any declared column tests) in the relevant `_<system>__sources.yml`;
- `dbt_project.yml` for the configured staging materialization and schema;
- the project's staging SQL and properties-YAML conventions (naming, CTE structure, macro usage) from representative completed staging models and `docs/merlinco/STYLE_GUIDE.md`, where reading that path is not excluded by an active isolation boundary;
- actual source columns, types, and a representative sample of distinct/observed values in the warehouse — never assume a column, encoding, or category from a name alone.

If no approved spec applies (e.g., an ad hoc staging fix), ground every decision in the source declaration, project convention, and direct warehouse observation instead.

## Output invariants

The completed staging model must:

- select from exactly one `source()`, using the project's configured staging materialization;
- preserve the source table's grain — one output row per source row, with no filtering that silently drops rows unless that retention rule is approved or already project convention;
- rename columns into project naming conventions without changing their meaning;
- cast raw text into real dates, timestamps, numerics, and booleans, using safe/try casts where the raw data has ever shown malformed values;
- normalize categoricals and apply approved shared macros (e.g., boolean, currency, region-conformance macros) only where the project already uses that pattern for equivalent columns;
- contain no join, aggregation, deduplication, or window function that changes grain;
- follow the project's import-CTE → transformation-CTE → `final` CTE → `select * from final` structure;
- when an approved build spec exists, match its model path, source input, output column list and order, transformations, properties entries, and tests exactly — no extra or missing column, test, or mapping;
- have matching properties YAML: model and column descriptions, and tests for keys, required fields, and normalized categoricals consistent with the project's testing standard.

## Workflow

1. **Confirm scope.** Identify the exact source table, target model path, and whether an approved spec governs this work. If the request implies a join, rollup, or business rule, stop — that belongs in intermediate or mart work, not this skill.
2. **Ground the source.** Read the active source declaration and query the raw table directly: inspect column types, and pull distinct/representative values for every categorical, boolean-like, and timestamp-like column you intend to touch. Do not rely on the source YAML description alone for encoding details.
3. **Draft the model.** Write the import CTE against the single `source()`, a transformation CTE with only grounded renames/casts/normalization/macro calls, a `final` CTE, and `select * from final`. If an approved spec exists, match its output columns and order exactly.
4. **Draft properties.** Add or update the model's YAML entry with descriptions and tests that reflect the project's baseline (primary key `unique`/`not_null`, normalized categoricals with evidence-backed `accepted_values`, required fields `not_null`), matching an approved spec's test list when one exists.
5. **Validate.** Run `dbt parse` to check structure, then a scoped `dbt build --select <model>+` (or the spec's build selector) so the model executes and its tests run.
6. **Check grain and retention in the warehouse.** Compare source row count and key cardinality against the built model's output to confirm no unintended row loss or duplication, and spot-check that normalized values only ever produced expected outputs (no silent nulling of an unrecognized category unless that's the approved behavior).
7. **Report.** Summarize the model, its source, transformations applied, tests added, and validation evidence. Note any deviation from an approved spec and why.

## Prompt-back conditions

Stop and ask for a focused human decision when:

- source authority, grain, key, or row-retention expectations are unsupported by the source declaration or contradicted by observed data;
- null handling, value mapping, unit conversion, or another business rule the request implies has no grounding in observed data or approved decision;
- the requested transformation requires a join, aggregation, deduplication, or other grain change — this belongs in an intermediate or mart model instead;
- an approved spec exists but conflicts with observed source structure or values;
- a normalization macro doesn't cover an observed value and the correct mapping isn't obvious from project convention.

State the decision needed, the evidence inspected, two or three viable options with implications, a recommendation when the evidence supports one, the accountable owner, and the narrowest approval question. Do not treat a plausible guess as approval.

## Validation and completion evidence

A staging model is complete only when:

- `dbt parse` succeeds with no structural errors;
- a scoped `dbt build` (or the approved spec's build selector) executes the model and its attached tests successfully;
- a warehouse check confirms output grain and row count match the source's expected retention, and key columns behave as declared (unique/not-null where required);
- normalization and macro output were checked against observed source values, not assumed;
- when an approved spec exists, the SQL output columns/order and properties YAML (descriptions, tests, arguments) match it exactly.

A parse or a plausible-looking query is not sufficient evidence. Do not report completion without the build and warehouse checks above.

## Behavioral acceptance

**Scenario:** A request asks for a staging model over a newly declared source table with a boolean-like column recorded as `Y`/`N`/`yes`/`no`/`TRUE`/`FALSE` and a categorical column with mixed-case values. No approved spec exists for this ad hoc request.

Expected behavior:

- inspect the source declaration and query the raw table for actual distinct values before writing any cast or mapping;
- reuse the project's existing boolean-normalization macro rather than writing a new one, since the observed encodings match its pattern;
- normalize the categorical with `lower(trim(...))` consistent with project convention, and confirm through a warehouse check that no value collapses to an unexpected result;
- write the model as source → transform → final → `select * from final`, one row per source row;
- add properties YAML with a primary-key test and an evidence-backed `accepted_values` test only for values actually observed;
- run `dbt parse`, then a scoped `dbt build`, and confirm row counts and key uniqueness against the source before reporting completion.

The scenario fails if the skill invents a mapping for a value it never observed, silently drops rows to "clean" the data without approval, adds a join or aggregation, or claims completion from a parse alone.

## Ownership and maintenance

**Primary owner:** analytics engineering.

Review this skill after a staging defect reaches intermediate or mart layers undetected, a repeated prompt-back reveals an unclear boundary with intermediate work, a new source system or macro is added, or project staging conventions change.
