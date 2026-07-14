with source as (
    select * from {{ source('abra_pos', 'raw_orders') }}
),

renamed as (
    select
        -- ids
        order_id,
        customer_id,
        shop_id,

        -- attributes
        lower(trim(status)) as order_status,
        lower(trim(channel)) as channel,

        -- money
        discount_copper::int as discount_copper,
        {{ copper_to_gold('discount_copper') }} as discount_gold,

        -- timestamps
        {{ parse_dual_timestamp('ordered_at') }} as ordered_at
    from source
)

select * from renamed
