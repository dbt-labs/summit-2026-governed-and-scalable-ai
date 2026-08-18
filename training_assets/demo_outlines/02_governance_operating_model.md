# Demo 02 — Build the repository governance operating model

## Audience outcome and takeaway

**Audience outcome:** Participants can turn project evidence into a small, maintainable instruction system consisting of always-on policy, task routing, a shared change workflow, planning artifacts, and focused skills.

**One-sentence takeaway:** Put stable project rules in `AGENTS.md`, reusable lifecycle in workflows/templates, and conditional task decisions in skills—then route by outcome and validate the system on a real scenario.

## Position in the throughline and timing

- **Order:** 02 of 07
- **Target time:** 28 minutes
- **Delivery mode:** Guided code-along
- **Participant mode:** Inspect, decide, prompt Wizard, approve edits, and compare outcomes
- **Starts from:** Sparse starter policy, basic routing, ready workflow/plan, ready skill-building standard, and intentionally missing source/layer assets
- **Ends with:** A source-onboarding route and three usable layer skills ready to guide the Alembic plan/build

### Timing budget

| Time | Beat |
|---:|---|
| 0:00–5:00 | Derive the authority map from project docs |
| 5:00–10:00 | Refine `AGENTS.md`: evidence lifecycle, prompt-backs, semantics, upkeep |
| 10:00–13:00 | Explain ready governed workflow, plan template, and skill standard |
| 13:00–18:00 | Design source-onboarding workflow and source-to-target template |
| 18:00–24:00 | Create staging, intermediate, and governed-mart skills/checklists |
| 24:00–26:00 | Complete routing and test route selection |
| 26:00–28:00 | Validate, compare with reference concepts, and transition |

## Setup and prerequisites

### Exact starting repository state

Present from the starter overlay:

- sparse root `AGENTS.md` with four `TODO(training)` prompts;
- ready `SECURITY.md`;
- ready `.agents/workflows/governed-dbt-change.md`;
- ready `.agents/templates/dbt-change-plan.md`;
- ready `.agents/skills/building-governed-skills/`;
- basic `.agents/ROUTING.md` with two source/layer TODOs.

Intentionally absent:

- `.agents/workflows/onboarding-source-system.md`;
- `.agents/templates/source-to-target-design.md`;
- `.agents/skills/authoring-staging-models/`;
- `.agents/skills/authoring-intermediate-models/`; and
- `.agents/skills/authoring-governed-marts/`.

### Evidence tabs

Open:

- `docs/merlinco/STYLE_GUIDE.md`;
- `docs/merlinco/ERD.md`;
- `docs/merlinco/DATA_DICTIONARY.md`;
- `docs/merlinco/LAB_procurement_slice.md`;
- representative completed staging, intermediate, and mart SQL/YAML;
- `macros/to_boolean.sql`, `macros/copper_to_gold.sql`, and `macros/conform_region.sql`;
- the active governed-change workflow and change-plan template; and
- the skill-design checklist.

Do not use `training_assets/reference/` as Wizard’s authoring input. It is the facilitator convergence check after trainees reason from project evidence.

### Fallback plan

Prepare a patch containing the tested reference sections and the missing active files. If time or model behavior prevents live convergence:

1. preserve the class’s authority and decision-rights discussion;
2. apply the prepared patch;
3. walk through the plan-to-file mapping; and
4. run the route/validation checks.

The non-negotiable live component is the human decision process, not typing every line.

## Facilitator script starters and slide beats

### 1. Derive the authority map

Ask the room to inspect the three core docs and assign authority:

| Evidence | Authority to encode |
|---|---|
| `STYLE_GUIDE.md` | Project structure, naming, SQL shape, layer placement, and macro reuse |
| `ERD.md` | Entity relationships, keys, cardinality clues, and expected grains |
| `DATA_DICTIONARY.md` | Raw columns, data types, value quirks, null behavior, and source caveats |
| Existing SQL/YAML | Actual implemented patterns, interfaces, contracts, and tests |
| Semantic YAML/metrics | Canonical business definitions and governed analytical interface |

> “We are not copying these documents into `AGENTS.md`. We are telling Wizard which source to trust for which question.”

### 2. Decide what belongs in always-on policy

Use the sparse TODOs to agree that final `AGENTS.md` must contain:

- the authority map;
- layer and naming defaults;
- shared macro reuse;
- public mart contract/test/documentation expectations;
- semantic definitions as the home for business numbers;
- Explore → Plan → Implement → Verify;
- focused prompt-back conditions;
- safe execution boundaries; and
- ownership/review/retirement triggers.

Keep detailed staging joins, mart checklists, and MetricFlow syntax out of `AGENTS.md`.

#### Slide beat — where the rules live (1–2 minutes)

This is deck time, not platform time; it does not draw on the 28-minute demo budget. It
follows the file inventory on slide 31 and calls back to Guide → Enforce → Runtime on
slide 26.

**Script starter:**

> “Reasonable question at this point: is there a standard place for any of this? Short
> answer, no. `AGENTS.md` is read by dbt Wizard and by Cursor. Claude Code reads
> `CLAUDE.md` instead, so a repo that wants both adds a one-line `CLAUDE.md` importing
> `AGENTS.md`. And for the safety boundary there is no agreed filename at all — we put
> ours in `SECURITY.md` for visibility in this training.”

##### There is no cross-vendor convention

Nothing has standardized. The closest thing to a documented location is Claude Code's
`.claude/rules/security.md`, which appears in Anthropic's docs as an example filename in a
rules directory — an illustration, not a spec. No other vendor documents a data-handling
policy file at all.

Verified against vendor documentation, August 2026:

| Tool | Instruction files | Safety-boundary file | Where enforcement actually lives |
|---|---|---|---|
| dbt Wizard | `AGENTS.md`, `CLAUDE.md` | none documented | Edit/command approval, sandbox profiles (CLI), destructive-command protection |
| Claude Code | `CLAUDE.md`, `.claude/rules/*.md` — **not** `AGENTS.md` | `.claude/rules/security.md` (example only) | `permissions.deny`, `PreToolUse` hooks, managed settings |
| Cursor | `.cursor/rules/*.mdc`, `AGENTS.md` | none documented | `.cursorignore` |
| Snowflake Cortex | no file convention | none | Model RBAC, `AI_SETTINGS` guardrails, masking and row-access policies |

##### Every vendor puts real gates in configuration, not Markdown

Anthropic's docs draw exactly this distinction in a table of their own: “Block specific
tools, commands, or file paths” routes to managed settings `permissions.deny`, while “data
handling and compliance reminders” route to a managed `CLAUDE.md`. Then, plainly:

> Settings rules are enforced by the client regardless of what Claude decides to do.
> CLAUDE.md instructions shape Claude's behavior but are not a hard enforcement layer.

Cursor's docs make the same admission from the other direction. `.cursorignore` blocks
indexing, but “the terminal and MCP server tools used by Agent cannot block access to code
governed by `.cursorignore`,” and complete protection “isn't guaranteed due to LLM
unpredictability.”

##### The takeaway

Guide → Enforce → Runtime is **vendor-confirmed**. Slide 26 is the industry position, not a
dbt Labs opinion — there simply is no agreed convention for where the guidance layer is
established. `AGENTS.md` and `SECURITY.md` are **Guide**. Tool permissions, platform RBAC,
contracts, tests, and CI are **Enforce** and **Runtime**.

One caveat worth stating out loud: in a public repository, `SECURITY.md` already means
something else — GitHub reads a root `SECURITY.md` as the vulnerability-disclosure policy
and surfaces it in the Security tab. Ours is a training choice, made for visibility.

##### Source documentation

- **dbt Wizard:** [skills in the dbt platform](https://docs.getdbt.com/docs/dbt-ai/wizard-platform-skills) · [how dbt Wizard works](https://docs.getdbt.com/docs/dbt-ai/wizard-how-it-works)
- **Claude Code:** [memory and CLAUDE.md](https://code.claude.com/docs/en/memory) · [permissions](https://code.claude.com/docs/en/permissions) · [hooks](https://code.claude.com/docs/en/hooks.md)
- **Cursor:** [rules](https://cursor.com/docs/context/rules) · [ignore files](https://cursor.com/docs/reference/ignore-file)
- **Snowflake Cortex:** [Cortex AI Guardrails](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-ai-guardrails) · [privileges and model access](https://docs.snowflake.com/en/user-guide/snowflake-cortex/aisql-privileges-and-access) · [Cortex Analyst](https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-analyst)

Re-verify these before delivery. Every one of these products ships frequently, and this
table is the kind of claim an attendee will check live.

### 3. Explain the ready shared lifecycle

Open the governed-change workflow and plan template.

> “These are ready because every material task needs the same lifecycle and decision record. Asking forty trainees to invent a change-control process would not be a useful workshop exercise.”

Show how the workflow delegates task detail to one routed skill.

### 4. Design source onboarding as orchestration

Ask:

> “Should Alembic get one giant source-specific skill, or should onboarding compose reusable staging, intermediate, and mart tasks?”

Guide the room to composition. The workflow should:

1. explore source and project evidence;
2. create a source-to-target design;
3. obtain human approval for grains and business rules;
4. invoke only the needed layer skills;
5. assess semantic impact; and
6. verify/review the complete path.

### 5. Design each layer skill by outcome

Use the skill-design checklist. For each skill, state trigger, goal, non-goals, evidence, prompt-backs, workflow, validation, owner, and reference checklist.

Key boundaries:

- **Staging:** one source, raw grain, cleanup/casting only.
- **Intermediate:** joins, dedupe, fanout control, aggregation, and grain changes.
- **Governed mart:** public grain, simple upstream interface, explicit contract/casts/tests/docs, compatibility, semantic impact.

### 6. Complete routing

Replace training TODOs with outcome-oriented routes for:

- source onboarding;
- staging work;
- join/grain-change intermediate work; and
- public dimension/fact work.

Do not route based only on file extension or folder name.

## Exact Wizard prompts

### Prompt A — refine always-on policy from evidence

```text
Use the active building-governed-skills standard and the TODO(training) markers in AGENTS.md. Inspect docs/merlinco/STYLE_GUIDE.md, ERD.md, DATA_DICTIONARY.md, the existing model layers, macros, mart contracts/tests, and semantic definitions. Propose a concise final authority map, Explore → Plan → Implement → Verify lifecycle, prompt-back policy, semantic boundary, and governance upkeep section for AGENTS.md. Keep task-specific checklists out of always-on policy. Do not use training_assets/reference as authoring input. Show the proposed structure and unresolved choices before editing.
```

After the room approves the concepts:

```text
Apply the approved AGENTS.md refinement. Preserve the project context and layer rules, resolve the four TODO(training) markers, and keep the file concise enough to serve as always-on policy. Do not edit models.
```

### Prompt B — design source onboarding artifacts

```text
Use .agents/skills/building-governed-skills/SKILL.md and its checklist. Inspect the governed-change workflow, change-plan template, Alembic lab brief, source YAML, and completed project patterns. Design and create:
1. .agents/workflows/onboarding-source-system.md
2. .agents/templates/source-to-target-design.md
The workflow must orchestrate reusable layer skills rather than contain Alembic-specific implementation. The design template must capture source tables, raw grains/keys/quirks, target models and grains, joins/cardinality, open human decisions, contracts/tests/semantic impact, and validation. Do not use training_assets/reference and do not build models yet.
```

### Prompt C — build the three layer skills

```text
Use the building-governed-skills standard to create three outcome-oriented skills and focused reference checklists:
- authoring-staging-models
- authoring-intermediate-models
- authoring-governed-marts
Ground them in AGENTS.md, the governed-change workflow, completed project SQL/YAML, and the project docs. Keep shared layer rules in AGENTS.md and add only task-specific evidence, decisions, prompt-backs, workflow, and validation. Staging must preserve one-source raw grain; intermediate must own joins/fanout/grain changes; marts must require a stated public grain, contracts, explicit casts, tests, descriptions, compatibility review, and semantic-impact assessment. Do not use training_assets/reference and do not create Alembic models.
```

### Prompt D — complete routing and review the instruction system

```text
Update .agents/ROUTING.md to route source onboarding and the three layer outcomes to the new workflow/skills. Remove the resolved TODO(training) markers. Then review AGENTS.md, routing, workflows, templates, and skills for duplication, conflicting authority, missing owners, broken links, or routes that point to absent assets. Report findings before making any corrective edits.
```

## Human decision checkpoints and expected artifacts

### Checkpoint 1 — authority

The room approves which project evidence governs:

- modeling conventions;
- source columns/quirks;
- relationships/grains;
- public interfaces; and
- business metrics.

### Checkpoint 2 — policy scope

The room approves what belongs in always-on policy versus a task skill or detailed reference.

### Checkpoint 3 — composition

The room approves a reusable source workflow that composes layer skills, rather than one Alembic-specific mega-skill.

### Expected artifacts

By the end of demo 02:

- refined root `AGENTS.md` close in concepts to `training_assets/reference/AGENTS.md`;
- completed `.agents/ROUTING.md` close in routes to the reference map;
- `.agents/workflows/onboarding-source-system.md`;
- `.agents/templates/source-to-target-design.md`;
- staging skill plus checklist;
- intermediate skill plus checklist; and
- governed-mart skill plus checklist.

The existing governed-change workflow, change-plan template, security policy, and skill-building standard remain intact unless review reveals a concrete conflict.

## Validation and evidence to show

### Structural checks

- Every routed path exists.
- Every new skill has a clear trigger, goal, non-goals, evidence, prompt-backs, validation, and ownership.
- Detailed checklists live under each skill’s `references/` directory.
- No task skill duplicates the entire `AGENTS.md` policy.
- No active file points trainees to `training_assets/reference/` as operational authority.

### Behavioral route test

In a fresh Wizard thread if available:

```text
We need to onboard the unfinished Alembic Ops procurement slice from its declared sources through trusted marts. What workflow and planning artifacts should we use before implementation?
```

Expected behavior:

- select the source-onboarding workflow;
- require source-to-target design and change plan;
- inspect project evidence;
- identify unresolved human decisions; and
- avoid immediately generating models.

### Repository check

```text
dbt parse
```

This is a regression check; agent Markdown does not itself validate through dbt.

## Convergence map

| Starting asset | Evidence to inspect | Live decision | Target concepts | Tested reference |
|---|---|---|---|---|
| Sparse `AGENTS.md` | Style guide, ERD, dictionary, existing project | Authority, defaults, prompt-backs, upkeep | Sections and behaviors in final policy | `training_assets/reference/AGENTS.md` |
| Basic routing | User outcomes and new assets | Smallest primary route; composition | Full outcome-oriented route map | `training_assets/reference/.agents/ROUTING.md` |
| Ready change workflow | Material-change lifecycle | Keep shared vs. task-specific responsibilities separate | No duplication in new skills | Reference governed workflow |
| Missing source workflow | Lab brief and layer boundaries | Orchestrate, do not create a mega-skill | Explore/design/approve/compose/verify | Reference onboarding workflow |
| Missing design template | ERD, dictionary, change-plan gaps | Required source-to-target evidence | Source/target grains, joins, decisions, validation | Reference source-to-target template |
| Missing layer skills | Completed SQL/YAML and skill checklist | Trigger, evidence, stop conditions, validation | Three focused skills with references | Corresponding reference skills/checklists |

Facilitators should compare concepts and executable behavior, not require byte-identical prose.

## Common failures and recovery

| Failure | Recovery |
|---|---|
| Wizard produces an enormous `AGENTS.md` | Move task procedures and examples into skills/references; retain only stable defaults and authority. |
| Skills repeat layer rules verbatim | Link to `AGENTS.md`; retain only task-specific decisions and validation. |
| Source workflow becomes Alembic-specific | Replace source names with generic source/target evidence and compose layer skills. |
| Routing points to missing files | Create the approved asset or remove the route; never leave a silent broken path. |
| Participants get stuck on wording | Use the convergence checklist and prepared patch. Exact prose is not the learning objective. |
| Live edits reach minute 18 without the missing skill set complete | Stop generating live files, apply the prepared governance-assets checkpoint, and spend the remaining time on routing behavior and validation. |

| Wizard uses facilitator references | Revert that draft and repeat that project evidence, not `training_assets/reference/`, is the authoring input. |

## Transition to demo 03

> “We now have a system that knows when to inspect, plan, route, validate, and stop. Next we’ll test the most important behavior: stopping for business decisions the repository cannot make for us.”

## Companion-session callout

None during the code-along. Keep attention on the repository operating model; deeper semantic design is introduced in demo 03.
