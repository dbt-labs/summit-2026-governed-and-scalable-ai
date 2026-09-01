with brews as (
    select * from {{ ref('int_brews_with_supply_cost__expected') }}
),

final as (
    select
        brew_id::varchar as brew_id,
        potion_sku::varchar as potion_sku,
        shop_id::varchar as shop_id,
        cauldron_id::varchar as cauldron_id,
        quality_check::varchar as quality_check,
        brewer_name::varchar as brewer_name,
        batch_size::integer as batch_size,
        brew_duration_minutes::integer as brew_duration_minutes,
        standard_supply_cost_copper::integer as standard_supply_cost_copper,
        standard_supply_cost_gold::number(38, 2) as standard_supply_cost_gold,
        estimated_batch_supply_cost_copper::integer as estimated_batch_supply_cost_copper,
        estimated_batch_supply_cost_gold::number(38, 2) as estimated_batch_supply_cost_gold,
        brewed_at::timestamp_ntz as brewed_at,
        brewed_at::date as brewed_date
    from brews
)

select * from final
