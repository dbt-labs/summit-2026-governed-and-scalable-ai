# Author governed semantic definitions — trainee scaffold

Use this skill when adding or materially changing a semantic model, entity, dimension, measure, or metric that analytics consumers or AI-assisted analytics will use.

## Trigger and goal

**Trigger:** a business metric or semantic definition must be added, changed, deprecated, or assessed for reuse.

**Goal:** publish one human-approved semantic definition grounded in a trusted public mart, with its decisions and validation evidence recorded.

## Non-goals

- Do not create a metric merely because a plausible numeric column exists.
- Do not define a competing version of a governed business number in ad hoc SQL or another semantic asset.
- Do not use semantic YAML to settle unresolved business policy.
- Do not use this skill to build the underlying staging, intermediate, or mart transformations.

## Required context and evidence

Before editing semantic configuration:

- inspect `AGENTS.md`, `SECURITY.md`, routing, and the applicable approved project-owned decision artifact;
- search existing metrics and semantic models for a definition to reuse;
- confirm the source mart is public, contracted, tested, and at the required grain; and
- identify the accountable metric or data-product owner.

`TODO(training): Define the complete evidence required for source columns, entities, dimensions, time behavior, consumers, and the project's installed semantic specification.`

## Workflow

1. Discover existing governed definitions before proposing a new one.
2. Ground the business question in one trusted public mart and state its grain.
3. Record unresolved business choices and obtain approval before writing YAML.
4. Implement the smallest compatible semantic change in the project's existing format.
5. Validate the definition and record representative results.

`TODO(training): Expand this workflow to capture aggregation or formula, filters, units and currency, time dimension and time zone, null and late-arriving-data treatment, semantic joins, conflict checks, and consumer impact.`

## Prompt-back conditions

Stop for a focused human decision when the business question, owner, source-of-truth mart, grain, aggregation, filters, units, null policy, time semantics, public-interface impact, or competing definition is unresolved.

`TODO(training): Add the Alembic-specific decision prompts for as-supplied units, standard versus actual cost, duration nulls, and any proposed revenue or margin interpretation.`

## Validation and completion evidence

A technically valid YAML file is not sufficient evidence of completion.

`TODO(training): Define the required parse, Semantic Layer validation, underlying-mart build, representative semantic query, owner approval, and approved-artifact/PR evidence.`

## References

Use `references/metric-definition-checklist.md` while refining and reviewing the definition. Compare the completed workshop result with `training_assets/reference/.agents/skills/authoring-governed-metrics/`.

## Ownership and maintenance

**Primary owner:** `TODO(owner: analytics engineering + metric/data-product owner)`.

Review this skill after a metric incident, definition conflict, consumer migration, semantic-spec change, or repeated prompt-back.
