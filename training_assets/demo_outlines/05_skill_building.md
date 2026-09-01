# Demo 5 — Skill building: staging together

## Summary

The trainer models the skill-authoring process end to end. The group reasons about staging behavior, fills `docs/prompts/skill_building_prompt_template.md`, invokes `building-governed-skills`, and reviews the resulting `authoring-staging-models` skill.

## Relevant files

- `docs/prompts/skill_building_prompt_template.md`
- `.agents/skills/building-governed-skills/SKILL.md`
- `AGENTS.md`
- `docs/merlinco/STYLE_GUIDE.md`
- representative completed staging SQL/YAML and shared macros
- facilitator convergence prompt: `training_assets/reference/docs/prompts/build_staging_skill.md`
- facilitator reference skill: `training_assets/reference/.agents/skills/authoring-staging-models/SKILL.md`

Facilitator references are comparison/recovery assets, not Wizard authoring input.

## Staging decision canvas for the slide

- What requests should trigger this skill?
- What is the output grain relative to the source?
- How many declared sources may it read?
- Which renames, casts, normalizations, and macros are allowed?
- Which operations would belong in intermediate instead?
- How must source columns and accepted values be grounded?
- Which PK, FK, required-field, categorical, and composite-grain tests apply?
- What null, mapping, unit, or retention choices require approval?
- What scoped build and warehouse checks prove success?
- What evidence or contradiction should make Wizard stop?

## How the group builds the prompt

1. Write one bounded recurring **outcome**.
2. Convert the decision canvas into a short set of **output invariants**.
3. Separate discoverable facts from **human decision boundaries**.
4. Name **completion evidence** that executes SQL and checks data behavior.
5. Assign the **primary owner**.
6. Submit the completed template to `building-governed-skills`.
7. Review the generated skill for trigger, non-goals, evidence, invariants, workflow, prompt-backs, completion, behavioral acceptance, and ownership.
8. Compare behavior with the facilitator reference only after authoring.

## Prompt to execute

The live prompt is the group-completed copy of `docs/prompts/skill_building_prompt_template.md`. Use `training_assets/reference/docs/prompts/build_staging_skill.md` only as a timed fallback or post-exercise convergence check.

## Validation

No dbt command proves a Markdown skill. Check that:

- `.agents/skills/authoring-staging-models/SKILL.md` exists;
- its route and owner are explicit;
- it stops on joins, grain changes, unsupported mappings, and contradictory source evidence;
- its behavioral scenario requires a scoped build plus warehouse checks.

## Exit state

A usable active staging skill exists, and trainees have a repeatable method for authoring the two remaining layer skills.
