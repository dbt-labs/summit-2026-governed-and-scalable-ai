-- Potion-grain standard recipe cost using current ingredient unit costs.
-- One row per potion SKU.

with potion_ingredients as (
    select * from {{ ref('stg_alembic_ops__potion_ingredients') }}
),

ingredients as (
    select * from {{ ref('stg_alembic_ops__ingredients') }}
),

recipe_lines as (
    select
        potion_ingredients.potion_sku,
        potion_ingredients.ingredient_quantity,
        ingredients.unit_cost_copper,
        potion_ingredients.ingredient_quantity * ingredients.unit_cost_copper as ingredient_line_cost_copper
    from potion_ingredients
    inner join ingredients
        on potion_ingredients.ingredient_id = ingredients.ingredient_id
),

final as (
    select
        potion_sku,
        count(*)::integer as recipe_ingredient_count,
        sum(ingredient_line_cost_copper)::integer as standard_ingredient_cost_per_unit_copper,
        {{ copper_to_gold('sum(ingredient_line_cost_copper)') }} as standard_ingredient_cost_per_unit_gold
    from recipe_lines
    group by potion_sku
)

select * from final
