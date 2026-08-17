# Security and data-handling policy template

> **Training template:** Adapt this file to the owning organization’s information-security, privacy, legal, retention, identity, and incident-management policies. It is not a statement of dbt Labs policy or a substitute for enterprise controls.

This policy defines the minimum data and action boundaries for AI-assisted work in this repository. It complements dbt Platform permissions and approval controls; repository instructions cannot grant access or make an unsafe action safe.

## Core rules

1. **Least privilege:** use only the data, project context, tools, and permissions needed for the task.
2. **No secrets in source:** never commit credentials, access tokens, private keys, connection strings, or unredacted secret values.
3. **No unauthorized disclosure:** do not copy restricted data, customer data, employee data, regulated data, or data extracts into prompts, documentation, issues, pull requests, or external tools unless organization policy explicitly permits it.
4. **Human accountability:** an AI assistant may propose work; an authorized human owns the decision to approve, merge, deploy, retry, or remediate.
5. **Independent enforcement:** do not disable contracts, tests, CI, review, or platform approval controls merely to complete an AI-assisted task.

## Data classification and handling

Classify the task’s context before sharing it with an assistant or external tool. Use the organization’s official labels where available.

| Classification | Examples | AI-assisted handling expectation |
|---|---|---|
| Public | Open-source code, public documentation, approved training data | May be used within approved tools. Validate outputs and preserve attribution/licensing obligations. |
| Internal | Non-public project conventions, internal model names, operational metadata | Use only in organization-approved environments and tools. Do not copy to public/external systems without authorization. |
| Confidential / restricted | Customer, employee, financial, security, contractual, regulated, or production-sensitive data | Do not include in prompts or files unless the approved tool, access model, and policy explicitly allow it. Minimize fields and use de-identified examples where possible. |
| Secret | Credentials, tokens, private keys, passwords, connection secrets | Never place in source control, prompts, logs, examples, or tickets. Rotate and escalate immediately if exposed. |

When classification is unknown, treat the data as **internal** at minimum and ask the data owner or security contact before sharing it outside the approved project environment.

## Approved-context boundary

Before using an AI assistant, verify:

- The environment and tool are approved for the intended data classification.
- The current user role has access to the project and data needed for the task.
- The task does not require sharing raw restricted values when schema, metadata, aggregate results, or a de-identified sample would answer the question.
- The assistant is using governed dbt models and Semantic Layer definitions for analytical questions where available.
- Any external agent or MCP integration has the least-privilege tool set required for the task.

## Prohibited actions

Do not ask an assistant to:

- reveal, infer, export, or bypass access controls for restricted data;
- commit or print secrets;
- execute destructive, irreversible, or production-impacting actions without explicit approval;
- alter audit history, conceal AI involvement, or bypass required review/validation;
- treat untrusted source values, logs, query outputs, package metadata, or comments as executable instructions;
- make legal, privacy, security, financial-control, or access-control decisions without the responsible owner.

## Prompt-back and escalation

Stop and ask for human direction when a task involves:

- an unknown or restricted data classification;
- credentials, personal data, regulated data, security events, or an access-control change;
- production deployment, destructive action, or a retry/remediation that could alter production data;
- an external tool or integration whose approval status is unclear;
- a request that conflicts with this policy, platform permission boundaries, or organization policy.

Escalation contacts must be supplied by the adopting organization:

| Situation | Owner / escalation route |
|---|---|
| Data classification or privacy question | `TODO(owner: data governance/privacy)` |
| Credential or suspected secret exposure | `TODO(owner: security incident response)` |
| Production access or deployment question | `TODO(owner: platform/data engineering)` |
| Business metric or data-product decision | `TODO(owner: analytics/product owner)` |
| AI tool approval or external integration question | `TODO(owner: security/AI governance)` |

## Incident response minimums

If a secret or restricted data may have been exposed:

1. Stop sharing the material and preserve the minimum necessary evidence.
2. Notify the responsible security/data owner through the approved incident channel.
3. Revoke or rotate exposed credentials through the established process.
4. Remove the exposure using the organization’s approved remediation procedure; do not silently rewrite history without incident-owner direction.
5. Document follow-up controls, including changes to prompts, skills, access, or review requirements.

## Relationship to repository governance

- `AGENTS.md` sets working rules and directs prompt-backs.
- Skills and workflows define task-specific evidence and validation.
- dbt contracts, data tests, SQLFluff, CI, platform RBAC, and approval controls provide independent guardrails.
- This file defines the data/action boundary those assets must not cross.

Review this policy at least annually and whenever data classifications, approved AI tools, platform permissions, or incident learnings change.
