# Trainer prompt: run the governed source-to-mart orchestrator

Use this prompt in a fresh Studio conversation after confirming:

- `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` exists, is approved, and has `verification.status: not_run`;
- the active staging, intermediate, and governed-mart skills exist under `.agents/skills/`;
- `models/wizard/` contains no unexplained or out-of-scope implementation files.

Copy and submit only the text below:

```text
Use `building-governed-source-to-mart` to implement the approved source-to-mart slice in `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` under `models/wizard/`.

Enforce the readiness gate before editing. Follow the active layer skills in dependency order, implement exactly the approved spec, run all required scoped validation and warehouse checks, and update only the spec's `verification` section outside the planned implementation files. Do not use facilitator references or answer-key models. If a gate fails or evidence contradicts the approved design, stop with the exact blocker and required handoff; otherwise continue until the implementation is ready for governed review.
```

The prompt is intentionally short. `AGENTS.md`, routing, the approved build spec, and the active layer skills provide the detailed authority and execution context.
