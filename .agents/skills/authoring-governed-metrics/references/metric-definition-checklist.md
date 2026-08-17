# Governed semantic definition checklist — trainee scaffold

Use this checklist to refine and validate a governed semantic definition. Resolve each `TODO(training)` from project evidence and an accountable human decision; do not mark an item complete because plausible YAML exists.

## Discover and ground

- [ ] Existing semantic definitions and public marts were searched for reuse or conflict.
- [ ] The selected source mart is public, contracted, tested, and has a stated grain.
- [ ] The accountable owner and intended consumers are named.
- [ ] `TODO(training): Add the required source-column, entity, dimension, time-spine, and installed-spec evidence.`

## Definition agreement

- [ ] The definition answers a stated business question.
- [ ] The source mart and one-row-per grain are explicit.
- [ ] `TODO(training): Record aggregation/formula, filters, units/currency, time semantics, null behavior, and inclusion/exclusion policy.`
- [ ] The accountable owner approved material business assumptions.

## Compatibility and governance

- [ ] Existing definitions were checked for reuse, conflict, or migration needs.
- [ ] Consumer and public-interface impact was assessed.
- [ ] `TODO(training): Add the Alembic standard-cost, unit-comparability, duration-null, and margin decision checks.`

## Implementation and evidence

- [ ] Semantic YAML uses the project’s established supported format.
- [ ] `TODO(training): Add parse, semantic validation, scoped mart build, representative query, and evidence-record requirements.`
