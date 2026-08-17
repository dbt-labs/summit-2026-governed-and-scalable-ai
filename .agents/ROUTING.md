# AI task routing — trainee starting state

Read `AGENTS.md` and `SECURITY.md` first. Select the smallest task-specific workflow or skill that matches the requested outcome. For a material dbt change, follow `.agents/workflows/governed-dbt-change.md` and complete `.agents/templates/dbt-change-plan.md` before implementation.

## Ready routes

| Request type | Primary asset | Notes |
|---|---|---|
| Create, revise, merge, or retire a reusable team skill | `.agents/skills/building-governed-skills/SKILL.md` | Use the skill-design checklist and test the skill on a realistic scenario. |
| Add or materially change a semantic definition or metric | `.agents/skills/authoring-governed-metrics/SKILL.md` | The starter skill is intentionally incomplete and must be refined around human-approved definitions. |
| Review a material dbt change or AI-authored proposal | `.agents/skills/reviewing-governed-dbt-changes/SKILL.md` | Use the review rubric and PR evidence; advisory review does not replace CI or human approval. |
| Investigate a failed, warning-bearing, slow, or intermittent dbt Platform run | `.agents/skills/investigating-dbt-job-failures/SKILL.md` | Scope to a specific project/job/run and follow the operational runbook. |
| Documentation-only or clearly non-material change | `AGENTS.md` | Apply the governed-change workflow if the scope becomes material. |

## Workshop routes to design

`TODO(training): Define how a new source system or material source-to-target slice should be planned, documented, and routed before implementation. Do not pretend a completed onboarding workflow exists.`

`TODO(training): Use the skill-building standard to define outcome-oriented routes for one-source staging cleanup, join or grain-change intermediates, and public governed marts. Keep layer rules in AGENTS.md rather than duplicating them.`

Until those routes are completed, use the governed-change workflow to explore and plan, then stop for the workshop decision checkpoint before implementing the missing Alembic slice.

## Routing boundaries

- Start from the requested outcome, not the currently open file.
- Add a second skill only when the task genuinely spans two governed outcomes.
- Inspect project evidence before making substantive claims or edits.
- Prompt back on unresolved grain, authority, business definitions, public interfaces, risk, or approval boundaries.
- Never use a missing training asset as permission to invent policy silently.
