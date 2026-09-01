# Build an approved governed source-to-mart slice

Use this skill when an approved project-owned source-to-mart build specification is ready for implementation across staging, intermediate, and mart layers.

## Trigger and goal

Trigger this skill only after `planning-governed-source-to-mart` has produced an approved active spec and the required staging, intermediate, and mart execution skills exist. For the Merlin & Co. exercise, the expected spec is `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` and the target root is `models/wizard/`.

The goal is to implement exactly the approved model inventory, lineage, ordered SQL outputs, properties, tests, and contracts; prove behavior with scoped dbt execution and warehouse checks; update only the spec's `verification` section; and hand a truthful result to governed review.

## Non-goals

- Do not create, reinterpret, amend, or approve the design.
- Do not add plausible models, columns, tests, metrics, mappings, cleanup, formulas, or lineage outside the approved spec.
- Do not use `models/answer_key/`, `training_assets/reference/`, a generic template, or another facilitator asset as implementation input.
- Do not edit completed starter models, the Warlock baseline, unrelated files, generated files, or vendored packages.
- Do not create a second plan, source-to-target document, checklist, review file, or validation report.
- Do not silently delete or overwrite unexplained target-root work.
- Do not deploy, merge, trigger production jobs, mutate production data, or bypass tests, contracts, lint, CI, review, or approval controls.

## Required context and evidence

Before implementation, inspect:

- `AGENTS.md`, `SECURITY.md`, `.agents/ROUTING.md`, and `dbt_project.yml`;
- the active project-owned spec named by the user or routed planning workflow;
- the current contents and git state of the spec's target root;
- the active `authoring-staging-models`, `authoring-intermediate-models`, and `authoring-governed-marts` skills;
- source declarations, macros, and representative completed project-owned patterns allowed by policy;
- actual source/input columns and warehouse evidence required by model acceptance checks;
- the prior `verification` findings and current target files when resuming a failed attempt.

The approved spec controls **what** is built. Layer skills control **how** each layer is implemented and validated. `AGENTS.md` and `SECURITY.md` remain always-on boundaries. Stop on a material conflict instead of choosing an authority silently.

## Output invariants

The completed orchestration must:

- create or update only the exact SQL and properties paths listed in the approved spec plus that spec's `verification` section;
- produce exactly the approved model count, names, paths, materializations, dependencies, grains, keys, transformations, and ordered output columns;
- reproduce exact approved properties descriptions, column entries, data types, tests, test arguments, contracts, and semantic scope;
- preserve staging source grain and retention, intermediate join/fanout controls, and mart public interfaces;
- introduce no unplanned model, column, dependency, test, metric, semantic object, or persistent artifact;
- use only active project evidence and active skills, never facilitator or answer-key content;
- execute ephemeral intermediates through the approved materialized downstream build and validate their output directly when needed;
- keep verification status truthful: readiness failures leave it unchanged, started attempts become `in_progress`, execution/acceptance failures become `failed`, and only complete success becomes `passed` with `ready_for_review: true`;
- preserve partial explainable work after failure so a later attempt can inspect and resume it safely rather than recreating or deleting it blindly.

## Approval and readiness gate

Do not edit implementation files or verification until all applicable gate checks pass:

- the spec path is active and project-owned, outside facilitator/reference paths;
- `plan.status` is `approved`;
- `plan.approval.approved_by` and approval evidence are populated;
- `plan.pre_approval_validation.status` is `passed`, `checked_at` and `checked_by` are populated, every fixed coherence check is `passed`, `findings` contains concise evidence, and `unresolved` is empty;
- every listed decision has `status: approved`, a non-null approved value, an owner, and rationale;
- the approved target root is configured, project-owned, and allowed by `AGENTS.md`;
- model names and paths are unique and listed in executable dependency order;
- every model defines layer, path, properties path, materialization, grain/key, inputs, implementation behavior, ordered outputs, properties, contract state, and acceptance checks;
- every public mart has an enforced contract and a data type for every public column;
- validation defines a bounded build selector, structural rejection rules, and warehouse-backed data checks;
- semantic scope and deferred scope are explicit;
- all three active layer skills exist and are readable;
- target-root files are absent, match the spec, or are explainable work from the same attempt;
- `verification.status` is `not_run` or `failed`.

If verification is already `passed`, stop unless the user explicitly requests revalidation of the same approved scope. If verification is `failed`, inspect its findings and current files before resuming; stop if they belong to another scope or contain unexplained changes.

A gate failure must identify the exact field, file, skill, or contradiction and the route that can resolve it. Readiness failures do not modify the spec or implementation.

## Workflow

### 1. Lock scope and start the attempt

Summarize approved products, model count by layer, lineage, public interfaces, human decisions, deferred scope, validation selector, and target-root state. Do not reopen approved decisions merely because another design is plausible.

After every readiness check passes, set only `verification.status` to `in_progress`, set `ready_for_review: false`, and preserve prior failed findings until replaced by current evidence.

### 2. Implement staging

Load and follow `authoring-staging-models`. Implement all staging entries in approved dependency order:

- use exact paths, one approved `source()` input, configured materialization, grain, and ordered outputs;
- apply only approved renames, casts, normalization, and macro calls;
- create or update the planned properties entries with exact descriptions, columns, tests, and arguments;
- ground source columns, key behavior, castability, categorical domains, and row-retention expectations with warehouse evidence;
- parse after the layer SQL/YAML is complete and compare source/output structure with the spec.

Reserve the spec's slice-wide build selector for complete-slice verification after all planned nodes exist. Stop on source-schema contradiction, unapproved mapping, impossible cast, row loss, key failure, or properties mismatch.

### 3. Implement intermediate

Load and follow `authoring-intermediate-models`. Implement all intermediate entries in approved dependency order:

- use exact refs, input/output grains, keys, join conditions, cardinalities, join types, retention, fanout controls, aggregation groups, formulas, and ordered outputs;
- preserve configured ephemeral materialization;
- profile input keys, duplicate distributions, match rates, nulls, units, and control totals before trusting the joins;
- create or update exact planned properties entries;
- parse and use direct development previews to validate grain, retention, fanout, null behavior, and arithmetic before marts are created.

Build-based intermediate completion remains pending until the approved materialized downstream mart executes the ephemeral SQL. Stop if observed evidence cannot support the approved design.

### 4. Implement marts

Load and follow `authoring-governed-marts`. Implement all mart entries in approved dependency order:

- use the exact simplest upstream ref and public grain/key;
- publish only approved columns in exact order through explicit contract-aligned casts;
- keep logic limited to approved projections and small approved derivations;
- enforce contracts and reproduce exact descriptions, data types, tests, and arguments;
- preserve approved semantic scope and leave deferred semantic work untouched;
- parse after all mart SQL/YAML is complete and reject any contract/output mismatch before warehouse build.

Stop on an unapproved public column, type, derivation, dependency, contract, semantic change, or consumer-impact decision.

### 5. Verify the complete slice

After all planned files exist and parse:

1. Run a project listing scoped to the target root and compare exact model count, names, paths, materializations, and dependencies with the spec.
2. Compare each final CTE's ordered columns with `output_columns` and reject `select *` from sources/upstream refs.
3. Compare every properties entry, description, column, data type, test, argument, and contract with the spec.
4. Run project-required SQL lint or the supported CI lint path for all changed SQL.
5. Run the exact bounded selector from `validation.build_selector` once as the complete-slice build. Pass selector tokens safely through the dbt command tool; widen only for a genuinely missing required ancestor and record the reason.
6. Confirm the build executed every planned staging model, both contracted marts, attached tests/contracts, and all intermediate SQL through downstream materialization.
7. Run the spec's warehouse acceptance checks against the built development relations, including grain, retention, match rates, fanout, nulls, accepted values, relationships, units, and arithmetic controls.
8. Enforce every structural rejection flag and confirm no unplanned model, column, test, lineage, or semantic object exists.

A parse, compile, generated file, plausible query result, or partial build is not completion evidence. Do not claim lint, comparison, CI, or warehouse checks passed when the environment cannot execute or prove them.

### 6. Record verification and hand off

Update only the existing `verification` structure with current evidence:

- final status and completion timestamp;
- parse and build commands, statuses, and invocation identifier when available;
- concise structural findings;
- concise warehouse/data findings;
- non-design execution deviations such as an approved selector widening, with rationale and authority;
- `ready_for_review`.

A change to model inventory, lineage, formula, grain, public interface, tests, contract, semantic meaning, materialization, or cost posture is a design change, not a verification deviation. Return it to planning and require reapproval.

Set `verification.status: passed` and `ready_for_review: true` only when every required structural, YAML, build, lint, contract/test, and warehouse check succeeds. On a started attempt that cannot complete, set `status: failed`, keep `ready_for_review: false`, record concise findings and successful evidence already obtained, preserve explainable partial files, and stop.

Return a concise summary of files changed, exact model counts, build/lint/test/warehouse results, deviations, verification state, and governed-review handoff. Create no separate evidence artifact.

## Prompt-back conditions

Stop and ask for focused human action when:

- the active spec is missing, draft, incomplete, internally contradictory, or already passed without an explicit revalidation request;
- approval, owner, rationale, required decision, semantic scope, validation, or target-root evidence is missing;
- a required active layer skill is unavailable or conflicts materially with the approved spec;
- source/input columns or warehouse evidence contradict approved grain, key, join, retention, mapping, null policy, unit treatment, formula, test, or contract;
- target files contain unexplained or out-of-scope work;
- implementation requires a material design, public-interface, semantic, materialization, performance, or cost change;
- required execution or acceptance evidence cannot be obtained or a failure cannot be resolved within the approved design;
- a security, permission, production, or action-authority boundary is unclear.

State the evidence, affected spec field or file, options and implications, recommendation when supportable, accountable owner, and narrowest question. Route material design changes through `planning-governed-source-to-mart` for reapproval.

## Validation and completion evidence

The source-to-mart build is complete only when:

- readiness passed and the exact approved files/models exist under the target root;
- parsed dependencies, materializations, SQL outputs, properties, tests, contracts, and semantic scope match the spec;
- one complete-slice scoped build executes all planned SQL and every applicable test/contract successfully;
- required lint and warehouse acceptance checks pass;
- intermediate grain, retention, fanout controls, and arithmetic are proven through previews and downstream execution;
- no unplanned model, column, test, metric, semantic object, lineage, or persistent artifact was introduced;
- only the spec's `verification` section changed outside approved implementation files;
- verification is `passed`, findings are current, deviations are non-design and approved, and `ready_for_review` is true;
- the implementation is handed to `reviewing-governed-dbt-changes`.

Failure of any required condition leaves the build incomplete and verification failed or unchanged according to whether execution began.

## Behavioral acceptance

**Scenario:** An active approved spec defines four staging models, two ephemeral intermediates, two contracted marts, exact tests and ordered outputs, no semantic extension, and one bounded build selector. All three active layer skills exist, but one source profile reveals a value outside an approved accepted-values domain.

Expected behavior:

- pass the static readiness checks without inspecting facilitator references;
- begin verification and implement only spec-listed files in dependency order;
- detect the source/spec contradiction before silently widening the accepted-values test;
- set verification to failed with `ready_for_review: false` if the attempt had started, preserve explainable partial files, and route the categorical decision back to planning;
- after reapproval, resume by inspecting prior findings and current files, then complete one slice-wide build and all warehouse checks;
- set verification passed only when exact scope, tests, contracts, lint, and data behavior all succeed.

The scenario fails if the orchestrator invents a mapping, changes the test, uses facilitator assets, creates another report, reruns expensive builds unnecessarily, cannot resume a failed attempt, or marks partial evidence as passed.

## Ownership and maintenance

Analytics engineering owns orchestration behavior. Layer-skill owners own task execution guidance; data-product and metric owners retain authority over business meaning and public interfaces. Review this skill after readiness bypasses, partial-build recovery failures, spec drift, duplicate warehouse execution, missed acceptance defects, or changes to the planning, layer, review, dbt, or platform contract.
