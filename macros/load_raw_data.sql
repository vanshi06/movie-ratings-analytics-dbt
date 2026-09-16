{% macro load_raw_data() %}

    {% set copy_movies %}
        COPY INTO NETFLIX_ANALYTICS_DB.RAW.RAW_MOVIES
        FROM '@NETFLIX_ANALYTICS_DB.RAW.S3_STAGE/movies.csv'
        FILE_FORMAT = (
            TYPE = 'CSV'
            SKIP_HEADER = 1
            FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        )
    {% endset %}

    {% set copy_ratings %}
        COPY INTO NETFLIX_ANALYTICS_DB.RAW.RAW_RATINGS
        FROM '@NETFLIX_ANALYTICS_DB.RAW.S3_STAGE/ratings.csv'
        FILE_FORMAT = (
            TYPE = 'CSV'
            SKIP_HEADER = 1
            FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        )
    {% endset %}

    {% set copy_tags %}
        COPY INTO NETFLIX_ANALYTICS_DB.RAW.RAW_TAGS
        FROM '@NETFLIX_ANALYTICS_DB.RAW.S3_STAGE/tags.csv'
        FILE_FORMAT = (
            TYPE = 'CSV'
            SKIP_HEADER = 1
            FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        )
    {% endset %}

    {% set copy_genome_scores %}
        COPY INTO NETFLIX_ANALYTICS_DB.RAW.RAW_GENOME_SCORES
        FROM '@NETFLIX_ANALYTICS_DB.RAW.S3_STAGE/genome-scores(2).csv'
        FILE_FORMAT = (
            TYPE = 'CSV'
            SKIP_HEADER = 1
            FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        )
    {% endset %}

    {% set copy_genome_tags %}
        COPY INTO NETFLIX_ANALYTICS_DB.RAW.RAW_GENOME_TAGS
        FROM '@NETFLIX_ANALYTICS_DB.RAW.S3_STAGE/genome-tags(2).csv'
        FILE_FORMAT = (
            TYPE = 'CSV'
            SKIP_HEADER = 1
            FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        )
    {% endset %}

    {% set copy_links %}
        COPY INTO NETFLIX_ANALYTICS_DB.RAW.RAW_LINKS
        FROM '@NETFLIX_ANALYTICS_DB.RAW.S3_STAGE/links.csv'
        FILE_FORMAT = (
            TYPE = 'CSV'
            SKIP_HEADER = 1
            FIELD_OPTIONALLY_ENCLOSED_BY = '"'
        )
    {% endset %}

    {{ run_query(copy_movies) }}
    {{ run_query(copy_ratings) }}
    {{ run_query(copy_tags) }}
    {{ run_query(copy_genome_scores) }}
    {{ run_query(copy_genome_tags) }}
    {{ run_query(copy_links) }}

{% endmacro %}