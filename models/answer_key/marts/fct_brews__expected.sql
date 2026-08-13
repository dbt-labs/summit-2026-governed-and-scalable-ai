with brews as (
    select * from {{ ref('int_brews_with_supply_cost__expected') }}
),

final as (
    select
        -- ids / foreign keys
        brew_id::varchar as brew_id,
        potion_sku::varchar as potion_sku,
        shop_id::varchar as shop_id,
        cauldron_id::varchar as cauldron_id,

        -- attributes
        quality_check::varchar as quality_check,
        (quality_check = 'pass')::boolean as passed_quality_check,
        brewer_name::varchar as brewer_name,

        -- measures
        batch_size::integer as batch_size,
        brew_duration_minutes::integer as brew_duration_minutes,
        potion_supply_cost_copper::integer as potion_supply_cost_copper,
        potion_supply_cost_gold::number(38, 2) as potion_supply_cost_gold,
        batch_supply_cost_copper::integer as batch_supply_cost_copper,
        batch_supply_cost_gold::number(38, 2) as batch_supply_cost_gold,

        -- timestamps
        brewed_at::timestamp_ntz as brewed_at,
        brewed_at::date as brewed_date
    from brews
)

select * from final
