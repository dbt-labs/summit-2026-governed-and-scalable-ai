# Demo 05 — Governed review and independent enforcement

## Audience outcome and takeaway

**Audience outcome:** Participants can review an AI-assisted dbt change against approved intent, classify defects separately from unresolved decisions and suggestions, and explain why dbt contracts/tests/CI remain necessary even with strong repository guidance.

**One-sentence takeaway:** Repository policy improves authorship; governed review and independent dbt enforcement determine whether the change is safe to merge.

## Position in the throughline and timing

- **Order:** 05 of 07
- **Target time:** 15 minutes
- **Delivery mode:** Facilitator showcase plus paired review
- **Participant mode:** Inspect a prepared diff, classify findings, compare with Wizard review, and decide the outcome
- **Starts from:** The validated demo 04 checkpoint, followed by an explicit facilitator switch to a dedicated flawed-change branch
- **Ends with:** Evidence-backed review findings and a clear request-changes/blocked decision outcome

### Timing budget

| Time | Beat |
|---:|---|
| 0:00–2:00 | Introduce fixture, approved plan, and review scope |
| 2:00–5:00 | Paired scan: find one defect, one decision gap, one suggestion |
| 5:00–9:00 | Invoke governed review and compare findings |
| 9:00–12:00 | Show contract/test/CI evidence catching author-independent failures |
| 12:00–14:00 | Decide review outcome and required next actions |
| 14:00–15:00 | Connect review evidence to operating model |

## Setup and prerequisites

### State transition from demo 04

End demo 04 on the validated learner implementation. Before showing the fixture, state that participants should stop editing and observe. The facilitator then switches to a named flawed-change branch/checkpoint forked from the same approved Alembic plan. Do not let the fixture overwrite or masquerade as the learner result.

### Dedicated fixture branch

Keep the flawed change off `main` and off the clean trainee baseline. Prepare a stable branch or checkpoint with:

- the same request and approved Alembic plan/design used in demo 04;
- a small, readable diff from a known good or pre-implementation checkpoint;
- intentionally incomplete or failing validation evidence;
- predictable dbt/CI output; and
- no secrets or production-impacting actions.


### Recommended flaw set

Use three to five defects that demonstrate different control planes. Recommended fixture:

1. `fct_brews` performs a join that belongs in intermediate, creating unproven fanout risk.
2. Cost is described as actual despite recipe/standard-cost-only inputs.
3. `brew_duration_minutes` is imputed or marked `not_null` contrary to the approved decision.
4. A mart contract omits a public column or declares a type that does not match SQL.
5. The PR claims validation passed while the scoped build or SQLFluff evidence is absent/failing.

Include one non-blocking readability improvement so participants practice using **suggestion** correctly.

### Required tabs/artifacts

- Flawed branch diff.
- Approved source-to-target design and change plan.
- Active `AGENTS.md`, review skill, and review rubric.
- Mart SQL/YAML and relevant upstream models.
- Prepared dbt build/test/contract/SQLFluff/CI output.
- Active PR template populated incompletely by the fixture.

### Fallback plan

Use a pre-recorded diff walkthrough and saved CI/build output if GitHub, Studio review, or the warehouse is unavailable. The fixture should be reviewable entirely from source files and saved artifacts.

## Facilitator script starters and slide beats

### 1. Establish review intent

> “We are not asking whether the SQL looks sophisticated. We are asking whether the implementation matches the approved meaning, architecture, public interface, and evidence requirements.”

Show the request and plan before the diff. Review without intent invites the reviewer to redesign the feature instead of evaluating it.

### 2. Run the paired classification exercise

Give pairs three minutes to find:

- one **must fix before merge**;
- one **needs human decision**; and
- one **suggestion**.

Remind them:

- A known policy violation or failed required check is a must-fix.
- Missing business authority is a decision request, not a code preference.
- Suggestions cannot block approved behavior merely because the reviewer prefers another style.

### 3. Invoke governed Wizard review

Show that Wizard must inspect:

- plan-to-diff alignment;
- layer fit and grain;
- actual upstream columns;
- joins/fanout and record retention;
- contracts, casts, tests, and descriptions;
- semantic impact and business wording;
- validation evidence; and
- unresolved risk/ownership.

> “The review skill supplements native dbt review with this project’s intent and decision rights. It does not replace the build, tests, CI, or human approval.”

### 4. Show independent enforcement

Use prepared evidence to demonstrate at least one failure that does not depend on reviewer judgment:

- contract mismatch;
- failing unique/relationship/accepted-values test;
- SQL compilation error from an unsupported column;
- SQLFluff violation; or
- CI gate failure.

Ask:

> “If the same defect were written by a senior engineer instead of an AI assistant, should this control behave differently?”

Expected answer: no. Enforcement is author-independent.

### 5. Decide the outcome

Use only the rubric outcomes:

- Approve.
- Approve with follow-up.
- Request changes.
- Blocked pending decision.

The recommended fixture outcome is **request changes**, with any separate business ambiguity labeled **blocked pending decision** until the owner responds.

## Exact Wizard prompts and commands

### Prompt A — governed review

```text
Review this prepared dbt change using .agents/skills/reviewing-governed-dbt-changes/SKILL.md and its review rubric. First inspect the request, approved source-to-target design/change plan, changed files/diff, active project policy, relevant upstream models, contracts/tests, semantic definitions, and available validation evidence. Check plan-to-diff alignment, layer fit, grain, join cardinality/fanout, null and unit treatment, public types/casts/tests/docs, semantic meaning, and consumer impact. Classify every finding as must fix before merge, needs human decision, or suggestion. For each finding cite concrete evidence, impact, and next action. Do not silently redesign business logic or approve missing evidence.
```

### Prompt B — recheck enforcement evidence

```text
Compare the review findings with the available dbt build/test/contract, SQLFluff, semantic, and CI output. State which findings are independently enforced, which require project-specific review, and which require a human business decision. Do not mark any check passed unless its result is present.
```

### Optional local reproduction

For a model fixture that is safe to build in development:

```text
dbt build --select +<fixture_model>+
```

Use the exact fixture selector and saved expected failure. Do not run an unbounded whole-project build merely for the showcase.

## Human decision checkpoint and expected artifacts

### Decision checkpoint

The room decides:

1. Is the change reviewable against an approved plan?
2. Which findings are demonstrable defects?
3. Which findings need a named business/data-product owner?
4. Which comments are truly non-blocking?
5. Is the outcome request changes or blocked pending decision?

### Expected artifact

A review record using the rubric’s required formats, for example:

```text
Must fix — models/marts/fct_brews.sql: the public fact performs a multi-input cost join that the approved design assigns to int_brews_with_supply_cost. Evidence: plan target lineage and SQL refs. Impact: unproven fanout and hidden grain-changing logic. Required action: move the join to the intermediate and rerun the scoped build/grain checks.
```

```text
Decision needed — cost terminology: Evidence inspected: only recipe quantities and standard ingredient unit cost are available. Options/implications: estimated standard cost is supported; actual cost requires consumption/purchase evidence. Owner: procurement data-product owner. Question: approve estimated-standard wording or provide an actual-cost source?
```

```text
Suggestion — models/marts/fct_brews.sql: rename the import CTE to `brews` for consistency. Benefit: readability.
```

The PR template should record AI assistance, human decision owners, validation results, open follow-up, and required reviewers.

## Validation and evidence to show

A complete showcase demonstrates:

- every finding cites inspected evidence;
- plan deviations are visible;
- must-fix and decision findings are not mixed with preferences;
- at least one defect is caught independently by dbt/CI;
- passing parse is not treated as warehouse correctness;
- required checks are not claimed without results;
- human/code-owner approval remains required; and
- resolved must-fix findings would be re-reviewed.

## Convergence map

| Review input | Project control | Expected finding behavior | Reference asset |
|---|---|---|---|
| Request and approved plan | Governed-change workflow/plan | Establish intended grain and scope | Reference workflow/template |
| SQL/YAML diff | `AGENTS.md` and layer skills | Verify architecture, columns, nulls, units, interfaces | Layer skills/checklists |
| Business wording | Semantic/mart decisions | Prompt back when meaning lacks approval | Governed-metrics and mart skills |
| Build/test/CI artifacts | Independent enforcement | Confirm or reject implementation claims | dbt/CI evidence |
| Review output | Review skill/rubric | Must-fix, decision, suggestion, outcome | Reference review skill/rubric |
| PR record | Template/CODEOWNERS | Trace AI use, decisions, evidence, owners | Reference GitHub assets |

## Common failures and recovery

| Failure | Recovery |
|---|---|
| Fixture has too many defects | Keep three high-signal findings plus one suggestion; depth beats volume. |
| Review starts without the plan | Pause and establish approved intent before evaluating implementation. |
| Every comment becomes must-fix | Apply the rubric definitions and separate preferences from correctness/public risk. |
| Wizard fixes code during review | Stop; review first, assign owners/decisions, then remediate in a separate approved step. |
| CI is unavailable | Use saved artifacts and state that they are fixture evidence; do not claim a live run. |
| Participants treat AI disclosure as a defect | Reframe disclosure as traceability; correctness and approval standards apply regardless of author. |
| A test is weakened to make CI green | Reject the workaround and investigate the underlying transformation/data/definition. |

## Transition to demo 06

> “Review governs changes before merge. The same evidence-first approach applies after deployment when a job fails or warns—and runtime actions require an even clearer approval boundary.”

## Companion-session callout

None. Keep the showcase focused on repository policy, Wizard review, and independent dbt enforcement.
