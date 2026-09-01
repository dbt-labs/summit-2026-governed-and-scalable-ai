# Skill-building prompt template

Use this template after discussing the task-specific outcome, invariants, human decision boundary, completion evidence, and owner. The `building-governed-skills` skill supplies evidence discovery, skill structure, artifact boundaries, behavioral acceptance, and self-review.

Replace every `<placeholder>` before submitting the prompt.

```text
Use `building-governed-skills` to create a reusable <execution-or-orchestration> skill at:

`<skill-path>/SKILL.md`

Outcome:

<What recurring task should this skill govern?>

Our output invariants:

- <What must always be true?>
- <What must always be true?>
- <What must always be true?>

Human decision boundary:

- Stop and prompt back when <decision the repository cannot safely make>.
- Stop and prompt back when <decision the repository cannot safely make>.

Completion evidence:

- <What execution or inspection proves success?>
- <What result check proves the intended behavior?>

Primary owner: <accountable team or role>.
```

Keep the prompt focused on task-specific decisions. Shared repository evidence, file boundaries, skill sections, acceptance scenarios, self-review, and deferred routing are already governed by `building-governed-skills`.
