with brew_events as (

    select * from {{ ref('stg_alembic_ops__brew_events__warlock') }}

),

potion_supply_costs as (

    select * from {{ ref('int_potion_supply_cost__warlock') }}

),

final as (

    select
        brew_events.brew_id,
        brew_events.potion_sku,
        brew_events.shop_id,
        brew_events.cauldron_id,
        brew_events.brewed_at,
        brew_events.batch_size,
        brew_events.brew_duration_minutes,
        brew_events.quality_check,
        brew_events.brewer_name,
        potion_supply_costs.ingredient_count,
        potion_supply_costs.supplier_count,
        potion_supply_costs.potion_supply_cost_copper,
        brew_events.batch_size
            * potion_supply_costs.potion_supply_cost_copper
            as batch_supply_cost_copper
    from brew_events
    inner join potion_supply_costs
        on brew_events.potion_sku = potion_supply_costs.potion_sku

)

select * from final
