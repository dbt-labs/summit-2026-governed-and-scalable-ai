# Governed semantic definition checklist

Use this checklist for a new or changed semantic model, entity, dimension, measure, or metric. Do not mark a business decision complete because a technically valid YAML shape exists.

## Discover and ground

- [ ] Existing semantic definitions and public marts were searched before proposing a new name.
- [ ] The selected source mart is public, contracted, tested, and has a stated grain.
- [ ] Source columns, entity keys, dimensions, and default time dimension were inspected from actual SQL/YAML/data.
- [ ] The project’s existing semantic specification was identified; legacy and current schema styles are not mixed.
- [ ] The accountable business/metric owner and intended consumers are named.

## Definition agreement

- [ ] The definition answers a stated business question.
- [ ] The metric, entity, or dimension has one clear name and description.
- [ ] The source mart and grain are explicit: “one row per …”.
- [ ] Aggregation/formula, numerator/denominator, filters, inclusion/exclusion rules, and dimensions/entities are explicit.
- [ ] Currency, units, conversions, and rounding behavior are explicit where relevant.
- [ ] Event time, default time dimension, time zone, late-arriving-data treatment, and requested grain are explicit where relevant.
- [ ] Null treatment and zero-denominator behavior are explicit where relevant.
- [ ] The owner approved the business meaning and material assumptions.

## Compatibility and governance

- [ ] Existing metrics were checked for reuse, conflict, or a required deprecation/migration path.
- [ ] Consumer impact was assessed for dashboards, semantic queries, AI-assisted analytics, and downstream models.
- [ ] The definition does not create a competing ad hoc revenue, order, unit, supply-cost, margin, or similar metric.
- [ ] A new or changed source mart has the necessary contract, tests, descriptions, and scoped build validation.
- [ ] The change respects data-classification and access boundaries.

## Implementation and evidence

- [ ] Semantic YAML uses the project’s established, version-supported format.
- [ ] Unrelated semantic definitions are preserved.
- [ ] `dbt parse` passed after the edit.
- [ ] Semantic validation ran when supported (`dbt sl validate` or MetricFlow validation after parsing).
- [ ] The underlying mart build passed with an appropriate scoped selector.
- [ ] Representative output or a governed semantic query was checked against the approved definition.
- [ ] The change plan and PR evidence record the definition, owner approval, validation, and remaining follow-up.

## Alembic supply-cost and margin decision prompts

Use these prompts during the procurement lab; do not choose the answer without the business owner.

- [ ] Are recipe quantities and ingredient costs in comparable units? If not, what approved conversion or exclusion policy applies?
- [ ] Is `batch_supply_cost_gold` a standard/estimated cost based on the modeled ingredient cost, or an actual historical batch cost?
- [ ] If margin is defined, which revenue basis applies: gross revenue, net revenue, recognized revenue, or another approved basis?
- [ ] What is the intended relationship between production batches and sales when interpreting supply cost or margin?
- [ ] Does missing `brew_duration_minutes` exclude a batch from duration metrics, produce an unknown bucket, or follow another approved policy?
