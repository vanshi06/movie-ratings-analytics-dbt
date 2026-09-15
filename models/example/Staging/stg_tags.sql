{{ config(
    materialized='view'
) }}

SELECT
    userId,
    movieId,
    tag,
    timestamp
FROM {{ source('raw', 'RAW_TAGS') }}