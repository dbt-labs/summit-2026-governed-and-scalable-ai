with recipe_components as (
    select * from {{ ref('stg_alembic_ops__potion_ingredients') }}
),

ingredients as (
    select * from {{ ref('stg_alembic_ops__ingredients') }}
),

final as (
    select
        recipe_components.potion_sku,
        count(*)::integer as ingredient_count,
        sum(recipe_components.quantity * ingredients.unit_cost_copper)::integer
            as standard_supply_cost_copper,
        {{ copper_to_gold('sum(recipe_components.quantity * ingredients.unit_cost_copper)') }}
            as standard_supply_cost_gold
    from recipe_components
    inner join ingredients
        on recipe_components.ingredient_id = ingredients.ingredient_id
        and recipe_components.unit = ingredients.unit
    group by recipe_components.potion_sku
)

select * from final
