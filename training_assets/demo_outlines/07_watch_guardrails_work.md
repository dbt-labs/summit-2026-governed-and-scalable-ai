# Demo 7 — You built the guardrails; now watch them work!

## Summary

Run the governed workflow end to end in two fresh Wizard conversations: first create and approve one Alembic build spec, then invoke the build orchestrator. The same spec carries intent, decisions, exact implementation contract, and verification evidence.

## Prerequisites

- Root `AGENTS.md` TODOs are resolved.
- All three active layer skills exist.
- `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` is absent at the start.
- `models/wizard/` contains no trainee SQL/YAML.
- Planning and orchestration skills were introduced in Demo 4.

## Relevant files and prompts

- planning prompt: `training_assets/reference/docs/prompts/run_governed_source_to_mart_planning.md`
- build prompt: `training_assets/reference/docs/prompts/run_governed_source_to_mart.md`
- `.agents/skills/planning-governed-source-to-mart/`
- `.agents/skills/building-governed-source-to-mart/`
- `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` — created live
- `models/wizard/` — populated only after approval

## Part 1 — Plan thoroughly

1. Open a fresh Studio conversation.
2. Run the short planning prompt.
3. Let the planner inspect project and warehouse evidence.
4. Discuss and resolve material unit, cost, null, public-interface, and semantic-scope decisions.
5. Watch the v2 pre-approval coherence checks catch mechanical contradictions before approval.
6. Approve the complete spec only after every check passes.

## Part 2 — Build once

1. Open a second fresh Studio conversation so active skills reload cleanly.
2. Run the short orchestrator prompt.
3. Show the readiness gate: approved spec, three layer skills, empty target, complete validation contract.
4. Let the orchestrator implement staging → intermediate → marts in dependency order.
5. Show one bounded slice-wide build, lint, warehouse checks, and verification updates in the same spec.

## Expected dbt commands

The skills choose and execute the commands. The final evidence should include:

```text
dbt parse
dbt lint --select path:models/wizard --format human
dbt build --select +fct_brews +dim_suppliers
```

## Talking points

- AGENTS defines durable project boundaries; layer skills govern how; the spec governs what.
- Planning is separate from implementation because humans approve material meaning.
- A readiness failure is a successful guardrail, not a failed demo.
- Ephemeral intermediate SQL is proven through the materialized mart build.
- Build success and warehouse behavior are both recorded before review.
- Compare the governed result with the preserved Warlock experience, not with hidden answer-key SQL.

## Exit state

Eight Wizard models and three properties files exist, the scoped build and acceptance checks pass, and `verification.ready_for_review` is true in the approved spec.
