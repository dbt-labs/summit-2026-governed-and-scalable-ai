# Demo 6 — Build the layering skills

## Summary

Trainees work in small groups to create the missing intermediate and governed-mart skills using the same template and skill-building standard demonstrated in Demo 5.

## Relevant files

- `docs/prompts/skill_building_prompt_template.md`
- `.agents/skills/building-governed-skills/SKILL.md`
- `AGENTS.md`
- `docs/merlinco/STYLE_GUIDE.md`
- representative completed intermediate and mart SQL/YAML
- facilitator prompts under `training_assets/reference/docs/prompts/`
- facilitator skills under `training_assets/reference/.agents/skills/`

## Intermediate decision canvas

- What requests should trigger the skill?
- Where do joins and grain changes belong?
- What must be known about input grain, output grain, and keys?
- How should join cardinality and fanout be handled?
- When is deduplication authorized, and what makes ordering deterministic?
- What record-retention, null, unit, allocation, or formula decisions require approval?
- How are ephemeral models executed through a materialized downstream node?
- What warehouse checks prove grain, retention, match rates, and reconciliation?
- What should cause Wizard to stop?

## Mart decision canvas

- What makes a model a public data product?
- Which grain, key, ordered interface, type, and meaning decisions need approval?
- Which joins and grain-changing transformations belong upstream?
- What should contracts enforce between SQL and properties YAML?
- Which tests are required, and how are values grounded?
- When does a change become breaking, and what migration evidence is needed?
- How should existing consumers and Semantic Layer impact be handled?
- What proves the public interface is trustworthy?
- What should cause Wizard to stop?

## Exercise flow

1. Split groups between intermediate and mart canvases, then cross-review.
2. Fill one prompt template per skill.
3. Create:
   - `.agents/skills/authoring-intermediate-models/SKILL.md`
   - `.agents/skills/authoring-governed-marts/SKILL.md`
4. Check each skill against the `building-governed-skills` required structure.
5. Confirm routes and orchestrator prerequisites now resolve.
6. Use facilitator reference prompts only for recovery or post-exercise comparison.

## dbt commands

None required. Optionally run:

```text
dbt parse --no-partial-parse
```

as a project regression check after file creation; parsing does not prove skill quality.

## Exit state

All three active layer skills exist and are readable. Together they define how the approved source-to-mart spec will be implemented; they do not decide what the Alembic products mean.
