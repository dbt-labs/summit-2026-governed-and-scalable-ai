with brew_events as (

    select * from {{ ref('stg_alembic_ops__brew_events__warlock') }}

),

potion_supply_cost as (

    select * from {{ ref('int_potion_supply_cost__warlock') }}

),

brews as (

    select
        brew_events.brew_id,
        brew_events.potion_sku,
        brew_events.shop_id,
        brew_events.cauldron_id,
        brew_events.brewer_name,
        brew_events.quality_check,
        brew_events.batch_size,
        brew_events.brew_duration_minutes,
        potion_supply_cost.ingredient_count,
        potion_supply_cost.supplier_count,
        potion_supply_cost.has_hazardous_ingredient,
        potion_supply_cost.lowest_supplier_reliability_rating,
        potion_supply_cost.potion_supply_cost_copper,
        potion_supply_cost.potion_supply_cost_gold,
        (
            brew_events.batch_size * potion_supply_cost.potion_supply_cost_copper
        )::int as batch_supply_cost_copper,
        round(
            brew_events.batch_size * potion_supply_cost.potion_supply_cost_gold,
            2
        ) as batch_supply_cost_gold,
        brew_events.brewed_at,
        brew_events.brewed_at::date as brewed_date
    from brew_events
    inner join potion_supply_cost
        on brew_events.potion_sku = potion_supply_cost.potion_sku

)

select * from brews
