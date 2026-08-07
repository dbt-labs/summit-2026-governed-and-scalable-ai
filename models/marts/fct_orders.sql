-- Order-grain fact. One row per order, with revenue/payment measures and
-- conformed customer, shop, and fulfillment-region attributes.

with orders as (
    select * from {{ ref('int_orders_with_payments') }}
),

final as (
    select
        -- ids / fks
        order_id::varchar as order_id,
        customer_id::varchar as customer_id,
        shop_id::varchar as shop_id,
        fulfillment_region::varchar as fulfillment_region,

        -- attributes
        order_status::varchar as order_status,
        channel::varchar as channel,

        -- measures
        line_item_count::integer as line_item_count,
        total_quantity::integer as total_quantity,
        gross_revenue_gold::number(38, 2) as gross_revenue_gold,
        discount_gold::number(38, 2) as discount_gold,
        net_revenue_gold::number(38, 2) as net_revenue_gold,
        amount_paid_gold::number(38, 2) as amount_paid_gold,

        -- payment behavior flags
        is_split_payment::boolean as is_split_payment,
        had_failed_attempt::boolean as had_failed_attempt,
        is_refunded::boolean as is_refunded,

        -- timestamps
        ordered_at::timestamp_ntz as ordered_at,
        ordered_at::date as ordered_date
    from orders
)

select * from final
