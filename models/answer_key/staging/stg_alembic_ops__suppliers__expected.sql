with source as (
    select * from {{ source('alembic_ops', 'raw_suppliers') }}
),

renamed as (
    select
        supplier_id,
        supplier_name,
        region,
        reliability_rating::integer as reliability_rating,
        contracted_since::date as contracted_since
    from source
),

final as (
    select
        supplier_id,
        supplier_name,
        region,
        reliability_rating,
        contracted_since
    from renamed
)

select * from final
