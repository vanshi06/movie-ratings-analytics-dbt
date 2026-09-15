{{ config(
    materialized = 'view'
) }}

WITH movie_ratings AS (

    SELECT *
    FROM {{ ref('movie_rating_summary') }}

),

release_dates AS (

    SELECT *
    FROM {{ ref('movie_release_dates') }}

)

SELECT
    m.movieId,
    m.title,
    m.genres,
    m.total_ratings,
    m.average_rating,

    {{ rating_category('m.average_rating') }} AS rating_category,

    r.release_date,

    CASE
        WHEN r.release_date IS NULL THEN 'Unknown'
        ELSE 'Known'
    END AS release_info_available

FROM movie_ratings m

LEFT JOIN release_dates r
    ON m.movieId = r.movieId