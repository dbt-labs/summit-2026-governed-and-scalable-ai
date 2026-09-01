with brew_events as (
    select * from {{ ref('stg_alembic_ops__brew_events__expected') }}
),

potion_supply_cost as (
    select * from {{ ref('int_potion_supply_cost__expected') }}
),

final as (
    select
        brew_events.brew_id,
        brew_events.potion_sku,
        brew_events.shop_id,
        brew_events.cauldron_id,
        brew_events.quality_check,
        brew_events.brewer_name,
        brew_events.batch_size,
        brew_events.brew_duration_minutes,
        potion_supply_cost.standard_supply_cost_copper,
        potion_supply_cost.standard_supply_cost_gold,
        brew_events.batch_size * potion_supply_cost.standard_supply_cost_copper
            as estimated_batch_supply_cost_copper,
        {{ copper_to_gold('brew_events.batch_size * potion_supply_cost.standard_supply_cost_copper') }}
            as estimated_batch_supply_cost_gold,
        brew_events.brewed_at
    from brew_events
    left join potion_supply_cost
        on brew_events.potion_sku = potion_supply_cost.potion_sku
)

select * from final
