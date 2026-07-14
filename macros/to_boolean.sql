{#-
    to_boolean(column)

    Normalizes the messy raw boolean encodings — Y / N / yes / no / TRUE /
    FALSE, any casing — into a real BOOLEAN. Anything unrecognized becomes
    NULL rather than silently falling to false, so bad values surface in tests.
-#}
{% macro to_boolean(column) %}
    case
        when lower(trim({{ column }})) in ('y', 'yes', 'true', 't', '1') then true
        when lower(trim({{ column }})) in ('n', 'no', 'false', 'f', '0') then false
        else null
    end
{% endmacro %}
