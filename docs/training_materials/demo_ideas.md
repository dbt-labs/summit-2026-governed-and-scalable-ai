1. How Wizard assists with governance out-of-the-box
- Native metadata grounding, not a generic coding agent — Wizard is built on a structured index of your project's lineage, tests, contracts, and semantic definitions, so its answers/edits are checked against real project state rather than guesses.
 - Deliverable: a demo project with model contracts + a few Semantic Layer metrics already defined, so attendees can visibly see Wizard respect them.
 - Reference: [About dbt Wizard in the dbt platform](https://docs.getdbt.com/docs/platform/wizard-platform)

- Approval-mode diffs by default — every proposed file change is shown as a diff before anything is persisted; nothing is silently written to the project.
 - Deliverable: a live toggle demo — same prompt run once in "Ask for approval" and once in "Edit files automatically" on a throwaway branch.
 - Reference: [How dbt Wizard works](https://docs.getdbt.com/docs/dbt-ai/wizard-how-it-works)

- Self-validation loop before you ever see a diff — Wizard checks proposed changes against the live project (lineage/tests) and retries silently on failure; you only see a diff once it's passed.
 - Deliverable: a demo model with a deliberately broken reference/test so the audience watches Wizard catch and self-correct before proposing anything.
 - Reference: [How dbt Wizard works](https://docs.getdbt.com/docs/dbt-ai/wizard-how-it-works)

- Built-in, always-on dbt Agent Skills — dbt Labs-maintained skills (e.g., troubleshooting-dbt-job-errors) encode best practices with zero setup.
 - Deliverable: an intentionally broken job run in the demo environment for Wizard to investigate live using the built-in skill.
 - Reference: [dbt Wizard in Studio IDE](https://docs.getdbt.com/docs/dbt-ai/wizard-ide)

2. Scaling AI-powered workflows with Wizard in the Platform
- One agent across every surface (Studio IDE, Canvas, Insights, home app) — engineers and analysts work through the same governed agent instead of a patchwork of point tools.
 - Deliverable: a two-part demo repo walkthrough — a dev-style ask in Studio IDE, then an analyst-style ask in Canvas/Insights against the same models.
 - Reference: [The dbt platform features](https://docs.getdbt.com/docs/platform/about-platform/dbt-platform-features)

- Skills as a team-wide scaling lever — repo-level skills (.agents/skills/SKILL.md) encode your conventions once; every teammate's Wizard session inherits them without re-prompting.
 - Deliverable: commit 2–3 real skills to the repo (e.g., a modeling-style skill, a semantic-model-authoring skill, a testing-standards skill) attendees can fork.
 - Reference: [Use skills with dbt Wizard in the dbt platform](https://docs.getdbt.com/docs/dbt-ai/wizard-platform-skills)

- Project-level instructions picked up automatically (AGENTS.md/CLAUDE.md) — onboarding a new project onto governed AI workflows doesn't mean re-teaching Wizard from scratch each time.
 - Deliverable: an AGENTS.md at repo root with project-wide context.
 - Reference: [Migrate to dbt Wizard](https://docs.getdbt.com/docs/dbt-ai/wizard-migrate)

- Whole-workflow iteration, not single-file edits — the agent-native home tab scales from one-off SQL generation to a full investigate → build → validate → ship loop.
 - Deliverable: a scripted "day in the life" prompt sequence (a markdown file in the repo) attendees run end-to-end during the lab.
 - Reference: [How dbt Wizard works](https://docs.getdbt.com/docs/dbt-ai/wizard-how-it-works)

- Predictable usage/cost scaling — included action limits by plan, plus BYOK, let teams budget as they roll AI out broadly rather than an unbounded spend.
 - Deliverable: a short README section in the repo documenting the workshop account's plan tier/BYOK setup for reproducibility.
 - Reference: [Overview of dbt Wizard (Billing section)](https://docs.getdbt.com/docs/platform/wizard-overview)

3. Governing, guardrailing, and enforcing in the Platform
- RBAC gates who can even touch the agent — governance starts before a single prompt is sent, via permission sets (Account admin, Developer seat, etc.).
 - Deliverable: a doc/screenshot in-repo showing the permission sets used for the workshop account.
 - Reference: [About user access in dbt](https://docs.getdbt.com/docs/platform/manage-access/about-user-access) / [Enterprise permissions](https://docs.getdbt.com/docs/platform/manage-access/enterprise-permissions)

- Account-wide admin toggle — a single admin-controlled switch enables/disables AI features for the whole account, centrally.
 - Deliverable: an "Enabling AI features" checklist step in the repo's setup README, mirroring this flow.
 - Reference: [Enable AI in dbt platform](https://docs.getdbt.com/docs/platform/enable-dbt-ai)

- Model contracts as a hard build-time guardrail — a public model with an enforced contract will fail to build if columns/types drift, whether the change came from a human or Wizard.
 - Deliverable: 1–2 demo models with config: contract: enforced: true and access: public, so attendees can watch a Wizard-proposed change get caught by the contract.
 - Reference: [Model contracts](https://docs.getdbt.com/docs/mesh/govern/model-contracts)

- CI enforcement independent of who authored the change — dbt Project Evaluator + state:modified selectors catch undocumented public models, missing tests, or contract gaps before merge.
 - Deliverable: a CI job config (packages.yml with dbt_project_evaluator, a CI workflow running dbt build --select state:modified+) committed in-repo.
 - Reference: [Get started with CI tests](https://docs.getdbt.com/guides/set-up-ci) / [dbt_project_evaluator governance rules](https://dbt-labs.github.io/dbt-project-evaluator/0.8/rules/governance/)

- Wizard's own hard-coded guardrails — it never runs destructive commands (--full-refresh, git reset --hard) without approval, and sandbox flags let you dial autonomy up/down per task.
 - Deliverable: a demo contrasting a scoped "relaxed" sandbox task vs. an attempted destructive command being blocked.
 - Reference: [How dbt Wizard works](https://docs.getdbt.com/docs/dbt-ai/wizard-how-it-works)

- Semantic Layer as the enforced single source of truth for metrics — dbt Labs explicitly recommends restricting freeform SQL to sandboxes and preferring query_metrics/Semantic Layer tools for anything production-facing, so "AI-assisted analytics" doesn't silently drift into ungoverned SQL.
 - Deliverable: a semantic_models/ + metrics.yml in the repo, plus two MCP tool profiles (a "governed" profile with only Semantic Layer tools, a "sandbox" profile with execute_sql enabled) to demo the contrast live.
 - Reference: [How the dbt MCP Server connects AI to trusted data](https://www.getdbt.com/blog/mcp)
