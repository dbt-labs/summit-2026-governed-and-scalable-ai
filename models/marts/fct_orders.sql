-- Order-grain fact. One row per order, with revenue/payment measures and
-- conformed FKs to the wizard, shop, and (via the shop) fulfilling region.

with orders as (
    select * from {{ ref('int_orders_with_payments') }}
),

shops as (
    select * from {{ ref('stg_alembic_ops__shops') }}
),

final as (
    select
        -- ids / fks
        orders.order_id::varchar as order_id,
        orders.customer_id::varchar as customer_id,
        orders.shop_id::varchar as shop_id,
        shops.region::varchar as fulfillment_region,

        -- attributes
        orders.order_status::varchar as order_status,
        orders.channel::varchar as channel,

        -- measures
        orders.line_item_count::integer as line_item_count,
        orders.total_quantity::integer as total_quantity,
        orders.gross_revenue_gold::number(38, 2) as gross_revenue_gold,
        orders.discount_gold::number(38, 2) as discount_gold,
        orders.net_revenue_gold::number(38, 2) as net_revenue_gold,
        orders.amount_paid_gold::number(38, 2) as amount_paid_gold,

        -- payment behavior flags
        orders.is_split_payment::boolean as is_split_payment,
        orders.had_failed_attempt::boolean as had_failed_attempt,
        orders.is_refunded::boolean as is_refunded,

        -- timestamps
        orders.ordered_at::timestamp_ntz as ordered_at,
        orders.ordered_at::date as ordered_date
    from orders
    left join shops on orders.shop_id = shops.shop_id
)

select * from final
