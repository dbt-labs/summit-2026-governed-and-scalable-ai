-- Payment-attempt grain enriched with parent-order customer context. One row
-- per payment attempt, preserving split payments, failures, and refunds.

with payments as (
    select * from {{ ref('stg_abra_pos__payments') }}
),

orders as (
    select * from {{ ref('stg_abra_pos__orders') }}
),

final as (
    select
        -- ids / fks
        payments.payment_id,
        payments.order_id,
        orders.customer_id,

        -- attributes
        payments.payment_method,
        payments.payment_status,

        -- measures
        payments.amount_gold,

        -- timestamps
        payments.paid_at
    from payments
    inner join orders on payments.order_id = orders.order_id
)

select * from final
