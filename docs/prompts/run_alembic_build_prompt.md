# Prompt: Building the new source

Use this prompt to build the Alembic slice.

```text
Use `building-governed-source-to-mart` to implement the approved source-to-mart slice in `docs/merlinco/ALEMBIC_BUILD_SPEC.yml` under `models/wizard/`.

Enforce the readiness gate before editing. Follow the active layer skills in dependency order, implement exactly the approved spec, run all required scoped validation and warehouse checks, and update only the spec's `verification` section outside the planned implementation files. Do not use facilitator references or answer-key models. If a gate fails or evidence contradicts the approved design, stop with the exact blocker and required handoff; otherwise continue until the implementation is ready for governed review.
```