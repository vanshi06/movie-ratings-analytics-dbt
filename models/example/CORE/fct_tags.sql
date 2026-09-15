{{ config(
    materialized='view'
) }}

SELECT
    userId,
    movieId,
    tag,
    timestamp
FROM {{ ref('stg_tags') }}