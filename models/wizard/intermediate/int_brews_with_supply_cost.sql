-- Brew-event grain enriched with current potion-level standard recipe cost.
-- One row per brew event; the left join preserves every brew.

with brew_events as (
    select * from {{ ref('stg_alembic_ops__brew_events') }}
),

potion_supply_cost as (
    select * from {{ ref('int_potion_supply_cost') }}
),

final as (
    select
        -- ids / fks
        brew_events.brew_id,
        brew_events.potion_sku,
        brew_events.shop_id,
        brew_events.cauldron_id,

        -- attributes
        brew_events.brewer_name,
        brew_events.quality_check,

        -- production measures
        brew_events.batch_size,
        brew_events.brew_duration_minutes,
        potion_supply_cost.recipe_ingredient_count,

        -- estimated standard ingredient cost
        potion_supply_cost.standard_ingredient_cost_per_unit_copper,
        potion_supply_cost.standard_ingredient_cost_per_unit_gold,
        (
            brew_events.batch_size
            * potion_supply_cost.standard_ingredient_cost_per_unit_copper
        )::integer as estimated_standard_ingredient_cost_copper,
        {{ copper_to_gold(
            'brew_events.batch_size * potion_supply_cost.standard_ingredient_cost_per_unit_copper'
        ) }} as estimated_standard_ingredient_cost_gold,

        -- timestamps
        brew_events.brewed_at
    from brew_events
    left join potion_supply_cost
        on brew_events.potion_sku = potion_supply_cost.potion_sku
)

select * from final
