# Staging model checklist

## Source grounding

- [ ] Source declaration, raw-table grain, key, and important FKs were inspected.
- [ ] Actual source values were profiled when type, null, casing, timestamp, boolean, money, or category behavior matters.
- [ ] The source model name follows `stg_<source>__<entity>`.
- [ ] The model reads exactly one `source()`.

## Layer boundary

- [ ] The model preserves one row per raw source row.
- [ ] No joins, cross-record deduplication, aggregation, reporting logic, or metric calculation appears in staging.
- [ ] Renames, casts, format cleanup, and conformance belong at this layer.
- [ ] Shared macros are reused for known cleanup patterns.

## Data product hygiene

- [ ] Key fields, booleans, dates/timestamps, and money fields use project naming and types.
- [ ] Raw money integers are retained and the reporting-currency field is exposed when applicable.
- [ ] Normalized categorical fields have grounded accepted values where appropriate.
- [ ] Source and staging descriptions explain grain/meaning rather than restating names.

## Evidence

- [ ] Source and staging tests cover the key and material data-quality rules.
- [ ] Output was checked for row count, key uniqueness, nulls, casts, and category normalization.
- [ ] Scoped build and SQLFluff results are recorded.
- [ ] Any unresolved business mapping, unit conversion, null policy, or source-authority question was prompted back.
