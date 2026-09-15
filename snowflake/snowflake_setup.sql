-- =========================================================
-- NETFLIX ANALYTICS - SNOWFLAKE + DBT PROJECT
-- =========================================================


-- =========================================================
-- 1. ROLE
-- =========================================================
-- Use admin role
USE ROLE ACCOUNTADMIN;

CREATE ROLE IF NOT EXISTS NETFLIX_ANALYTICS_ROLE;

GRANT ROLE NETFLIX_ANALYTICS_ROLE TO ROLE ACCOUNTADMIN;


-- =========================================================
-- 2. WAREHOUSE
-- =========================================================

USE WAREHOUSE COMPUTE_WH;

-- =========================================================
-- 3. DATABASE
-- =========================================================

CREATE DATABASE IF NOT EXISTS NETFLIX_ANALYTICS_DB;


-- =========================================================
-- 4. SCHEMAS
-- =========================================================

CREATE SCHEMA IF NOT EXISTS NETFLIX_ANALYTICS_DB.RAW;

CREATE SCHEMA IF NOT EXISTS NETFLIX_ANALYTICS_DB.STAGING;

CREATE SCHEMA IF NOT EXISTS NETFLIX_ANALYTICS_DB.CORE;

CREATE SCHEMA IF NOT EXISTS NETFLIX_ANALYTICS_DB.REPORTING;

CREATE SCHEMA IF NOT EXISTS NETFLIX_ANALYTICS_DB.AUDIT;


-- =========================================================
-- 5. GRANTS
-- =========================================================

GRANT ALL ON WAREHOUSE NETFLIX_ANALYTICS_WH
    TO ROLE NETFLIX_ANALYTICS_ROLE;

GRANT ALL ON DATABASE NETFLIX_ANALYTICS_DB
    TO ROLE NETFLIX_ANALYTICS_ROLE;

GRANT ALL ON ALL SCHEMAS IN DATABASE NETFLIX_ANALYTICS_DB
    TO ROLE NETFLIX_ANALYTICS_ROLE;

GRANT ALL ON FUTURE SCHEMAS IN DATABASE NETFLIX_ANALYTICS_DB
    TO ROLE NETFLIX_ANALYTICS_ROLE;

GRANT ALL ON ALL TABLES IN SCHEMA NETFLIX_ANALYTICS_DB.RAW
    TO ROLE NETFLIX_ANALYTICS_ROLE;

GRANT ALL ON FUTURE TABLES IN SCHEMA NETFLIX_ANALYTICS_DB.RAW
    TO ROLE NETFLIX_ANALYTICS_ROLE;


-- =========================================================
-- 6. SET CONTEXT
-- =========================================================

USE ROLE NETFLIX_ANALYTICS_ROLE;

USE WAREHOUSE COMPUTE_WH;

USE DATABASE NETFLIX_ANALYTICS_DB;

USE SCHEMA RAW;


-- =========================================================
-- 7. FILE FORMAT
-- =========================================================

CREATE OR REPLACE FILE FORMAT NETFLIX_ANALYTICS_DB.RAW.CSV_FORMAT

    TYPE = 'CSV'
    FIELD_DELIMITER = ','
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
    NULL_IF = ('', 'NULL')
    EMPTY_FIELD_AS_NULL = TRUE;

    -- =========================================================
-- 8. STORAGE INTEGRATION
-- =========================================================

USE ROLE ACCOUNTADMIN;


CREATE OR REPLACE STORAGE INTEGRATION NETFLIX_S3_INTEGRATION
  TYPE = EXTERNAL_STAGE
  STORAGE_PROVIDER = S3
  ENABLED = TRUE
  STORAGE_AWS_ROLE_ARN = '<YOUR_AWS_ROLE_ARN>'
  STORAGE_ALLOWED_LOCATIONS = ('s3://netflixdatasetnew/');
  
 DESC INTEGRATION NETFLIX_S3_INTEGRATION;

    -- =========================================================
-- 9. EXTERNAL STAGE
-- =========================================================


CREATE OR REPLACE STAGE NETFLIX_ANALYTICS_DB.RAW.S3_STAGE

URL = 's3://netflixdatasetnew/'
STORAGE_INTEGRATION = NETFLIX_S3_INTEGRATION;

LIST @NETFLIX_ANALYTICS_DB.RAW.S3_STAGE;


     -- =========================================================
-- 10. TABLES
-- =========================================================

USE DATABASE NETFLIX_ANALYTICS_DB;

USE SCHEMA RAW;

-- Movies
CREATE OR REPLACE TABLE RAW_MOVIES (
    movieId INTEGER,
    title STRING,
    genres STRING
);

-- Ratings
CREATE OR REPLACE TABLE RAW_RATINGS (
    userId INTEGER,
    movieId INTEGER,
    rating FLOAT,
    timestamp BIGINT
);


-- Tags
CREATE OR REPLACE TABLE RAW_TAGS (
    userId INTEGER,
    movieId INTEGER,
    tag STRING,
    timestamp BIGINT
);


-- Genome Scores
CREATE OR REPLACE TABLE RAW_GENOME_SCORES (
    movieId INTEGER,
    tagId INTEGER,
    relevance FLOAT
);


-- Genome Tags
CREATE OR REPLACE TABLE RAW_GENOME_TAGS (
    tagId INTEGER,
    tag STRING
);


-- Links
CREATE OR REPLACE TABLE RAW_LINKS (
    movieId INTEGER,
    imdbId INTEGER,
    tmdbId INTEGER
);

-- =========================================================
-- 11. LOAD MOVIES
-- =========================================================

COPY INTO RAW_MOVIES

FROM '@S3_STAGE/movies.csv'

FILE_FORMAT = (
    TYPE = 'CSV'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
);

-- =========================================================
-- 12. LOAD RATINGS
-- =========================================================

COPY INTO RAW_RATINGS

FROM '@S3_STAGE/ratings.csv'

FILE_FORMAT = (
    TYPE = 'CSV'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
);

-- =========================================================
-- 13. LOAD TAGS
-- =========================================================

COPY INTO RAW_TAGS

FROM '@S3_STAGE/tags.csv'

FILE_FORMAT = (
    TYPE = 'CSV'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
);

-- =========================================================
-- 14. LOAD GENOME SCORES
-- =========================================================

COPY INTO RAW_GENOME_SCORES

FROM '@S3_STAGE/genome-scores(2).csv'

FILE_FORMAT = (
    TYPE = 'CSV'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
);



-- =========================================================
-- 15. LOAD GENOME TAGS
-- =========================================================

COPY INTO RAW_GENOME_TAGS

FROM '@S3_STAGE/genome-tags(2).csv'

FILE_FORMAT = (
    TYPE = 'CSV'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
);

-- =========================================================
-- 16. LOAD LINKS
-- =========================================================

COPY INTO RAW_LINKS

FROM '@S3_STAGE/links.csv'

FILE_FORMAT = (
    TYPE = 'CSV'
    SKIP_HEADER = 1
    FIELD_OPTIONALLY_ENCLOSED_BY = '"'
);

-- =========================================================
-- 17. VALIDATE RAW DATA
-- =========================================================

SELECT * FROM RAW_MOVIES;

SELECT  * FROM RAW_RATINGS;

SELECT * FROM RAW_TAGS;

SELECT * FROM RAW_GENOME_SCORES;

SELECT * FROM RAW_GENOME_TAGS;

SELECT * FROM RAW_LINKS;


-- =========================================================
-- 18. ROW COUNT VALIDATION
-- =========================================================

SELECT
    'RAW_MOVIES' AS TABLE_NAME,
    COUNT(*) AS ROW_COUNT
FROM RAW_MOVIES

UNION ALL

SELECT
    'RAW_RATINGS',
    COUNT(*)
FROM RAW_RATINGS

UNION ALL

SELECT
    'RAW_TAGS',
    COUNT(*)
FROM RAW_TAGS

UNION ALL

SELECT
    'RAW_GENOME_SCORES',
    COUNT(*)
FROM RAW_GENOME_SCORES

UNION ALL

SELECT
    'RAW_GENOME_TAGS',
    COUNT(*)
FROM RAW_GENOME_TAGS

UNION ALL

SELECT
    'RAW_LINKS',
    COUNT(*)
FROM RAW_LINKS;





-- ============================================================
-- 19. SEED VALIDATION
-- ============================================================

USE DATABASE NETFLIX_ANALYTICS_DB;

USE WAREHOUSE COMPUTE_WH;

-- Check that the dbt seed was created in Snowflake
SELECT COUNT(*) AS SEED_ROW_COUNT
FROM NETFLIX_ANALYTICS_DB.STAGING.MOVIE_RELEASE_DATES;

-- View seed data
SELECT *
FROM NETFLIX_ANALYTICS_DB.STAGING.MOVIE_RELEASE_DATES
ORDER BY movieId;

-- Check seed table structure
DESCRIBE TABLE NETFLIX_ANALYTICS_DB.STAGING.MOVIE_RELEASE_DATES;


-- ============================================================
-- 20. SNAPSHOT VALIDATION
-- ============================================================

-- Check snapshot row count
SELECT COUNT(*) AS SNAPSHOT_ROW_COUNT
FROM NETFLIX_ANALYTICS_DB.STAGING.SNAP_TAGS;

-- View snapshot data and dbt snapshot metadata
SELECT
    userId,
    movieId,
    tag,
    DBT_VALID_FROM,
    DBT_VALID_TO,
    DBT_SCD_ID
    
FROM NETFLIX_ANALYTICS_DB.STAGING.SNAP_TAGS

ORDER BY 
userId,
movieId,
DBT_VALID_FROM;

-- Check currently active snapshot records

SELECT
    userId,
    movieId,
    tag,
    DBT_VALID_FROM,
    DBT_VALID_TO
FROM NETFLIX_ANALYTICS_DB.STAGING.SNAP_TAGS

WHERE DBT_VALID_TO IS NULL;


-- ============================================================
-- 21. MACRO VALIDATION
-- ============================================================

-- Check the rating categories generated by the dbt macro
SELECT
    movieId,
    title,
    average_rating,
    rating_category
    
FROM NETFLIX_ANALYTICS_DB.STAGING.MOVIE_RATINGS_MART

ORDER BY average_rating DESC;

-- Count movies in each rating category
SELECT
    rating_category,
    COUNT(*) AS MOVIE_COUNT
FROM NETFLIX_ANALYTICS_DB.STAGING.MOVIE_RATINGS_MART

GROUP BY rating_category

ORDER BY rating_category;



-- ============================================================
-- 22. INCREMENTAL MODEL VALIDATION
-- ============================================================
INSERT INTO NETFLIX_ANALYTICS_DB.RAW.RAW_RATINGS
    (userId, movieId, rating, timestamp)
VALUES
    (999, 1, 5.0, 9999999999);


    SELECT
    COUNT(*) AS APPEND_ROW_COUNT

FROM NETFLIX_ANALYTICS_DB.STAGING.FCT_RATINGS_APPEND;


SELECT
    COUNT(*) AS MERGE_ROW_COUNT

FROM NETFLIX_ANALYTICS_DB.STAGING.FCT_RATINGS_MERGE;


SELECT
    COUNT(*) AS DELETE_INSERT_ROW_COUNT

FROM NETFLIX_ANALYTICS_DB.STAGING.FCT_RATINGS_DELETE_INSERT;


SELECT
    COUNT(*) AS MICROBATCH_ROW_COUNT

FROM NETFLIX_ANALYTICS_DB.STAGING.FCT_RATINGS_MICROBATCH;


-- =========================================================
-- 23. MICROBATCH EVENT TIME VALIDATION
-- =========================================================

SELECT
    COUNT(*) AS NULL_EVENT_TIMESTAMP_COUNT

FROM NETFLIX_ANALYTICS_DB.STAGING.FCT_RATINGS_MICROBATCH

WHERE event_timestamp IS NULL;


SELECT
    userId,
    movieId,
    rating,
    timestamp,
    event_timestamp

FROM NETFLIX_ANALYTICS_DB.STAGING.FCT_RATINGS_MICROBATCH

ORDER BY event_timestamp DESC

LIMIT 10;





-- ============================================================
-- 5. FINAL MART VALIDATION
-- ============================================================

-- View the final movie analytics mart

SELECT *
FROM NETFLIX_ANALYTICS_DB.STAGING.MOVIE_RATINGS_MART
ORDER BY average_rating DESC;

-- Check final mart row count

SELECT COUNT(*) AS MART_ROW_COUNT
FROM NETFLIX_ANALYTICS_DB.STAGING.MOVIE_RATINGS_MART;

-- View the important final business columns

SELECT
    movieId,
    title,
    genres,
    total_ratings,
    average_rating,
    rating_category,
    release_date,
    release_info_available
    
FROM NETFLIX_ANALYTICS_DB.STAGING.MOVIE_RATINGS_MART

ORDER BY average_rating DESC;


-- ============================================================
-- END OF DBT SNOWFLAKE VALIDATION
-- ============================================================










