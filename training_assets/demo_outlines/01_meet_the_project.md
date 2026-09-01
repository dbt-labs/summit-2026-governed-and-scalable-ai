# Demo 1 — Meet the project

## PPT alignment

**Slide:** “Meet the project” (around slide 17)

## Summary

Give trainees a fast orientation to Merlin & Co. Apothecaries before asking them to change anything. Show the business domains, declared sources, dbt layers, completed patterns, workshop tracks, and the difference between active project evidence and facilitator-only assets.

## Relevant files

- `README.md`
- `dbt_project.yml`
- `models/staging/`, `models/intermediate/`, `models/marts/`
- `models/staging/*/*__sources.yml`
- `models/warlock/README.md` and `models/wizard/README.md`
- `docs/merlinco/STYLE_GUIDE.md`, `ERD.md`, and `DATA_DICTIONARY.md`
- `macros/`
- `docs/prompts/onboard_new_merlinco_developer.md`

## Prompt

Run the prompt in `docs/prompts/onboard_new_merlinco_developer.md` after the facilitator tour. It explicitly skips trainee workspaces, facilitator assets, and generated/vendor paths.

## dbt commands

```text
dbt ls --resource-type source
dbt ls --resource-type model
```

## Talking points

- Three business domains feed one layered analytics project.
- Staging cleans one source; intermediate owns joins and grain changes; marts publish contracted products.
- Existing SQL/YAML is project evidence and a source of patterns.
- `models/warlock/` and `models/wizard/` are intentionally empty learner workspaces.
- `training_assets/reference/` and `models/answer_key/` are facilitator-only.
- Wizard can accelerate onboarding, but developers still need to know which evidence is authoritative.

## Exit state

Trainees can name the source systems, layers, completed assets, unfinished Alembic slice, and files they would inspect before modeling.
