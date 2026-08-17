# Demo-outline plan — Governed & Scalable AI-assisted Analytics with dbt

This directory contains the facilitator run-of-show drafts for the workshop. Each file is a slide-development and delivery contract: learning objective, key messages, script starters, exact Studio/Wizard actions, participant mode, decision checkpoint, expected artifacts, validation evidence, recovery path, and companion-session callouts.

The workshop follows one continuous story:

1. Understand the existing project and the missing Alembic slice.
2. Experience why native grounding is useful but insufficient as team policy.
3. Establish versioned context, decision rights, routing, and task-specific workflows.
4. Use the resulting system to plan and build the Alembic source-to-target path.
5. Prove that review and independent dbt enforcement catch errors regardless of author.
6. Close with the operating model for scaling across projects and beyond dbt Platform.

## Run-of-show

| Order | File | Topic and outcome | Delivery mode | Target time |
|---|---|---|---|---:|
| 00 | `00_intro.md` | Tour the completed project, name the missing Alembic slice, establish the Guide → Enforce → Runtime model, and set the workshop contract. | Facilitator walkthrough + group discussion | 12 min |
| 01 | `01_ungrounded_to_governed.md` | Contrast an ungrounded request with Wizard’s project-aware baseline; define why durable repository policy is still necessary. | Facilitator demo | 10 min |
| 02 | `02_governance_operating_model.md` | Build/refine the team operating model: `AGENTS.md`, routing, workflows, plans, source-to-target design, and layer skills. | Guided code-along | 28 min |
| 03 | `03_decision_checkpoints_and_semantic_governance.md` | Practice prompt-backs and human decision rights using Alembic unit/null/cost decisions; connect governed data products to Semantic Layer definitions. | Facilitator-led decision exercise | 12 min |
| 04 | `04_alembic_build.md` | Invoke the source-system workflow to build and validate the Alembic staging → intermediate → mart path. | Guided code-along | 30 min |
| 05 | `05_review_and_enforcement_showcase.md` | Review a deliberately flawed AI-authored change; demonstrate contracts/tests/CI evidence and traceable approval. | Facilitator showcase + paired review | 15 min |
| 06 | `06_operational_and_agentic_extensions.md` | Demonstrate job-investigation and agentic PR-review possibilities; distinguish what is repo-governed, Platform-governed, and beyond-platform. | Facilitator showcase / pre-record fallback | 8 min |
| 07 | `07_conclusion_and_scale.md` | Recap the operating model, identify Monday-morning adoption steps, and map the next control planes. | Facilitator close | 5 min |

**Total target time: 120 minutes.** This is content runtime with no scheduled break. Confirm whether the event slot includes opening logistics, a break, or Q&A before finalizing slides.

### Timing guardrails

Protect demo 04 as the centerpiece. If the session is running long, compress in this order:

1. Use the prepared project-grounding comparison in demo 01 instead of waiting on a second live response.
2. At minute 18 of demo 02, apply the prepared governance-assets checkpoint after the human decisions are captured.
3. Skip the optional semantic implementation in demo 04; retain the mart build and result checks.
4. Use recorded evidence for demos 05 and 06 rather than shortening the review or action-boundary discussion.
5. Preserve at least three minutes for demo 07’s adoption commitment.

## Why this sequence

- The intro is project-first, not theory-first: attendees see real dbt artifacts before we name governance.
- The ungrounded comparison establishes the problem without implying that Wizard lacks native dbt context.
- Governance assets precede the Alembic implementation, so the class sees policy drive behavior rather than retrofitting documentation after code exists.
- Semantic governance is a decision checkpoint, not a separate large build. This preserves the workshop focus while pointing attendees to the dedicated Semantic Layer workshop.
- Review, contracts/tests, and job investigation are best showcased against prepared examples. They need predictable defects and platform/runtime state, which makes them poor 40-person hands-on labs.


## Starting-state design

The active learner project starts with a deliberately small set of visible, discoverable gaps. Keep the complete answer key in `training_assets/reference/`; never silently remove context.

The derived active overlay and its reset checks are maintained in [`../trainee_starter_manifest.md`](../trainee_starter_manifest.md). Keep that manifest, this table, and the per-demo convergence maps synchronized.

| Asset | Learner state | Workshop treatment | Reference source |
|---|---|---|---|
| Root `AGENTS.md` | **Refine live** | Keep project/domain basics and layer rules; use explicit `TODO(training)` gaps for governance lifecycle, authoritative sources, prompt-back policy, and upkeep. | `reference/AGENTS.md` |
| Root `SECURITY.md` | **Ready scaffold** | Provide concise template and discuss boundaries; do not ask attendees to invent a security program. | `reference/SECURITY.md` |
| `.agents/skills/building-governed-skills/` | **Ready** | Use to assess and shape task-oriented skills. | `reference/.agents/skills/building-governed-skills/` |
| `.agents/workflows/governed-dbt-change.md` + `templates/dbt-change-plan.md` | **Ready** | Explain and use during planning. | corresponding reference assets |
| `.agents/ROUTING.md` | **Refine live** | Start with basic routes and visible TODOs for source onboarding/layer skill composition. | `reference/.agents/ROUTING.md` |
| Source-system workflow + source-to-target design | **Build live** | Absent from learner state; create before Alembic implementation. | corresponding reference assets |
| Staging/intermediate/mart skills and checklists | **Build live** | Absent from learner state; create from the skill-building standard. | corresponding reference assets |
| Semantic skill | **Scaffold/refine** | Minimal visible scaffold, completed around approved Alembic metric decisions. | `reference/.agents/skills/authoring-governed-metrics/` |
| Review skill/rubric, PR template, CODEOWNERS | **Showcase/refine** | Prepared baseline; walkthrough focuses on using/reviewing it. | corresponding reference assets |
| Job-investigation skill/runbook | **Ready** | Prepared and used for operational showcase. | corresponding reference assets |
| Governance scorecard | **Reference only** | Take-home scaling artifact; connect operational signals to continuous improvement in `06` and `07`. | `reference/docs/governance_scorecard.md` |

## Delivery dependencies and content boundaries

Current status before workshop delivery:

1. **Reference assets — complete:** semantic, review, job-investigation, PR/ownership, runbook, and scorecard assets exist in the tested reference system.
2. **Starting overlay — complete:** sparse/refine-live and ready assets are active; intentional source/layer gaps remain absent.
3. **Demo drafts — complete:** `00` through `07` exist and map their live work to tested reference concepts.
4. **Prepared examples — pending:** create a deliberately flawed AI-authored change and a known failing job/run with stable evidence; decide live versus recorded fallback.
5. **Product UX verification — pending:** verify the delivery build supports the exact Wizard custom-skill discovery/invocation, approval-mode, review, and job-debug UX used in the demos. Keep product claims tied to current documentation.

## Companion-session callouts

Use these as concise handoffs, not workshop detours:

- **Semantic Layer workshop:** deeper metric semantics, MetricFlow design, and governed analytical consumption. Mention in `03` and after the optional approved brew-metrics extension in `04`.
- **Creating context with dbt MCP Server:** trusted context and least-privilege external-agent integration. Mention in `06` and `07`.
- **AI in analytics / Accelerating analytics with AI:** analyst-facing use of governed marts and metrics. Mention in `01` and `07`.



## Definition of done for each final demo outline

Each `0*_*.md` must include:

- audience outcome and one-sentence takeaway;
- position in the throughline and timing budget;
- setup/prerequisites, exact repository state, and fallback plan;
- facilitator script starters and slide beats;
- exact Wizard prompts or commands where relevant;
- participant mode: watch, code along, small-group decision, or independent work;
- explicit human decision checkpoint and expected artifact;
- validation/evidence to show;
- common failure/recovery path;
- companion-session callout only where it adds value.
