# Demo 07 — Conclusion and scale

## Audience outcome and takeaway

**Audience outcome:** Participants can summarize the workshop operating model, identify the first repository assets and human decisions to adopt in their own project, and distinguish near-term team controls from broader Platform and external-agent controls.

**One-sentence takeaway:** Start small: encode authority and decision rights, route one risky recurring task, validate it on real work, and improve the system from review and incident evidence.

## Position in the throughline and timing

- **Order:** 07 of 07
- **Target time:** 5 minutes
- **Delivery mode:** Facilitator close
- **Participant mode:** Reflect, choose one adoption action, and record an owner
- **Starts from:** Complete workshop story across guidance, implementation, review, enforcement, and operations
- **Ends with:** A practical adoption commitment and scaling map

### Timing budget

| Time | Beat |
|---:|---|
| 0:00–1:30 | Recap the continuous Merlin & Co. story |
| 1:30–3:00 | Present the Monday-morning adoption sequence |
| 3:00–4:00 | Show maintenance/scorecard loop and control planes |
| 4:00–5:00 | Participant commitment and companion-session handoff |

## Setup and prerequisites

Have one closing slide or page showing:

- Guide → Enforce → Runtime;
- Explore → Plan → Implement → Verify;
- `AGENTS.md` → routing → workflow/plan → task skill → dbt/CI → review/owner;
- the three control planes; and
- the governance scorecard categories.

Open `training_assets/reference/docs/governance_scorecard.md` for the maintenance takeaway. No live repository or warehouse action is required.

### Fallback plan

Use a static closing slide. This segment should not depend on Studio, warehouse, GitHub, or job state.

## Facilitator script starters and slide beats

### 1. Recap the story

> “We began with a project-aware assistant and an intentionally missing data product. We did not start by generating SQL.”

Recap:

1. **Understand:** Wizard inspected real dbt context.
2. **Govern:** The team encoded authority, workflow, routing, and task skills.
3. **Decide:** People approved units, cost meaning, null treatment, and semantic boundaries.
4. **Build:** Wizard implemented against an approved plan.
5. **Enforce:** Contracts, tests, lint, builds, and CI checked the result independently.
6. **Review:** Findings separated defects, decisions, and suggestions.
7. **Operate:** Run-specific evidence and approval boundaries governed remediation.

### 2. Give the Monday-morning sequence

Recommend this order:

1. **Pick one real project and one recurring risky task.** Do not start with an enterprise-wide prompt library.
2. **Write a concise `AGENTS.md`.** Name project authority, stable defaults, validation, prompt-backs, and safe boundaries.
3. **Add one shared material-change workflow and plan.** Make decisions and evidence visible before implementation.
4. **Create one outcome-oriented skill.** Use a real recurring task, named owner, and observable validation.
5. **Route it and test it on real work.** Compare behavior and evidence, not prose aesthetics.
6. **Keep independent enforcement.** Contracts, tests, CI, required review, and Platform permissions remain author-independent.
7. **Review and improve.** Use incidents, repeated findings, stale instructions, and user friction as maintenance signals.

> “The smallest useful governance system is better than a giant policy nobody can execute.”

### 3. Show the upkeep loop

Use scorecard categories such as:

- required validation completion;
- must-fix review findings;
- unresolved decision prompts;
- skill invocation/reuse;
- stale or conflicting assets;
- AI-assisted PR evidence completeness;
- recurring job failures/warnings; and
- incident-driven policy updates.

Explain that metrics should trigger action and ownership, not become vanity counts.

### 4. Revisit the control planes

| Control plane | Adopt now | Scale later |
|---|---|---|
| Repository | Policy, routes, skills, workflows, templates, CODEOWNERS | Cross-project distribution and shared governance lifecycle |
| dbt Platform | CI, environments, permissions, approvals, jobs | Broader monitoring, audit, and operating standards |
| Beyond Platform | Approved integrations and least-privilege tool policy | MCP/external-agent ecosystems and organization-wide AI governance |

## Exact participant prompt

Ask participants to write or discuss:

```text
For one dbt project I own, what recurring task would benefit most from a governed skill? Name the task, the human owner, the authoritative evidence it must inspect, one decision it must never make silently, and the validation that proves completion.
```

Optional Wizard prompt for post-workshop use:

```text
Inspect this dbt project’s existing policy, workflows, tests, semantic definitions, and recurring review or job-failure evidence. Recommend one narrowly scoped governed skill to adopt first. State its trigger, owner, authority, prompt-back condition, and observable validation. Do not create files until a human approves the scope.
```

## Human decision checkpoint and expected artifact

### Decision checkpoint

Each participant or team chooses:

- one project;
- one recurring task;
- one accountable owner;
- one decision right to protect; and
- one completion check.

### Expected artifact

A one-line adoption commitment:

```text
We will govern [task] in [project], owned by [role], grounded in [authority], stopping for [decision], and validated by [evidence].
```

No repository edit is required during the five-minute close.

## Validation and evidence to show

The close succeeds when participants can answer:

- What belongs in always-on policy versus a task skill?
- When should Wizard stop and ask a person?
- What proves a material dbt change is complete?
- Which controls remain independent of the author?
- Who owns review, production action, and governance upkeep?
- What is the first small adoption step?

## Convergence map

| Workshop element | Durable operating practice | Take-home reference |
|---|---|---|
| Sparse-to-final policy | Derive authority/defaults from real project evidence | Final reference `AGENTS.md` |
| Routed source/layer skills | Conditional, owned, testable workflows | Reference `.agents/` system |
| Alembic decisions/build | Human-approved meaning plus warehouse evidence | Acceptance-test records and disabled answer key |
| Governed review | Evidence-backed findings and human approval | Review skill/rubric and PR template |
| Job investigation | Run-specific diagnosis and action boundary | Job skill and bundled runbook |
| Maintenance | Measure, review, revise, merge, or retire | Governance scorecard |

## Common failures and recovery

| Failure | Recovery |
|---|---|
| Closing becomes a product-feature recap | Return to the operating model and participant adoption commitment. |
| Teams propose dozens of skills | Ask for one recurring, material task with an owner and validation. |
| Governance is framed as AI-only | Reiterate that contracts, tests, review, and decision records improve human-authored work too. |
| Participants expect repository files to grant permissions | Revisit the Platform control plane and security boundary. |
| Scorecard sounds like surveillance | Focus on system health, stale guidance, validation, incidents, and improvement—not individual productivity. |

## Final close

> “AI can make analytics engineering faster. A governed system makes that speed dependable: grounded in the project, constrained by team decisions, verified by dbt, and accountable to people.”

## Companion-session callouts

- **Creating context with dbt MCP Server:** for approved external-agent context and tools.
- **Semantic Layer workshop:** for deeper governed metric modeling and consumption.
- **AI in analytics / Accelerating analytics with AI:** for analyst-facing applications built on trusted marts and metrics.
