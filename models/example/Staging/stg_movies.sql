{{ config(
    materialized='view'
) }}

SELECT
    movieId,
    title,
    genres
FROM {{ source('raw', 'RAW_MOVIES') }}