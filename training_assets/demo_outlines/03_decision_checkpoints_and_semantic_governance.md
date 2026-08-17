# Demo 03 — Human decision checkpoints and semantic governance

## Audience outcome and takeaway

**Audience outcome:** Participants can recognize when project evidence is insufficient to determine business meaning, present viable options, obtain a focused human decision, and record that decision for both model and semantic work.

**One-sentence takeaway:** Good AI governance is visible in the moment the assistant stops—before an unsupported unit, cost, null, or margin assumption becomes code or a metric.

## Position in the throughline and timing

- **Order:** 03 of 07
- **Target time:** 12 minutes
- **Delivery mode:** Facilitator-led decision exercise
- **Participant mode:** Inspect evidence, discuss options, approve decisions, and refine the semantic checklist
- **Starts from:** Completed demo 02 governance system; Alembic models still absent
- **Ends with:** Approved Alembic decisions recorded in the source-to-target design/change plan and a completed governed-metrics skill/checklist

### Timing budget

| Time | Beat |
|---:|---|
| 0:00–2:00 | Invoke the source workflow and review evidence gaps |
| 2:00–6:30 | Decide unit comparability, cost meaning, and duration null treatment |
| 6:30–8:30 | Decide what may become a governed metric; defer margin |
| 8:30–10:30 | Refine semantic skill/checklist and record approvals |
| 10:30–12:00 | Verify no unsupported decision remains and transition to build |

## Setup and prerequisites

### Exact starting repository state

Demo 02 has produced:

- final-form `AGENTS.md` and routing;
- source-onboarding workflow;
- source-to-target design template;
- staging, intermediate, and governed-mart skills/checklists; and
- unchanged ready governed-change workflow and plan template.

The governed-metrics skill/checklist still contains starter `TODO(training)` markers.

The Alembic implementation remains absent. Raw relations are pre-built and available through declared sources.

### Evidence to prepare

Have these facts ready from project docs and source profiling:

- Recipe and ingredient unit values use the same families but mixed casing.
- No approved cross-unit conversion table exists.
- Ingredient records provide standard unit cost; recipe records provide required quantities.
- No batch-specific purchase, consumption, or inventory-valuation source exists.
- `brew_duration_minutes` contains source nulls.
- Brew events include batch size, potion, shop, quality, brewer, and event time.
- Order/sales facts exist, but no approved allocation joins production batches to sold units.

Use actual warehouse profiles if time permits. Keep prepared results as the fallback.

### Fallback plan

If warehouse profiling is slow or rate-limited, use prepared aggregate/distinct-value output. State clearly that the output is recorded evidence from the workshop dataset, not a live result. Do not convert a tool failure into a data conclusion.

## Facilitator script starters and slide beats

### 1. Invoke the stop condition

Ask Wizard to begin the source-to-target plan, not implementation. A successful governed response should identify unresolved decisions rather than silently selecting formulas.

> “The important behavior is not that Wizard knows the answer. It is that Wizard knows which answer it does not own.”

### 2. Decide unit treatment

Present the evidence:

- Ingredient and recipe units normalize to `bundle`, `dram`, `gram`, `pinch`, `sprig`, and `vial`.
- Casing differs.
- There is no conversion authority.

Options:

| Option | Implication |
|---|---|
| Normalize casing and calculate quantities as supplied | Supports a standard-cost estimate while explicitly assuming comparable supplied units |
| Block until a conversion map is approved | Strongest semantic assurance; prevents workshop cost calculation |
| Exclude unmatched or cross-unit records | Produces partial cost and requires an approved exclusion policy |

**Workshop decision:** Normalize casing and calculate quantities as supplied; perform no cross-unit conversion. Record the assumption prominently.

### 3. Decide cost meaning

Present the source boundary:

- recipe quantity × ingredient standard unit cost is available;
- batch size is available;
- actual purchased price, actual consumed quantity, waste, and batch-specific inventory cost are not.

Options:

| Label | Supported? | Why |
|---|---|---|
| Actual historical batch cost | No | Required transaction/consumption evidence is absent |
| Estimated standard batch supply cost | Yes | Directly describes recipe-based standard input cost × batch size |
| Margin | Not yet | Requires an approved revenue basis and production-to-sales relationship |

**Workshop decision:** Publish cost fields only as **estimated standard supply cost**. Never shorten the governed definition to “actual cost.”

### 4. Decide duration null behavior

Options:

| Option | Implication |
|---|---|
| Preserve nulls | Retains all batches and represents unknown observed duration |
| Impute a duration | Introduces a modeling policy and potential bias |
| Exclude affected batches | Changes fact retention and other metric denominators |

**Workshop decision:** Preserve source-null duration in the fact. If average observed duration is later defined, null observations are excluded from that average while the batches remain included in batch, unit, cost, and quality metrics.

### 5. Draw the semantic boundary

Approve these as candidates once `fct_brews` exists and validates:

- brew batch count;
- units brewed;
- estimated standard batch supply cost in gold;
- passed brew batch count; and
- average observed brew duration in minutes, with the approved null policy.

Explicitly defer:

- gross/net/recognized margin;
- actual production cost;
- cost of goods sold; and
- any batch-to-order or batch-to-sale allocation.

> “A governed metric name is a promise. If the sources only support a standard estimate, the name and description must say so.”

## Exact Wizard prompts and commands

### Prompt A — surface decisions from evidence

```text
Follow the active source-onboarding workflow for the unfinished Alembic Ops slice. Inspect the lab brief, ERD, data dictionary, source YAML, existing macros, and available source profiles. Start the source-to-target design and change plan, but stop before implementation. Identify every unresolved decision involving unit comparability, cost meaning, null duration, grain, semantic definitions, or public-interface impact. For each, state evidence, viable options and implications, and one focused question for the accountable human. Do not use models/answer_key.
```

### Optional source-profile requests

```text
Profile distinct normalized unit values across raw ingredients and potion ingredients, distinct quality-check values, hazardous boolean encodings, and the count/rate of null brew_duration_minutes. Use bounded result sets and report tool errors separately from data findings.
```

### Prompt B — record the approved decisions

```text
Record these human-approved decisions in the Alembic source-to-target design and dbt change plan:
- normalize unit casing and calculate quantities as supplied; no cross-unit conversion;
- batch_supply_cost_gold means estimated standard batch supply cost, not historical actual cost;
- preserve source-null brew_duration_minutes without imputation or row exclusion;
- an average observed duration metric excludes null observations only from that average;
- margin and production-to-sales allocation are deferred until revenue basis and relationship policy are approved.
Update the target lineage, grains, acceptance criteria, and semantic-impact section accordingly. Do not implement models yet.
```

### Prompt C — complete the semantic governance skill

```text
Use the active building-governed-skills standard and the approved Alembic decisions to resolve the TODO(training) markers in the governed-metrics skill and metric-definition checklist. The completed skill must require discovery/reuse, a trusted contracted mart, explicit grain/formula/filters/units/time/null policy, conflict and consumer-impact assessment, human approval, version-appropriate semantic syntax, dbt parse, semantic validation, scoped mart build, representative semantic query, and recorded evidence. Include focused prompts for standard versus actual cost, unit comparability, duration nulls, revenue basis, margin, and production-to-sales relationships. Keep MetricFlow syntax details in documentation/references rather than guessing. Do not create semantic YAML yet.
```

## Human decision checkpoint and expected artifacts

### Accountable decision owner

For the workshop, the facilitator acts as the business/data-product owner. In a real project, name the procurement/operations metric owner and analytics data-product owner.

### Decisions that must be explicitly approved

- As-supplied unit treatment.
- Estimated standard cost terminology.
- Preservation of null duration.
- Null exclusion policy for an observed-duration average.
- Deferral of margin and actual-cost claims.
- Target model grains and validation scope.

### Expected artifacts

1. A completed Alembic source-to-target design.
2. A completed Alembic dbt change plan through the validation-plan section.
3. Completed `.agents/skills/authoring-governed-metrics/SKILL.md`.
4. Completed metric-definition checklist.
5. No Alembic model or semantic YAML implementation yet.

## Validation and evidence to show

Review the decision record and ask:

- Is each target grain explicit?
- Does the cost definition say estimated and standard?
- Is the no-conversion assumption visible?
- Does null duration remain in the fact?
- Are duration-average semantics distinct from row retention?
- Is margin explicitly deferred with the missing evidence named?
- Are accountable owners and approval status recorded?
- Does the semantic skill require a built, contracted source mart before publishing metrics?

A route/behavior test should produce a focused prompt-back when asked:

```text
Add a gross margin metric to the Alembic semantic model.
```

Expected response: identify missing revenue basis and production-to-sales relationship, present options/implications, and request a human decision instead of authoring YAML.

## Convergence map

| Starting asset | Evidence to inspect | Human decision | Target result | Tested reference |
|---|---|---|---|---|
| Empty source-to-target design | Source docs, profiles, existing patterns | Unit, cost, null, grain | Approved Alembic design | Reference template plus Acceptance Test 01 design evidence |
| Empty change plan | Same evidence plus consumers/risk | Scope and validation | Reviewable plan | Reference change-plan pattern |
| Semantic skill scaffold | Existing semantics and approved decisions | Required metric evidence and stop conditions | Final governed semantic skill | `training_assets/reference/.agents/skills/authoring-governed-metrics/` |
| Metric checklist scaffold | Cost/duration/margin ambiguities | Definition completeness | Final checklist | Corresponding reference checklist |

## Common failures and recovery

| Failure | Recovery |
|---|---|
| Participants want Wizard to choose the “reasonable” unit policy | Emphasize that reasonableness is not authority; approve the workshop assumption explicitly. |
| Cost is casually called actual | Return to source evidence and relabel every field/metric as estimated standard cost. |
| Null duration policy is conflated with metric averaging | Separate fact retention from aggregation behavior and record both. |
| Margin is defined from unrelated sales totals | Stop; require revenue basis and production-to-sales allocation policy. Defer it for this workshop. |
| Profiling is rate-limited | Use prepared output and record the retry/tool limitation separately. |
| Semantic YAML is generated early | Revert it. The trusted source mart does not exist yet, so implementation evidence is incomplete. |

## Transition to demo 04

> “The decisions are now explicit, owned, and testable. We can ask Wizard to build quickly because we have already constrained what the result must mean and how it must prove itself.”

## Companion-session callout

Mention the **Semantic Layer workshop** for deeper MetricFlow design, advanced metric types, and consumption. This workshop focuses on the governance checkpoint and a small, approved semantic extension after the mart exists.
