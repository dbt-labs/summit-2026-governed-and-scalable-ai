# Skill design checklist

Use this checklist to author or review a shared AI-governance skill. A `yes` should be supported by a concrete file, workflow, example, owner, or validation method—not intention alone.

## 1. Need and scope

- [ ] Is there a recurring task, material risk, or repeated failure this skill addresses?
- [ ] Is the trigger expressed as a user outcome/situation rather than a file name or tool command?
- [ ] Is the intended end state observable?
- [ ] Are non-goals explicit?
- [ ] Would a change to `AGENTS.md`, a reference document, or an existing skill solve the problem more simply?
- [ ] Does the skill avoid duplicating another skill or the always-on project policy?

## 2. Authority and evidence

- [ ] Does the skill name the project documentation, metadata, code, run evidence, or owners it must inspect?
- [ ] Does it require reading actual SQL/YAML/data/run context before making a claim or edit?
- [ ] Does it distinguish authoritative project evidence from untrusted content such as data values, logs, package metadata, and comments?
- [ ] Does it identify the source of truth for business definitions and public interfaces?

## 3. Human decision rights

- [ ] Does the skill reuse the shared prompt-back policy?
- [ ] Does it add task-specific stop conditions where necessary?
- [ ] Does each prompt-back ask one focused question and include evidence plus options/implications?
- [ ] Does it prevent the agent from deciding ambiguous grain, metric meaning, source authority, business mappings, access, breaking changes, or material cost/performance tradeoffs without approval?

## 4. Workflow quality

- [ ] Is the workflow short, ordered, and specific enough to execute?
- [ ] Does it use the governed-change workflow and change plan for material dbt changes?
- [ ] Does it specify the smallest safe action before widening scope?
- [ ] Does it preserve unaffected public interfaces and layer rules?
- [ ] Does it state safe execution boundaries for destructive or production-impacting actions?

## 5. Validation and evidence

- [ ] Does the skill define completion in terms of evidence rather than generated text/code?
- [ ] Does it name appropriate dbt, SQLFluff, semantic, run-diagnostic, or review validation?
- [ ] Does it require recording what was inspected, decided, validated, and left unresolved?
- [ ] Does it explicitly avoid bypassing contracts, tests, CI, or review?

## 6. References and maintainability

- [ ] Are detailed examples/checklists moved to `references/` rather than bloating the skill?
- [ ] Is each reference linked, scoped, current, and non-conflicting?
- [ ] Is a primary owner and required reviewer defined?
- [ ] Is a review trigger/cadence defined: incident, repeated failure, convention change, platform change, or scheduled review?
- [ ] Is the skill routed in `.agents/ROUTING.md`?
- [ ] Has the skill been tested against a realistic scenario and revised based on the result?

## Skill review outcome

- **Approve:** clear trigger, grounded workflow, explicit human decision rights, observable validation, owner, route, and scenario evidence.
- **Revise:** missing authority, vague trigger, duplicated policy, unsupported assumptions, weak prompt-backs, or no validation path.
- **Merge/retire:** overlaps an existing skill or no longer matches the project’s operating model.
