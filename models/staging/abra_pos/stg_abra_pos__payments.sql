with source as (
    select * from {{ source('abra_pos', 'raw_payments') }}
),

renamed as (
    select
        -- ids
        payment_id,
        order_id,

        -- attributes
        lower(trim(method)) as payment_method,
        lower(trim(status)) as payment_status,

        -- money
        amount_copper::int as amount_copper,
        {{ copper_to_gold('amount_copper') }} as amount_gold,

        -- timestamps
        {{ parse_dual_timestamp('paid_at') }} as paid_at
    from source
)

select * from renamed
