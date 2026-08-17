# PPT alignment checklist

Use this checklist with the co-trainer’s slide deck. The PPT is not stored in this repository, so this file records the intended slide-to-demo contract without claiming a completed visual comparison.

## One continuous story

The deck should preserve this order:

```text
Project and missing Alembic slice
→ native grounding versus durable team policy
→ repository governance operating model
→ human business/semantic decisions
→ governed Alembic implementation and evidence
→ review and independent enforcement
→ run investigation and agentic extensions
→ adoption and scale
```

Do not introduce the Alembic implementation before the governance and decision checkpoints. Do not end the build at generated SQL; the validation evidence is part of the story.

## Demo-to-slide contract

| Demo | Slide-level job | Must show | Avoid |
|---|---|---|---|
| 00 | Establish project, missing slice, and workshop contract | Existing layers; intentional Alembic gap; Guide → Enforce → Runtime | Detailed governance taxonomy or metric design |
| 01 | Show why native grounding and team policy solve different problems | Project-grounded evidence; facts vs. policy vs. human decisions | Vendor/model comparison or a cartoonishly bad “ungrounded” example |
| 02 | Build the operating model | Authority map; `AGENTS.md`; routing; workflow/plan; source/layer skills; minute-18 checkpoint | Reading every generated file line-by-line |
| 03 | Make prompt-backs tangible | Unit, estimated-standard-cost, nullable-duration, and deferred-margin decisions | MetricFlow syntax tutorial or early semantic YAML |
| 04 | Deliver the protected implementation centerpiece | Approved lineage; two intermediates; contracts/tests; output checks; fallback checkpoints | Direct joins in `fct_brews`, seed setup, or optional semantics before mart evidence |
| 05 | Separate review judgment from independent enforcement | Plan-to-diff review; must-fix/decision/suggestion; contract/test/CI result | Treating AI disclosure itself as a defect |
| 06 | Extend evidence and approval boundaries into operations | Same flawed branch/run when possible; run-specific evidence; no action without approval; three control planes | Diagnosing latest account-wide run or clicking retry live |
| 07 | Convert the story into an adoption commitment | Monday sequence; upkeep loop; one task/owner/decision/validation | Broad product recap or an enterprise skill catalog |

## Concept ownership

Use these concepts once as the primary teaching beat, then only reference them:

| Concept | Introduce | Reuse |
|---|---|---|
| Guide → Enforce → Runtime | 00 | 05, 06, recap in 07 |
| Native dbt grounding vs. durable policy | 01 | 02 |
| Explore → Plan → Implement → Verify | 02 | Invoke in 03–06; recap in 07 |
| Human prompt-back / decision rights | 03 | Build checkpoints in 04; review/operations in 05–06 |
| Contracts/tests/CI as author-independent enforcement | 04 | Primary showcase in 05 |
| Repository / Platform / beyond-Platform controls | 06 | Recap in 07 |

If the PPT explains one of these concepts in several consecutive sections, keep the strongest slide and convert the others into brief transition references.

## Timing and delivery checks

- [ ] Confirm whether the 120-minute event slot includes opening logistics, a break, or Q&A.
- [ ] Reserve the full protected demo 04 window; compress according to the run-of-show README.
- [ ] Add a visible minute-18 cutoff/checkpoint to the demo 02 facilitator notes.
- [ ] Treat optional brew semantic implementation as expendable; retain semantic decisions and mart validation.
- [ ] Mark demos 05–06 as showcase/recording-capable rather than participant code-alongs.
- [ ] Preserve at least three minutes for the demo 07 participant commitment.

## State-transition checks

- [ ] Slides distinguish the starter overlay from the completed reference state.
- [ ] The answer key is described as facilitator comparison, never learner implementation input.
- [ ] Demo 04 ends on the validated learner/checkpoint state.
- [ ] Demo 05 explicitly switches to a named flawed-change branch/checkpoint.
- [ ] Demo 06 preferably uses a job/run from that same flawed branch; otherwise the deck labels the incident as a separate fixture.
- [ ] Raw workshop relations are described as pre-built; seeds are facilitator/environment portability fixtures only.

## Product-UX claims to verify in the delivery build

- [ ] Root `.agents/skills/` discovery in a fresh Wizard session.
- [ ] Exact skill invocation/routing behavior used in demos 02–04.
- [ ] File-edit approval interaction shown in the deck.
- [ ] Review experience and available diff context used in demo 05.
- [ ] Job/run evidence, warning, artifact, and action-approval UX used in demo 06.
- [ ] Current terminology for dbt Platform, Studio/Wizard, CI, approval mode, and Semantic Layer commands.

Use current product documentation or a tested rehearsal for each checked claim. Prefer a screenshot/recording fallback when runtime state is likely to drift.

## Companion-session handoffs

- Demo 01 and 07: AI in analytics / Accelerating analytics with AI.
- Demo 03 and optional post-build moment in 04: Semantic Layer workshop.
- Demo 06 and 07: Creating context with dbt MCP Server.

Keep each handoff to one sentence and one “go there for…” outcome.

## Co-trainer decisions needed

| Decision | Owner | Status |
|---|---|---|
| Does the two-hour slot include break, logistics, or Q&A? | Event/facilitator owner | Pending |
| Which demo 02 assets are generated live versus applied from checkpoint? | Lead facilitator | Pending |
| Is the optional brew semantic extension shown live, recorded, or omitted? | Lead facilitator + Semantic Layer owner | Pending |
| Can demos 05 and 06 use the same flawed branch/job run? | Facilitator + dbt Platform operator | Pending |
| Which slide claims/screenshots need refresh for the Summit build? | Co-trainer/product owner | Pending |

## Sign-off

The deck and repository outlines are aligned when:

- slide order matches the continuous story;
- each concept has one clear primary teaching beat;
- repository states and branch transitions are explicit;
- timing/fallback choices are decided;
- product UX claims are rehearsed or recorded; and
- every demo ends with the transition stated in its outline.
