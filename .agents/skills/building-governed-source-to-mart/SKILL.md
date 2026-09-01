# Build an approved governed source-to-mart slice

Use this skill when an approved source-to-mart build specification is ready to be implemented across staging, intermediate, and mart layers.

## Trigger and goal

Trigger this skill only after `planning-governed-source-to-mart` has produced an approved project-owned spec. For the Merlin & Co. workshop, the expected spec is `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` and the target root is `models/wizard/`.

The goal is to implement exactly the approved model inventory, lineage, SQL output contract, properties YAML, tests, and mart contracts; validate the result against warehouse data; and update only the spec's `verification` section.

## Non-goals

- Do not create, reinterpret, or approve the plan.
- Do not add plausible models, columns, tests, metrics, or cleanup outside the approved spec.
- Do not edit completed starter-state models, the Warlock baseline, or facilitator-only assets.
- Do not use `models/answer_key/` or `training_assets/reference/` as implementation input.
- Do not create a second plan, checklist, review document, or test-results Markdown file.
- Do not deploy, merge, trigger production jobs, or change production data.

## Required context and evidence

Before implementation, inspect:

- `AGENTS.md`, `SECURITY.md`, and `dbt_project.yml`.
- The project-owned build spec named by the user or routed planning workflow.
- The current contents of the spec's target root.
- The three implementation skills:
  - `authoring-staging-models`
  - `authoring-intermediate-models`
  - `authoring-governed-marts`
- Source declarations, macros, and representative completed project models named by the spec or layer skills.
- Warehouse evidence required by the spec's acceptance checks.

The approved spec controls **what** is built. Layer skills control **how** each layer is implemented and validated. If they conflict materially, stop and route back to planning; do not choose one silently.

## Approval and readiness gate

Do not write implementation files until all of the following are true:

- `plan.status` is `approved`.
- `plan.approval.approved_by` and approval evidence are populated.
- Every required decision has `status: approved` and a non-null approved value.
- Target paths are configured, project-owned, and inside the approved target root.
- Models are listed once in dependency order with unique names and paths.
- Every model defines grain, key, inputs, output columns, properties, and acceptance checks.
- Public marts have enforced contracts and complete data types.
- Validation defines a scoped build selector and structural/data checks.
- `verification.status` is `not_run`.
- All three layer skills exist and are available.

If a gate fails, report the exact missing or contradictory field and stop. Use the planning skill to revise and reapprove material design.

## Workflow

### 1. Lock scope and inspect current state

Summarize the approved products, model count by layer, lineage, public interfaces, decisions, and deferred scope. Inspect the target root for existing SQL/YAML. Preserve matching work, flag unplanned files, and never delete or overwrite unexplained user changes.

Do not reopen approved decisions merely because another design is plausible.

### 2. Implement staging

Load and follow `authoring-staging-models`. Build only the staging entries in the approved spec, in listed order.

For each model:

- use the exact name, path, source input, materialization, grain, and ordered output columns;
- implement only approved casts, renames, cleanup, and macro calls;
- create or update the planned shared properties file with the exact model entries, columns, tests, and arguments;
- preserve one-source, no-join, no-grain-change behavior;
- run the layer's specified parse/build and acceptance checks before proceeding.

Stop on a source-schema contradiction, unapproved value mapping, row loss, key failure, or properties mismatch.

### 3. Implement intermediate

Load and follow `authoring-intermediate-models`. Build only the intermediate entries in listed order.

For each model:

- use the exact refs, grain, join contracts, retention behavior, aggregation rules, and ordered outputs;
- preserve ephemeral materialization;
- prove input cardinality and fanout controls with warehouse evidence;
- create or update the planned properties entries exactly;
- validate grain, retention, null behavior, and arithmetic before proceeding.

Stop if joins cannot support the approved grain or if implementation would require changing an approved decision.

### 4. Implement marts

Load and follow `authoring-governed-marts`. Build only the mart entries in listed order.

For each mart:

- use the exact approved upstream ref and public output order;
- keep transformations limited to approved public casts and derivations;
- align every SQL cast with the properties `data_type`;
- enforce the contract and reproduce the exact planned tests and arguments;
- assess only the approved semantic scope and leave deferred concepts untouched.

Stop on any unapproved public-interface, contract, or semantic change.

### 5. Verify the complete slice

After all files are grounded and parsed:

1. Run `dbt ls` for the target root and compare exact model names, paths, materializations, and dependencies with the spec.
2. Compare every SQL final output with ordered `output_columns`.
3. Compare every properties entry, column, data type, test, and argument with `properties` and `contract`.
4. Run the exact scoped `dbt build` selector from `validation.build_selector`; widen only when a required ancestor is missing, never to the whole project by default.
5. Run the spec's warehouse-backed acceptance and data checks against the newly built development relations.
6. Confirm model counts by layer and reject unplanned models, columns, lineage, or tests where the spec requires rejection.

A parse or compile alone is not completion evidence.

### 6. Record verification and hand off

Update only the spec's `verification` section with:

- completion status and timestamp;
- parse/build commands, status, and invocation identifier when available;
- concise structural-check findings;
- concise data-check findings;
- approved deviations, if any;
- `ready_for_review`.

Set `verification.status: passed` and `ready_for_review: true` only when the implementation exactly satisfies all required structural, YAML, build, and data checks. Otherwise set the status to `failed`, record the evidence, and stop.

Return a concise summary of files created, model counts, validation, deviations, and the review handoff. Do not create a separate evidence document.

## Prompt-back conditions

Stop and ask for focused human action when:

- the approved spec is missing, draft, incomplete, or internally contradictory;
- a required layer skill is unavailable;
- source or warehouse evidence contradicts an approved grain, join, value mapping, null policy, or formula;
- target files contain unexplained or unplanned work;
- implementation requires changing a public interface, semantic meaning, materialization, or cost posture;
- required validation cannot be executed or fails for reasons the approved implementation cannot resolve.

Explain the evidence and route material design changes back through `planning-governed-source-to-mart` for reapproval.

## Validation and completion evidence

The build is complete only when:

- the exact approved number of staging, intermediate, and mart models exists under the target root;
- parsed dependencies match the spec inputs;
- SQL outputs and properties YAML match the approved contracts;
- all scoped builds, tests, contracts, and acceptance checks pass;
- no unplanned models, columns, tests, metrics, or lineage were introduced;
- the spec's verification section is complete and marked passed;
- the implementation is ready for the governed review skill.

## References

The approved project-owned build spec is the implementation contract. Do not substitute the generic template, facilitator reference, or answer key.

## Ownership and maintenance

The analytics engineering owner maintains this orchestration skill. Layer-skill owners maintain implementation guidance; domain and metric owners retain authority over approved meaning. Revisit this skill when builds bypass approval, drift from specs, duplicate evidence, or fail to compose the layer skills cleanly.
