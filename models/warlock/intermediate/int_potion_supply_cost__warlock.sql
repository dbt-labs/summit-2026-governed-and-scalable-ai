with potion_ingredients as (

    select * from {{ ref('stg_alembic_ops__potion_ingredients__warlock') }}

),

ingredients as (

    select * from {{ ref('stg_alembic_ops__ingredients__warlock') }}

),

suppliers as (

    select * from {{ ref('stg_alembic_ops__suppliers__warlock') }}

),

potion_supply_cost as (

    select
        potion_ingredients.potion_sku,
        count(*) as ingredient_count,
        count(distinct suppliers.supplier_id) as supplier_count,
        boolor_agg(ingredients.is_hazardous) as has_hazardous_ingredient,
        min(suppliers.reliability_rating) as lowest_supplier_reliability_rating,
        sum(
            potion_ingredients.quantity * ingredients.unit_cost_copper
        )::int as potion_supply_cost_copper,
        round(
            sum(potion_ingredients.quantity * ingredients.unit_cost_copper) / 100.0,
            2
        ) as potion_supply_cost_gold
    from potion_ingredients
    inner join ingredients
        on potion_ingredients.ingredient_id = ingredients.ingredient_id
        and potion_ingredients.unit = ingredients.unit
    inner join suppliers
        on ingredients.supplier_id = suppliers.supplier_id
    group by potion_ingredients.potion_sku

)

select * from potion_supply_cost
