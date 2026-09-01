# Demo 4 — Project inheritance

## Summary

Trainees inspect the AI assets they inherited and discover how policy, routing, planning, orchestration, skill authoring, and review compose. The guided reveal is that the source-to-mart orchestrator cannot run reliably until three routed layer execution skills exist.

## Relevant files

- `.agents/ROUTING.md`
- `.agents/skills/building-governed-skills/SKILL.md`
- `.agents/skills/planning-governed-source-to-mart/SKILL.md`
- `.agents/skills/planning-governed-source-to-mart/references/build-spec-template.yml`
- `.agents/skills/building-governed-source-to-mart/SKILL.md`
- `.agents/skills/reviewing-governed-dbt-changes/SKILL.md`
- `AGENTS.md` and `SECURITY.md`

## Guided questions for the slide

- Which assets are always-on policy, which route tasks, and which activate only for a specific outcome?
- What single artifact connects planning, approval, implementation, verification, and review?
- What does the planning skill decide, and what is it forbidden to implement?
- What does the build orchestrator delegate instead of defining itself?
- Follow every route and prerequisite: which required skill paths do not exist?
- Why should staging, intermediate, and mart behavior be separate reusable skills?
- What should happen if the orchestrator is invoked before those skills or an approved spec exist?
- Which decisions still belong to accountable humans?

## Facilitator reveal

Do not announce the missing skills at the start. Let attendees trace:

1. the build route;
2. the orchestrator readiness gate;
3. its delegated staging, intermediate, and mart work; and
4. the absent active skill paths.

Then introduce `building-governed-skills` as the mechanism for creating those reusable guardrails.

## Optional prompt

```text
Inspect AGENTS.md, .agents/ROUTING.md, and the active skills at a high level. What governed workflows are already available, how does the source-to-mart plan connect to the build orchestrator, and which required execution capabilities are still missing before the Alembic slice can be built reliably? Do not create or edit anything yet.
```

## dbt commands

None required. This demo is about instruction architecture and readiness, not warehouse execution.

## Exit state

Trainees identify the three missing layer skills themselves and understand that demos 5–6 must create them before Demo 7 can pass readiness.
