# Governed dbt change workflow

Use this workflow for a material dbt change: a new or changed data product, source wiring, model logic, contract, data test, semantic definition, macro, or configuration with downstream impact. It ensures the team agrees on intent before implementation and captures evidence after verification.

`AGENTS.md` supplies always-on project rules. Use `.agents/ROUTING.md` to add the primary task skill.

## Phase 1 — Explore

**Purpose:** replace plausible assumptions with project evidence.

Required actions:

- Identify the requested business outcome and affected consumers.
- Read the relevant project docs, source/model SQL, properties YAML, macros, and existing patterns.
- Inspect upstream/downstream lineage and public interfaces.
- Profile relevant source/model data when the task depends on actual columns, values, null behavior, or grain.
- Identify the authoritative source and existing governed metric/data-product definitions.

**Output:** a concise evidence list and a list of unresolved assumptions.

**Stop and prompt back** if grain, source authority, business rules, metric meaning, interface impact, data sensitivity, or material performance tradeoffs remain unresolved.

## Phase 2 — Plan

**Purpose:** obtain human agreement on design before generating implementation.

Required actions:

- Complete `.agents/templates/dbt-change-plan.md`.
- State the grain of each target model and expected join cardinality.
- State the layer placement, transformations, macro reuse, contract/test/documentation impact, and semantic/downstream impact.
- Name acceptance criteria and the exact validation selectors.
- Present explicit decision points and options rather than silently choosing business logic.

**Human checkpoint:** an authorized human approves material business definitions, grain, assumptions, public-interface changes, and validation scope.

**Output:** approved plan or a focused prompt-back.

## Phase 3 — Implement

**Purpose:** make the smallest reviewable change that satisfies the approved plan.

Required actions:

- Follow the routed skill and `AGENTS.md` layer rules.
- Use `source()` and `ref()`; preserve unaffected columns and interfaces.
- Reuse shared macros instead of duplicating known cleanup logic.
- Add contracts, tests, descriptions, and semantic changes required by the plan.
- Keep edits small and logically grouped. Do not hide unrelated refactors in an AI-assisted change.

**Execution boundary:** do not bypass tests/contracts/CI or perform destructive or production-impacting actions without explicit approval.

**Output:** reviewable diff with a clear mapping to the approved plan.

## Phase 4 — Verify

**Purpose:** prove the change works and meets the agreed acceptance criteria.

Required actions:

- Run the planned dbt validation. For changed SQL models, prefer a scoped `dbt build --select +<model>+`; widen the selector when the change affects ancestors, macros, or downstream dependents.
- Run SQLFluff on changed SQL.
- Inspect material results: grain, row counts, nulls, categorical values, joins, contract alignment, and metric behavior as applicable.
- Confirm test/contract results and capture errors rather than explaining them away.
- Complete the verification evidence section of the plan and PR template.

**Output:** validation evidence, remaining limitations/follow-up, and a review-ready summary.

## Review and handoff

Before merge or deployment:

- Use the review skill and PR template to verify the implementation, plan, and evidence agree.
- Ensure required owners review governance assets, semantic definitions, contracts, and CI changes.
- Confirm the CI/CD path appropriate to the environment has run or is explicitly queued.
- Preserve human accountability: AI assistance is declared; human approvers own the decision.

## Escalate instead of proceeding

Stop and escalate through the documented owner when:

- the request changes a public contract or consumer interface without an approved migration path;
- business logic or metric definitions conflict;
- data classification, access, or tool approval is unclear;
- validation exposes a failure outside the approved change scope;
- a production action, retry, or remediation could change data or availability;
- the required evidence cannot be obtained.
