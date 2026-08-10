# Source-to-target design

> Complete this design before onboarding a new source system or materially extending one. It supplements the generic `dbt-change-plan.md` with source-system and layer decisions. Replace every bracketed prompt; use `N/A` with a reason where a section does not apply.

## 1. Source system and business outcome

- **Source system:** [name]
- **Business owner / source owner:** [name/team/role]
- **Business purpose:** [why this system is being modeled]
- **Requested data products or decisions enabled:** [dimensions, facts, governed metrics, consumers]
- **Data classification and approved environment:** [classification/tool/access confirmation]
- **Affected existing models or consumers:** [models, metrics, dashboards, jobs, or `None known`]

## 2. Raw-source inventory and evidence

| Raw table | Business grain | Primary/natural key | Important FKs | Known quirks/nulls | Source/YAML/data evidence inspected |
|---|---|---|---|---|---|
| [raw table] | [one row per …] | [key] | [keys] | [formats, casing, nulls, units] | [paths/query] |

- **Source authority and freshness assumptions:** [owner, authoritative system, freshness/SLA, or `unknown—prompt back`]
- **Existing source-system patterns reused:** [analogous sources/models/macros]

## 3. Staging design

Create one row per raw table. Each staging model reads exactly one `source()` and preserves its raw-table grain.

| Raw table | Staging model | Casts/renames/cleanup | Shared macros | Source/staging tests | Open decision |
|---|---|---|---|---|---|
| [raw table] | `stg_<source>__<entity>` | [details] | [macros] | [PK/accepted values/not null] | [decision or `none`] |

## 4. Intermediate design

Add an intermediate only when a join, deduplication, fanout control, aggregation, or grain change is required.

| Intermediate model | Intended grain | Inputs | Join/cardinality or aggregation | Fanout/deduping control | Consumers |
|---|---|---|---|---|---|
| `int_<description>` | [one row per …] | [refs] | [logic] | [proof/strategy] | [marts/intermediates] |

State why each intermediate exists: [reason].

## 5. Mart design

Public marts should consume a single upstream model whenever possible. A simple one-to-one dimension may project a staging model; a mart that needs joins, aggregation, dedupe, fanout control, or grain changes must consume an intermediate.

| Mart | Type | Intended grain | Upstream input | Contract and key tests | Relationships/categoricals | Consumer impact |
|---|---|---|---|---|---|---|
| `dim_` / `fct_` | [dimension/fact] | [one row per …] | [one ref] | [PK/type/not null] | [FK/accepted values] | [new/compatible/breaking] |

## 6. Semantic-layer design

Complete only when a governed entity, dimension, measure, or metric is added or changed.

| Semantic asset | Definition and grain | Source mart/column | Time semantics | Consumer/metric conflict check | Decision owner |
|---|---|---|---|---|---|
| [entity/dimension/measure/metric] | [definition] | [source] | [time dimension] | [existing/reuse/conflict] | [owner] |

## 7. Human decisions and prompt-backs

| Decision needed | Evidence and options | Decision owner | Status / approved outcome |
|---|---|---|---|
| [unit conversion, null policy, grain, metric definition, source authority, etc.] | [evidence/options] | [role] | [pending/approved] |

Do not proceed past a material unresolved decision.

## 8. Implementation and validation plan

| Layer / artifact | Skill or workflow invoked | Implementation order | Validation | Expected evidence |
|---|---|---|---|---|
| Staging | `authoring-staging-models` | [order] | [build/test/show] | [result] |
| Intermediate | `authoring-intermediate-models` | [order or `N/A`] | [build/test/show] | [result] |
| Marts | `authoring-governed-marts` | [order] | [build/contracts/tests] | [result] |
| Semantic | `authoring-governed-metrics` | [order or `N/A`] | [semantic validation] | [result] |

- **Final build selector:** [e.g. `dbt build --select +fct_<name> +dim_<name>`]
- **SQLFluff scope:** [files/path]
- **Review/PR evidence required:** [plan, tests, compare, owner approvals]
- **Rollback or containment:** [approach]
