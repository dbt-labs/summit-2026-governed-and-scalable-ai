# Demo 01 — From native grounding to durable governance

## Audience outcome and takeaway

**Audience outcome:** Participants can explain what Wizard learns natively from a dbt project and identify the business, ownership, and process decisions that must still be encoded as durable team policy.

**One-sentence takeaway:** Native dbt grounding makes AI more relevant; versioned repository policy makes its behavior repeatable, reviewable, and team-owned.

## Position in the throughline and timing

- **Order:** 01 of 07
- **Target time:** 10 minutes
- **Delivery mode:** Facilitator demo
- **Participant mode:** Watch, compare, and classify findings
- **Starts from:** Demo 00 starter state; no repository edits
- **Ends with:** A concrete list of context Wizard can discover and governance it cannot infer

### Timing budget

| Time | Beat |
|---:|---|
| 0:00–2:00 | Show a prepared ungrounded response to an Alembic request |
| 2:00–5:00 | Ask Wizard the same outcome-oriented question in the dbt project |
| 5:00–7:30 | Separate discoverable facts from unresolved policy |
| 7:30–9:00 | Show sparse `AGENTS.md` and active TODOs |
| 9:00–10:00 | Frame the operating-model build in demo 02 |

## Setup and prerequisites

### Exact repository state

Use the same published trainee overlay as demo 00. No files have changed.

Keep open:

- `AGENTS.md`;
- `docs/merlinco/STYLE_GUIDE.md`;
- `docs/merlinco/ERD.md`;
- `docs/merlinco/DATA_DICTIONARY.md`;
- `docs/merlinco/LAB_procurement_slice.md`; and
- the Alembic source YAML.

### Prepared comparison

Prepare one short “ungrounded” answer that plausibly:

- proposes models from names alone;
- assumes units are directly comparable;
- calls supply cost “actual cost”;
- imputes or drops missing brew duration;
- places joins directly in a mart; or
- considers generated SQL to be completion.

Label it as a teaching fixture, not as a claim about a specific external product.

### Fallback plan

If live Wizard behavior differs from rehearsal, use the prepared response and a saved project-grounded response. The learning objective is the classification exercise, not forcing Wizard to make a particular mistake.

## Facilitator script starters and slide beats

### 1. Show the plausible ungrounded answer

> “Nothing here looks absurd. That is the risk: plausible structure can hide unsupported decisions.”

Ask participants to identify assumptions. Capture answers under:

- source/grain assumptions;
- business-definition assumptions;
- architecture assumptions; and
- validation assumptions.

### 2. Ask Wizard inside the project

Use a proposal-only prompt so Wizard can inspect the dbt graph and docs without making edits.

Highlight native grounding when Wizard discovers:

- Snowflake/dbt project configuration;
- active models and source declarations;
- existing staging/intermediate/mart patterns;
- contracts, tests, and semantic definitions;
- shared macros; and
- the intentionally unfinished procurement slice.

> “Wizard has real project context. We should use that capability rather than restating the entire repo in a prompt.”

### 3. Identify what cannot be discovered as fact

Ask:

> “Which questions still require team policy or a human decision even after Wizard reads every file?”

Expected examples:

- Which source is authoritative when evidence conflicts?
- Are recipe and ingredient units comparable?
- Is modeled batch cost standard/estimated or historical actual?
- What should missing duration mean in a metric?
- Who approves a public metric or breaking contract?
- Which validation evidence is mandatory before review?
- Who may retry or change a production job?

### 4. Reveal the sparse policy gaps

Open root `AGENTS.md` and show its four `TODO(training)` prompts.

> “These TODOs are not missing prose. They are missing team decisions: authority, lifecycle, prompt-backs, and maintenance.”

Distinguish:

- **Native context:** graph, code, metadata, tests, results.
- **Repository policy:** defaults, decision rights, evidence requirements, routing.
- **Human checkpoint:** unresolved meaning, risk, approval, and action authority.

## Exact Wizard prompts

### Project-grounded proposal

```text
We need to complete the Alembic Ops procurement slice. Before proposing any implementation, inspect the active project, source declarations, existing layer patterns, contracts, tests, macros, semantic definitions, and supporting project docs. Summarize what is established by evidence, what is intentionally missing, and which decisions cannot be made safely from the repository as it stands. Do not edit files and do not use models/answer_key as an implementation source.
```

### Policy-gap classification

```text
Now classify your findings into three groups: facts dbt project context establishes, team policy that should be version-controlled, and focused human decisions required before implementation. Cite the project paths you inspected. Do not propose SQL yet.
```

### Optional follow-up

```text
Review the TODO(training) markers in AGENTS.md. For each TODO, explain one concrete failure mode it is intended to prevent. Do not fill in the TODOs yet.
```

## Human decision checkpoint and expected artifact

### Decision checkpoint

The room decides whether each statement is:

1. discoverable project fact;
2. durable team policy; or
3. task-specific human decision.

Use at least these examples:

| Statement | Expected classification |
|---|---|
| Staging models are views | Project fact/configuration |
| Joins belong in intermediate | Durable project policy |
| Recipe units can be multiplied as supplied | Task-specific human decision |
| Public marts require contracts | Durable project policy plus dbt enforcement |
| A failed production job should be retried | Runtime human decision based on run evidence |

### Expected artifact

A slide, whiteboard, or facilitator note with three columns:

```text
Native project facts | Versioned team policy | Human decisions
```

No repository file changes in this demo.

## Validation and evidence to show

A successful demo shows that Wizard:

- cites real project files rather than inventing structure;
- identifies at least one existing pattern or macro;
- recognizes that the Alembic implementation is absent;
- distinguishes evidence from assumptions; and
- stops short of deciding unit, cost, null, metric, or production-action policy.

The quality measure is not whether Wizard uses exact facilitator wording. It is whether it separates knowable context from unapproved decisions.

## Convergence map

| Starting asset | Evidence to inspect | Decision trainees make | Target content or behavior | Reference comparison |
|---|---|---|---|---|
| Sparse `AGENTS.md` | TODOs plus project evidence | Which missing items are policy rather than task detail | Inputs for demo 02 refinement | `training_assets/reference/AGENTS.md` |
| Native dbt context | Graph, models, YAML, macros, docs | What Wizard can discover without prompt duplication | Evidence-first exploration | Existing project |
| Alembic ambiguity | Data dictionary, ERD, lab brief | What still needs human approval | Decision list for demo 03 | Acceptance-test decision record |

## Common failures and recovery

| Failure | Recovery |
|---|---|
| The “ungrounded” fixture is cartoonishly bad | Use a plausible response with only one or two unsupported assumptions; subtle failure is the lesson. |
| Wizard immediately asks the right questions | Treat that as evidence of strong native behavior, then ask whether those questions are consistently required and owned without repository policy. |
| Wizard begins editing | Stop the action and restate “proposal only; do not edit.” |
| Participants conclude `AGENTS.md` should contain everything | Point out that always-on policy, task skills, detailed references, and human decisions have different scopes. |
| Discussion becomes vendor comparison | Return to the repository operating model; this is about repeatability and accountability, not model rankings. |

## Transition to demo 02

> “We now know what the project can tell Wizard and what the team still must decide. Next we’ll turn those missing decisions into a small operating system: policy, routing, workflow, plans, and task skills.”

## Companion-session callout

At the close, mention that the **AI in analytics / Accelerating analytics with AI** sessions explore analyst-facing use. This workshop focuses on the engineering and governance system that makes those experiences trustworthy.
