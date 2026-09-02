# Workflows

This directory holds one live workflow. GitHub Actions reads `.yml` and `.yaml`
files here, so `codeowners-check.yml` is parsed and triggered on every pull request.

| File | Status | What it demonstrates |
|---|---|---|
| `codeowners-check.yml` | Live | Validating CODEOWNERS with a GitHub App credential. |

The enforcement that matters for the project — the warehouse-backed build, tests,
contracts, and the semantic layer — runs as a dbt platform CI job, not from here.

Note that `codeowners-check.yml` validates against this repository's placeholder
`@example-org/*` owners, which do not resolve to real teams. Its `owners` check is
expected to fail until CODEOWNERS points at teams in the adopting organization.

## Hardening checklist

Anything that runs automatically on a pull request is reachable by anyone who can
open a pull request. Before adding or activating a workflow in a repository you
care about:

- [ ] **No secrets on an automatic `pull_request` trigger.** A workflow that needs a
      credential needs a gate: an `environment:` with required reviewers, a
      `workflow_dispatch`-only trigger, or an explicit trusted-actor condition.
      GitHub withholds secrets from fork-originated `pull_request` runs, but that is
      a platform default protecting you — not a control you configured, and it does
      not apply to branches inside the repository. `codeowners-check.yml` leans on a
      trusted-actor condition alone; an `environment:` gate would be stronger.
- [ ] **`pull_request_target` only with extreme care, if at all.** It runs with the
      base repository's secrets and write-scoped token. Combining it with a checkout
      of the PR head executes untrusted code with those privileges. Nothing here
      uses it.
- [ ] **Least-privilege `permissions:`.** `codeowners-check.yml` sets
      `contents: read`. Widen only for a specific need, and prefer setting it per
      job.
- [ ] **Pin third-party actions to full commit SHAs.** Version tags are mutable.
      `codeowners-check.yml` pins each action to a reviewed SHA.
- [ ] **No credentials in source.** Secrets belong in Actions secrets or an
      environment, never in a committed file.

## Why this is in a governance workshop

This is the **Enforce** layer. Repository instructions guide an author; `AGENTS.md`
and skills cannot stop a bad change on their own. Contracts, tests, lint, and CI
reject it regardless of who — or what — wrote it.

The same reasoning applies to the workflow itself. A credential handed to an
automatic trigger is a control that anyone who can open a pull request gets to use,
which is why the gate matters as much as the check.
