{% macro no_nulls_in_columns(model) %}

    {% set columns = adapter.get_columns_in_relation(ref(model)) %}

    {% for column in columns %}

        SUM(
            CASE
                WHEN {{ column.name }} IS NULL THEN 1
                ELSE 0
            END
        ) AS {{ column.name }}_null_count

        {% if not loop.last %}, {% endif %}

    {% endfor %}

{% endmacro %}