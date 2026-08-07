# Onboard a source system

Use this workflow when a new source system—or a material new slice of an existing system—must become trusted dbt data products. This workflow composes reusable layer skills; it does not assume every source table needs every layer.

Use `AGENTS.md`, `SECURITY.md`, and `.agents/workflows/governed-dbt-change.md` throughout.

## Trigger and goal

**Trigger:** a request to add a new source system or build a source-to-target path that creates or materially extends staging, intermediate, marts, and optionally Semantic Layer assets.

**Goal:** produce an approved source-to-target design, governed models at the right layer, public mart contracts/tests/docs, semantic definitions when needed, and validation evidence.

## Non-goals

- Do not use this workflow for a narrow documentation-only change or a single non-material cast.
- Do not create ceremonial intermediate models when a simple one-to-one dimension can project a staging model.
- Do not invent business definitions, source authority, unit conversions, null policy, or metric logic.
- Do not bypass the generic governed-change workflow, review, contracts, tests, or CI.

## 1. Explore the system

1. Read the source declaration/YAML, ERD/data dictionary, source-owner documentation, and analogous completed source slices.
2. Inspect raw/staging data where column presence, values, nulls, key behavior, units, timestamps, or grain matter.
3. Identify source tables, intended business outcomes, consumers, source authority, keys, relationships, raw quirks, and freshness assumptions.
4. Inspect existing marts and semantic definitions for data products or metrics that should be extended instead of duplicated.
5. Record evidence and uncertainty in `.agents/templates/source-to-target-design.md` and the generic change plan.

## 2. Obtain design decisions

1. State the grain for every raw table, intermediate, mart, and proposed semantic asset.
2. Map each raw table to one staging model.
3. Add intermediates only for joins, dedupe, fanout control, aggregation, or grain change.
4. Design each public mart with one upstream model whenever possible.
5. Identify contract types, data tests, descriptions, Semantic Layer impact, downstream compatibility, and validation selectors.
6. Ask for human decisions before implementation when a material assumption remains unresolved.

**Required human checkpoint:** approve the source-to-target design, business definitions, grains, unit/null policies, public-interface impact, and validation scope.

## 3. Invoke only the required layer skills

| Need | Invoke |
|---|---|
| Every raw table to be modeled | `.agents/skills/authoring-staging-models/SKILL.md` |
| Join, dedupe, fanout control, aggregation, or grain change | `.agents/skills/authoring-intermediate-models/SKILL.md` |
| Public dimension or fact | `.agents/skills/authoring-governed-marts/SKILL.md` |
| Governed entity, dimension, measure, or metric | `.agents/skills/authoring-governed-metrics/SKILL.md` |

Implement in dependency order. Keep changes small and reviewable. Preserve existing public interfaces unless an approved migration path exists.

## 4. Verify and hand off

1. Build and test new staging/intermediate/mart paths with selectors that include necessary ancestors and affected dependents.
2. Run SQLFluff on changed SQL.
3. Inspect source and output data for grain, row counts, nulls, categorical normalization, and join/fanout behavior.
4. Validate contract and Semantic Layer behavior when applicable.
5. Record evidence, plan deviations, and follow-up in the design template, change plan, and PR template.
6. Route the result through the review skill and required owners.

## Prompt-back conditions

Stop and ask for a decision when any of the following is unresolved:

- source system of record, freshness expectation, key, or raw-table grain;
- staging cleanup policy, especially unit conversion, null handling, categorical normalization, or timestamp interpretation;
- intermediate join cardinality, dedupe strategy, or fanout control;
- mart grain, public contract, consumer impact, or relationship semantics;
- semantic definition, aggregation, time semantics, or conflict with an existing metric;
- data classification, access, deployment, cost, or performance tradeoff.

A prompt-back must state the decision, evidence inspected, viable options/implications, and the narrowest question needed to proceed.

## Completion evidence

The onboarding is complete when:

- the source-to-target design and material decisions are approved;
- every new model has a stated, validated grain;
- staging, intermediate, and marts comply with their respective layer rules;
- new marts have contracts, tests, and descriptions;
- semantic changes are governed and validated where applicable;
- scoped dbt builds and SQLFluff pass; and
- review/PR evidence documents decisions, validation, ownership, and follow-up.

## Ownership and maintenance

**Primary owner:** `TODO(owner: analytics engineering)`.

Review after a source-onboarding incident, repeated modeling/review failure, changed project layering convention, new source type, or platform capability change.
