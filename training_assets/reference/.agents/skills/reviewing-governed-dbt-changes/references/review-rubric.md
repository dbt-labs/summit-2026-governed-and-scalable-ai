# Governed dbt change review rubric

Use this rubric after Wizard’s native dbt review to apply team-specific policy and evidence requirements. Review the smallest relevant scope, but never skip an item that the diff or plan makes applicable.

## Required review evidence

Before approving a material change, inspect:

- [ ] Request, diff, changed files, and affected public interfaces.
- [ ] Approved change plan and source-to-target design when applicable.
- [ ] Relevant project policy, routed skills/checklists, upstream SQL/YAML, and downstream lineage.
- [ ] Contracts, tests, semantic definitions, macros, and consumer impact.
- [ ] Build/test/parse, SQLFluff, semantic validation, CI, and data-check evidence appropriate to the change.

Missing evidence is not automatically a code defect; classify it as **needs human decision** when a decision/approval is missing or **must fix before merge** when required validation or governance control has not occurred.

## Review dimensions

### 1. Intent, scope, and decision record

- [ ] The request and business outcome are clear.
- [ ] Material work has an approved plan; source onboarding also has an approved source-to-target design.
- [ ] The implementation matches approved grain, transformations, business rules, and acceptance criteria.
- [ ] Deviations are documented and approved.
- [ ] Unresolved assumptions have an accountable owner rather than being embedded in code.

### 2. Layer fit, grain, and lineage

- [ ] Staging reads one `source()`, preserves raw grain, and performs only cleanup/casting/conformance.
- [ ] Intermediate owns joins, aggregation, dedupe, fanout control, and grain changes.
- [ ] A simple 1:1 dimension may project staging; a mart with multi-input transformation logic consumes a named intermediate.
- [ ] Every changed output has a stated grain and grounded key.
- [ ] Join cardinality, record retention, fanout prevention, and nulls from joins are intentional and evidenced.

### 3. Correctness and maintainability

- [ ] Referenced source/ref columns exist and are grounded in actual upstream SQL/YAML/data.
- [ ] Existing macros handle recurring cleanup; logic is not reimplemented inline.
- [ ] Naming, casts, money fields, booleans, timestamps, categoricals, CTE structure, and materialization match project policy.
- [ ] Unaffected columns and public interfaces are preserved.
- [ ] The change is focused; unrelated refactors are not hidden in the diff.

### 4. Public data products and semantics

- [ ] Marts state purpose and grain, use appropriate upstream inputs, and expose only intentional public columns.
- [ ] Every mart contract is enforced; every public column has a type and matching SQL cast.
- [ ] PK, FK, categorical, required-field, and transformation-risk tests are present and grounded.
- [ ] Model and key-column descriptions are present and meaningful.
- [ ] Semantic entities, dimensions, measures, and metrics reuse existing definitions or follow the semantic skill with owner approval.
- [ ] Breaking contract, type, grain, entity, or metric changes include consumer impact and a migration/deprecation path.

### 5. Validation, risk, and operational readiness

- [ ] The scoped `dbt build` selector exercises changed SQL and relevant dependencies/dependents.
- [ ] SQLFluff ran on changed SQL.
- [ ] Parse, semantic, contract, test, CI, and output/data checks match the change’s risk and acceptance criteria.
- [ ] Failures are addressed or explicitly escalated; they are not explained away.
- [ ] Security, classification, access, performance, cost, freshness, materialization, deployment, and rollback impacts are assessed when applicable.

## Finding categories

### Must fix before merge

Use when the implementation or required verification demonstrably violates approved policy or creates an unmitigated correctness, safety, or public-interface risk.

Examples:

- A staging model joins another model, changes raw grain, or introduces business aggregation.
- A mart contains a join/rollup that should be in intermediate, creating unproven fanout risk.
- A public mart lacks an enforced contract, type/cast alignment, mandatory tests, or a required description.
- A `ref()`/`source()` is invalid, a column is unsupported, or a join produces duplicate PKs.
- A semantic definition duplicates a governed metric or changes a public meaning without an approved migration.
- Required scoped build, contract/test, lint, or CI evidence is failing or absent.
- The change exposes secrets/restricted data or bypasses required review/controls.

**Required finding format:** `Must fix — [file/asset]: [concrete defect]. Evidence: [inspection/result]. Impact: [why it matters]. Required action: [specific remediation and revalidation].`

### Needs human decision

Use when the implementation cannot be judged correct because a material business, ownership, risk, or public-interface decision is unresolved. Do not infer the answer.

Examples:

- Grain, join cardinality, source authority, record-retention policy, or fanout strategy is undocumented.
- Unit conversion, null handling, category mapping, time zone, metric aggregation, or revenue/cost/margin definition lacks owner approval.
- A contract or semantic interface changes but consumers/migration path are unknown.
- A material performance, cost, freshness, materialization, data-classification, or deployment tradeoff has no owner decision.

**Required finding format:** `Decision needed — [topic]: Evidence inspected: [facts]. Options/implications: [concise options]. Owner: [role]. Question: [narrowest decision required].`

### Suggestion

Use for a non-blocking improvement that does not change approved business meaning, public interfaces, or required controls.

Examples:

- A clearer CTE/model description, more targeted non-mandatory test, or readability improvement.
- A follow-up to reduce duplication after correctness and governance requirements are satisfied.

**Required finding format:** `Suggestion — [file/asset]: [improvement]. Benefit: [maintainability/readability/observability].`

## Review outcome

- **Approve:** no unresolved must-fix or decision findings; required evidence and owners are present.
- **Approve with follow-up:** no must-fix or decision findings; suggestions and explicitly owned post-merge work are recorded.
- **Request changes:** one or more must-fix findings require remediation and re-review.
- **Blocked pending decision:** an accountable owner must resolve a material decision before the change can be evaluated or merged.

AI review is advisory. Contracts, tests, CI, required code-owner approval, and accountable human decisions remain independent merge controls.
