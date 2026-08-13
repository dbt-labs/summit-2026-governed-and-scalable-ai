with suppliers as (
    select * from {{ ref('stg_alembic_ops__suppliers__expected') }}
),

final as (
    select
        supplier_id::varchar as supplier_id,
        supplier_name::varchar as supplier_name,
        region::varchar as region,
        reliability_rating::integer as reliability_rating,
        contracted_since::date as contracted_since
    from suppliers
)

select * from final
