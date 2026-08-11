# Governance scorecard

> **Training template:** use this scorecard to improve a governed AI-assisted analytics operating model over time. It is not a people-performance scorecard, a surveillance mechanism, or a substitute for incident management, security controls, or accountable human review.

## Purpose

Repository policy, skills, plans, contracts, tests, CI, review, and runbooks are only useful when teams maintain them. This scorecard turns routine delivery and operational evidence into a small feedback loop:

1. observe recurring quality, decision, and operational signals;
2. identify the smallest control that would reduce repeated risk or rework;
3. improve, merge, retire, or clarify that control through normal review; and
4. verify whether the change improved the next review cycle.

Measure the system, not individual contributors or model providers. Favor trends, representative samples, and learning over target-chasing.

## Operating cadence and owners

| Cadence | Forum / owner | Inputs | Outcome |
|---|---|---|---|
| Monthly, 30 minutes | `TODO(owner: analytics engineering)` + data-product and platform representatives | Material PR samples, CI/build evidence, review findings, job warnings/failures | Prioritized improvement actions with owner and due date. |
| After material incident or repeated finding | Incident/change owner + affected owners | Runbook/incident evidence, PR/review history, relevant code/config | Immediate control change, follow-up experiment, or documented reason no change is needed. |
| Quarterly, 45 minutes | `TODO(owner: analytics governance)` | Scorecard trend, active skills/workflows/templates, ownership map, platform/spec changes | Merge, retire, clarify, or refresh stale governance assets and ownership. |

Do not collect a metric unless a named owner can interpret it and act on it.

## Starter indicators

Choose the smallest set that matches the team’s maturity and data availability. Establish a baseline first; thresholds below are starting prompts, not universal SLOs.

| Indicator | Definition | Evidence source | Owner | Review prompt / response when it regresses |
|---|---|---|---|---|
| **Material-change evidence coverage** | Share of material PRs with completed plan/design links, AI-assistance declaration, decision owner, and required validation evidence. | PR template sample; review record | Analytics engineering | If coverage is below the agreed baseline for two review cycles, simplify the template, reinforce the workflow, or add reviewer automation/checks. |
| **Independent validation completion** | Share of applicable material changes with passing scoped build/test, SQLFluff, and required CI/semantic checks before merge. | GitHub CI; dbt Platform CI; PR validation table | Analytics engineering + data platform | If checks are skipped, pending at merge, or repeatedly fail, address the gate, environment, selector, or delivery process—never lower a control only to improve the score. |
| **Review finding recurrence** | Count and trend of must-fix findings by category: layer fit/fanout, contract/type, tests/docs, semantic definition, validation evidence, or security/operations. | Review rubric output; PR comments | Analytics engineering + data-product owner | Repeated category in two cycles means add/clarify the smallest relevant skill, checklist, test, contract, CI rule, or example. |
| **Decision hygiene** | Share of material changes where grain, source authority, business mappings, metric meaning, and breaking impact are approved before implementation. | Change plans; source-to-target designs; PR template | Data-product owner | Repeated late decisions mean add a better prompt-back, approval checkpoint, or owner routing—not an AI guess. |
| **Governance-asset health and reuse** | Active skills/workflows/templates used, repeated prompt-backs, unused/redundant assets, and overdue policy ownership reviews. | PR links; skill/workflow review log; quarterly audit | Analytics governance | Merge/retire unused assets; clarify assets associated with repeated prompt-backs; update routes after platform or convention changes. |
| **AI-assisted traceability** | Share of AI-assisted material changes that declare tool use, human accountability, and validation evidence. | PR template sample | Analytics governance | Low coverage signals a process-design problem. Make disclosure easy and non-punitive; do not use it to evaluate individuals. |
| **Operational trust signals** | Material job warnings/failures, repeat incident classes, time to evidence-backed diagnosis, and unapproved retry/remediation attempts. | dbt Platform run history; job runbook; incident records | Data platform + analytics engineering | Repeated class triggers a runbook, test, alert, job-config, source-contract, or ownership improvement. Escalate security/production-boundary violations immediately. |
| **Public-interface and semantic incidents** | Contract breaks, consumer regressions, metric conflicts, or semantic-definition migrations that caused downstream confusion. | CI/build failures; support/incidents; review records | Data-product owner + analytics engineering | Require migration/deprecation guidance, consumer communication, contract/semantic test coverage, or a stronger review checkpoint. |

## Minimum review agenda

1. Review the last cycle’s actions and whether they changed the intended signal.
2. Look at the smallest useful sample of material PRs, CI/build outcomes, review findings, and job investigations.
3. Identify one or two repeated patterns—not every isolated defect.
4. Choose the smallest intervention:
   - clarify `AGENTS.md` or a template;
   - add/refine/retire a skill or checklist;
   - add a contract, data test, unit test, or CI rule;
   - improve review routing or code ownership;
   - change job configuration, alerting, or operational runbook;
   - escalate a policy, security, access, or source-owner issue.
5. Assign an accountable owner, completion evidence, and review date.
6. Record decisions in the team’s normal planning/issue process; link the resulting PRs or incidents.

## When to change the operating model

Review or revise project policy, skills, workflows, templates, ownership, or enforcement when any of the following occurs:

- a material incident, contract break, metric conflict, or consumer regression;
- the same review finding, prompt-back, job warning, or failure class recurs;
- a skill is unused, overlaps another asset, or is too broad to execute reliably;
- a dbt semantic specification, platform capability, CI path, source system, access boundary, or project convention changes;
- an ownership path lacks a real accountable team; or
- evidence shows that a required control is routinely bypassed, unavailable, or too costly to run.

Preserve the control objective while improving the implementation. Do not remove contracts, tests, review, or CI simply because they expose recurring problems.

## Workshop placement

This is a take-home/reference asset, not a participant build.

- In the operational showcase, connect job failures, warnings, and review findings to the scorecard as signals for improving the system rather than isolated events.
- In the conclusion, recommend a team start with one policy, one repeatable workflow, one independent evidence gate, and a monthly review of recurring friction.
- For cross-project and beyond-platform scaling, use the scorecard to identify which project patterns are mature enough to distribute, automate, or expose to external agents under approved controls.

## Evidence-handling boundary

Use aggregated counts, categories, and redacted examples where possible. Do not place secrets, restricted values, private incident detail, or employee-performance assessments in this scorecard. Follow `SECURITY.md` and the organization’s retention and incident policies.
