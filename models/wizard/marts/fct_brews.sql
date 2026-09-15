-- Brew-event fact. One row per production batch, with estimated standard
-- ingredient supply cost (per unit and per batch) from recipe quantities and
-- current ingredient unit costs. Left join preserves all brew events.

with brews as (
    select * from {{ ref('stg_alembic_ops__brew_events') }}
),

potion_supply_cost as (
    select * from {{ ref('int_potion_supply_cost') }}
),

final as (
    select
        -- ids / fks
        brews.brew_id::varchar as brew_id,
        brews.potion_sku::varchar as potion_sku,
        brews.shop_id::varchar as shop_id,
        brews.cauldron_id::varchar as cauldron_id,

        -- measures
        brews.batch_size::integer as batch_size,
        brews.brew_duration_minutes::integer as brew_duration_minutes,

        -- attributes
        brews.quality_check::varchar as quality_check,
        brews.brewer_name::varchar as brewer_name,

        -- supply cost
        potion_supply_cost.standard_supply_cost_gold::number(38, 2) as standard_unit_supply_cost_gold,
        round(potion_supply_cost.standard_supply_cost_gold * brews.batch_size, 2)::number(38, 2) as standard_batch_supply_cost_gold,

        -- timestamps
        brews.brewed_at::timestamp_ntz as brewed_at,
        brews.brewed_date::date as brewed_date
    from brews
    left join potion_supply_cost on brews.potion_sku = potion_supply_cost.potion_sku
)

select * from final
