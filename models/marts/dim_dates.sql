-- Date dimension spanning the full activity window. Generated with
-- dbt_utils.date_spine; bounds come from project vars (date_spine_start/end).

with spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('" ~ var('date_spine_start') ~ "' as date)",
        end_date="cast('" ~ var('date_spine_end') ~ "' as date)"
    ) }}
),

final as (
    select
        date_day::date as date_day,
        (year(date_day) * 10000 + month(date_day) * 100 + day(date_day))::integer as date_key,
        year(date_day)::integer as calendar_year,
        quarter(date_day)::integer as calendar_quarter,
        month(date_day)::integer as calendar_month,
        monthname(date_day)::varchar as month_name,
        day(date_day)::integer as day_of_month,
        dayofweek(date_day)::integer as day_of_week,
        dayname(date_day)::varchar as day_name,
        (dayofweek(date_day) in (0, 6))::boolean as is_weekend
    from spine
)

select * from final
