with potion_ingredients as (

    select * from {{ ref('stg_alembic_ops__potion_ingredients__warlock') }}

),

ingredients as (

    select * from {{ ref('stg_alembic_ops__ingredients__warlock') }}

),

potion_supply_cost as (

    select
        potion_ingredients.potion_sku,
        sum(potion_ingredients.quantity * ingredients.unit_cost_copper) as potion_supply_cost_copper,
        count(*) as ingredient_count,
        count(distinct ingredients.supplier_id) as supplier_count,
        boolor_agg(ingredients.is_hazardous) as contains_hazardous_ingredient
    from potion_ingredients
    inner join ingredients
        on potion_ingredients.ingredient_id = ingredients.ingredient_id
    group by 1

)

select * from potion_supply_cost
