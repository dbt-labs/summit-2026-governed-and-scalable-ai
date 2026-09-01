# Governed dbt change review rubric

Use this rubric after Wizard's native dbt review to apply project-specific authority, layer, decision, and evidence requirements. Review the smallest relevant scope without skipping an item made applicable by the diff or approved artifact.

## Required review evidence

Before approving a material change, inspect:

- [ ] Request, diff, changed files, target/base context, and affected public or semantic interfaces.
- [ ] Applicable approved project-owned artifact; for governed source-to-mart work, the approved build spec and completed `verification` section.
- [ ] Relevant project policy, routed skills, upstream SQL/YAML, source/ref columns, and downstream lineage.
- [ ] Contracts, tests, semantic definitions, macros, consumers, and migration requirements.
- [ ] Build/test/parse, contract, lint, semantic, comparison, CI, and warehouse-check evidence appropriate to the change.

Missing approval is **needs human decision**. Missing or failed required implementation/validation evidence is **must fix before merge**.

## Review dimensions

### 1. Intent, scope, and approval

- [ ] The request, business outcome, materiality, and accountable owners are clear.
- [ ] Governed source-to-mart work has an approved project-owned build spec; other material work has the approved artifact required by its route.
- [ ] Exact model inventory, paths, materializations, lineage, grains, keys, ordered outputs, transformations, tests, contracts, and semantic scope match the approved artifact.
- [ ] Deviations are explicitly approved and recorded in the approved artifact rather than hidden in code or review prose.
- [ ] Unresolved assumptions have an accountable owner and block approval.

### 2. Layer fit, grain, and lineage

- [ ] Staging reads one declared `source()`, preserves source grain and retention, and performs only approved cleanup/casting/normalization.
- [ ] Intermediate owns joins, aggregation, deduplication, enrichment, fanout control, and grain changes.
- [ ] A mart uses the simplest approved upstream input and contains no unplanned multi-input or grain-changing logic.
- [ ] Every changed output has an explicit approved grain and grounded key.
- [ ] Join cardinality, record retention, fanout prevention, deterministic ordering, and join-produced nulls are intentional and evidenced.

### 3. Correctness and maintainability

- [ ] Referenced source/ref columns exist and are grounded in actual upstream SQL/YAML and warehouse evidence.
- [ ] Existing macros handle approved recurring cleanup; logic is not duplicated or changed without evidence.
- [ ] Naming, explicit casts, money fields, booleans, timestamps, categoricals, CTE structure, and materializations match policy and the approved artifact.
- [ ] Unaffected columns and public interfaces are preserved.
- [ ] No unrelated refactor, model, column, test, dependency, or business rule is hidden in the diff.

### 4. Public data products and semantics

- [ ] Marts state purpose and grain and expose exactly the approved public columns in order.
- [ ] Every mart contract is enforced; every public column has a matching properties `data_type` and explicit SQL cast.
- [ ] PK, FK, categorical, required-field, composite-grain, and transformation-risk tests exactly match approved requirements.
- [ ] Model and material column descriptions accurately state meaning, units, nullability, calculation basis, and limitations.
- [ ] Semantic entities, dimensions, measures, and metrics reuse existing definitions or follow their routed skill with owner approval.
- [ ] Breaking contract, type, grain, behavior, entity, or metric changes include consumer impact and an approved migration/deprecation path.

### 5. Verification, risk, and readiness

- [ ] The approved scoped `dbt build` selector executed changed SQL and applicable dependencies/dependents.
- [ ] Parse, tests, contracts, and project-required SQL lint or CI lint passed.
- [ ] Warehouse checks prove approved grain, retention, key behavior, cardinality, accepted values, null treatment, units, and arithmetic.
- [ ] Semantic validation and representative governed results exist when semantic behavior changed.
- [ ] Production comparison covers material output changes when a valid baseline is available.
- [ ] The build spec's `verification` status, commands, findings, deviations, and `ready_for_review` value agree with observed evidence.
- [ ] Security, classification, access, performance, cost, freshness, materialization, deployment, and rollback impacts are assessed when applicable.

## Finding categories

### Must fix before merge

Use when implementation or required verification demonstrably violates approved policy/design or creates an unmitigated correctness, safety, or interface risk.

Examples:

- A staging model joins, filters, changes source grain, or introduces business aggregation.
- A mart contains unapproved join/rollup logic or exposes an extra convenience field.
- A public mart lacks contract/type/cast alignment, exact approved tests, or required descriptions.
- A `ref()`/`source()` or column is unsupported, a join produces duplicate keys, or arithmetic fails reconciliation.
- Implementation differs from the approved artifact without an approved recorded deviation.
- Required build, contract/test, lint, comparison, semantic, CI, or warehouse evidence failed or is absent.
- The change exposes secrets/restricted data or bypasses required controls.

**Format:** `Must fix — [file/asset]: [defect]. Evidence: [inspection/result]. Impact: [why it matters]. Required action: [remediation and revalidation].`

### Needs human decision

Use when correctness cannot be judged because a material business, ownership, risk, or interface decision is unresolved. Do not infer the answer.

Examples:

- Grain, source authority, join cardinality, retention, fanout strategy, or deduplication priority is unapproved.
- Unit conversion, null handling, mapping, time semantics, metric aggregation, or cost/revenue meaning lacks owner approval.
- A public or semantic interface changes but consumer and migration treatment are unknown.
- A material performance, cost, freshness, materialization, classification, access, or deployment tradeoff lacks an owner decision.

**Format:** `Decision needed — [topic]. Evidence inspected: [facts]. Options/implications: [concise options]. Owner: [role]. Question: [narrowest decision].`

### Suggestion

Use for a non-blocking improvement that does not alter approved meaning, scope, interfaces, or required controls.

Examples include a clearer CTE name, more useful wording, or separately owned follow-up after correctness and governance requirements are satisfied.

**Format:** `Suggestion — [file/asset]: [improvement]. Benefit: [maintainability/readability/observability].`

## Review outcome

- **Approve:** no unresolved must-fix or decision findings; required evidence and approvals are present.
- **Approve with follow-up:** no must-fix or decision findings; non-blocking work has an owner.
- **Request changes:** one or more must-fix findings require remediation and re-review.
- **Blocked pending decision:** an accountable human must resolve a material decision before approval.

AI review is advisory. Contracts, tests, lint, CI, platform controls, code owners, and accountable human decisions remain independent merge controls.
