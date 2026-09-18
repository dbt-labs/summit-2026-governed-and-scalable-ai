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
        potion_ingredients.ingredient_id,
        ingredients.supplier_id,
        potion_ingredients.quantity,
        ingredients.unit_cost_copper,
        potion_ingredients.quantity * ingredients.unit_cost_copper as ingredient_cost_copper,
        ingredients.is_hazardous,
        suppliers.reliability_rating
    from potion_ingredients
    inner join ingredients
        on potion_ingredients.ingredient_id = ingredients.ingredient_id
    inner join suppliers
        on ingredients.supplier_id = suppliers.supplier_id

),

aggregated as (

    select
        potion_sku,
        count(*) as ingredient_count,
        count(distinct supplier_id) as supplier_count,
        sum(ingredient_cost_copper)::number(18, 2) as potion_supply_cost_copper,
        max(is_hazardous) as has_hazardous_ingredient,
        min(reliability_rating) as minimum_supplier_reliability_rating
    from recipe_costs
    group by potion_sku

)

select * from aggregated
