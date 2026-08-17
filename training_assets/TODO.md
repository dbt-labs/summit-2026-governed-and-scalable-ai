What is still missing from training_assets/reference/
The reference overlay currently has the foundation plus the source-to-target/layer assets. It still needs:

Governed metric authoring

.agents/skills/authoring-governed-metrics/SKILL.md
references/metric-definition-checklist.md
Review

This should be a project-specific review rubric/skill, not a recreation of Wizard’s built-in dbt review ability.
.agents/skills/reviewing-governed-dbt-changes/SKILL.md
references/review-rubric.md
Job investigation

.agents/skills/investigating-dbt-job-failures/SKILL.md
.agents/skills/investigating-dbt-job-failures/references/dbt-job-investigation.md

Review traceability and ownership

.github/pull_request_template.md
.github/CODEOWNERS
Governance upkeep

docs/governance_scorecard.md
Acceptance-test fixtures

A deliberately flawed dbt change/PR for the review showcase.
A stable failed or warning-bearing dbt job/run for the troubleshooting showcase.
A facilitator-only GitHub PR-review automation demo, derived from agentic_pr_review/.
That’s the remaining reference governance scope. The first five are source-controlled assets; the fixtures and GitHub automation are demo infrastructure.

Semantic: what we need
The semantic skill should be intentionally narrow: it governs how a team changes definitions, not a generic MetricFlow tutorial.

The current repo gives us a concrete reason for it:

models/marts/_marts.yml contains model-level semantic metadata and base measures such as total_net_revenue, total_orders, and total_units_sold.
models/marts/metrics.yml defines only average_order_value.
models/marts/_semantic_models.yml is currently just an empty placeholder/header.
So the skill needs to require:

inspect existing semantic definitions first;
state business definition, grain, source measure/mart, aggregation, dimensions/entities, and time semantics;
assess overlap/conflict with existing metrics;
obtain a human decision on ambiguous meaning;
validate the semantic change and consumer impact;
avoid creating a second definition of revenue, orders, units, supply cost, or margin.
For the Alembic lab, it should prompt back on the right issues:

Are recipe and ingredient units comparable, or do we need a conversion policy?
Is batch_supply_cost_gold an estimated standard cost based on current ingredient costs, or a historical actual cost?
Does margin use net order revenue, gross order revenue, or a different recognized-revenue definition?
What should a null brew_duration_minutes mean for operational metrics?
That’s enough to make “Semantic Layer governance” real in the course. The deep implementation mechanics belong in the Semantic Layer workshop.

Review: built-in Wizard vs. a project review skill
You’re right: Wizard already has built-in dbt knowledge and review capability, so we should demo that rather than pretending attendees need to build a generic SQL/YAML reviewer from scratch.

The project asset should add what the product cannot know by default:

this project’s staging → intermediate → mart boundary;
its “mart transformations must come through named intermediate models” rule;
the exact public contract and test requirements;
macro reuse and money conventions;
the organization’s human decision rights;
evidence needed for approval;
a consistent distinction between:
must fix before merge
needs human decision
suggestion / nice to have
So I recommend a thin reviewing-governed-dbt-changes skill, explicitly written as a supplement to Wizard’s native review. It would tell Wizard how to inspect the change plan, source-to-target design, diff, lineage, contracts/tests, Semantic Layer impact, and validation evidence through this project’s governance lens.

The demo then becomes much stronger:

Ask Wizard to review a deliberately flawed Alembic-style change.
Show its native dbt review behavior.
Show the project review rubric sharpening the feedback around grain, fanout, contract/type mismatch, missing tests, and missing decision evidence.
Explain that teams customize this rubric for their own business definitions, regulated fields, ownership model, and production risk—not to replace dbt’s native quality checks.
Job investigation
Agreed: keep this light and operational.

I’d create a concise job-investigation skill and companion runbook because they demonstrate the same core operating model in a different context:

gather run-specific evidence first;
identify the failed node, job configuration, error, and relevant code at the run’s Git SHA;
distinguish root cause from symptoms;
recommend the smallest safe remediation;
stop before retrying or making production-impacting changes without approval.
The workshop demo should be 5–10 minutes:

Open a prepared failed dbt Platform run or warning-bearing run.
Use Wizard / its built-in troubleshooting capability to inspect it.
Show the evidence-based diagnosis.
Ask the room: “Is this safe to retry, safe to fix in a branch, or does this require an owner decision?”
Tie it back to Explore → Plan → Implement → Verify.
No attendee-authored runbook or job failure required.

PR automation prototype: recommendation
The agentic_pr_review/ prototype has a good architecture:

reads repository guidance at runtime;
reviews only dbt SQL/YAML files;
identifies layers from paths;
returns structured findings;
states that AI feedback does not replace CI, tests, or business sign-off.
I would preserve that architecture, but create a facilitator-only GitHub proof of concept rather than porting the Azure DevOps/Cortex implementation mechanically.

Proposed GitHub-compatible demo design
A GitHub Actions workflow triggered on pull_request:

Checkout the PR head.
Gather changed dbt files through the GitHub API or git diff.
Load:
AGENTS.md
SECURITY.md
.agents/ROUTING.md
the project review skill/rubric
relevant changed-model YAML and nearby upstream context
Read the existing GitHub Actions dbt CI result:
dbt parse
sqlfluff lint
Call an approved model provider.
Post or update one advisory PR comment with:
scope reviewed;
evidence available/unavailable;
must-fix findings;
human-decision requests;
suggestions;
explicit statement that CI, contracts/tests, and required human review remain merge gates.
Boundaries
No automatic edits.
No auto-approval or auto-merge.
No secrets in source—provider/API credentials live in GitHub Actions secrets.
No claim that the model executed warehouse-backed tests unless the dbt Platform CI job has actually completed and its result is available.
Keep this outside the attendee hands-on path. It’s a “here’s how your repo policy can travel into a GitHub review workflow” demo.
I would not make Cortex required. The existing prototype can remain a Cortex/ADO example; the Summit demo can use whichever approved provider and GitHub integration are easiest to provision reliably. The important takeaway is repo-guided, advisory review plus independent dbt CI—not the LLM vendor.

One implementation note: agentic_pr_review/dbt_pr_review.py and azure_pipelines.yml currently appear empty in this workspace, while the README and mock_test.py retain the ADO/Cortex design. We should treat the README’s design as the reusable input and build the GitHub demo deliberately instead of assuming the full script is ready to port.

Ownership: what I meant
This is accountability for governance assets and public data products, not broad enterprise org design.

CODEOWNERS is the repository mechanism that asks the right people to review sensitive paths. For the public training repo, we should use transparent placeholder teams, such as:

/AGENTS.md, /SECURITY.md, and /.agents/ → @example-org/analytics-governance
/models/marts/ and semantic definitions → @example-org/analytics-engineering
/.github/workflows/ → @example-org/data-platform
/.github/pull_request_template.md and /.agents/skills/investigating-dbt-job-failures/ → appropriate governance/platform placeholders

The point of the demo is:

The people who own business definitions, deployment risk, and project policy should be asked to review their changes. AI can draft the change; it cannot assume that accountability.

This pairs with the PR template, which captures:

whether AI assisted;
the human decisions and prompt-backs;
grain/contract/metric impact;
validation evidence;
required reviewers.
For the public workshop repo, placeholders are correct. Participants map them to their own teams after the workshop.

Recommended build order
I’d do the remaining reference assets in this order:

Semantic skill + definition checklist
Thin project-specific review skill + rubric
Job investigation skill + lightweight runbook
PR template + CODEOWNERS
Governance scorecard
GitHub agentic PR-review demo design and workflow
Prepare flawed-change and failed-job fixtures
Run the four reference acceptance scenarios
Derive the trainee starting assets
Write the individual demo outlines

--------
The four acceptance scenarios are the proof that the reference governance system works as an operating model—not just as a set of well-written Markdown files.

1. Build the alembic_ops procurement vertical
What it tests: Can the source-system workflow guide a real new source slice from raw sources through governed marts?

Assets exercised

AGENTS.md
routing
governed-change workflow and change plan
source-system onboarding workflow
source-to-target design
staging, intermediate, and mart skills/checklists
review skill
mart contracts/tests
CI expectations
Expected behavior

Wizard explores the actual Alembic source YAML, ERD, data dictionary, existing patterns, and raw data as needed.
It creates a source-to-target design and material change plan.
It identifies and prompts back on unresolved decisions:
recipe/ingredient unit handling;
brew grain and batch supply cost;
null handling for brew_duration_minutes;
margin/semantic impact, if included.
After human decisions, it creates conforming staging, intermediate, mart SQL/YAML.
The new marts have contracts, tests, and descriptions.
Scoped build and SQLFluff pass.
Branch boundary: this is a valid implementation scenario, so it can run on a clean implementation branch or facilitator branch. It should not permanently build the lab into the learner main branch unless we decide the main project should become the completed answer state. The disabled models/answer_key/ remains the comparison point.

2. Add or change a governed metric
What it tests: Can the semantic skill prevent metric drift and require a real business definition before YAML is changed?

Assets exercised

semantic authoring skill and checklist
generic change plan
existing semantic metadata and metrics.yml
review skill/rubric
underlying mart contracts/tests
Expected behavior

Wizard searches current semantic definitions first.
It identifies whether the requested business question can reuse total_net_revenue, total_orders, total_units_sold, or average_order_value.
It documents the proposed definition: source mart, grain, aggregation/formula, entity/dimension, time semantics, units, null behavior, consumers, and overlap/conflict assessment.
It prompts back if the definition is unresolved—especially supply cost/margin:
standard versus actual cost;
gross versus net/recognized revenue;
unit conversion policy;
relationship between brews and sales.
After approval, it makes a compatible semantic change and validates parse, semantic configuration, source-mart build, and representative output.
Branch boundary: this is also a valid change scenario. It can run on a clean facilitator branch paired with a valid Alembic implementation. It does not need to land on learner main.

3. Review a deliberately flawed AI-authored change
What it tests: Can the review skill/rubric sharpen native Wizard review with team-specific policy and clearly classify findings?

Assets exercised

review skill and rubric
PR template
CODEOWNERS
contracts/tests
plan/source-to-target design
project policy and layer skills
Expected behavior

Wizard inspects the diff, request, plan, relevant upstream/downstream lineage, contracts/tests, and validation evidence.
It finds concrete defects—such as a mart joining multiple inputs directly, unproven fanout, missing contract/test, or cast/type mismatch.
It identifies unresolved business assumptions—such as supply-cost units or margin basis—as needs human decision, rather than inventing a fix.
It identifies any non-blocking cleanup as a suggestion.
It rejects “parse passed” as sufficient evidence for SQL behavior.
After correction, it verifies the must-fix items are actually resolved.
Branch boundary: this belongs entirely on the separate flawed-change demo branch/PR. It should never merge to main.

4. Diagnose a failed dbt Platform job
What it tests: Can the job-investigation skill turn actual run evidence into a safe next action without guessing or retrying production work?

Assets exercised

job-investigation skill
job runbook
routing
dbt Platform job/run details, errors/warnings, logs, and artifacts
relevant code/config at the failing run’s SHA
security and escalation policy
Expected behavior

Wizard scopes the run to the current project and identifies job, run, environment, branch/SHA, failed node, and impact.
It gathers run-specific errors, warnings, logs, artifacts, timing, and job configuration.
It classifies the failure and separates confirmed evidence from hypotheses.
It recommends the smallest safe action:
fix on a branch;
escalate to source/platform/warehouse owner;
request approval to retry;
or gather a specific missing artifact.
It does not weaken a test, claim an unsupported root cause, or retry/remediate without approval.
Branch boundary: this belongs on the separate failed-job demo branch with a dedicated job run at a preserved SHA. The actual failing run is a dbt Platform artifact; main remains clean.

How this fits the branch strategy
Scenario	Where it should run	Main remains green?
Alembic vertical	Valid facilitator implementation branch	Yes
Governed metric	Valid facilitator implementation branch	Yes
Flawed review	Dedicated flawed-change PR branch	Yes
Failed job	Dedicated failure branch + demo job/run	Yes
One subtle but important point: the delivery plan originally says to run all four before deriving the learner starter state. With the branch boundary we just agreed, I’d refine that sequencing:

Complete and cross-check the reference governance assets on main.
Derive the learner starter state from the clean main/reference state.
Execute the two valid-change acceptance scenarios on controlled facilitator branches.
Create the flawed-review and failed-job fixture branches.
Execute the two showcase acceptance scenarios.
Finalize the individual demo outlines with exact branch/run references and fallback artifacts.
That keeps the answer key and learner baseline clean while still proving all four scenarios end to end.