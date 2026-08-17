# Demo 00 — Project tour and workshop contract

## Audience outcome and takeaway

**Audience outcome:** Participants can describe the Merlin & Co. project, identify the intentionally missing Alembic procurement slice, and distinguish repository guidance, independent enforcement, and runtime controls.

**One-sentence takeaway:** AI-assisted analytics scales when the repository guides the work, dbt independently enforces correctness, and people retain runtime decision authority.

## Position in the throughline and timing

- **Order:** 00 of 07
- **Target time:** 12 minutes
- **Delivery mode:** Facilitator walkthrough plus group discussion
- **Participant mode:** Watch, inspect, and answer two framing questions; no file edits
- **Starts from:** Published trainee starter overlay
- **Ends with:** Shared understanding of the project, missing slice, and Guide → Enforce → Runtime frame

### Timing budget

| Time | Beat |
|---:|---|
| 0:00–2:00 | Welcome, workshop contract, and human-accountability framing |
| 2:00–5:00 | Tour completed source systems, layers, marts, tests, and semantics |
| 5:00–8:00 | Show the intentionally unfinished Alembic slice |
| 8:00–10:30 | Introduce Guide → Enforce → Runtime |
| 10:30–12:00 | Confirm the starting state and transition to the grounding demo |

## Setup and prerequisites

### Exact repository state

- Root `AGENTS.md` is the sparse trainee policy with four `TODO(training)` gaps.
- `SECURITY.md`, the governed-change workflow, and the starter route map are active.
- `abra_pos` and `grimoire_crm` provide completed implementation patterns.
- The only active Alembic model is `stg_alembic_ops__shops`.
- Procurement staging models, intermediates, `dim_suppliers`, and `fct_brews` are absent.
- Disabled `__expected` comparison models remain under `models/answer_key/`.
- Raw source relations are pre-built; trainees do not run seeds.

### Facilitator preflight

1. Open dbt Studio on the trainee branch.
2. Confirm `dbt parse` passes.
3. Confirm the active model inventory for `models/staging/alembic_ops/` contains only `stg_alembic_ops__shops`.
4. Open, but do not yet edit, `AGENTS.md`, `dbt_project.yml`, `models/marts/_marts.yml`, and `docs/merlinco/LAB_procurement_slice.md`.
5. Keep `training_assets/trainee_starter_manifest.md` available as the reset contract.

### Fallback plan

Have screenshots or copied output ready for:

- the project DAG;
- the Alembic source declarations;
- the active Alembic model list;
- one enforced mart contract and its tests; and
- one existing semantic definition.

If Studio or the warehouse is unavailable, deliver this demo from repository files and the prepared model-list output. No warehouse query is required.

## Facilitator script starters and slide beats

### 1. Establish the contract

> “This is a mostly completed analytics project, not a blank tutorial repo. Our job is to make AI-assisted changes follow the same evidence, decision, and verification standards we expect from people.”

> “AI can explore, draft, test, and review. People still own business meaning, approval, and production actions.”

### 2. Tour the completed project

Show:

- source declarations under `models/staging/`;
- the staging → intermediate → marts layout;
- explicit contracts and tests in `models/marts/_marts.yml`;
- existing metrics and semantic metadata; and
- shared cleanup macros.

Ask:

> “Which controls here guide an author, and which controls independently catch a bad change?”

Expected distinction:

- **Guide:** `AGENTS.md`, docs, routing, workflows, skills, templates.
- **Enforce:** contracts, data tests, SQLFluff, parsing, CI, warehouse-backed builds.
- **Runtime:** dbt Platform permissions, approvals, job configuration, and accountable operators.

### 3. Reveal the missing slice

Open `docs/merlinco/LAB_procurement_slice.md` and the Alembic source YAML. Show that raw sources exist while the downstream procurement path does not.

> “The workshop’s protected centerpiece is this missing source-to-mart path. We will build the governance system before we ask Wizard to build the models.”

Do not open or copy the answer-key SQL during the participant flow.

### 4. Set expectations for evidence

> “A plausible model is not completion. Completion means agreed grain and business rules, an implementation that follows layer boundaries, and warehouse-backed validation that another reviewer can inspect.”

## Exact Wizard prompts and commands

Use the first prompt without requesting edits:

```text
Orient me to this dbt project. Inspect the project structure, active models, mart contracts, tests, and semantic definitions. Summarize the staging → intermediate → marts architecture, the completed source-system slices, and the intentionally unfinished Alembic work. Do not edit files and do not use models/answer_key as an implementation source.
```

Then narrow the inventory:

```text
List the active models under the Alembic Ops slice and compare them with the target lineage described in docs/merlinco/LAB_procurement_slice.md. State what exists and what is intentionally missing. Do not make changes.
```

Facilitator verification command:

```text
dbt ls --select path:models/staging/alembic_ops --resource-type model --output name
```

Expected active result:

```text
stg_alembic_ops__shops
```

## Human decision checkpoint and expected artifact

### Decision checkpoint

Ask the room to agree:

1. The missing Alembic slice is the implementation lab, not missing context to be silently inferred.
2. Business meaning and risk decisions remain human-owned.
3. Generated code is accepted only with independent validation evidence.

### Expected artifact

No source file is changed. The facilitator records or restates the workshop contract:

```text
Guide the work in the repository.
Enforce correctness independently with dbt and CI.
Keep runtime and business decisions accountable to people.
```

## Validation and evidence to show

- `dbt parse` passes on the starter state.
- Active Alembic model listing returns only `stg_alembic_ops__shops`.
- A completed mart shows an enforced contract and tests.
- Existing semantic definitions demonstrate that business numbers have a governed home.
- `training_assets/trainee_starter_manifest.md` confirms the intentional gaps.

## Convergence map

| Starting asset | Evidence to inspect | Decision or learning | Target state | Reference comparison |
|---|---|---|---|---|
| Sparse `AGENTS.md` | Project tree and supporting docs | Repository policy is intentionally incomplete | No edit in demo 00 | `training_assets/reference/AGENTS.md` is facilitator-only context |
| Existing dbt project | DAG, contracts, tests, semantics | Guide, Enforce, and Runtime are separate control planes | Shared vocabulary | Existing project artifacts |
| Missing Alembic models | Source YAML and lab brief | Missing implementation is deliberate | Preserve gap through demo 03 | `models/answer_key/` remains disabled and unused |

## Common failures and recovery

| Failure | Recovery |
|---|---|
| Wizard starts proposing implementation | Stop and repeat “orientation only; no edits.” Keep the demo focused on evidence and architecture. |
| Answer-key models appear in search results | Explain that they are facilitator comparison assets, disabled from the learner DAG, and excluded from implementation evidence. |
| Attendees assume seeds must be loaded | Reiterate that workshop raw relations are pre-built; seeds exist only for portability/setup. |
| The DAG view is slow or unavailable | Use `dbt ls`, repository paths, and prepared screenshots. |
| Discussion turns into detailed metric design | Park it for demo 03 and the companion Semantic Layer workshop. |

## Transition to demo 01

> “Wizard already understands a surprising amount from dbt metadata and code. Next we’ll see what that native grounding gives us—and the team-policy decisions it still cannot make on its own.”

## Companion-session callout

None in this opening demo. Keep attention on the workshop’s own control model and continuous project story.
