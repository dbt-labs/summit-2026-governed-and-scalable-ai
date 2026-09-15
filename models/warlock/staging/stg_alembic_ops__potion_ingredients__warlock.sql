with source as (

    select * from {{ source('alembic_ops', 'raw_potion_ingredients') }}

),

renamed as (

    select
        trim(potion_sku) as potion_sku,
        trim(ingredient_id) as ingredient_id,
        quantity,
        lower(trim(unit)) as unit
    from source

)

select * from renamed
