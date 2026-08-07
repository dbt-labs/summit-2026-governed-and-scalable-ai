# Mart contract and test checklist

## Purpose and layer fit

- [ ] The mart’s business purpose and grain are stated as “one row per …”.
- [ ] The mart reads one upstream model whenever possible.
- [ ] A simple 1:1 dimension may project one staging model; all joins, aggregations, dedupe, fanout control, and grain changes occur in intermediate.
- [ ] The model name follows `dim_` or `fct_` naming.

## Public interface and contract

- [ ] Every public column has a deliberate name, type, and description.
- [ ] SQL explicitly casts every public column to its declared contract type.
- [ ] The properties YAML declares `contract: {enforced: true}` and `data_type` for every column.
- [ ] Existing column names, types, grain, semantic entities, and downstream interfaces were checked for breaking impact.
- [ ] A migration plan exists if a public interface changes.

## Tests and semantics

- [ ] Every PK has `unique` and `not_null`.
- [ ] Every FK has a grounded `relationships` test.
- [ ] Normalized categoricals have `accepted_values`.
- [ ] Required measures/fields have `not_null` where appropriate.
- [ ] The Semantic Layer was checked for an existing definition and updated through the metric skill when required.

## Evidence

- [ ] Output grain, row counts, keys, relationship coverage, nulls, and categorical values were checked.
- [ ] Contract and data tests passed in a scoped build.
- [ ] SQLFluff passed for changed SQL.
- [ ] Consumer and downstream impact was recorded.
- [ ] Any unresolved metric, interface, null-policy, or performance decision was prompted back.
