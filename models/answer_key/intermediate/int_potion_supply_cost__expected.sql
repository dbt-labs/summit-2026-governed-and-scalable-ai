with potion_ingredients as (
    select * from {{ ref('stg_alembic_ops__potion_ingredients__expected') }}
),

ingredients as (
    select * from {{ ref('stg_alembic_ops__ingredients__expected') }}
),

final as (
    select
        potion_ingredients.potion_sku,
        count(*) as ingredient_count,
        sum(potion_ingredients.quantity * ingredients.unit_cost_copper) as potion_supply_cost_copper,
        {{ copper_to_gold('sum(potion_ingredients.quantity * ingredients.unit_cost_copper)') }} as potion_supply_cost_gold
    from potion_ingredients
    inner join ingredients on potion_ingredients.ingredient_id = ingredients.ingredient_id
    group by potion_ingredients.potion_sku
)

select * from final
