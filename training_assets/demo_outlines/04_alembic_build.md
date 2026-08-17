# Demo 04 — Build and validate the Alembic source-to-mart path

## Audience outcome and takeaway

**Audience outcome:** Participants can use the governed source workflow and routed layer skills to implement a multi-layer dbt change that matches an approved plan and proves its grains, contracts, tests, and business assumptions with warehouse-backed evidence.

**One-sentence takeaway:** Once intent and decision rights are explicit, Wizard can build quickly—but the trusted outcome comes from layer boundaries, contracts, tests, and result checks rather than generated SQL alone.

## Position in the throughline and timing

- **Order:** 04 of 07
- **Target time:** 30 minutes
- **Delivery mode:** Guided code-along
- **Participant mode:** Prompt, approve edits, inspect diffs, and review validation evidence
- **Starts from:** Completed governance assets plus approved Alembic source-to-target design/change plan; no active procurement solution
- **Ends with:** Validated procurement staging, intermediates, `dim_suppliers`, and `fct_brews`; optional approved semantic extension only if time permits

### Timing budget

| Time | Beat |
|---:|---|
| 0:00–3:00 | Reconfirm plan, lineage, grains, and decisions |
| 3:00–10:00 | Build four staging models and staging YAML |
| 10:00–16:00 | Build two intermediates and validate grains |
| 16:00–23:00 | Build contracted marts and tests |
| 23:00–27:00 | Run output checks and review evidence |
| 27:00–29:00 | Optional governed brew semantic extension or prepared result walkthrough |
| 29:00–30:00 | Mark plan ready for review and transition |

## Setup and prerequisites

### Exact starting repository state

Required active governance artifacts from demos 02–03:

- final `AGENTS.md` and `.agents/ROUTING.md`;
- governed-change and source-onboarding workflows;
- dbt change plan and source-to-target design;
- staging, intermediate, governed-mart, and governed-metrics skills/checklists;
- approved unit, cost, duration-null, and semantic-scope decisions.

Required dbt state:

- raw source relations are pre-built;
- Alembic source YAML and `stg_alembic_ops__shops` exist;
- procurement solution models are absent;
- existing Abra POS and CRM models provide patterns;
- disabled `models/answer_key/` is not used as implementation input.

### Approved target lineage

```text
stg_alembic_ops__potion_ingredients
+ stg_alembic_ops__ingredients
  -> int_potion_supply_cost              -- one row per potion SKU

stg_alembic_ops__brew_events
+ int_potion_supply_cost
  -> int_brews_with_supply_cost          -- one row per brew batch

stg_alembic_ops__suppliers
  -> dim_suppliers                       -- one row per supplier

int_brews_with_supply_cost
  -> fct_brews                           -- one row per brew batch
```

Staging also includes `stg_alembic_ops__suppliers`, `stg_alembic_ops__ingredients`, `stg_alembic_ops__potion_ingredients`, and `stg_alembic_ops__brew_events`.

### Why two intermediates

Do not let `fct_brews` join brew events directly to potion cost. That would place multi-input enrichment in the public mart. `int_brews_with_supply_cost` owns the join and preserves a simple one-upstream mart interface.

### Fallback plan

Prepare checkpoint commits or patches for:

1. staging complete;
2. intermediates complete;
3. marts complete; and
4. validation evidence plus optional semantic YAML.

If a warehouse build exceeds the live budget, move to the next checkpoint and show the saved command result. Clearly label saved evidence with its branch/commit and run time.

## Facilitator script starters and slide beats

### 1. Reconfirm the contract before editing

Open the source-to-target design and plan.

> “We are not asking Wizard to invent the architecture now. We are asking it to implement an approved architecture and produce the evidence named in the plan.”

Restate:

- supplied-unit calculation without conversion;
- estimated standard cost terminology;
- preserved null duration;
- staging raw-grain rule;
- two named intermediates;
- simple mart inputs; and
- margin out of scope.

### 2. Build staging from actual source columns

For each raw table, require Wizard to inspect source YAML/data before writing SQL.

Expected staging behavior:

| Model | Key behavior |
|---|---|
| suppliers | Cast ID/name/rating/date; preserve source grain |
| ingredients | Normalize unit casing; use `to_boolean`; expose copper and gold standard unit cost |
| potion ingredients | Normalize unit; cast quantity; preserve composite recipe grain |
| brew events | Parse/cast timestamps and numerics; normalize quality status; preserve null duration |

Expected tests include PKs, relevant FKs, accepted values, and composite recipe uniqueness. No `not_null` test on `brew_duration_minutes`.

### 3. Build and prove intermediate grains

`int_potion_supply_cost`:

- joins recipe components to ingredients;
- calculates supplied quantity × standard unit cost;
- aggregates to one row per potion SKU;
- exposes ingredient count and potion standard cost.

`int_brews_with_supply_cost`:

- joins brew events to potion-grain cost;
- preserves one row per brew ID;
- calculates batch size × potion standard cost;
- retains all brew attributes including null duration.

> “Intermediate models are not clutter. They name and test the cardinality-changing decisions the mart should not hide.”

### 4. Build public marts

`dim_suppliers` may project one staging model with explicit public casts.

`fct_brews` must project only `int_brews_with_supply_cost`, with explicit casts for every contracted column.

Review:

- model descriptions state grain and cost meaning;
- public types align with SQL casts;
- PK/FK tests are present;
- accepted quality/region/rating values are tested;
- cost fields are required;
- duration remains nullable; and
- Semantic Layer impact is recorded.

### 5. Inspect results, not just commands

Show output checks for:

- source/staging row preservation;
- potion-cost uniqueness;
- brew-fact uniqueness;
- null duration preservation;
- non-null estimated cost;
- accepted quality values; and
- arithmetic consistency.

## Exact Wizard prompts and commands

### Prompt A — implement staging

```text
Follow the approved Alembic source-to-target design, governed-change plan, source-onboarding workflow, and active staging skill. Inspect the actual Alembic source YAML, source columns/profiles, existing staging patterns, and shared macros. Create the four missing one-source staging models and update their properties YAML. Preserve raw-table grain, normalize only approved values, reuse to_boolean and copper_to_gold, keep brew_duration_minutes nullable, and add grounded key/FK/categorical tests. Do not use models/answer_key and do not implement intermediates or marts yet. Validate the staging scope and record evidence in the plan.
```

### Staging validation

```text
dbt build --select +stg_alembic_ops__brew_events+
```

For recipe relationships, use the widened local selector when necessary:

```text
dbt build --select +stg_alembic_ops__potion_ingredients+ stg_alembic_ops__ingredients stg_alembic_ops__suppliers
```

Explain that a relationship-test target may need explicit selection even when it is not a DAG ancestor of the model under test.

### Prompt B — implement intermediates

```text
Using the approved design and active intermediate skill, create int_potion_supply_cost at one row per potion SKU and int_brews_with_supply_cost at one row per brew ID. Ground every selected column in the staging models. Put all joins and aggregation here, control fanout explicitly, calculate costs only as supplied, and preserve nullable duration. Update intermediate YAML with meaningful descriptions and targeted grain/required-value tests. Do not create marts until the intermediate build and grain checks pass.
```

### Intermediate validation

```text
dbt build --select +int_brews_with_supply_cost+
```

Representative output-check request:

```text
Use dbt show to verify one row per potion SKU in int_potion_supply_cost and one row per brew ID in int_brews_with_supply_cost. Check ingredient-count range, null cost counts, preserved null duration count, and sample batch_supply_cost_gold = batch_size * potion_supply_cost_gold arithmetic. Do not add SQL LIMIT clauses; use the dbt show limit option for samples.
```

### Prompt C — implement marts

```text
Using the approved plan and active governed-mart skill, create dim_suppliers from one staging input and fct_brews from int_brews_with_supply_cost only. Add explicit public casts, enforced contracts, complete column types, descriptions, PK/FK/categorical/required-field tests, and the approved estimated-standard-cost and nullable-duration wording. Preserve every approved output column and do not define margin. Validate with the planned scoped build and inspect representative output.
```

### Mart validation

```text
dbt parse
dbt build --select +fct_brews +dim_suppliers
```

Representative result-check request:

```text
Use dbt show to verify fct_brews row count equals distinct brew_id count, null duration is preserved, batch_supply_cost_gold is non-null, quality values are canonical, and sample cost arithmetic matches. Verify dim_suppliers row count equals distinct supplier_id count and required region/rating fields are populated. Record query evidence and any tool retries separately from data findings.
```

### SQL style

Run SQLFluff on changed Alembic SQL through the environment’s supported lint/CI path. If live SQLFluff is unavailable, show the prepared CI result and record the limitation rather than claiming it ran.

### Optional semantic extension

Only if the mart build and decisions are complete:

```text
Follow the completed governed-metrics skill. Add a latest-spec semantic model to fct_brews using brewed_date as the day-grain aggregation time, brew_id as the primary entity, and potion/shop as foreign entities. Add only the approved core brew metrics: batch count, units brewed, estimated standard batch supply cost in gold, passed-batch count, and average observed duration with null observations excluded from that average. Do not add margin. Run dbt parse, dbt sl validate, the underlying mart build, and representative semantic queries.
```

If time is short, defer this implementation and show only how the approved decisions make it safe to do later.

## Human decision checkpoint and expected artifacts

### In-demo checkpoints

Stop if implementation reveals:

- a source column not in the approved design;
- an unexpected unit family;
- missing potion cost after the join;
- duplicate potion or brew grains;
- a contract type not supported by explicit SQL casts;
- a desire to add or remove a public column; or
- a performance/materialization tradeoff outside project policy.

The facilitator/business owner decides whether to update the plan, narrow scope, or block the build.

### Expected artifacts

- Four active Alembic staging SQL models and updated staging YAML.
- `int_potion_supply_cost.sql`.
- `int_brews_with_supply_cost.sql`.
- Updated intermediate YAML.
- `dim_suppliers.sql` and `fct_brews.sql`.
- Updated mart YAML with enforced contracts/tests/descriptions.
- Completed verification-evidence section in the change plan.
- Optional governed semantic metadata/metrics only if fully validated.

## Validation and evidence to show

Minimum completion evidence:

- staging builds/tests pass;
- intermediate build passes with expected ephemeral no-op statuses;
- potion and brew grains are unique;
- mart contracts and tests pass;
- cost arithmetic is sampled and correct under the approved assumption;
- null duration is preserved;
- no invalid quality values remain;
- SQLFluff/CI evidence is recorded; and
- plan deviations and tool retries are documented.

Do not call the lab complete on `dbt compile` or `dbt parse` alone.

## Convergence map

| Approved target | Layer skill | Required evidence | Target implementation | Facilitator comparison |
|---|---|---|---|---|
| Four raw-table cleanup models | Staging | Source YAML/data, raw grains, values | Four one-source views plus tests | `models/answer_key/staging/*__expected.sql` |
| Potion standard supply cost | Intermediate | Recipe/ingredient cardinality and unit policy | One row per potion SKU | Expected intermediate model |
| Brew enrichment | Intermediate | Many-to-one cost join and brew retention | One row per brew ID | Expected brew intermediate |
| Supplier product | Governed mart | Supplier grain and public contract | `dim_suppliers` | Expected dimension |
| Brew product | Governed mart | Brew grain, explicit casts, cost/null policy | `fct_brews` | Expected fact |
| Core brew metrics | Governed metrics | Built mart and approved definition | Optional semantic extension | Governed-metrics checklist |

The answer key is used only by the facilitator after participant implementation. Compare architecture, grain, and controls rather than copying SQL text.

## Common failures and recovery

| Failure | Recovery |
|---|---|
| Relationship test target is missing in a scoped build | Add the parent relation explicitly to the selector; do not dismiss the test. |
| `fct_brews` contains the cost join | Move the join to `int_brews_with_supply_cost` and restore the mart’s one-input interface. |
| Wizard invents columns | Re-read actual upstream SQL/YAML/data, repair the select list, and rerun the scoped build. |
| Duration receives a `not_null` test or imputation | Remove it and restore the approved null-preservation decision. |
| Cost is labeled actual | Rename descriptions/metrics to estimated standard cost and re-review consumer meaning. |
| A build is too slow for the session | Switch to the prepared checkpoint and saved evidence; do not skip result interpretation. |
| A 429/tool error occurs | Retry sequentially and record it as a tool limitation, not a failed data assertion. |
| Semantic validation fails | Keep the mart deliverable, record semantic follow-up, and do not claim the metric is published. |

## Transition to demo 05

> “We now have a change that looks complete and has passing evidence. Next we’ll review a deliberately flawed change to prove that policy and independent enforcement still matter regardless of who—or what—authored it.”

## Companion-session callout

After the optional semantic extension, point to the **Semantic Layer workshop** for deeper metric types, semantic joins, time behavior, and downstream consumption.
