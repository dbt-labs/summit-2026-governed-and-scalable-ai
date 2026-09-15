with source as (

    select * from {{ source('alembic_ops', 'raw_suppliers') }}

),

renamed as (

    select
        trim(supplier_id) as supplier_id,
        trim(supplier_name) as supplier_name,
        trim(region) as region,
        reliability_rating,
        contracted_since
    from source

)

select * from renamed
