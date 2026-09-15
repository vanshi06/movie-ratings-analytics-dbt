{{ config(
    materialized='view'
) }}

SELECT
    movieId,
    imdbId,
    tmdbId
FROM {{ ref('stg_links') }}