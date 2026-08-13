# Governed dbt change

> Use this template for human- and AI-assisted changes. Keep it concise and evidence-based. For a material change, link the completed `.agents/templates/dbt-change-plan.md` and, for source onboarding, the source-to-target design. Do not paste restricted data, credentials, or private extracts.

## 1. Change summary

- **What changed:**
- **Why / intended business outcome:**
- **Affected assets:** [models, YAML, macros, semantic definitions, jobs/configuration, governance files]
- **Linked plan/design/issue:** [links or `N/A — non-material change`]

## 2. AI assistance and human accountability

- **AI assistance:** [none / Wizard / approved tool]
- **How AI assisted:** [exploration, plan, implementation, review, troubleshooting, docs, or `N/A`]
- **Human author accountable for this change:** [name/role]
- **Human decision owner(s):** [name/team/role or `N/A`]

AI assistance may accelerate the work. Human authors, decision owners, reviewers, and deployers remain accountable for its meaning, approval, and production impact.

## 3. Decisions, assumptions, and impact

- **Approved decisions / prompt-backs resolved:** [grain, cardinality, source authority, units, null treatment, metric meaning, etc.; link to plan when material]
- **Open decision or follow-up:** [owner and next step, or `None`]
- **Public contract / column / type / grain impact:** [none / compatible / breaking + migration path]
- **Tests and documentation impact:** [added/changed/none]
- **Semantic Layer impact:** [reused / added / changed / `N/A`; consumer impact]
- **Downstream consumer impact:** [dashboards, models, jobs, AI/semantic consumers, or `None known`]
- **Security, access, performance, cost, freshness, or deployment impact:** [assessment or `N/A`]

## 4. Validation evidence

| Check | Command / run / artifact | Result | Notes or follow-up |
|---|---|---|---|
| dbt parse | [command/CI run] | [pass/fail/not run] | |
| Scoped dbt build/test | [selector or dbt Platform run] | [pass/fail/not run] | |
| SQLFluff | [command/CI run] | [pass/fail/not run] | |
| Semantic validation/query | [command/query or `N/A`] | [pass/fail/not run/N/A] | |
| Output/data/grain check | [query/check or `N/A`] | [pass/fail/not run/N/A] | |
| CI / deployment gate | [GitHub/dbt Platform run] | [pass/fail/pending/not run] | |

Do not mark a required check as passed unless its result is available. Explain any `not run`, failure, or pending gate and name the owner/next step.

## 5. Reviewer checklist

- [ ] I understand the requested outcome and changed scope.
- [ ] For material work, the approved plan/design matches the implementation and any deviation is documented.
- [ ] Grain, lineage, join/fanout behavior, and business assumptions are evidenced or have an accountable decision owner.
- [ ] Contracts, casts, tests, descriptions, Semantic Layer impact, and consumer compatibility are appropriate.
- [ ] Required validation evidence is present; failures are resolved or explicitly escalated.
- [ ] Required code owners and accountable humans reviewed the change.
- [ ] No unresolved **must fix before merge** or **needs human decision** findings remain.

Review using `.agents/skills/reviewing-governed-dbt-changes/SKILL.md` and its rubric. Automated or AI review is advisory; it does not replace required human approval or CI gates.
