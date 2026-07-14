with potions as (
    select * from {{ ref('stg_abra_pos__potions') }}
),

final as (
    select
        potion_sku::varchar as potion_sku,
        potion_name::varchar as potion_name,
        category::varchar as category,
        potency::integer as potency,
        shelf_life_days::integer as shelf_life_days,
        is_regulated::boolean as is_regulated,
        base_price_copper::integer as base_price_copper,
        base_price_gold::number(38, 2) as base_price_gold,
        introduced_at::date as introduced_at
    from potions
)

select * from final
