{{ config(
    materialized='view'
) }}

SELECT
    userId,
    movieId,
    rating,
    timestamp,
    TO_TIMESTAMP(timestamp) AS event_timestamp
FROM {{ source('raw', 'RAW_RATINGS') }}