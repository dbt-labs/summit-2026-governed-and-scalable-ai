# Demo 2 — Now break it!

## Summary

Have trainees issue a deliberately underspecified request before the repository’s three discovery TODOs and layer skills are complete. The goal is not guaranteed failure; it is visible variation, hidden assumptions, and expensive review.

## Prompt

```text
Build models for the alembic_ops source in models/warlock; give each model the suffix '__warlock'.
```

## Relevant files

- `models/warlock/`
- Alembic source declarations under `models/staging/alembic_ops/`
- Whatever SQL/YAML each Warlock creates

Do not use `models/answer_key/` or `training_assets/reference/`.

## Optional dbt commands

Run only after the Warlock has produced a coherent selector:

```text
dbt ls --select tag:warlock
dbt build --select tag:warlock
```

A failed or incomplete build is valid discussion evidence; do not spend the workshop repairing this track into the governed solution.

## Small-group comparison questions

- What models and layers did your Warlock create?
- Where did it put joins and grain changes?
- What grain did it assume for each output?
- Which names, columns, formulas, null rules, or unit rules did it invent?
- What tests, descriptions, and contracts did it add or omit?
- What did it inspect before writing code?
- What evidence would you need before approving this?
- How different are the implementations across groups?

## PPT talking points

- A plausible build can still be expensive to review.
- More prompt detail would help once; durable project guidance should help repeatedly.
- Passing SQL is not the same as approved meaning or proven grain.
- Preserve the Warlock output for comparison with Demo 7.

## Exit state

Trainees feel the cost of underspecified authorship and can identify assumptions that should become durable context, reusable skills, or explicit human decisions.
