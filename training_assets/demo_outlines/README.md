# Workshop demo plans

These concise plans align the hands-on workshop with the accompanying slide deck. Each plan records the demo purpose, relevant project files, prompts, dbt commands, talking points, and expected handoff. They are facilitator planning aids, not trainee implementation authority.

## Hands-on sequence

| Demo | File | Workshop beat |
|---:|---|---|
| 1 | `01_meet_the_project.md` | Tour the project and use Wizard for new-developer onboarding. |
| 2 | `02_now_break_it.md` | Run an underspecified Warlock build and compare assumptions. |
| 3 | `03_find_the_patterns.md` | Discover project conventions and complete three AGENTS TODOs. |
| 4 | `04_project_inheritance.md` | Inspect inherited AI assets and discover the three missing layer skills. |
| 5 | `05_skill_building.md` | Build the staging skill together from the prompt template. |
| 6 | `06_build_layering_skills.md` | Trainees build the intermediate and governed-mart skills. |
| 7 | `07_watch_guardrails_work.md` | Generate and approve one spec, then run the build orchestrator. |
| 8 | `08_how_to_review.md` | Review implementation and evidence against the same spec. |

Everything after Demo 8 is facilitator-led showcase material—agentic PR review, job debugging, ownership/maintenance, and scaling beyond one project—and does not require a demo-plan Markdown file.

## Throughline

```text
meet the project
→ experience underspecified generation
→ discover durable project patterns
→ inspect inherited governance and find capability gaps
→ build reusable layer skills
→ plan thoroughly in one approved spec
→ build once through orchestration
→ review against the same intent and evidence
```

## Starting state

The learner branch begins with:

- exactly three `TODO(training):` markers in root `AGENTS.md`;
- no active Alembic build spec;
- empty Warlock and Wizard model tracks;
- planning, orchestration, skill-building, review, and job-investigation skills;
- no active staging, intermediate, or governed-mart authoring skills;
- disabled facilitator answer-key models and complete references unavailable as trainee evidence.

See `training_assets/trainee_starter_manifest.md` for the reset contract.

## Prompt index

- New-developer onboarding: `docs/prompts/onboard_new_merlinco_developer.md`
- Skill prompt template: `docs/prompts/skill_building_prompt_template.md`
- Facilitator convergence and Demo 7 prompts: `training_assets/reference/docs/prompts/`

## Maintenance

Update these plans when slide sequencing, prompts, skills, starter state, or dbt Platform UX changes. Update the PPT only after the demo sequence and timing are stable.
