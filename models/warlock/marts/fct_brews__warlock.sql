with brew_events as (

    select * from {{ ref('stg_alembic_ops__brew_events__warlock') }}

),

shops as (

    select * from {{ ref('stg_alembic_ops__shops__warlock') }}

),

potion_supply_cost as (

    select * from {{ ref('int_potion_supply_cost__warlock') }}

),

final as (

    select
        brew_events.brew_id,
        brew_events.potion_sku,
        brew_events.shop_id,
        shops.shop_name,
        shops.city as shop_city,
        shops.region as shop_region,
        brew_events.cauldron_id,
        brew_events.brewed_at,
        brew_events.batch_size,
        brew_events.brew_duration_minutes,
        brew_events.quality_check,
        brew_events.brewer_name,
        potion_supply_cost.potion_supply_cost_copper,
        brew_events.batch_size * potion_supply_cost.potion_supply_cost_copper as batch_supply_cost_copper,
        potion_supply_cost.ingredient_count,
        potion_supply_cost.supplier_count,
        potion_supply_cost.contains_hazardous_ingredient
    from brew_events
    left join shops
        on brew_events.shop_id = shops.shop_id
    left join potion_supply_cost
        on brew_events.potion_sku = potion_supply_cost.potion_sku

)

select * from final
