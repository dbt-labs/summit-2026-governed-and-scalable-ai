# Demo 8 — How to review

## Summary

Teach trainees to evaluate the Wizard implementation against approved intent and independent evidence. Introduce the ready governed-review skill as the final handoff from the build orchestrator.

## Slide validation checklist

- Compiles and executes through the planned scoped build.
- Produces the expected grain and preserves approved populations.
- Tests and enforced contracts pass.
- Documentation states grain, units, null behavior, formulas, and limitations.
- SQL outputs, YAML properties, and the approved spec agree exactly.
- Warehouse checks prove cardinality, retention, accepted values, and arithmetic.
- The diff is bounded and reviewable.
- Human approval and independent controls remain visible.

## Relevant files

- `docs/merlinco/ALEMBIC_BUILD_SPEC.yml`
- `models/wizard/`
- `.agents/skills/reviewing-governed-dbt-changes/SKILL.md`
- `.agents/skills/reviewing-governed-dbt-changes/references/review-rubric.md`
- `.github/pull_request_template.md`
- `.github/CODEOWNERS`

## Prompt

```text
Use `reviewing-governed-dbt-changes` to review the completed Wizard implementation against `docs/merlinco/ALEMBIC_BUILD_SPEC.yml`. Inspect the actual SQL/YAML, lineage, contracts, tests, verification evidence, and diff. Classify every finding as must fix before merge, needs human decision, or suggestion, and give an explicit review outcome. Do not use facilitator references or answer-key models as review authority, silently redesign the implementation, or claim evidence that is not present.
```

## dbt commands and evidence

The review should verify the recorded commands rather than rerun an expensive build without reason:

```text
dbt parse --no-partial-parse
dbt build --select +fct_brews +dim_suppliers
dbt lint --select path:models/wizard --format human
```

Use current run evidence, contracts/tests, and warehouse findings from the spec. Rerun only the narrow check needed to resolve a review finding.

## Talking points

- Review asks “does this match approved intent?”, not “does this SQL look plausible?”
- Passing tests cannot excuse an extra column, changed formula, or unapproved lineage edge.
- Missing business authority is a human decision; a demonstrated defect is a must-fix; preferences are suggestions.
- Contracts, tests, lint, CI, review, and code owners are author-independent controls.
- The completed spec makes the change easier to review because decisions and evidence are colocated.

## Exit state

Trainees can use the review skill and rubric to produce an evidence-backed outcome and explain what still requires accountable human approval before merge.
