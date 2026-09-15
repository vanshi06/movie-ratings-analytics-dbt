{{ config(
    materialized='view'
) }}

SELECT
    m.movieId,
    m.title,
    m.genres,
    COUNT(r.rating) AS total_ratings,
    ROUND(AVG(r.rating), 2) AS average_rating
FROM {{ ref('stg_movies') }} m
LEFT JOIN {{ ref('stg_ratings') }} r
    ON m.movieId = r.movieId
GROUP BY
    m.movieId,
    m.title,
    m.genres