{{ config(
    materialized='view'
) }}

SELECT
    userId,
    movieId,
    rating,
    timestamp
FROM {{ ref('stg_ratings') }}