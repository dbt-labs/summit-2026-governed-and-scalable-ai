# Governed & Scalable AI-assisted Analytics with dbt — Course Outline

## At a glance

- **Format:** Training (2 hours)
- **Audience:** ~40 participants, sold out with a waitlist
- **Presenters:** Jessica Stayton, Raini Laughlin
- **TAs:** Stephen Thibeault, Carol Ohms
- **Prerequisites:** dbt Fundamentals; comfort reviewing SQL changes (not writing complex SQL from scratch)
- **What to bring:** laptop; sandbox dbt + data platform provided
- **Repo:** https://github.com/dbt-labs/summit-2026-goverened-and-scalable-ai

### Scope

**In scope:** governed development and analytics workflows with dbt Wizard in dbt Platform: repository context, task-oriented skills, planning and human decision checkpoints, reviewable edits, dbt contracts/tests, CI/CD handoff, and Semantic Layer governance.

**Mention only:** dbt MCP Server, external agents, Snowflake Cortex, Runlayer/plugins, cross-project skill distribution, and broader enterprise AI observability. These extend the same principles beyond dbt Platform; they are not the subject of this training. Point attendees who want that next step to the separate **Creating context with dbt MCP Server** training.

**Non-goal:** designing an organization’s full AI security architecture, identity model, or external-agent control plane in two hours.

## Learning objectives

- Describe where AI helps most in analytics engineering, and where it introduces risk.
- Apply a review framework for AI-assisted changes: correctness, performance, maintainability, documentation, and evidence.
- Identify governance decisions needed before scaling AI usage: who can access what context, which decisions require a human, what outputs are acceptable, and how changes are approved.
- Establish team norms that prevent AI drift in definitions, naming, documentation, and implementation.

## Design principles guiding this outline

1. **Experience first, name it second.** Let learners feel ungrounded AI risk before giving it a label.
2. **One or two concrete examples per lesson.** Documentation and job failure are universal pain points; lean on those.
3. **Accessible titles, technical subtitle underneath.** Say what we mean, then name the jargon.
4. **Cost, governance, and scaling are recurring threads.** Call them out inside each lesson; never turn them into a rabbit hole.
5. **Use the workflow everywhere:** Explore → Plan → Implement → Verify. Where useful, tag the pipeline layer (source → staging → intermediate → marts) or governance layer (guide → enforce → runtime).
6. **Wizard executes; attendees own the decision checkpoints.** Learners build the reusable governance assets and approve business/design choices. Wizard performs the repetitive implementation under visible review.

## The throughline

The project ships with two source slices already built end to end (`abra_pos` and `grimoire_crm`) and one source vertical deliberately left unbuilt: the `alembic_ops` procurement/supply-cost slice. The course drives toward one goal: give Wizard enough trustworthy, versioned context and independent enforcement that the room can confidently build the missing Alembic staging, intermediate, and mart layers.

The flagship hands-on builds a reusable AI-governance operating model from the project’s established patterns, then uses it to generate the Alembic slice. A complete target-state reference lives in `models/answer_key/` as take-home material.

## Section 1 — Welcome (~10 min)

**Goal:** orient the room, set norms, and quietly plant the 80/20 idea before naming it.

- Instructor and TA intros; course description, objectives, and honest scope: governance inside dbt Platform, not the entire enterprise AI architecture.
- Signpost adjacent sessions: **Creating context with dbt MCP Server**, **Accelerating analytics with AI**, and the expert lounge.
- Norms/housekeeping; note the feedback survey in the repo README.
- Check-in questions:
  - Where are you starting with AI in dbt work — never, occasionally, or daily?
  - How much SQL is AI drafting versus written by hand?
  - Optional themed “scary story” prompt: what goes wrong in a project with no governance?
- Land the belief without teaching the theory: “we operate on roughly an 80/20 split.” Park it; the rest of the session proves why it requires trustworthy inputs.

## Section 2 — Meet the project, then feel the risk (~25 min)

**Goal:** get hands-on immediately, discover the project’s patterns, and distinguish ungrounded AI from Wizard’s native baseline.

- Sandbox setup (~10 min): workshop link, credentials, working branch. Keep it tight; learners can finish setup during the next activity.
- Guided exploration (Explore · pipeline layer): tour the completed `abra_pos` and `grimoire_crm` slices. Learners note conventions in naming, folders, casts/renames, macros, grain, contracts, tests, and metrics.
- State the goal: build the missing `alembic_ops` procurement slice through marts.
- Plan the target end state: identify the intended staging, intermediate, and mart models from the existing patterns.
- **Demo — ungrounded external AI:** ask a generic assistant to “build the missing models” with no project context. Debrief predictable misses: source paths, layer boundaries, macro reuse, grain, contracts/tests, semantic governance, and unresolved business decisions.
- **Contrast — Wizard baseline:** Wizard already has native dbt project grounding, reviewable file edits, and validation tools. Team-governed Wizard adds durable repository assets—context, workflows, skills, review standards, and ownership—to make correct behavior repeatable across people and sessions.

## Section 3 — AI foundations: name what we just felt (~20 min)

**Goal:** give language to the experience: the 80/20 split, human decision rights, why AI misbehaves, and the workflow that keeps people in control.

- **80/20 framework:** AI handles high-volume scaffolding, boilerplate, first-pass docs, test stubs, syntax, and implementation. Humans own business logic, grain/join semantics, competing definitions, source authority, performance tradeoffs, security/access, and governance.
- **Human in the loop:** the high-stakes 20% is non-delegable. “Check in with me” means stopping for an explicit decision before implementation.
- **Two failure modes:**
  - *AI drift:* non-deterministic output changes over time. Versioned context and reusable skills reduce drift.
  - *Hallucination:* a confident unsupported answer. Grounding, plan review, and runtime validation catch it.
- **Workflow:** Explore → Plan → Implement → Verify. Explore sources and list assumptions; plan grain, decisions, acceptance criteria, and validation; implement in reviewable steps; verify against both the plan and dbt enforcement.
- **Guardrails, lightly named:**
  - *Guide:* `AGENTS.md`, layer conventions, task routing, skills, planning templates.
  - *Enforce:* contracts, tests, SQLFluff, CI, and code review.
  - *Runtime:* approval gates, RBAC, deployment controls, and the Semantic Layer for governed consumption.
- Thread callout: high-quality context reduces corrective round-trips; shared rules travel across the team; independent checks enforce correctness regardless of whether a human or Wizard drafted the change.

## Section 4 — Add governance to development (~30 min, flagship hands-on)

**Working title:** “Trustworthy inputs are the foundation”  
**Subtitle:** institutionalizing knowledge to prevent drift

**Goal:** build a coherent, versioned governance operating model, then use it to plan the Alembic build.

### Explain the asset types

- `AGENTS.md`: always-on project context—domain, layer rules, naming, source-of-truth locations, validation requirements, and boundaries.
- Layer conventions: always-on baseline context, not standalone skills. Every staging/intermediate/mart model must follow them.
- Task routing: maps a request to the relevant workflow or skill.
- Skills: conditional, reusable instructions for a task such as building a governed vertical slice, reviewing SQL, defining a metric, or investigating a failed job.
- Workflow and plan templates: required decision checkpoints and implementation evidence.
- `SECURITY.md`: a pointer to sensitive-data and prohibited-action policy; mention it, but do not make it a hands-on artifact.

### Hands-on — build the governance scaffold together

Ship a **skill-building skill** as the shared point of entry, then use it to create/refine these six assets:

1. Task routing map.
2. A task-oriented “build a governed dbt vertical slice” skill.
3. A semantic-layer authoring skill.
4. A model/review-and-verification skill.
5. An Explore → Plan → Implement → Verify workflow/runbook.
6. A planning and prompt-back template.

The prompt-back policy requires a human decision for ambiguous grain, source authority, metric definitions, business classifications, join/cardinality assumptions, contract-breaking changes, PII/access concerns, and material performance tradeoffs.

- Use the existing project patterns as the source material. Do not invent generic standards when the repo already has a proven convention.
- Govern the governance assets like code: version control, CODEOWNERS review, change history, and periodic pruning.
- **Slide-worthy principle:** *Skills and `AGENTS.md` are executable team policy in practice. Ownership, version control, review requirements, change logs, and periodic pruning matter as much as writing them once.*
- Take-home: the template set in `docs/training_materials/ai_governance_templates.md` plus the disabled reference implementation in `models/answer_key/`.

## Section 5 — Add governance to production (~20 min)

**Working title:** “Guardrails in action”  
**Subtitle:** governing risk and action requires explicit boundaries

**Goal:** extend governance through review, promotion, and production with one review example and one failure investigation.

- **Review as a discipline** (demo/walkthrough · enforce):
  - Use an AI-assisted PR rubric to review a deliberately flawed change: grain, lineage, contracts, tests, semantic impact, performance, docs, and evidence.
  - Traceability: tag/record AI assistance and validation. Human ownership remains attached to the author and reviewer.
  - CI and dbt Platform CI independently validate work; reviewer approval is not a substitute for a passing build.
- **Contract/test proof:** deliberately break a safe example and show an enforced contract or data test fail loudly, then correct it through the workflow.
- **Human-in-the-loop progression** (runtime): start with ask-for-approval; scope autonomy by risk; require a prompt-back whenever the agent lacks the authority or evidence to decide.
- **Hands-on — debug a failed job** (Verify · runtime): learners use “Debug with Wizard” on a prepared failed run, compare diagnosis evidence with a neighbor, and identify the smallest safe next action. Confirm during build whether a pre-failed run can ship or must be triggered in-session.
- RBAC, deployment permissions, and account controls are discussion/demo topics. They set the boundary for who may diagnose, edit, approve, and deploy.

## Section 6 — Scaling (~8 min, walkthrough only)

**Working title:** “Consistency across teams”  
**Subtitle:** consistency is an infrastructure problem

**Goal:** show how one person’s pattern becomes shared infrastructure within a project, then point to the next control planes.

- **Within a project, now:** `AGENTS.md`, layer conventions, task routing, skills, workflows, PR templates, contracts/tests, semantic definitions, and ownership checks.
- **Across projects, next:** native package-skill support will make standardized skills easier to distribute and govern across dbt projects. Mention as an upcoming scaling path; do not teach package installation in this session.
- **Beyond dbt Platform, mention only:** the dbt MCP Server carries trusted dbt context to external agents and tools. MCP, Runlayer/plugins, and Snowflake Cortex are extensions of the same principles—least privilege, governed definitions, evidence, and ownership—not replacements for dbt-native governance. Point attendees to **Creating context with dbt MCP Server** for the implementation depth.
- Thread callout: central rules reduce rework and cost; contributors change AI assets through code review; governed dbt definitions remain the trusted foundation as more tools consume them.

## Section 7 — Closing (~7 min)

**Goal:** recap, hand off, and give attendees an actionable Monday-morning starting point.

- One-breath recap: explore → feel ungrounded risk → name human decision rights → build durable context/skills/workflows → enforce through dbt → scale the same controls outward.
- Hand off the governance template map and the fully governed target-state reference in `models/answer_key/`.
- “First Monday back”: add/refine `AGENTS.md`; capture one repeatable workflow as a skill; require a written plan and scoped validation before accepting AI-authored implementation.
- Tease the separate dbt MCP Server training for beyond-platform implementation.
- Survey and thank you.

## Open questions to resolve before delivery

1. Confirm the precise dbt Platform UX for creating, discovering, and invoking custom skills during the workshop; keep the live exercise aligned with current product support.
2. Reconcile PR review rubric categories with the final rubric/template source.
3. Confirm whether the prepared failed job can ship pre-failed or must be triggered in-session.
4. Decide which production/CI examples are live versus pre-recorded.
5. Confirm current product language and availability before naming external integrations or Cortex guardrails on slides.
