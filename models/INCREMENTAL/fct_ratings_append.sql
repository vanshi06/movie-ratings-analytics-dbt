{{ config(
    materialized='incremental',
    incremental_strategy='append'
) }}

SELECT
    userId,
    movieId,
    rating,
    timestamp
FROM {{ ref('stg_ratings') }}

{% if is_incremental() %}

WHERE timestamp > (
    SELECT MAX(timestamp)
    FROM {{ this }}
)

{% endif %}