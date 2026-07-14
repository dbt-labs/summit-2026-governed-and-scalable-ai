{#-
    parse_dual_timestamp(column)

    Raw *_at columns arrive in two formats within the same column:
        ISO-8601 with a trailing Z   ->  2024-07-01T18:08:26Z
        space-separated (no zone)    ->  2024-07-01 17:35:52

    try_to_timestamp_ntz returns NULL (rather than erroring) on a format
    mismatch, so we attempt both formats and coalesce. Result is TIMESTAMP_NTZ.
    Centralizing this here means every staging model parses timestamps
    identically — change the rule once, it applies everywhere.
-#}
{% macro parse_dual_timestamp(column) %}
    coalesce(
        try_to_timestamp_ntz({{ column }}, 'YYYY-MM-DD"T"HH24:MI:SS"Z"'),
        try_to_timestamp_ntz({{ column }}, 'YYYY-MM-DD HH24:MI:SS')
    )
{% endmacro %}
