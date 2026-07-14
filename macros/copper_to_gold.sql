{#-
    copper_to_gold(column)

    Merlin & Co. prices everything in copper pieces; 100 copper = 1 gold crown.
    Gold is the money-of-record for reporting. We keep the raw *_copper integer
    alongside and expose *_gold as NUMBER(38,2). Cast to numeric first so the
    division does not truncate.
-#}
{% macro copper_to_gold(column) %}
    round({{ column }}::number(38, 0) / 100.0, 2)
{% endmacro %}
