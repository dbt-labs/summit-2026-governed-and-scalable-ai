# Workflow templates

Both files here end in `.yml.example`, which makes them **inert**. GitHub Actions
only reads `.yml` and `.yaml` files in this directory, so these are never parsed,
never triggered, and can never reach a secret. They exist to be read.

| Template | What it demonstrates |
|---|---|
| `dbt_ci.yml.example` | A warehouse-free PR gate — `dbt parse` plus SQL lint. Uses no secrets. |
| `codeowners-check.yml.example` | Validating CODEOWNERS with a GitHub App credential, behind an approval gate. |

This repository does not rely on either one. The enforcement that matters for the
project — the warehouse-backed build, tests, contracts, and the semantic layer —
runs as a dbt platform CI job.

## Activating one

1. Rename it to drop `.example` (`dbt_ci.yml.example` → `dbt_ci.yml`).
2. Work through the checklist below.
3. Open a throwaway PR and confirm the run does what you expect before relying on it.

## Hardening checklist

Anything that runs automatically on a pull request is reachable by anyone who can
open a pull request. Before activating a workflow in a repository you care about:

- [ ] **No secrets on an automatic `pull_request` trigger.** A workflow that needs a
      credential needs a gate: an `environment:` with required reviewers, a
      `workflow_dispatch`-only trigger, or an explicit trusted-actor condition.
      GitHub withholds secrets from fork-originated `pull_request` runs, but that is
      a platform default protecting you — not a control you configured, and it does
      not apply to branches inside the repository.
- [ ] **`pull_request_target` only with extreme care, if at all.** It runs with the
      base repository's secrets and write-scoped token. Combining it with a checkout
      of the PR head executes untrusted code with those privileges. Neither template
      here uses it.
- [ ] **Least-privilege `permissions:`.** Both templates set `contents: read`. Widen
      only for a specific need, and prefer setting it per job.
- [ ] **Pin third-party actions to full commit SHAs.** Version tags are mutable.
      Neither template ships a usable pin: `codeowners-check.yml.example` uses
      `example-commit-sha` placeholders, and `dbt_ci.yml.example` uses floating
      version tags. Resolve both against the action's releases before activating.
- [ ] **No credentials in source.** Secrets belong in Actions secrets or an
      environment. `ci/profiles.yml` is deliberately credential-free: `dbt parse`
      and lint resolve the adapter without connecting, so every value in it is a
      placeholder.
- [ ] **Confirm the engine.** `dbt_ci.yml.example` installs classic dbt-core, which
      does not parse this project's platform-authored semantic definitions.

## Why this is in a governance workshop

These templates are the **Enforce** layer. Repository instructions guide an author;
`AGENTS.md` and skills cannot stop a bad change on their own. Contracts, tests,
lint, and CI reject it regardless of who — or what — wrote it.

The same reasoning applies to the workflows themselves. A credential handed to an
automatic trigger is a control that anyone who can open a pull request gets to use,
which is why the gate matters as much as the check.
