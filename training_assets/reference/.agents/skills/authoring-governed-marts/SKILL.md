# Author governed marts

Use this skill when creating or materially changing a public dimension or fact that consumers, BI tools, the Semantic Layer, or AI-assisted analytics can trust.

## Trigger and goal

**Trigger:** a new or changed `dim_`/`fct_` data product is needed, including its public schema, contract, tests, documentation, and consumer/semantic impact.

**Goal:** create a readable, stable public mart with a stated grain, a simple upstream dependency, explicit contract-aligned casts, complete data-quality tests, descriptions, and scoped validation evidence.

## Non-goals

- Do not put raw cleanup in a mart; that belongs in staging.
- Do not put joins, aggregation, dedupe, fanout control, or grain changes in a mart. Route that logic through a named intermediate model.
- Do not create a competing business metric or semantic definition; route it to the Semantic Layer skill.
- Do not change a public interface without assessing consumers and obtaining an approved migration path.

## Required context and evidence

Inspect before implementation:

- `AGENTS.md`, governed-change workflow, change plan, and source-to-target design.
- The immediate upstream model’s SQL/YAML, grain, keys, and available columns.
- Analogous dimensions/facts and their contracts/tests.
- Downstream lineage, semantic definitions, consumer documentation, and existing public-interface expectations.
- Data profiles needed to validate output grain, keys, relationships, required measures, and categoricals.

## Workflow

1. State the mart’s business purpose and grain: “one row per …”.
2. Confirm the upstream design is layer-correct. Use one upstream model whenever possible:
   - a simple one-to-one dimension may project one staging model;
   - a mart requiring joins, aggregation, dedupe, fanout control, or grain change must consume a named intermediate.
3. Define the public columns, PK/FKs, required measures, categoricals, types, descriptions, and consumer/semantic impact before editing SQL.
4. Create a `dim_` or `fct_` model with an import CTE, a final CTE, and explicit casts for every public column.
5. Add or update the enforced contract in the mart properties YAML. Declare `data_type` for every column and make SQL casts match exactly.
6. Add tests: `unique` + `not_null` for each PK; `relationships` for each FK; `accepted_values` for normalized categoricals; `not_null` for required measures/fields.
7. Assess whether a semantic entity, dimension, measure, or metric must be added or changed. Route that work when applicable.
8. Check downstream compatibility. Preserve unaffected columns, names, types, and grain unless a human-approved migration is in place.
9. Validate the mart’s data and contract using the planned scoped build and output checks.

## Prompt-back conditions

Stop and ask when:

- mart grain, PK, FK, required measure, consumer, or business purpose is unclear;
- the proposed mart needs a join or aggregation but no intermediate design exists;
- the public schema, data type, semantic entity, or metric change could break consumers;
- relationship semantics, categorical values, null policy, or required field behavior are not grounded;
- a request duplicates or conflicts with a governed metric;
- material performance, materialization, access, or deployment decisions are unresolved.

## Validation and completion evidence

Completion requires:

- a stated, validated grain and clear public purpose;
- a layer-correct upstream dependency and no transformation logic that belongs in intermediate;
- enforced contract with every public column typed and explicitly cast in SQL;
- required tests and model/key-column descriptions;
- `dbt build --select +<mart>+` passing, including contract and data tests;
- SQLFluff passing for changed SQL;
- output checks for grain, keys, FK coverage, categoricals, nulls, and required measures;
- a consumer/semantic impact assessment; and
- recorded decisions, validation, and follow-up in the plan and PR evidence.

## References

Use `references/mart-contract-and-test-checklist.md` before review.

## Ownership and maintenance

**Primary owner:** `TODO(owner: analytics engineering/data product owner)`.

Review after a contract/test failure, consumer incident, metric-definition conflict, breaking-change request, or repeated review finding.
