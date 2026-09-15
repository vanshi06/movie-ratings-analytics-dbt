{{ config(
    materialized = 'view'
) }}

WITH ratings AS (
    SELECT DISTINCT userId
    FROM {{ ref('stg_ratings') }}
),

tags AS (
    SELECT DISTINCT userId
    FROM {{ ref('stg_tags') }}
)

SELECT DISTINCT userId
FROM (
    SELECT userId FROM ratings
    UNION
    SELECT userId FROM tags
)