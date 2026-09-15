-- Brew-event fact for production analysis. Standard ingredient costs use
-- current ingredient prices and are estimates, not actual historical cost.

with brews as (
    select * from {{ ref('int_brews_with_supply_cost') }}
),

final as (
    select
        -- ids / fks
        brew_id::varchar as brew_id,
        potion_sku::varchar as potion_sku,
        shop_id::varchar as shop_id,
        cauldron_id::varchar as cauldron_id,

        -- attributes
        brewer_name::varchar as brewer_name,
        quality_check::varchar as quality_check,

        -- production measures
        batch_size::integer as batch_size,
        brew_duration_minutes::integer as brew_duration_minutes,
        recipe_ingredient_count::integer as recipe_ingredient_count,

        -- estimated standard ingredient cost
        standard_ingredient_cost_per_unit_copper::integer as standard_ingredient_cost_per_unit_copper,
        standard_ingredient_cost_per_unit_gold::number(38, 2) as standard_ingredient_cost_per_unit_gold,
        estimated_standard_ingredient_cost_copper::integer as estimated_standard_ingredient_cost_copper,
        estimated_standard_ingredient_cost_gold::number(38, 2) as estimated_standard_ingredient_cost_gold,

        -- timestamps
        brewed_at::timestamp_ntz as brewed_at,
        brewed_at::date as brewed_date
    from brews
)

select * from final
