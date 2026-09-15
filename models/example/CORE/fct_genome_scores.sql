{{ config(
    materialized='view'
) }}

WITH stg_genome_scores AS (
    SELECT * FROM {{ ref('stg_genome_scores') }}
)

SELECT
    movieId,
    tagId,
    ROUND(relevance, 4) AS relevance_score
FROM stg_genome_scores
WHERE relevance > 0