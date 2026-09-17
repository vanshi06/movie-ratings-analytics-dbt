{{ config(
    materialized='incremental',
    unique_key=['userId', 'movieId'],
    incremental_strategy='merge'
) }}

SELECT
    userId,
    movieId,
    rating,
    timestamp
FROM {{ ref('stg_ratings') }}

{% if is_incremental() %}

WHERE timestamp >= (
    SELECT MAX(timestamp)
    FROM {{ this }}
)

{% endif %}