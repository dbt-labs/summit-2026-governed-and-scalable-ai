-- Payment-attempt-grain fact. One row per payment attempt. Order FK links
-- back to fct_orders; customer context is carried through the intermediate.

with payments as (
    select * from {{ ref('int_payments_with_order_context') }}
),

final as (
    select
        -- ids / fks
        payment_id::varchar as payment_id,
        order_id::varchar as order_id,
        customer_id::varchar as customer_id,

        -- attributes
        payment_method::varchar as payment_method,
        payment_status::varchar as payment_status,

        -- measures
        amount_gold::number(38, 2) as amount_gold,

        -- timestamps
        paid_at::timestamp_ntz as paid_at,
        paid_at::date as paid_date
    from payments
)

select * from final
