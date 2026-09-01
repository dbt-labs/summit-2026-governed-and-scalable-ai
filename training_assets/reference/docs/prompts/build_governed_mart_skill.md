# Trainer prompt: build the governed-mart authoring skill

Copy and submit this prompt after attendees complete the mart-layer decision canvas.

```text
Use `building-governed-skills` to create a reusable execution skill at:

`.agents/skills/authoring-governed-marts/SKILL.md`

Outcome:

Govern creating or materially changing a public dimension or fact.

Our output invariants:

- Give every mart one explicit approved public grain and key using the configured mart materialization.
- Use the simplest approved upstream input; keep multi-input joins, fanout control, deduplication, and substantial aggregation in intermediate.
- Publish exactly the approved columns in the approved order with explicit SQL casts matching contract data types.
- Enforce the mart contract and enumerate every public column with the exact approved tests and arguments.
- Document grain, business meaning, units, null behavior, and material limitations.
- Do not add convenience columns, metrics, semantic objects, or calculations outside the approved spec.
- Inspect existing semantic definitions and consumers before changing a public interface.

Human decision boundary:

- Stop when grain, public columns, business meaning, units, null treatment, or semantic scope lacks approval.
- Stop when a breaking interface change has no approved migration path.
- Stop when implementation requires an unplanned upstream model, multi-input mart join, or material cost/performance decision.

Completion evidence:

- A scoped dbt build executes the mart, enforced contract, and attached tests.
- SQL output order and casts exactly match the approved properties contract.
- Warehouse checks prove public grain, key behavior, retention, relationships, accepted values, required fields, and approved calculations.
- No unplanned public or semantic interface is introduced.

Primary owner: analytics engineering, with the accountable data-product owner approving public meaning and interface decisions.
```
