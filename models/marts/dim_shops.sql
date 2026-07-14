with shops as (
    select * from {{ ref('stg_alembic_ops__shops') }}
),

final as (
    select
        shop_id::varchar as shop_id,
        shop_name::varchar as shop_name,
        city::varchar as city,
        region::varchar as region,
        opened_at::date as opened_at
    from shops
)

select * from final
