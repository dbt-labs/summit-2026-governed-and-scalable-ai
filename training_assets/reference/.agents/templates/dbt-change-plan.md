# dbt change plan

> Complete this plan before implementing a material change. Keep it concise and evidence-based. Replace every bracketed prompt; use `N/A` with a reason when a section does not apply.

## 1. Request and intended outcome

- **Request:** [What is being asked?]
- **Business outcome:** [What decision, product, or user need does this support?]
- **Owner approving business decisions:** [Name/team/role]
- **Affected consumers:** [Dashboards, semantic consumers, downstream models, jobs, teams, or `None known`]

## 2. Evidence inspected during Explore

| Evidence | Path/query/run | What it established |
|---|---|---|
| Project/domain documentation | [path] | [finding] |
| Source/upstream model and YAML | [path] | [columns, grain, keys, quirks] |
| Existing pattern/model | [path] | [convention reused] |
| Downstream lineage/interface | [selector/path] | [impact] |
| Data profile or sample | [query/command] | [nulls, values, cardinality, or `N/A` with reason] |
| Existing governed metric/semantic definition | [path] | [reuse/conflict/no existing definition] |

## 3. Target design

| Target | Layer | Intended grain | Inputs | Key transformations / joins | Public interface impact |
|---|---|---|---|---|---|
| [model/asset] | [staging/intermediate/mart/semantic/etc.] | [one row per …] | [sources/refs] | [summary and expected cardinality] | [new/compatible/breaking/N/A] |

- **Reusable macros/patterns:** [macros or existing models to reuse]
- **Materialization/performance decision:** [decision and rationale, or `N/A`]
- **Contract and documentation impact:** [models/columns/descriptions/types]
- **Data-test impact:** [PK/FK/categorical/required-value tests]
- **Semantic Layer impact:** [existing metric reused, proposed definition, or `N/A`]

## 4. Human decisions and explicit assumptions

| Decision or assumption | Evidence/options | Decision owner | Approved outcome / status |
|---|---|---|---|
| [grain, unit conversion, null treatment, metric meaning, source authority, etc.] | [what was inspected and viable options] | [name/team/role] | [approved / pending prompt-back] |

Do not implement while a material decision is `pending prompt-back`.

## 5. Risk and governance review

- **Data classification/access check:** [public/internal/restricted/secret; approved tool/context]
- **Breaking-change assessment:** [none / describe interface and migration plan]
- **Downstream/consumer impact:** [none known / describe]
- **Security or action boundary:** [none / approval or escalation required]
- **Rollback/remediation approach:** [how to revert or contain if validation fails]

## 6. Acceptance criteria and validation plan

| Criterion | Validation command/check | Expected evidence |
|---|---|---|
| [model behavior/grain] | [command/query/check] | [expected result] |
| [contract/tests] | [dbt build selector] | [passing nodes/tests] |
| [SQL style] | [sqlfluff command] | [no violations] |
| [semantic metric, if applicable] | [semantic validation/query] | [expected definition/result] |
| [downstream compatibility, if applicable] | [selector/check] | [expected result] |

## 7. Verification evidence

Complete after implementation.

| Check run | Result | Evidence/artifact | Notes or follow-up |
|---|---|---|---|
| [command/check] | [pass/fail] | [run ID, artifact, result summary] | [notes] |

- **Plan deviations:** [none / describe and obtain approval]
- **Remaining limitations or follow-up:** [none / describe owner and next step]
- **Ready for review:** [yes/no and why]
