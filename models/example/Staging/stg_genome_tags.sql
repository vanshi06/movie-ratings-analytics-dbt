{{ config(
    materialized='view'
) }}

SELECT
    tagId,
    tag
FROM {{ source('raw', 'RAW_GENOME_TAGS') }}