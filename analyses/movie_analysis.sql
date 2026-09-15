SELECT
    movieId,
    title,
    genres,
    total_ratings,
    average_rating
FROM {{ ref('movie_rating_summary') }}
WHERE total_ratings > 0
ORDER BY average_rating DESC