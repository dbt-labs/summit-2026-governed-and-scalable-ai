# AI task routing

Read `AGENTS.md` and `SECURITY.md` first. Start from the requested outcome, then load the smallest applicable skill. Always-on policy remains authoritative; a skill adds conditional execution guidance and cannot approve a human-owned decision.

## Routing rules

1. Inspect project evidence before deciding the route or making substantive claims.
2. Use one primary skill. Add another only when the outcome genuinely spans multiple governed tasks.
3. For planned work, distinguish **planning** from **implementation**. An approved project-owned artifact must connect them when human approval is required.
4. Do not substitute facilitator references, answer-key models, generic plans, or unapproved notes for the active project-owned artifact.
5. If a required skill or approved artifact is missing, stop at that readiness gate and create, revise, or approve it through the route below.
6. Follow `SECURITY.md` before any restricted-data, credential, access, external-tool, production, destructive, retry, or deployment action.

## Routes

| Requested outcome | Primary skill | Required artifact or readiness | Handoff |
|---|---|---|---|
| Plan a governed source-to-mart slice | `.agents/skills/planning-governed-source-to-mart/SKILL.md` | Project and warehouse evidence; no implementation | Produce one project-owned build spec, resolve human decisions, and obtain approval. |
| Build an approved source-to-mart slice | `.agents/skills/building-governed-source-to-mart/SKILL.md` | Approved build spec plus all three layer skills | Implement staging → intermediate → marts, update only spec verification, then review. |
| Create, revise, merge, or retire a reusable team skill | `.agents/skills/building-governed-skills/SKILL.md` | Outcome, invariants, human boundary, completion evidence, and owner | Create one `SKILL.md` by default; routing changes only when requested and approved. |
| Create or materially change one source-facing staging model | `.agents/skills/authoring-staging-models/SKILL.md` | Skill must exist; approved spec when part of planned work | Preserve one-source grain and hand material work to review or the orchestrator. |
| Create or materially change a join, rollup, dedupe, fanout-control, or grain-change model | `.agents/skills/authoring-intermediate-models/SKILL.md` | Skill must exist; approved spec when part of planned work | Validate through a materialized downstream node and hand off to review/orchestration. |
| Create or materially change a public dimension or fact | `.agents/skills/authoring-governed-marts/SKILL.md` | Skill must exist; approved public decisions/spec when planned | Enforce the contract, assess consumers/semantics, and hand off to review. |
| Add or materially change a semantic model, entity, dimension, measure, or metric | `.agents/skills/authoring-governed-metrics/SKILL.md` | Human-approved business definition and applicable decision artifact | Validate semantic behavior and consumer impact; do not create a competing metric. |
| Review a material dbt change or AI-authored proposal | `.agents/skills/reviewing-governed-dbt-changes/SKILL.md` | Diff, applicable approved artifact, implementation evidence, and rubric | Approve, request changes, or block pending a named human decision. |
| Investigate a failed, warning-bearing, slow, or intermittent dbt Platform run | `.agents/skills/investigating-dbt-job-failures/SKILL.md` | Current project, job/run ID, run evidence, and action authority | Diagnose first; route approved code changes through the applicable planning/implementation/review path. |
| Documentation-only or clearly non-material change | `AGENTS.md` | No build spec by default | Apply proportionate validation; reroute if policy, contracts, sources, semantics, or public behavior become material. |

The staging, intermediate, and mart execution skills are required prerequisites for the orchestrator. They are intentionally absent from the trainee starter state and are created during the skill-building demos. The trainer prompts under `training_assets/reference/docs/prompts/` are facilitator-only reproducibility assets, not implementation evidence.

## Cross-route boundaries

Every route must:

- preserve completed starter models, unaffected interfaces, layer rules, and governed semantic definitions;
- consume approved decisions exactly and return material contradictions to planning;
- prompt back on unresolved authority, grain, fanout, retention, business meaning, units, nulls, public interfaces, cost, risk, or action permissions;
- use scoped dbt execution and result checks appropriate to the change;
- rely on contracts, tests, lint, CI, review, and accountable humans as independent enforcement;
- avoid creating duplicate plans, checklists, or evidence artifacts.

## Maintenance

The analytics engineering governance owner reviews this map when a skill is added, promoted, merged, or retired; when a readiness gate changes; or when incidents and repeated prompt-backs reveal a missing or ambiguous route.
