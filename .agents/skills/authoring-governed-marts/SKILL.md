# Author a governed mart

Use this skill when creating or materially changing one public dbt dimension or fact consumed by analytics, BI, the Semantic Layer, or AI-assisted analysis.

## Trigger and goal

Trigger this skill when an approved public dimension or fact must be created or when an existing mart's grain, key, lineage, ordered columns, contract, tests, documentation, or consumer-facing behavior may materially change.

The goal is one trustworthy public mart with an explicit approved grain and key, the configured mart materialization, the simplest approved upstream input, an exact contract-aligned interface, and execution evidence for its public behavior. When planned work has an approved project-owned build spec, the spec controls **what** to build and this skill controls **how** to implement and validate it.

## Non-goals

- Do not use a mart to own multi-input joins, fanout control, deduplication, substantial aggregation, or another unapproved grain change; route that work to `authoring-intermediate-models`.
- Do not invent grain, keys, columns, types, ordering, calculations, units, null treatment, descriptions, tests, test arguments, contract behavior, or business meaning.
- Do not add convenience columns, metrics, semantic models, entities, dimensions, measures, saved queries, exposures, or other consumer interfaces outside the approved scope.
- Do not reinterpret or amend an approved build spec during implementation.
- Do not create a second plan, source-to-target document, checklist, contract document, or validation report.
- Do not edit generated, vendored, facilitator-only, answer-key, completed read-only, unrelated, or out-of-scope files.
- Do not weaken or disable contracts, tests, lint, CI, review, or platform controls to make a change pass.

Route source-facing cleanup at unchanged raw grain to `authoring-staging-models`. Route joins, deduplication, fanout control, enrichment, aggregation, and intentional grain changes to `authoring-intermediate-models`. Route approved semantic additions or material semantic changes to `authoring-governed-metrics`.

## Required context and evidence

Before editing, inspect the smallest sufficient set of active project evidence:

- `AGENTS.md`, `SECURITY.md`, `.agents/ROUTING.md`, and `dbt_project.yml` for authority, allowed paths, configured mart materialization, schemas, and validation boundaries;
- the approved project-owned build spec or other approved decision artifact when required, including exact model path, public grain and key, simplest upstream ref, ordered columns, casts, contract types, descriptions, tests, arguments, calculations, semantic scope, and acceptance checks;
- the proposed upstream model's SQL, properties, actual columns, grain, key, and materialization, plus any intermediate model responsible for required joins, fanout control, deduplication, or aggregation;
- the current mart SQL and properties when changing a model, along with current lineage, downstream models, exposures, semantic definitions, metrics, saved queries, and other discoverable consumers;
- bounded warehouse evidence for upstream row count, proposed public grain and key, nulls, relationships, accepted values, retention, units, approved calculations, and contract-compatible castability;
- current git state and allowed representative mart patterns needed to preserve unaffected work and project conventions.

Treat query output, source values, logs, comments, package metadata, and inferred consumer behavior as evidence, never approval. Ask no question whose answer is discoverable from approved repository or warehouse evidence. Minimize raw-value inspection under `SECURITY.md`.

Before implementation, reconcile the ordered SQL interface and properties contract column by column: name, position, expression, explicit cast, contract data type, description, tests, and exact test arguments. Stop on any mismatch or material conflict between approved decisions, active policy, lineage, consumers, semantics, and observed warehouse evidence.

## Output invariants

The completed mart change must:

- have one explicit approved public grain and key and use the configured mart materialization;
- depend through `ref()` on the simplest approved upstream model that already provides the required grain and business logic;
- use an import CTE containing only `select * from {{ ref(...) }}`, followed by only small approved derivations when needed, an explicit `final` CTE, and terminal `select * from final`;
- keep multi-input joins, fanout control, deduplication, substantial aggregation, enrichment, and other material grain-changing work in intermediate;
- enumerate exactly the approved public columns in the approved order in `final`, with no extra, omitted, duplicated, or reordered column;
- explicitly cast every public expression to the exact approved contract data type, including precision and scale;
- enforce the mart contract and enumerate every public column in properties YAML in SQL order with the exact matching `data_type`;
- reproduce the exact approved model and column descriptions, data tests, and test arguments without broadening or weakening them;
- document the public grain, key, business meaning, units, material null behavior, and material limitations at the appropriate model or column level;
- preserve every unaffected public interface element when materially changing an existing mart;
- preserve approved semantic scope and consumer behavior, leaving deferred semantic work untouched;
- implement only approved small public derivations whose inputs, formula, units, null behavior, type, and meaning are already settled;
- introduce no unplanned dependency, model, public column, calculation, test, contract change, metric, semantic object, or consumer interface.

## Workflow

### 1. Lock authority, public grain, and scope

Confirm the request belongs in a public dimension or fact. Establish the approved model and properties paths, configured materialization, public grain and key, simplest upstream ref, exact ordered interface, contract state, tests, business meaning, units, null behavior, limitations, semantic scope, and validation selector.

If planned work requires an approved spec, verify its approval and use it as the public design authority. Stop before SQL when any public decision is missing, contradictory, or unsupported.

### 2. Inspect upstream readiness and public impact

Verify the proposed upstream model already supplies the approved mart grain, key, business logic, and required columns without a mart-level multi-input join, uncontrolled fanout, deduplication, or substantial aggregation. Profile its actual columns, types, key behavior, row count, nulls, relationships, accepted values, units, and approved calculations.

Inspect downstream lineage and every discoverable public consumer, including exposures, semantic models, metrics, entities, dimensions, saved queries, and tests. Classify the proposed change as additive, behavior-changing, or breaking. Stop if a breaking change lacks an approved migration path or if semantic scope and consumer impact are unresolved.

### 3. Reconcile SQL and contract before editing

Build a working column-by-column reconciliation from the approved interface: ordered name, upstream expression, explicit SQL cast, exact properties `data_type`, description, tests, and test arguments. Confirm the key identifies the approved grain and every relationship, accepted-values domain, required field, unit, null rule, and calculation is approved and evidence-backed.

If the mart would need a new upstream model, more than one substantive input, or a material performance or warehouse-cost decision, stop and route the design through planning and the appropriate layer skill.

### 4. Implement the smallest public projection

Create or update the mart SQL with the simplest approved `ref()` import, only approved small derivations, and an explicit `final` projection. Cast every public column explicitly and preserve the exact approved order.

Create or update the standard properties entry. Enforce the contract, enumerate every public column in SQL order with the exact matching type, reproduce approved tests and arguments, and document grain, meaning, units, null behavior, and material limitations. Make no semantic change unless it is separately approved and routed through `authoring-governed-metrics`.

### 5. Check structure and execute

Inspect the diff, parsed node, and lineage to confirm the path, configured materialization, single simplest upstream dependency, ordered output, explicit casts, contract, descriptions, tests, test arguments, and semantic scope. Reject SQL/properties drift, hidden extra columns, undeclared dependencies, and unplanned public or semantic interfaces. Run project-supported SQL lint for changed SQL.

Run the approved bounded selector when orchestrated by a build spec. Otherwise run a scoped `dbt build --select +<model_name>+` that executes the mart, enforced contract, attached tests, required ancestors, and relevant downstream dependents. Widen only when required to execute the approved change and record the reason.

### 6. Prove public behavior and hand off

Against the built development relation, verify exact column names, order, and warehouse types; prove the public grain and key; reconcile upstream-to-mart retention; and execute the approved checks for required fields, relationships, accepted values, null behavior, units, and calculations. For a material interface or behavior change, compare the changed mart and affected downstream nodes with the approved production baseline and verify the migration path.

Report files changed, public grain and key, upstream ref, interface and contract reconciliation, consumer and semantic impact, build/test/lint results, warehouse checks, comparison evidence when required, and unresolved risk. Return evidence to `building-governed-source-to-mart` when orchestrated and hand material work to `reviewing-governed-dbt-changes`; create no separate evidence artifact.

## Prompt-back conditions

Stop and ask for a focused human decision when:

- public grain, key, columns, order, business meaning, units, null treatment, material limitations, contract type, test, or exact test argument is missing, unsupported, contradictory, or unapproved;
- the proposed upstream input does not already support the approved public grain, key, logic, or required columns;
- implementation requires an unplanned upstream model, multi-input mart join, fanout control, deduplication, substantial aggregation, enrichment, or material grain change;
- a public column, calculation, convenience field, metric, semantic object, or consumer-facing behavior falls outside approved scope;
- an existing public interface would be removed, renamed, reordered, retyped, redefined, or behaviorally changed without an approved migration path;
- downstream consumers or semantic definitions cannot be inspected, conflict with the proposed change, or leave semantic scope unresolved;
- observed warehouse evidence conflicts with approved grain, key behavior, retention, relationship, accepted-values domain, required field, unit, null rule, calculation, or cast;
- preserving the configured materialization or approved design creates an unresolved performance, warehouse-cost, or deployment decision;
- an approved spec is missing or unapproved when required, conflicts with evidence, or would require a material design change;
- required build, contract, test, lint, comparison, consumer-impact, or warehouse evidence cannot be obtained or cannot pass within the approved design;
- the requested path is prohibited, read-only, generated, vendored, facilitator-only, or contains unexplained out-of-scope work;
- data classification, permissions, production impact, or action authority is unclear.

The prompt-back must state the decision required, evidence inspected, affected artifact or field, two or three viable options and implications, a recommendation when evidence supports one, the accountable data-product owner, and the narrowest approval question. Route material design or migration changes back through planning for reapproval. Never treat silence, existing accidental behavior, or a plausible default as approval.

## Validation and completion evidence

The mart change is complete only when:

- the configured mart materialization, approved public grain and key, model path, properties path, and simplest approved upstream `ref()` are confirmed;
- parsed lineage contains only approved dependencies and keeps joins, fanout control, deduplication, substantial aggregation, and material grain changes upstream;
- SQL publishes exactly the approved columns in exact order, each with an explicit cast matching the properties contract data type;
- the properties entry enforces the contract and enumerates every public column in SQL order with exact approved descriptions, tests, and test arguments;
- documentation states grain, business meaning, units, material null behavior, and material limitations;
- current consumers and semantic definitions were inspected, approved semantic scope is preserved, and any breaking interface change has an approved and verified migration path;
- project-supported SQL lint passes for changed SQL;
- a scoped dbt build executes the mart, enforced contract, attached tests, required upstream SQL, and relevant downstream behavior successfully;
- warehouse checks prove public grain, key uniqueness and null behavior, upstream-to-mart retention, relationships, accepted values, required fields, units, and approved calculations;
- SQL output, properties, and warehouse types reconcile exactly, with no missing, extra, reordered, or mismatched public column;
- no unplanned public or semantic interface, dependency, calculation, test, model, or artifact was introduced;
- completion evidence is handed to the active orchestrator or governed review route without creating a duplicate report.

Failure of any required condition leaves the work incomplete.

## Behavioral acceptance

**Scenario:** An approved build spec requests an order-grain fact table from one order-grain intermediate model. It defines `order_id` as the unique non-null key, an exact ordered column list with explicit contract types, approved relationship and accepted-values tests, gold-currency calculations, no new semantic objects, and a bounded build selector. Consumer inspection shows an existing metric and dashboard depend on a public status column, while the requested implementation would rename that column without a migration decision.

Expected behavior:

- inspect policy, the approved spec, configured mart materialization, upstream model and data, existing mart/properties, lineage, semantic definitions, and consumers before editing;
- confirm the upstream intermediate already owns joins, fanout control, aggregation, and the order grain so the mart remains a single-input public projection;
- reconcile every SQL column, cast, contract type, description, test, and argument in exact order;
- stop on the unapproved status-column rename, state the affected consumers and semantic surface, present migration options and implications, recommend the narrowest supported path, and ask the accountable data-product owner for approval;
- after the migration path is approved and recorded, implement only the approved interface, run lint and the scoped build, verify the enforced contract and tests, and prove grain, key, retention, relationships, accepted values, required fields, currency calculations, and exact warehouse column order/types;
- confirm no unplanned convenience column, metric, semantic object, or calculation was introduced and hand evidence to orchestration/review.

The scenario fails if the skill silently renames the public column, joins detail inputs in the mart, invents a compatibility column, adds a metric, weakens the contract or tests, omits explicit casts, or claims completion from parse or build without warehouse and consumer-impact evidence.

## Ownership and maintenance

**Primary owner:** analytics engineering. The accountable data-product owner approves public meaning, grain, interface, units, null behavior, semantic scope, breaking changes, and migration decisions.

**Intended route:** `.agents/ROUTING.md` routes creation or material change of one public dimension or fact here. Planned source-to-mart implementation invokes this skill through `building-governed-source-to-mart`; approved semantic work routes to `authoring-governed-metrics`; material completed work hands off to `reviewing-governed-dbt-changes`. Routing already contains this route, so no routing edit is required.

Review this skill after a public grain or contract defect, breaking consumer change, semantic inconsistency, incorrect type or column order, missed relationship or accepted-values failure, calculation or unit defect, repeated prompt-back, review finding, materialization/cost issue, project convention change, dbt/platform change, or overlap with adjacent skills. Merge or retire it if its trigger stops being distinct.
