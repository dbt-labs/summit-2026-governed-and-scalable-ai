-- One row per potion. Standard ingredient supply cost to produce a single unit,
-- summed over the recipe (recipe quantity * current ingredient unit cost).
--
-- The recipe bridge is at (potion_sku, ingredient_id) grain; joining to the
-- unique ingredient list is many-to-one (no fanout), then we aggregate to potion.

with recipe as (
    select * from {{ ref('stg_alembic_ops__potion_ingredients') }}
),

ingredients as (
    select * from {{ ref('stg_alembic_ops__ingredients') }}
),

recipe_costed as (
    select
        recipe.potion_sku,
        sum(recipe.quantity * ingredients.unit_cost_copper) as standard_supply_cost_copper
    from recipe
    inner join ingredients on recipe.ingredient_id = ingredients.ingredient_id
    group by recipe.potion_sku
),

final as (
    select
        potion_sku,
        standard_supply_cost_copper,
        {{ copper_to_gold('standard_supply_cost_copper') }} as standard_supply_cost_gold
    from recipe_costed
)

select * from final
