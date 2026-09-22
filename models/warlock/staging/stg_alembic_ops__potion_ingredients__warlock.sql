with source as (

    select * from {{ source('alembic_ops', 'raw_potion_ingredients') }}

),

renamed as (

    select
        potion_sku,
        ingredient_id,
        quantity::integer as quantity,
        lower(unit) as unit
    from source

),

final as (

    select * from renamed

)

select * from final
