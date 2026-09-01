with potion_ingredients as (
    select * from {{ ref('stg_alembic_ops__potion_ingredients__expected') }}
),

ingredients as (
    select * from {{ ref('stg_alembic_ops__ingredients__expected') }}
),

recipe_components as (
    select
        potion_ingredients.potion_sku,
        potion_ingredients.quantity,
        ingredients.unit_cost_copper
    from potion_ingredients
    inner join ingredients
        on potion_ingredients.ingredient_id = ingredients.ingredient_id
),

final as (
    select
        potion_sku,
        count(*) as ingredient_count,
        sum(quantity * unit_cost_copper)::integer as standard_supply_cost_copper,
        {{ copper_to_gold('sum(quantity * unit_cost_copper)') }} as standard_supply_cost_gold
    from recipe_components
    group by potion_sku
)

select * from final
