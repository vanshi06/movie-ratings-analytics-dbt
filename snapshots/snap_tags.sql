{% snapshot snap_tags %}

{{
    config(
        target_schema='STAGING',
        unique_key=['userId', 'movieId', 'tag'],
        strategy='check',
        check_cols=['tag']
    )
}}

SELECT
    userId,
    movieId,
    tag,
    timestamp
FROM {{ ref('stg_tags') }}

{% endsnapshot %}