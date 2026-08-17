# Demo 06 — Operational and agentic extensions

## Audience outcome and takeaway

**Audience outcome:** Participants can apply the same evidence, decision-rights, and validation model to a dbt Platform job failure and distinguish repository-governed instructions from Platform controls and external-agent integrations.

**One-sentence takeaway:** An agent can accelerate diagnosis and review, but run-specific evidence, least privilege, explicit action approval, and independent controls still define the safe operating boundary.

## Position in the throughline and timing

- **Order:** 06 of 07
- **Target time:** 8 minutes
- **Delivery mode:** Facilitator showcase with pre-recorded fallback
- **Participant mode:** Watch, classify evidence, and choose the smallest safe next action
- **Starts from:** The demo 05 flawed-change story plus a prepared dbt Platform run for that branch when feasible
- **Ends with:** A run-specific diagnosis/handoff and a three-control-plane scaling map

### Timing budget

| Time | Beat |
|---:|---|
| 0:00–1:00 | Scope the prepared project/job/run and impact |
| 1:00–4:00 | Use Wizard to collect evidence and classify the failure |
| 4:00–5:30 | Decide whether to fix, escalate, or request retry approval |
| 5:30–6:30 | Show agentic PR-review extension |
| 6:30–8:00 | Map repository, Platform, and beyond-Platform controls |

## Setup and prerequisites

### Prepared job fixture

Prefer a stable CI/build run generated from the same flawed-change branch used in demo 05. This keeps the story continuous: the review finding becomes runtime evidence rather than an unrelated incident. If that run cannot be preserved reliably, use a separate fixture and say so explicitly.

The run must be safe to inspect and have:

- known project, environment, job ID, and run ID;
- stable branch and Git SHA;
- one clear failed or warning-bearing step;
- preserved error/warning/log/artifact evidence;
- known impact and expected classification; and
- no requirement to expose credentials or restricted data.

Recommended fixture classes:

- a contract or data-test failure from the demo 05 Alembic flaw;
- data-test failure caused by a deliberate fixture value;
- warning with a clear trust impact; or
- transient infrastructure failure with saved evidence and a deliberately separate retry decision.

Do not rely on “latest run in the account.” Job/run tools are account-wide and must be scoped to the workshop project.


### Active assets

- `.agents/skills/investigating-dbt-job-failures/SKILL.md`
- `.agents/skills/investigating-dbt-job-failures/references/dbt-job-investigation.md`
- `SECURITY.md`
- governed-change workflow for any approved code/config remediation
- governance scorecard under `training_assets/reference/docs/governance_scorecard.md`

### Agentic review fixture

Prepare a screenshot or short recording showing how a repository-guided external review agent could consume the same diff, policy, and validation evidence. Keep this advisory; do not imply it can approve or merge.

### Fallback plan

The default fallback is pre-recorded because platform state can drift. Keep:

- run details screenshot;
- focused error/warning output;
- artifact/log excerpt;
- expected classification;
- safe-next-action decision; and
- final handoff record.

## Facilitator script starters and slide beats

### 1. Scope one run

> “Operational diagnosis begins with one project, one job, one run, and one impact—not the newest failure in an account-wide list.”

Record:

- project/environment;
- job/run IDs;
- status and impact;
- timestamps;
- branch/SHA;
- execution steps/target/schema override;
- failed or warned node; and
- evidence available.

### 2. Classify before acting

Use the runbook categories:

- code/compilation;
- data test/contract;
- source freshness/availability;
- warehouse/connection/permission;
- job configuration;
- timeout/performance;
- warning-only; or
- unknown.

Require Wizard to separate:

- confirmed facts;
- supported hypotheses; and
- unknowns.

> “A confident explanation without run-specific evidence is still only a hypothesis.”

### 3. Choose the smallest safe next action

Present options:

| Evidence state | Safe next action |
|---|---|
| Confirmed code/config defect | Fix on a branch through governed-change workflow; validate and review |
| Confirmed source/data issue | Escalate to source/data owner; document impact |
| Transient infrastructure issue | Recommend retry, then request explicit approval |
| Permission/warehouse/platform issue | Escalate with run evidence |
| Root cause unconfirmed | Preserve evidence and request the narrowest next input |

Do not retry, cancel, reconfigure, deploy, or mutate production data during the demo.

### 4. Show the agentic review extension

> “The same repository policy can guide a PR-review agent outside Studio. What changes is the integration and permission boundary—not the need for evidence, review categories, and human accountability.”

Show an advisory review output that:

- cites the diff and policy;
- uses must-fix/decision/suggestion categories;
- links validation evidence; and
- leaves approval to humans and CI.

### 5. Map the control planes

| Control plane | Examples | Owner |
|---|---|---|
| Repository-governed | `AGENTS.md`, routing, skills, workflows, plans, PR template, CODEOWNERS | Analytics/data-product teams through version control |
| dbt Platform-governed | RBAC, approval mode, environments, credentials, jobs, CI, audit/runtime capabilities | Platform/account administrators and authorized operators |
| Beyond Platform | External agents, MCP tools, GitHub automation, organization policy, cross-project distribution | Security, AI governance, platform, and owning teams |

## Exact Wizard prompt

```text
Investigate the prepared dbt Platform run using the active investigating-dbt-job-failures skill and its bundled runbook. Confirm the current project, job, run ID, environment, status, impact, branch/SHA, execution steps, failed or warned node, timing, and available errors/logs/artifacts. Keep account-wide listings scoped to the current project. Classify the primary failure, separate confirmed facts from hypotheses and unknowns, and recommend the smallest safe next action. Do not retry, cancel, change job configuration, deploy, or modify production data. If action approval or evidence is missing, ask one focused question.
```

Optional warning-specific follow-up:

```text
Assess whether the warnings affect data trust, freshness, consumer behavior, or future failure risk. Do not dismiss them because the run completed successfully. Record the warning evidence, impact, owner, and follow-up.
```

## Human decision checkpoint and expected artifact

### Decision checkpoint

Ask the room:

> “Given this evidence, is the smallest safe next action to fix in a branch, escalate to an owner, observe, or request approval to retry?”

If retry is proposed, ask:

- Is the cause plausibly transient?
- Could retry change data, availability, or cost?
- Who is authorized to approve it?
- What result would confirm recovery?

### Expected artifact

A concise investigation record containing:

- scoped run identity and impact;
- evidence collected;
- failure classification;
- confirmed facts, hypotheses, and unknowns;
- recommended action and owner;
- approval status;
- validation/retry result if separately approved; and
- follow-up/escalation.

No production action is required for workshop completion.

## Validation and evidence to show

A successful showcase demonstrates:

- account-wide results were scoped to the current project;
- diagnosis uses the run’s branch/SHA and artifacts, not only the current workspace;
- classification precedes remediation;
- failing tests/contracts are investigated rather than weakened;
- action authority is explicit;
- no retry or mutation occurs without approval;
- the handoff names owner and next step; and
- advisory agent review remains separate from merge/deploy authority.

## Convergence map

| Starting asset/evidence | Applied control | Target behavior | Tested reference |
|---|---|---|---|
| Prepared job/run | Job skill/runbook | Run-specific evidence and classification | Active/reference investigation skill |
| Security/action ambiguity | `SECURITY.md` | Prompt back or escalate | Reference security policy |
| Approved code fix | Governed-change workflow | Branch, validate, review, then deploy through normal gates | Shared workflow/plan |
| External review agent | Repo policy plus least-privilege integration | Advisory findings with evidence | Review skill/rubric and PR template |
| Operational outcomes | Governance scorecard | Repeated failures/findings drive policy upkeep | Reference scorecard |

## Common failures and recovery

| Failure | Recovery |
|---|---|
| Live run no longer has expected evidence | Switch immediately to the recording/saved artifacts; do not improvise a new account-wide run. |
| Wizard diagnoses the current branch instead of run SHA | Re-anchor to job/run metadata and note the local-state mismatch. |
| A test failure is treated as bad test design | Inspect the failing data and approved definition before proposing any test change. |
| Participants want to click retry | Use it as the action-authority checkpoint; request approval but do not execute. |
| Platform permissions hide details | Record unavailable evidence and escalate; do not fill gaps with guesses. |
| External-agent discussion expands | Return to the three-control-plane table and companion-session handoff. |

## Transition to demo 07

> “We have now used the same operating model for authoring, business decisions, review, and operations. We’ll close by turning that pattern into a practical adoption and maintenance plan.”

## Companion-session callouts

- **Creating context with dbt MCP Server:** for trusted context, least-privilege tool access, and external-agent integration.
- Mention external AI/analytics sessions only as examples of consumers that benefit from governed marts and metrics.
