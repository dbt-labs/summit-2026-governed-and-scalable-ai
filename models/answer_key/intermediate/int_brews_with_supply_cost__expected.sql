with brew_events as (
    select * from {{ ref('stg_alembic_ops__brew_events__expected') }}
),

potion_supply_cost as (
    select * from {{ ref('int_potion_supply_cost__expected') }}
),

final as (
    select
        -- ids / foreign keys
        brew_events.brew_id,
        brew_events.potion_sku,
        brew_events.shop_id,
        brew_events.cauldron_id,

        -- attributes
        brew_events.quality_check,
        brew_events.brewer_name,

        -- measures
        brew_events.batch_size,
        brew_events.brew_duration_minutes,
        potion_supply_cost.potion_supply_cost_copper,
        potion_supply_cost.potion_supply_cost_gold,
        brew_events.batch_size * potion_supply_cost.potion_supply_cost_copper as batch_supply_cost_copper,
        brew_events.batch_size * potion_supply_cost.potion_supply_cost_gold as batch_supply_cost_gold,

        -- timestamps
        brew_events.brewed_at
    from brew_events
    inner join potion_supply_cost on brew_events.potion_sku = potion_supply_cost.potion_sku
)

select * from final
