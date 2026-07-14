-- Payment-attempt-grain fact. One row per payment attempt (splits, failures,
-- and refunds each get their own row). Order FK links back to fct_orders.

with payments as (
    select * from {{ ref('stg_abra_pos__payments') }}
),

orders as (
    select * from {{ ref('stg_abra_pos__orders') }}
),

final as (
    select
        -- ids / fks
        payments.payment_id::varchar as payment_id,
        payments.order_id::varchar as order_id,
        orders.customer_id::varchar as customer_id,

        -- attributes
        payments.payment_method::varchar as payment_method,
        payments.payment_status::varchar as payment_status,

        -- measures
        payments.amount_gold::number(38, 2) as amount_gold,

        -- timestamps
        payments.paid_at::timestamp_ntz as paid_at,
        payments.paid_at::date as paid_date
    from payments
    inner join orders on payments.order_id = orders.order_id
)

select * from final
