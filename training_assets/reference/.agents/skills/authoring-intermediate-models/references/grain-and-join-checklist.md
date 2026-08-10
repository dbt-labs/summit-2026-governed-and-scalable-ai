# Intermediate grain and join checklist

## Grain first

- [ ] The intended output grain is stated as “one row per …”.
- [ ] Each upstream input grain and key was inspected from SQL/YAML/data.
- [ ] The final select preserves the intended grain.
- [ ] The model name describes the transformation or resulting context.

## Join safety

- [ ] Every join has an expected cardinality: 1:1, 1:many, many:1, or many:many.
- [ ] A potentially fanout-producing join has an explicit control: pre-aggregation, dedupe, filtering, bridge semantics, or a documented acceptable fanout.
- [ ] Latest-record/deduping logic has a deterministic ordering and an approved business rule.
- [ ] Inner versus outer joins reflect an approved record-retention policy.
- [ ] Nulls produced by joins have intentional handling.

## Layer fit

- [ ] Raw casting/cleanup remains in staging.
- [ ] Joins, rollups, enrichments, and grain changes live here.
- [ ] The downstream mart can consume one intermediate input rather than repeat this logic.
- [ ] Public contract casts, consumer interface decisions, and governed metrics remain downstream.

## Evidence

- [ ] Model documentation states grain and transformation purpose.
- [ ] Key/grain tests and targeted risk tests are present.
- [ ] Row counts and uniqueness were compared to expected inputs.
- [ ] Aggregate totals or join coverage were checked where relevant.
- [ ] Scoped build and SQLFluff results are recorded.
- [ ] Any unresolved cardinality, business rule, or performance decision was prompted back.
