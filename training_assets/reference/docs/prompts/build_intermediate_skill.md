# Trainer prompt: build the intermediate authoring skill

Copy and submit this prompt after attendees complete the intermediate-layer decision canvas.

```text
Use `building-governed-skills` to create a reusable execution skill at:

`.agents/skills/authoring-intermediate-models/SKILL.md`

Outcome:

Govern creating or materially changing a model that owns joins, deduplication, aggregation, fanout control, enrichment, or another grain change.

Our output invariants:

- Declare every input with `ref()` and preserve the configured intermediate materialization.
- Make input grain, output grain, key, join cardinality, record retention, and fanout control explicit before writing SQL.
- Keep joins, deduplication, aggregation, and grain changes in intermediate rather than public marts.
- Block many-to-many joins unless an approved bridge, allocation, or aggregation strategy exists.
- Aggregate at the exact approved grain and require evidence-backed keys and deterministic ordering for deduplication.
- When an approved build spec exists, match its refs, joins, formulas, output columns, properties, and tests.
- Never invent join keys, retention rules, allocations, null treatment, unit conversion, or business formulas.

Human decision boundary:

- Stop when available keys or cardinalities cannot support the requested output grain.
- Stop when retention, deduplication priority, allocation, null treatment, units, or formulas lack approval.
- Stop when a many-to-many join or materialization/cost tradeoff lacks an approved control.

Completion evidence:

- A scoped dbt build exercises the intermediate logic through an executable selected node.
- Warehouse checks prove output grain, key uniqueness, retention, join match rates, and absence of fanout.
- Approved arithmetic, null behavior, SQL output, and properties YAML reconcile to the build spec.

Primary owner: analytics engineering.
```
