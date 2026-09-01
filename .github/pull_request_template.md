# Governed dbt change

> Keep this record concise and evidence-based. Link the applicable approved project-owned artifact for material work; for the governed source-to-mart exercise, link the approved build spec with its completed `verification` section. Do not paste restricted data, credentials, or private extracts.

## 1. Change summary

- **What changed:**
- **Why / intended business outcome:**
- **Affected assets:** [models, YAML, macros, semantic definitions, jobs/configuration, governance files]
- **Approved artifact / issue:** [link or `N/A — documentation-only or clearly non-material`]

## 2. AI assistance and human accountability

- **AI assistance:** [none / Wizard / approved tool]
- **How AI assisted:** [exploration, planning, implementation, review, troubleshooting, docs, or `N/A`]
- **Human author accountable for this change:** [name/role]
- **Human decision owner(s):** [name/team/role or `N/A`]

AI assistance may accelerate the work. Human authors, decision owners, reviewers, and deployers remain accountable for meaning, approval, and production impact.

## 3. Decisions, deviations, and impact

- **Approved decisions / prompt-backs resolved:** [grain, cardinality, source authority, units, null treatment, metric meaning, etc.; link to approved artifact when applicable]
- **Approved deviations from the artifact:** [recorded deviation or `None`]
- **Open decision or follow-up:** [owner and next step, or `None`]
- **Public contract / column / type / grain impact:** [none / compatible / breaking + approved migration path]
- **Tests and documentation impact:** [added/changed/none]
- **Semantic Layer impact:** [reused / added / changed / deferred / `N/A`; consumer impact]
- **Downstream consumer impact:** [dashboards, models, jobs, AI/semantic consumers, or `None known`]
- **Security, access, performance, cost, freshness, deployment, or rollback impact:** [assessment or `N/A`]

## 4. Validation evidence

| Check | Command / run / approved artifact | Result | Notes or follow-up |
|---|---|---|---|
| dbt parse | [command/CI run] | [pass/fail/not run] | |
| Scoped dbt build/test/contracts | [selector or dbt Platform run] | [pass/fail/not run] | |
| SQL lint / supported CI lint | [command/CI run] | [pass/fail/not run] | |
| Warehouse grain/data/arithmetic checks | [query/check or `N/A`] | [pass/fail/not run/N/A] | |
| Semantic validation/query | [command/query or `N/A`] | [pass/fail/not run/N/A] | |
| Production/downstream comparison | [command/result or `N/A`] | [pass/fail/not run/N/A] | |
| Approved artifact verification | [spec section or `N/A`] | [pass/fail/not run/N/A] | |
| CI / deployment gate | [GitHub/dbt Platform run] | [pass/fail/pending/not run] | |

Do not mark a required check as passed unless its result is available. Explain any failure, `not run`, `N/A`, or pending gate and name the owner/next step.

## 5. Governed review

- [ ] I understand the requested outcome, changed scope, and applicable approved artifact.
- [ ] For material work, implementation inventory, lineage, grain, columns, logic, properties, tests, contracts, and semantic scope match the approved artifact.
- [ ] Any deviation is explicitly approved and recorded in the approved artifact.
- [ ] Grain, join/fanout behavior, retention, nulls, units, formulas, and business meaning are evidenced or assigned to an accountable decision owner.
- [ ] Contracts, casts, tests, descriptions, semantic impact, consumers, and migration behavior are appropriate.
- [ ] Required execution and warehouse evidence is present and agrees with the artifact's verification status.
- [ ] Required code owners and accountable humans reviewed the change.
- [ ] No unresolved **must fix before merge** or **needs human decision** findings remain.

Review using `.agents/skills/reviewing-governed-dbt-changes/SKILL.md` and its rubric. Automated or AI review is advisory and does not replace required human approval or independent CI/platform gates.
