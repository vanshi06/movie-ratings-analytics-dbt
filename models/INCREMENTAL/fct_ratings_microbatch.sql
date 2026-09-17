{{ config(
    materialized='incremental',
    incremental_strategy='microbatch',
    event_time='event_timestamp',
    begin='2006-01-01',
    batch_size='day'
) }}

SELECT
    userId,
    movieId,
    rating,
    timestamp,
    event_timestamp
FROM {{ ref('stg_ratings') }}