with brew_events as (
    select * from {{ ref('stg_alembic_ops__brew_events__warlock') }}
),

supply_costs as (
    select * from {{ ref('int_potion_supply_cost__warlock') }}
),

final as (
    select
        brew_events.brew_id,
        brew_events.potion_sku,
        brew_events.shop_id,
        brew_events.cauldron_id,
        brew_events.batch_size,
        brew_events.brew_duration_minutes,
        brew_events.quality_check,
        brew_events.brewer_name,
        supply_costs.recipe_ingredient_count,
        supply_costs.recipe_supply_cost_copper,
        supply_costs.recipe_supply_cost_gold,
        (brew_events.batch_size * supply_costs.recipe_supply_cost_copper)::int as batch_supply_cost_copper,
        {{ copper_to_gold('brew_events.batch_size * supply_costs.recipe_supply_cost_copper') }} as batch_supply_cost_gold,
        brew_events.brewed_at
    from brew_events
    inner join supply_costs on brew_events.potion_sku = supply_costs.potion_sku
)

select * from final
