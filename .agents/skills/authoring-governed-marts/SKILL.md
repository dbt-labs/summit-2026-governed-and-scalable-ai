# Author governed marts

Use this skill when creating or materially changing a public dbt dimension or fact consumed by analytics, BI, the Semantic Layer, or AI-assisted analysis.

## Trigger and goal

**Trigger:** a `dim_<noun>` or `fct_<noun>` mart needs to be created, or an existing one needs a material change to its public columns, contract, grain, or semantic scope.

**Goal:** publish one contracted, tested mart that exposes exactly the approved public interface from the simplest possible upstream model, so downstream consumers (BI, Semantic Layer, other marts) can trust it without re-verifying its logic.

## Non-goals

- Do not add a convenience column, join, or derivation beyond what's approved — a mart's public interface is a governed surface, not a place for incidental additions.
- Do not select from a source or an intermediate model further upstream than necessary; a mart should ref the single simplest model that already has the correct grain and columns (typically one `int_` model, occasionally a `stg_` model directly).
- Do not weaken, disable, or omit the contract to make a build pass.
- Do not define a competing metric or semantic property here — semantic layer changes go through `authoring-governed-metrics`.
- Do not use `models/answer_key/`, `training_assets/reference/`, or another facilitator asset as implementation input.

## Required context and evidence

Before writing or editing a mart:

- inspect `AGENTS.md`, `docs/merlinco/STYLE_GUIDE.md`, and the approved build spec's exact public column list, types, and semantic scope when part of planned work;
- inspect the upstream model (usually one `int_` model) that already has the mart's declared grain — confirm it, don't assume it;
- inspect representative completed marts (`models/marts/dim_*.sql`, `fct_*.sql`) and `_marts.yml` for the explicit-cast pattern, contract structure, and semantic model / metric conventions;
- confirm every public column's approved data type against `dbt_project.yml`'s money convention (`*_gold` as `number(38, 2)`) and other project casting norms;
- identify known consumers (BI dashboards, Semantic Layer metrics, other marts) before changing or removing an existing public column — a breaking change needs an approved migration path, not a silent edit.

## Output invariants

A completed mart must:

- use the `dim_<noun>` (entity) or `fct_<noun>` (event, stated grain) naming convention and the project's configured `table` materialization;
- select from the single simplest upstream `ref()` — never `select *` from a source or upstream model;
- enforce a dbt contract (`config.contract.enforced: true`) with an explicit `data_type` for every public column in `_marts.yml`;
- cast every public column explicitly in SQL to match its declared contract type (e.g. `order_id::varchar`, `net_revenue_gold::number(38, 2)`), never relying on implicit upstream typing;
- publish only the approved column list, in the approved order, with no undeclared additions or omissions;
- use the import → `final` CTE → `select * from final` pattern;
- carry PK `unique`/`not_null` tests, FK `relationships` tests to other marts, and `accepted_values` on every categorical, matching the exact contract-cast values;
- leave semantic model/metric definitions untouched unless the request explicitly includes a governed semantic change (route that through `authoring-governed-metrics`).

## Workflow

1. Confirm the approved public column list, types, grain, key, and upstream ref from the spec (or from the requested outcome and existing consumer expectations when no spec is orchestrating this work).
2. Confirm the single upstream model already provides that grain and every needed source column — if it doesn't, that's a signal the intermediate layer is incomplete, not something to patch around in the mart.
3. Write the mart's `final` CTE with an explicit cast on every column, in the approved order.
4. Write or update `_marts.yml`: contract enforcement, per-column `data_type`, description, and tests (PK, FK `relationships`, `accepted_values`).
5. Run `dbt parse` to catch a contract/output mismatch before touching the warehouse.
6. Run `dbt build --select +<model_name>+` (or the spec's bounded selector) to execute the model, its contract, and its tests against real data.
7. When changing an existing mart's public interface, check known downstream refs (other marts, semantic model dimensions/measures) and, for a behavior-affecting change, run `dbt compare` on the affected slice to see the production delta before calling the work done.

## Prompt-back conditions

Stop and ask for a focused human decision when:

- a requested column, type, or derivation isn't in the approved spec or can't be traced to an existing, unambiguous business definition;
- removing or retyping an existing public column would break a known consumer (BI, Semantic Layer metric, downstream mart) without an approved migration plan;
- the upstream model doesn't yet support the mart's declared grain or a needed column, which means intermediate work is missing or wrong — don't compensate with mart-layer joins or logic;
- a semantic extension (new metric, dimension, entity) is requested alongside the mart — that decision and its implementation belong to `authoring-governed-metrics`, not this skill.

State the evidence inspected, the options and consumer impact, a recommendation when supportable, the accountable owner, and the narrowest approval question.

## Validation and completion evidence

A mart is complete only when:

- `dbt parse` succeeds with no contract/output mismatch;
- `dbt build --select +<model_name>+` executes the model, enforces its contract, and passes every attached test against real warehouse data;
- the published column list, order, and types match the approved spec (or documented consumer-compatible design) exactly — no undeclared additions;
- for a change to an existing mart's public interface, known consumer impact was checked and, when the change is behavior-affecting, a `dbt compare` was run and reviewed;
- `_marts.yml` documents every column with a description and the required tests.

A passing parse or plausible SQL is not sufficient; the contracted build and its tests must actually pass, and any interface change must be checked against known consumers.

## Behavioral acceptance

**Scenario:** A request asks to add a `days_since_signup` convenience column to `dim_wizards`, computed from `signed_up_at`, because a dashboard author finds it easier than computing it in BI.

Expected behavior:

- recognize this as an unapproved addition to a contracted public interface, not a bug fix;
- check whether the approved spec or an existing decision record already covers this column — if not, prompt back: is this a case for a BI-layer calculation, a genuinely reusable mart column, or a Semantic Layer metric/dimension instead?
- do not add the column speculatively while waiting for a decision;
- if approved as a mart column, add it with an explicit cast, a `data_type` in the contract, a description, and confirm it doesn't change the grain or break the existing PK test;
- validate with `dbt build --select +dim_wizards+` before considering it complete.

The scenario fails if the column is added directly without confirming approval, if the contract/type isn't declared, or if completion is claimed without a passing contracted build.

## Ownership and maintenance

**Primary owner:** analytics engineering, with data-product/metric owners approving public interface and semantic-adjacent changes.

Review this skill after a contract violation reaches consumers, a breaking mart change ships without migration evidence, or project casting/testing/semantic conventions change.
