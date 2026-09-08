with source as (
    select * from {{ source('alembic_ops', 'raw_suppliers') }}
),

renamed as (
    select
        supplier_id,
        supplier_name,
        region,
        reliability_rating::int as reliability_rating,
        contracted_since::date as contracted_since
    from source
)

select * from renamed
