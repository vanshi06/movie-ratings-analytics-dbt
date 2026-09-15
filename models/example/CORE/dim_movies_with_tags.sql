{{ config(
    materialized = 'ephemeral'
) }}

WITH movies AS (
    SELECT * FROM {{ ref('dim_movies') }}
),

tags AS (
    SELECT * FROM {{ ref('dim_genome_tags') }}
),

scores AS (
    SELECT * FROM {{ ref('fct_genome_scores') }}
)

SELECT
    m.movieId,
    m.movie_title,
    m.genres,
    t.tag_name,
    s.relevance_score
FROM movies m
LEFT JOIN scores s
    ON m.movieId = s.movieId
LEFT JOIN tags t
    ON t.tagId = s.tagId