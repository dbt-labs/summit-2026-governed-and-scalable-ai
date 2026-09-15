with potion_ingredients as (

    select * from {{ ref('stg_alembic_ops__potion_ingredients__warlock') }}

),

ingredients as (

    select * from {{ ref('stg_alembic_ops__ingredients__warlock') }}

),

suppliers as (

    select * from {{ ref('stg_alembic_ops__suppliers__warlock') }}

),

recipe_costs as (

    select
        potion_ingredients.potion_sku,
        count(*) as ingredient_count,
        count(distinct suppliers.supplier_id) as supplier_count,
        sum(
            potion_ingredients.quantity * ingredients.unit_cost_copper
        ) as potion_supply_cost_copper
    from potion_ingredients
    inner join ingredients
        on potion_ingredients.ingredient_id = ingredients.ingredient_id
    inner join suppliers
        on ingredients.supplier_id = suppliers.supplier_id
    group by potion_ingredients.potion_sku

)

select * from recipe_costs
