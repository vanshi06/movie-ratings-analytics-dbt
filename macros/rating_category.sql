{% macro rating_category(rating_column) %}

    CASE
        WHEN {{ rating_column }} >= 4.0 THEN 'Highly Rated'
        WHEN {{ rating_column }} >= 3.0 THEN 'Average'
        ELSE 'Low Rated'
    END

{% endmacro %}