# Demo 3 — Find the patterns

## Summary

Trainees inspect the existing project and complete the three bounded `TODO(training):` sections in root `AGENTS.md`. The exercise captures durable project context—not the Alembic solution and not a task-specific checklist.

## Relevant files

- `AGENTS.md`
- `training_assets/reference/AGENTS.md` — facilitator convergence check only, never Wizard input
- `README.md`
- `dbt_project.yml`
- `docs/merlinco/`
- representative SQL/YAML under `models/staging/`, `models/intermediate/`, and `models/marts/`
- `macros/`

## TODO 1 — Project map and authority

Guide trainees to answer:

- What business domains and source systems exist?
- Which paths are completed/read-only patterns?
- Which paths are learner workspaces?
- Which files govern source structure, requested outcomes, modeling conventions, routing, and security?
- Which folders must never be used as trainee evidence?

## TODO 2 — Layer, grain, naming, and SQL patterns

Guide trainees to answer:

- What belongs in staging, intermediate, and marts?
- Where may grain change, joins, deduplication, and aggregation occur?
- What are the effective materializations?
- What naming differences isolate Warlock and Wizard nodes?
- How do `source()`, `ref()`, import CTEs, transformation CTEs, and `final` appear in completed models?

## TODO 3 — Documentation, testing, contracts, and evidence

Guide trainees to answer:

- Which tests protect PKs, FKs, categoricals, required fields, and composite grains?
- How are accepted values grounded?
- How are copper and gold fields represented?
- What do public mart contracts require from SQL and YAML?
- Why are descriptions, scoped builds, lint, and warehouse checks separate evidence?

## Optional Wizard prompt

```text
Help us complete the three TODO(training) sections in AGENTS.md. Inspect only the active project files named by each TODO, summarize the patterns you find, and propose concise durable policy language. Do not inspect training_assets/reference or models/answer_key, do not edit models, and do not add Alembic-specific implementation decisions.
```

## dbt commands

```text
dbt ls --resource-type model
dbt parse --no-partial-parse
```

The parse is a project regression check; it does not validate Markdown policy.

## Exit state

Root `AGENTS.md` contains no training TODOs and is conceptually aligned with `training_assets/reference/AGENTS.md` without requiring identical prose.
