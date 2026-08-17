# AGENTS.md — governed AI-assisted analytics policy

This file is always-on context for people and AI assistants working in this dbt project. It records the project rules that make AI-assisted changes repeatable, reviewable, and independently verifiable.

**Operating principle:** AI can accelerate implementation. Humans retain decision rights for business meaning, risk, and production accountability. Treat skills, workflows, and this file as version-controlled team policy.

## Project context and authoritative sources

Merlin & Co. Apothecaries is a Snowflake dbt project with pre-built workshop source relations modeled through **staging → intermediate → marts**. The completed `abra_pos` and `grimoire_crm` slices are the implementation patterns. The `alembic_ops` procurement/supply-cost slice is the intentional hands-on build.


Read the appropriate source of truth before proposing or editing a material change:

- Project structure and modeling rationale: `docs/merlinco/STYLE_GUIDE.md`
- Source grain, keys, raw columns, and deliberate quirks: `docs/merlinco/ERD.md` and `docs/merlinco/DATA_DICTIONARY.md`
- Procurement lab target lineage and open business decisions: `docs/merlinco/LAB_procurement_slice.md`
- Existing patterns: authored SQL and properties YAML in `models/staging/`, `models/intermediate/`, and `models/marts/`
- Canonical metrics: `models/marts/_semantic_models.yml` and `models/marts/metrics.yml`
- Task selection: `.agents/ROUTING.md`
- Human decision and evidence record: `.agents/templates/dbt-change-plan.md`
- Sensitive-data and action boundaries: `SECURITY.md`


## Layer rules

| Layer | Path | Materialization | Required behavior |
|---|---|---|---|
| Staging | `models/staging/<source>/` | view | Read exactly one `source()` at a 1:1 grain. Rename, cast, and clean only. No joins or business logic. |
| Intermediate | `models/intermediate/` | ephemeral | Perform joins, fanout control, and grain changes. Keep marts readable. Do not expose this layer directly. |
| Marts | `models/marts/` | table | Expose dimensions and facts only. State grain clearly; enforce contracts; add tests and descriptions; assess Semantic Layer impact. |

Layer rules are always-on project context. Do not create separate skills that merely repeat them.

## Naming, SQL, and reuse

- Models: `stg_<source>__<entity>`, `int_<description>`, `dim_<noun>`, `fct_<noun>`.
- Columns: `snake_case`; PKs use `<entity>_id`; booleans use `is_*`/`has_*`; timestamps use `*_at`; dates use `*_date` or date-typed `*_at`.
- Money: retain raw `*_copper` integers and expose `*_gold` as `number(38, 2)`. Gold is the reporting currency; 100 copper equals one gold crown.
- SQL: use import CTEs for each `source()`/`ref()`, transformation CTEs as needed, a `final` CTE, and `select * from final`. Use lowercase SQL and identifiers.
- Reuse the shared macros. Do not reimplement known cleanup logic inline:
  - `to_boolean(col)` for messy booleans.
  - `copper_to_gold(col)` for copper-to-gold conversion.
  - `conform_region(col)` for CRM region normalization.

## Data products and independent enforcement

Marts are the trusted data products. They must have:

1. An enforced contract in `models/marts/_marts.yml`, with a `data_type` for every column and explicit matching casts in model SQL.
2. Tests: `unique` and `not_null` for every PK; `relationships` for every FK; `accepted_values` for normalized categoricals; `not_null` for required measures/fields.
3. Model and key-column descriptions.
4. Scoped warehouse-backed validation with `dbt build --select +<model>+` and SQLFluff validation for changed SQL.

Use the Semantic Layer for business numbers. Do not introduce an ad hoc competing definition of revenue, orders, AOV, units, supply cost, margin, or another governed metric. Any semantic change must follow the relevant routed skill and include a human-approved business definition.

## Required workflow and evidence

For every material change, follow **Explore → Plan → Implement → Verify**:

1. **Explore:** inspect relevant docs, SQL, YAML, lineage, and data. Do not infer source columns, grain, or metric meaning from names alone.
2. **Plan:** complete `.agents/templates/dbt-change-plan.md` before implementation. The human approves material business and design decisions.
3. **Implement:** make small, reviewable changes that preserve unaffected interfaces and follow layer rules.
4. **Verify:** run the plan’s validation selector; inspect results; record evidence and unresolved follow-up.

Use `.agents/ROUTING.md` to select the appropriate task skill. A specialized skill adds conditional workflow; it does not override this policy.

## Prompt-back and escalation policy

Stop, state the evidence inspected, and ask a focused question before proceeding when any of these is unresolved:

- Intended grain, join cardinality, or fanout behavior.
- System of record or source authority.
- Metric definition, aggregation, time semantics, or conflict with an existing governed metric.
- Business classification, null treatment, unit conversion, or status mapping.
- Breaking public interface: mart contract/column/type, semantic entity, or downstream consumer behavior.
- Sensitive-data, credential, permission, or action-authority boundary.
- Material performance, cost, materialization, freshness, or deployment tradeoff not already encoded in project policy.

A prompt-back must include the decision needed, evidence inspected, viable options and implications, and the narrowest question required to proceed.

## Safe operating boundaries

- Never commit credentials, connection secrets, tokens, or private data extracts.
- Never edit generated or vendored content such as `target/`, `logs/`, or `dbt_packages/` as a durable fix.
- Never bypass contracts, tests, CI, or review to make a build pass.
- Never run destructive or production-impacting actions without explicit human approval and the required platform permissions.
- Never present an unsupported assumption as confirmed fact.

See `SECURITY.md` for the reusable data-handling and escalation template.

## Governance upkeep

- Shared governance assets require code review by their documented owners.
- Review skills, workflows, templates, and this policy when project conventions, platform capabilities, incidents, or repeated review findings change.
- Retire or merge redundant skills. Keep skills task-oriented and references current.
- Record validation evidence and AI-assistance context in the pull request template.
