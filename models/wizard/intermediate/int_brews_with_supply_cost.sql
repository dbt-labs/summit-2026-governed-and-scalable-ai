with brews as (
    select * from {{ ref('stg_alembic_ops__brew_events') }}
),

potion_supply_cost as (
    select * from {{ ref('int_potion_supply_cost') }}
),

final as (
    select
        brews.brew_id,
        brews.potion_sku,
        brews.shop_id,
        brews.cauldron_id,
        brews.quality_check,
        brews.brewer_name,
        brews.batch_size,
        brews.brew_duration_minutes,
        brews.brewed_at,
        potion_supply_cost.standard_supply_cost_copper,
        potion_supply_cost.standard_supply_cost_gold,
        (brews.batch_size * potion_supply_cost.standard_supply_cost_copper)::integer
            as estimated_batch_supply_cost_copper,
        {{ copper_to_gold('brews.batch_size * potion_supply_cost.standard_supply_cost_copper') }}
            as estimated_batch_supply_cost_gold
    from brews
    left join potion_supply_cost
        on brews.potion_sku = potion_supply_cost.potion_sku
)

select * from final
