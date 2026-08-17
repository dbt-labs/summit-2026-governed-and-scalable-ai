# PPT edits — slide-anchored change queue

Working list for the drafted deck
(`training_assets/(WIP) Governed & Scalable AI-assisted Analytics with dbt Training.pdf`,
50 slides). Slide numbers refer to that PDF export.


Three questions this file answers:

1. What needs to be **refined** in existing slides?
2. What needs to be **added**?
3. **Where** do the project demos slot in, and what goes on the DEMO slides?

Guiding principles:

- Slide-only content (objectives, polls, 80/20, drift, readiness levels) needs no MD.
- Platform-only content (the demos) needs no teaching slide — the DEMO handoff slide
  references it and the demo outline carries the detail.
- Prefer editing an existing slide over adding a net-new one. The only net-new slides
  are the DEMO handoff slides.
- A gap is only a gap when the two artifacts contradict each other, or when a demo has
  nowhere natural to land.

---

## 1. Refine existing slides

| Slide | Change | Status |
|---:|---|---|
| 4 | Learning objectives do not reflect the actual arc. Add an objective for the governed source-to-mart build (the Alembic slice) and one for metric/semantic definition governance. | Open |
| 5 | Companion-session list needs the Semantic Layer workshop added once its name is confirmed. Demos 03, 04, and 07 all hand off to it. | Open |
| 17 | Project is introduced as "abra & grimoire"; the repo and `docs/merlinco/` use the Merlin & Co. Apothecaries framing throughout. Name the company once here. | Open |
| 21 | Reword the 80/20 split so it aligns with `03_decision_checkpoints_and_semantic_governance.md`. Currently *"First draft of semantic metrics"* sits under **safe to delegate**, while demo 03 teaches that metric definitions require a human decision before any YAML. The draftable part is syntax; the definition is not. | Open |
| 31 | Wrong path. Deck reads `skills/SKILLS.md`; repo convention is `.agents/skills/<skill-name>/SKILL.md`. | Open |
| 31 | Clarify the Studio caveat. "not in dbt Studio yet — supported locally" applies to installed/managed skill catalogs, not project-root `.agents/skills/`, which is exactly what trainees build and use in demos 02–04. Reword so nobody concludes their repo skills will not work in the sandbox. | Open |
| 33 | **Trim to the skills half.** Keep "build the intermediate + marts skills the same way" (closes demo 02). Move "point your skills at the alembic source / generate the missing slice / this has been the goal all along / watch your guardrails work" onto the **DEMO 04** handoff slide, which lands after 34. This lets demo 03 sit between the skills and the build without splitting or adding a slide. | Open |
| 34 | **Runs before the Alembic build**, not after. Decision — keep the tested `03 → 04` outline order and let the deck follow it. With slide 33 trimmed, no slide has to move. | Decided 2026-08-17 |
| 34 | "Feed it an under-documented source" — the project has only three sources and `alembic_ops` is the build target. The under-documented material is the Alembic unit / standard-cost / null-duration ambiguity set from demo 03. Make that explicit. | Open |
| 38 | Rubric shown is Correctness / Tests / Governance. The paired exercise in demo 05 turns on **must-fix / needs-human-decision / suggestion**. Add the severity classes. | Open |
| 42 | Written as a participant activity ("compare with your neighbor"). Demo 06 treats it as a facilitator showcase with a prepared run. Confirm which, and align the demo outline if it becomes participant-mode. | Open |
| 45 or 46 | Add the governance scorecard (`training_assets/reference/docs/governance_scorecard.md`) as the upkeep take-home. Used in demos 06 and 07; no deck mention today. Fold into an existing scaling slide rather than adding one. | Open |
| 46 | Companion-session list needs the Semantic Layer workshop added alongside MCP Server and Accelerating analytics with AI. | Open |
| 48 | Add the participant adoption commitment from demo 07 ("We will govern [task] in [project], owned by [role], stopping for [decision], validated by [evidence]"). Slide 48 recaps the arc but asks for nothing. | Open |
| 49 | Slide says the survey link is "in the README." `README.md` has no survey link today. Add the link or change the slide. | Open |

## 2. Slides to add

Only the DEMO handoff slides — 7 of them, one per demo 00–06. See §3.

Everything else previously flagged as a missing slide is demo content, and lands on
the DEMO slides via the `Files` and `Done when` lines rather than earning a teaching
slide of its own. That covers `.agents/ROUTING.md`, the source-onboarding workflow,
the source-to-target design template, and demo 04's validation evidence. (The evidence
*concept* already has a home in the deck — slide 23, "prefer evidence over plausibility.")

## 3. Where the demos slot in

### Resulting order for 31–35

No slides added, no slides moved. Slide 33 is trimmed and its build half relocates to
the DEMO 04 handoff slide.

```text
31    The files that guide AI
      → DEMO 02 · Governance operating model
32    Build a skill from a pattern             (inside demo 02)
33    Build the intermediate + marts skills    (closes demo 02)
      → DEMO 03 · Decision checkpoints & semantic governance
34    Revise & re-run / prompt-backs           (inside demo 03)
      → DEMO 04 · Build the Alembic slice      (absorbs 33's build half)
35    Govern the rules like code (CODEOWNERS)
```

### Insertion points

| DEMO slide | Insert after | Immediately precedes |
|---|---:|---|
| DEMO 00 · Meet the project | 16 | 17 (find the patterns) |
| DEMO 01 · Ungrounded to governed | 17 | 18 (break it) |
| DEMO 02 · Governance operating model | 31 | 32 (build a skill) |
| DEMO 03 · Decision checkpoints & semantic governance | 33 | 34 (prompt-backs) |
| DEMO 04 · Build the Alembic slice | 34 | 35 (CODEOWNERS) |
| DEMO 05 · Review & enforcement | 37 | 38 (review this PR) |
| DEMO 06 · Operations & agentic extensions | 38 | 39 (CI gates / agentic review) |

Demo 06 spans two deck moments — the agentic PR review (39) and the failed-job debug
(42). One handoff slide before 39 covering both is probably enough; use two if the
RBAC/approval slides (40–41) break the thread too much in practice.

Demo 07 is a facilitator close, not a demo. No handoff slide unless you want one for
symmetry.

### DEMO slide template

Every field below already exists in the demo outline files, so the slide stays a
projection of the MD rather than a parallel artifact that can drift.

```text
DEMO 0X · <title>                         ~<n> min · <watch | code along | pairs>

Goal          <one sentence>                    ← "Audience outcome"
You'll do     1. …  2. …  3. …                  ← timing-budget beats
Files         <paths trainees will touch>       ← "Exact repository state"
Repo state    <branch / revert / what's absent> ← "Setup and prerequisites"
Stop and ask  <the decision that isn't AI's>    ← "Decision checkpoint"
Done when     <observable validation>           ← "Validation and evidence"
Prompts       training_assets/demo_prompts/0X_prompts.md
```

The `Files` line is what carries the assets the deck never names — routing, the
source-onboarding workflow, the source-to-target template. Worked example:

```text
DEMO 02 · Governance operating model       ~28 min · code along

Goal          Turn the patterns you wrote down into a system the agent follows
              every time — not a doc nobody reads.
You'll do     1. Resolve the four TODOs in AGENTS.md
              2. Build the source-onboarding workflow + source-to-target template
              3. Build the staging / intermediate / mart skills
              4. Finish ROUTING.md and test that the right route fires
Files         AGENTS.md · .agents/ROUTING.md · .agents/workflows/ ·
              .agents/templates/ · .agents/skills/
Repo state    Source workflow, design template, and 3 layer skills absent
Stop and ask  What belongs in always-on policy vs. a task skill
Done when     Every route resolves to a file that exists, and a fresh thread
              picks the onboarding workflow on its own
Prompts       training_assets/demo_prompts/02_prompts.md
```

```text
DEMO 04 · Build the Alembic slice          ~30 min · code along

Goal          Point your skills at the alembic source and generate the missing
              slice — this has been the goal all along. Then prove it.
You'll do     1. Staging: 4 models from real source columns
              2. Intermediate: potion cost, then brew enrichment
              3. Marts: dim_suppliers + fct_brews, contracted and tested
              4. Verify: grain, nulls, cost arithmetic
Files         models/staging/alembic_ops/ · models/intermediate/ · models/marts/
Repo state    Alembic procurement models absent · answer_key is for checking
              your work afterward, not for building from
Stop and ask  Grain surprises, unexpected units, any new public column
Done when     Scoped build passes, grains unique, null duration preserved,
              cost arithmetic sampled
Prompts       training_assets/demo_prompts/04_prompts.md
```

Keep them at template size. If a DEMO slide grows explanatory bullets, that content
belongs in the MD or in a real teaching slide.

---

## 4. Demo outline edits (MD side, not slide side)

Tracked here so the two stay reconcilable. All deferred until after the dry run.

| File | Change | Status |
|---|---|---|
| `00_intro.md` | Trim scope. Demo 00 currently owns Guide → Enforce → Runtime; the deck teaches it at slide 26, after the break-it. Leave 00 as project tour + missing slice + workshop contract. | Open |
| `00_intro.md` | Add the scratchpad capture step. Slide 17 has trainees write down naming/folders/tests/docs/grain conventions, and slide 29 pays it off ("rename that scratch pad → AGENTS.md"). The outline is currently watch-only with no capture. | Open |
| `00_intro.md` | Add sandbox provisioning (slide 16) to the preflight. The outline assumes trainees are already in Studio on the trainee branch. | Open |
| `01_ungrounded_to_governed.md` | Change participant mode from facilitator demo to participant build. The deck has everyone run the ungoverned build (18) and compare with a neighbor (19). The outline's "prepared ungrounded fixture" section becomes moot. | Open |
| `01_ungrounded_to_governed.md` | Add the revert step — trainees use version-control revert in the platform to walk back the ungoverned build. This is what protects the starting state for demos 02–04. Exists in neither artifact today. | Open |
| `02_governance_operating_model.md` | Surface the minute-18 checkpoint on the DEMO 02 slide or in facilitator notes — no delivery-time cue exists today. | Open |
| `05_*.md`, `06_*.md` | Both describe a facilitator switch to a named flawed-change branch. Trainees only ever have `main`; the flawed PR and failed run are trainer-side fixtures. Reword the branch-transition language so it doesn't imply trainees follow along. | Open |

## 5. Trainer-side prep

Not trainee-facing, but slides 38, 39, and 42 depend on these existing at delivery.

| Item | State |
|---|---|
| Flawed PR for the review showcase (slides 38, 42) | Trainer-side. Not in this repo — only `main`, `feature/asset-buildout-and-test`, and `feature/building-demo-assets` exist today. |
| Failed / warning dbt job run at a preserved SHA (slide 42) | Trainer-side. Not confirmed. |
| Agentic PR review artifact (slide 39) | Trainer demo only; trainees have no access. Note that `agentic_pr_review/dbt_pr_review.py` and `azure_pipelines.yml` are both 0 bytes in-repo, so the demo needs to run from elsewhere or from a recording. |

## 6. Verify or decide

| Slide | Item | Owner |
|---:|---|---|
| 18–19 | Does the ungoverned build reliably diverge? Starter `AGENTS.md` ships project context and layer rules, so output may be closer to correct than "spoiler: it diverged" promises. Needs a reliable way to have Wizard disregard the starter AI files, or a tightened prompt. Cut 18–19 if testing can't produce the effect. | JS |
| 27 | "Same prompt, now governed" lands before `AGENTS.md` (29–31) and the skills (32–33) exist. Confirm it's a prepared/recorded comparison and label it, or move it after 34. | Instructor |
| 5, 46 | Need the confirmed name of the Semantic Layer workshop so it can be added to both companion-session slides. Demos 03, 04, and 07 already hand off to it. | Instructor |
| — | Section timings and cut order — deferred to the dry run. | Both |

### Settled

- Slide 16 sandbox setup is the standard trainee account template, not stale copy.
- Slide 39 "Wizard auto-tags its sessions" is verified.
- Slide 46 Runlayer mention and the "native support coming" language are cleared.
- Exact prompts live in `training_assets/demo_prompts/` (to be created), not on slides.
- Answer keys: the "meet the project" walkthrough points out that the solution subfolders
  exist and that trainees can check their work against them after a lab. Trainees are
  not to read or build from them during a lab. No change needed to demo 00's wording.
- Starter-vs-answer-key and branch transitions are handled verbally in "meet the project."
- If demo 03 is cut for time, the finished assets are copy/pasteable from the reference
  set to keep momentum; trainers talk through what the lab would have been and trainees
  redo it in their take-home sandbox.
