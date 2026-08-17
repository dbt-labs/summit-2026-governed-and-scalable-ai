# Training asset delivery plan

This document defines the complete deliverable set for **Governed & Scalable AI-assisted Analytics with dbt** before implementation begins. It separates the final reference state from the workshop starter state so we can validate a coherent operating model first, then deliberately decide what attendees inspect, refine, or build.

## Delivery principle

Build and test the **complete final-state reference** first. Only after it works end to end do we derive the learner experience:

1. **Ready immediately:** existing, working foundation attendees use from minute one.
2. **Refine live:** intentionally incomplete or simplified scaffolds attendees improve.
3. **Build net-new:** deliberately absent assets attendees create with Wizard.
4. **Reference only:** complete answers and optional extensions used for recovery and take-home adoption.

> **Skills and `AGENTS.md` are executable team policy in practice. Ownership, version control, review requirements, change logs, and periodic pruning matter as much as writing them once.**

## Reference-state file tree

`training_assets/reference/` is initially a complete snapshot of every final deliverable asset, including versions that later differ from active project files. It is intentionally comprehensive at this stage. Once the workshop flow is proven, we may keep only the reference copies needed for refined and net-new exercises.

```text
training_assets/
├── README.md
├── reference/
│   ├── AGENTS.md
│   ├── SECURITY.md
│   ├── .agents/
│   │   ├── ROUTING.md
│   │   ├── skills/
│   │   │   ├── building-governed-skills/
│   │   │   │   ├── SKILL.md
│   │   │   │   └── references/
│   │   │   │       └── skill-design-checklist.md
│   │   │   ├── authoring-staging-models/
│   │   │   │   ├── SKILL.md
│   │   │   │   └── references/
│   │   │   │       └── staging-model-checklist.md
│   │   │   ├── authoring-intermediate-models/
│   │   │   │   ├── SKILL.md
│   │   │   │   └── references/
│   │   │   │       └── grain-and-join-checklist.md
│   │   │   ├── authoring-governed-marts/
│   │   │   │   ├── SKILL.md
│   │   │   │   └── references/
│   │   │   │       └── mart-contract-and-test-checklist.md
│   │   │   ├── authoring-governed-metrics/
│   │   │   │   ├── SKILL.md
│   │   │   │   └── references/
│   │   │   │       └── metric-definition-checklist.md
│   │   │   ├── reviewing-governed-dbt-changes/
│   │   │   │   ├── SKILL.md
│   │   │   │   └── references/
│   │   │   │       └── review-rubric.md
│   │   │   └── investigating-dbt-job-failures/
│   │   │       ├── SKILL.md
│   │   │       └── references/
│   │   │           └── dbt-job-investigation.md
│   │   ├── workflows/
│   │   │   ├── governed-dbt-change.md
│   │   │   └── onboarding-source-system.md
│   │   └── templates/
│   │       ├── dbt-change-plan.md
│   │       └── source-to-target-design.md
│   ├── .github/
│   │   ├── CODEOWNERS
│   │   └── pull_request_template.md
│   └── docs/
│       └── governance_scorecard.md

├── starter/                         # created after the reference state is proven
│   └── README.md
└── lab_guides/                      # created after the starter state is designed
    └── README.md
```

`models/answer_key/` remains separate. It is the disabled dbt answer key for the completed `alembic_ops` procurement models, contracts/tests, and Semantic Layer extension. It is not the home for non-dbt governance assets.

## Source-system workflow architecture

The source-system onboarding workflow composes reusable layer skills; it is not a source-specific implementation skill.

```text
Explore source system and established project patterns
        ↓
Approve source-to-target design and open business decisions
        ↓
Staging skill for each required raw table
        ↓
Intermediate skill when joins, aggregation, dedupe, fanout control, or grain change is required
        ↓
Mart skill for public dimensions/facts, contracts, tests, descriptions, and interface impact
        ↓
Semantic skill when a governed entity, dimension, measure, or metric changes
        ↓
Review and verification: build, lint, CI, and recorded evidence
```

A simple one-to-one dimension may project one staging model. A public mart that needs joins, aggregation, deduplication, fanout control, or grain changes must consume a named intermediate model rather than embedding that logic directly.

## Asset catalog and definition of done

### Repository-level context and boundaries

| Asset | Governance purpose | Final reference definition of done | Intended workshop state |
|---|---|---|---|
| `reference/AGENTS.md` | Always-on context for Wizard and humans: project purpose, source-of-truth documents, layer rules, naming, macro reuse, validation, semantic boundary, and decision rights. | Accurately reflects the final project; links resolve; establishes clear defaults; names mandatory validation; directs Wizard to prompt back instead of inventing business decisions; does not conflict with skills or policies. | **Refine live.** The active root version will have selected context removed or simplified so attendees discover and restore it from the project evidence. |
| `reference/SECURITY.md` | Records the AI/data-handling boundary: what must not be exposed, when to escalate, and how repository policy relates to platform permissions. | Clearly labeled as a reusable training template, not an organizational security claim; identifies sensitive-data decisions, credential restrictions, prohibited actions, least privilege, escalation, and human responsibility; linked from final `AGENTS.md`. | **Ready/scaffold.** Keep a concise skeleton in the active repo; discuss organization-specific customization rather than asking the room to invent a security program. |
| `reference/.github/CODEOWNERS` | Gives governance assets and data-product definitions accountable reviewers. | Covers `AGENTS.md`, `SECURITY.md`, `.agents/`, semantic definitions, marts/contracts, CI, and PR template paths; uses documented placeholder teams/users suitable for a public training repo; no unowned governance path. | **Refine live or demo.** Start with visible placeholder ownership and ask attendees to identify which teams would own each path. |
| `reference/.github/pull_request_template.md` | Makes AI assistance, human decisions, impact, and validation visible at review time. | Requires: change summary, AI assistance declaration, human decisions/prompt-backs, grain/metric/contract impact, validation commands/results, and reviewer checklist; usable for both human- and AI-assisted changes. | **Refine live.** Start with a generic template and add the AI evidence fields after the review lesson. |

### Agent operating model

| Asset | Governance purpose | Final reference definition of done | Intended workshop state |
|---|---|---|---|
| `reference/.agents/ROUTING.md` | Makes instruction selection predictable by mapping request types to a workflow and relevant skill. | Covers source-system onboarding, layer-specific model work, semantic changes, model review, job failures, and skill authoring; says what always-on context applies; avoids conflicting routes; explains fallback when no specialized skill applies. | **Build net-new.** Learners create it after they understand the project and assets. |
| `reference/.agents/skills/building-governed-skills/SKILL.md` | Standardizes how the team creates, scopes, tests, and maintains skills. | Defines a skill’s trigger, non-goals, required context, workflow, prompt-backs, references, validation, ownership, and retirement/review cadence; prevents redundant or overly broad skills. | **Ready then audit live.** Ship it as the shared point of entry so the class can use it to shape other skills. |
| `reference/.agents/skills/authoring-staging-models/SKILL.md` | Builds source declarations and one-source, 1:1 staging models. | Requires source/YAML/data inspection, source tests, exact source column grounding, type/casing/null cleanup, shared macro reuse, and staging-level validation; prohibits joins, aggregation, and business logic. | **Build live.** Reused for every raw Alembic table. |
| `reference/.agents/skills/authoring-intermediate-models/SKILL.md` | Handles joins, deduplication, fanout control, aggregation, and grain changes before public marts. | Requires stated grain, join cardinality, upstream column grounding, fanout/deduping strategy, intermediate tests/docs, and scoped validation; keeps public contract logic in marts. | **Build live.** Used for supply cost and as the project’s join-layer rule. |
| `reference/.agents/skills/authoring-governed-marts/SKILL.md` | Builds public dimensions and facts. | Requires stated grain, direct single upstream input whenever possible, explicit casts, enforced contracts, tests, descriptions, compatibility review, semantic impact review, and scoped build/lint validation. | **Build live.** Used for `dim_suppliers` and `fct_brews`. |
| `reference/.agents/skills/authoring-governed-metrics/SKILL.md` | Keeps metric changes tied to agreed business definitions and the Semantic Layer. | Requires definition, grain, aggregation, entities/dimensions, time semantics, source measures, consumer/downstream impact, conflict check, and validation; stops for an unresolved definition rather than creating a competing metric. | **Scaffold/refine.** Seed a minimal version, then complete the supply-cost/margin decision guidance during the final lab. |
| `reference/.agents/skills/reviewing-governed-dbt-changes/SKILL.md` | Gives reviewers a consistent standard for AI-assisted dbt changes. | Checks grain, lineage, fanout, layer fit, contracts, types, tests, semantic impact, docs, performance/materialization, breaking changes, and verification evidence; separates must-fix defects from suggestions. | **Refine live.** Start with the basic rubric and add project-specific failure patterns from the flawed-change review. |
| `reference/.agents/skills/investigating-dbt-job-failures/SKILL.md` | Standardizes safe, evidence-based job failure diagnosis. | Requires job/run context, failed-node/error evidence, affected code/config inspection, minimal safe remediation, validation/retry decision, and escalation boundaries; does not guess or mutate production without approval. | **Ready immediately.** The job-debug lab demonstrates using it, not authoring it. |
| `reference/.agents/skills/*/references/*.md` | Holds detailed checklists and examples without making core skills long or generic. | Each reference is tied to one skill, current with final policies, contains no conflicting authority, and is linked from the owning `SKILL.md`; examples use project conventions. | **Reference only** at first; selectively expose where a lab benefits from it. |
| `reference/.agents/workflows/governed-dbt-change.md` | Operationalizes Explore → Plan → Implement → Verify as the shared lifecycle. | Defines required inputs, expected artifact, human checkpoint, execution boundary, and evidence for each phase; points to the plan template and relevant skills; includes a stop/escalate path. | **Ready; explain.** |
| `reference/.agents/workflows/onboarding-source-system.md` | Orchestrates staging → intermediate → marts → semantic as needed for a new source system. | Requires source-to-target design approval, invokes only necessary layer skills, records open decisions, and ends with review/verification evidence. | **Build live.** Used for Alembic planning. |
| `reference/.agents/templates/dbt-change-plan.md` | Captures the human-approved design before a material change. | Prompts for business outcome, sources/evidence inspected, grain, transformations/joins, assumptions, prompt-backs/decisions, contract/test/docs/semantic/downstream impact, acceptance criteria, validation selector/results, and follow-up. | **Ready; use live.** |
| `reference/.agents/templates/source-to-target-design.md` | Designs a new source system before implementation. | Maps source tables, keys, quirks, staging models, required intermediates and grain changes, marts, semantic definitions, open decisions, and validation plan. | **Build live.** Complete for Alembic before implementation. |

### Production enforcement, operations, and upkeep

| Asset | Governance purpose | Final reference definition of done | Intended workshop state |
|---|---|---|---|
| Existing mart contracts/tests | Enforces public model schemas and data quality regardless of author. | Every mart has a complete typed enforced contract; PK/FK/categorical/required-value tests follow project policy; models explicitly cast to contract types; scoped builds pass. | **Ready immediately.** Use as the enforcement proof point and extend for `dim_suppliers`/`fct_brews`. |
| Existing parse/lint CI | Independently catches dbt configuration and SQL style problems before merge. | Workflow installs declared dependencies, uses a safe CI profile, runs `dbt parse` and SQLFluff, and documents its warehouse-free boundary. | **Ready immediately.** Walk through; do not build live. |
| dbt Platform CI job | Verifies warehouse-backed behavior before promotion. | Configured to run appropriate CI selector/build, surfaces artifacts/errors, has correct environment/deferral/access settings, and is tested with a known PR. | **Demo/pre-record.** Platform configuration is not a source-controlled workshop build. |
| Semantic models and metrics | Defines the canonical business definitions available to governed analytics and AI consumption. | Existing metrics remain valid; Alembic supply-cost measures and margin metric have explicit agreed definitions, correct grain, tests/contracts supporting them, and validated results. | **Extend in final lab** after the class makes the business decisions. |
| RBAC and approval mode | Controls who can use Wizard, make edits, approve actions, deploy, or diagnose. | Documented role/action matrix exists in platform administration; approval boundaries align with risk; training account setup is verified. | **Discuss/demo.** Do not create a pretend RBAC policy in repo source. |
| `reference/.agents/skills/investigating-dbt-job-failures/references/dbt-job-investigation.md` | Bundles the detailed operational playbook with its owning job-investigation skill. | Includes triage sequence, evidence to collect, severity/escalation guidance, safe remediation/retry steps, and post-incident follow-up; agrees with the owning skill. | **Reference/supporting asset.** Use during the job lab if helpful. |

| `reference/docs/governance_scorecard.md` | Makes ongoing governance measurable and maintained. | Defines owners, review cadence, indicator definitions, evidence source, and action when a metric regresses; starter indicators cover validation rate, reviewer findings, AI-assisted PR evidence, skill reuse, stale assets, and incident learnings. | **Discuss/take-home.** Do not spend live time designing the measurement program. |

### Explicitly outside the reference repo implementation

These are important controls, but they are not buildable source files for this workshop:

- dbt Platform account-level AI enablement, permission sets, RBAC, approval configuration, and audit/usage capability.
- dbt Platform CI job configuration and environment credentials.
- dbt MCP Server setup, external-agent permissions, Snowflake Cortex, Runlayer/plugins, and organization-wide identity or observability architecture.
- Native package-skill distribution across projects. Position this as an upcoming scaling path once available as a first-class capability.

The training should name these as the next control planes and point attendees to the dbt MCP Server session for the beyond-platform implementation.

## Cross-asset consistency requirements

The reference implementation is not done until these statements are true:

1. **One policy, many applications:** `AGENTS.md` defines defaults; routing, skills, workflows, templates, PR review, and runbooks reinforce rather than contradict those defaults.
2. **Prompt-backs are consistent:** all assets use the same stop conditions—unclear grain/cardinality, source authority, metric definition, business meaning, breaking interfaces, data sensitivity, and material performance/cost tradeoffs.
3. **Evidence is required:** a material change records what was inspected, the human decisions made, validation performed, and any remaining uncertainty.
4. **Enforcement is independent:** contracts, tests, lint, CI, and review can catch problems even if the agent or human author misses them.
5. **Ownership is explicit:** every shared governance asset has an accountable reviewer and an update/review cadence.
6. **Skills are task-oriented:** layer conventions stay in always-on context; source-system onboarding composes layer skills only as needed.
7. **The Semantic Layer remains authoritative:** AI-assisted analytics extends governed definitions rather than hand-rolling competing metrics.

## Reference acceptance test plan

Before deriving the workshop starter state, test the final assets against four scenarios.

| Scenario | Assets exercised | Evidence of success |
|---|---|---|
| Build the `alembic_ops` procurement vertical | `AGENTS.md`, routing, source-system workflow, source-to-target design, staging/intermediate/mart skills, review skill, contracts/tests, CI expectations | Wizard inspects actual sources/docs, produces a plan, prompts back on units/nulls/margin definition, creates conforming models and YAML, and passes scoped build + SQLFluff after human decisions. |
| Add or change a governed metric | Metric skill, plan template, Semantic Layer YAML, review skill | Wizard identifies whether an existing metric already applies, obtains the business definition, produces a compatible semantic change, and validates it without creating a competing definition. |
| Review a deliberately flawed AI-authored change | Review skill, reference rubric, PR template, contracts/tests | Reviewer identifies the intended grain and the concrete defects, distinguishes must-fix from suggestions, requests missing evidence, and verifies the corrected change. |
| Diagnose a failed dbt job | Job-investigation skill, runbook, routing, platform run evidence | Wizard uses run-specific evidence, identifies the smallest safe next action, avoids unsupported claims, and stops for approval before a remediation/retry with production impact. |

## Deriving the workshop state after acceptance

After the acceptance tests pass, create `training_assets/starter/` and `training_assets/lab_guides/` from the reference state.

1. Copy all reference assets initially.
2. Mark each asset as **ready**, **scaffolded**, **net-new**, **reference only**, or **discuss/demo**.
3. For refined assets, remove only the specific information learners can discover from the repo or supply through an explicit human decision. Use visible `TODO(training)` markers, never silent omissions.
4. For net-new assets, omit the active copy while preserving the reference version for facilitator recovery.
5. Keep the reference copy intact and versioned; it is the answer key for governance assets.
6. Write the facilitator guide only after the starter gaps and expected participant outputs are fixed.

## Next implementation order

1. Create the `training_assets/reference/` tree and its top-level README.
2. Build final `AGENTS.md`, `SECURITY.md`, routing, shared workflow/template, and skill-building skill.
3. Use the skill-building skill to build source-system onboarding, staging, intermediate, mart, semantic, review, and job-investigation assets with focused references.
4. Build final CODEOWNERS, PR template, job runbook, and governance scorecard.
5. Run the four acceptance scenarios and revise until the assets work together.
6. Derive the starter/refine/net-new workshop state.
7. Create `docs/training_materials/facilitator_prompts_and_labs.md` with exact prompts, required context, human checkpoints, validation, recovery paths, and reference links.
8. Use the proven asset set to build and validate the final Alembic dbt answer key.
