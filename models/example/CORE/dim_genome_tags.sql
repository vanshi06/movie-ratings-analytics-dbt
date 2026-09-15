{{ config(
    materialized='view'
) }}

WITH stg_genome_tags AS (
    SELECT * FROM {{ ref('stg_genome_tags') }}
)

SELECT
    tagId,
    INITCAP(TRIM(tag)) AS tag_name
FROM stg_genome_tags