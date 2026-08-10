# AI task routing

Use this map after reading `AGENTS.md`. It selects the smallest set of task-specific instructions needed for the request. Always-on policy in `AGENTS.md` and the security boundary in `SECURITY.md` apply to every route.

## Routing rules

1. Start with the user’s intended outcome, not the file they happened to open.
2. Load one primary task skill. Add another only when the work genuinely spans both tasks.
3. For a material change, follow `.agents/workflows/governed-dbt-change.md` and complete `.agents/templates/dbt-change-plan.md` before implementation.
4. For a new source system or material source slice, also follow `.agents/workflows/onboarding-source-system.md` and complete `.agents/templates/source-to-target-design.md`.
5. If no route cleanly applies, follow the governed-change workflow, inspect relevant project evidence, and ask a focused prompt-back before inventing a new process.
6. If the request involves restricted data, credentials, production-impacting action, or unclear tool approval, stop and follow `SECURITY.md`.

## Routes

| Request type | Primary skill/workflow | Required artifacts | Notes |
|---|---|---|---|
| Onboard a new source system or material source-to-target slice | `.agents/workflows/onboarding-source-system.md` | Source-to-target design + governed change plan | Orchestrates layer skills only as needed. |
| Create or change a source declaration or one-to-one staging model | `.agents/skills/authoring-staging-models/SKILL.md` | Change plan when material; source-to-target design for source onboarding | Staging reads one `source()` and preserves raw-table grain. |
| Create or change a join, rollup, dedupe, fanout-control, or grain-change model | `.agents/skills/authoring-intermediate-models/SKILL.md` | Change plan; source-to-target design when applicable | Intermediate owns multi-input transformation logic. |
| Create or materially change a public dimension or fact | `.agents/skills/authoring-governed-marts/SKILL.md` | Governed change plan; source-to-target design when applicable | Public marts are contracted, tested, documented products. |
| Add or materially change a semantic model, measure, dimension, or metric | `.agents/skills/authoring-governed-metrics/SKILL.md` | Governed change plan | Use after the business definition and grain are approved. Do not hand-roll a competing metric. |
| Review a dbt change or AI-authored proposal | `.agents/skills/reviewing-governed-dbt-changes/SKILL.md` | PR template/review rubric; plan when the change is material | Review implementation and evidence. Do not silently redesign business logic; request decisions where needed. |
| Investigate a failed dbt Platform job/run | `.agents/skills/investigating-dbt-job-failures/SKILL.md` | Job investigation runbook | Gather run-specific evidence first. Diagnose before proposing a fix or retry. |
| Create, revise, merge, or retire a shared governance skill | `.agents/skills/building-governed-skills/SKILL.md` | Skill design checklist | Use when a repeatable task needs conditional instructions beyond `AGENTS.md`. |
| Documentation-only, small configuration, or narrow non-material change | No specialized skill by default | Follow `AGENTS.md`; use a concise plan if the change affects policy, contracts, sources, or downstream interfaces | Apply the closest skill if the change becomes material. |

## What always applies

Every route must:

- inspect real project context before making substantive claims or edits;
- preserve layer rules, public contracts, governed metric definitions, and unaffected interfaces;
- state uncertainty and prompt back on unresolved decision rights;
- use version-controlled artifacts for shared policy;
- record validation evidence and remaining follow-up;
- rely on dbt contracts, tests, lint, CI, and human review as independent enforcement.

## Routing maintenance

The governance owner reviews this map whenever a new skill is added, a skill is retired, a repeated failure reveals a missing route, or platform behavior changes. Keep routes outcome-oriented and avoid one skill per file or dbt layer.
