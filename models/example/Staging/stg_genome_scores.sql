{{ config(
    materialized='view'
) }}

SELECT
    movieId,
    tagId,
    relevance
FROM {{ source('raw', 'RAW_GENOME_SCORES') }}