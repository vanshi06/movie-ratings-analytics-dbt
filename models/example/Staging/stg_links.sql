{{ config(
    materialized='view'
) }}

SELECT
    movieId,
    imdbId,
    tmdbId
FROM {{ source('raw', 'RAW_LINKS') }}