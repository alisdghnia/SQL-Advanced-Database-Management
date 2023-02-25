---------------------- Question #1 --------------------------

SELECT *
FROM sqlmdb.studios
WHERE studio_name LIKE '%Disney%';

---------------------- Question #2 --------------------------

SELECT COUNT(person_name) as person_tally, person_name
FROM sqlmdb.movie_actors
    INNER JOIN sqlmdb.movies
       USING (movie_guid)
        INNER JOIN sqlmdb.persons
            USING (person_guid)            
WHERE (release_year > 1989 AND release_year < 2000)
GROUP BY person_name
ORDER BY person_tally desc;

---------------------- Question #3 --------------------------

--------------------------------------------------------------------------------
---------------------------------Attempt 2--------------------------------------
--------------------------------------------------------------------------------

---------------------- Question #1 --------------------------

SELECT movie_title, runtime
FROM sqlmdb.movies
where runtime is not Null
ORDER BY runtime desc;

---------------------- Question #2 --------------------------

SELECT count(genre_name), genre_name, avg(worldwide_gross)
FROM sqlmdb.movies
    INNER JOIN sqlmdb.movie_genres USING (movie_guid)
        INNER JOIN sqlmdb.genres USING (genre_code)
Having count(movie_title) > 5
group by genre_name
order by avg(worldwide_gross) desc;

---------------------- Question #3 --------------------------

SELECT remake_guid, movie_title, imdb_rating
-- SELECT movie_title, imdb_rating, release_year
FROM sqlmdb.movies
WHERE remake_guid is not null;

--------------------------------------------------------------------------------
---------------------------------Attempt 2--------------------------------------
--------------------------------------------------------------------------------

---------------------- Question #1 --------------------------

SELECT COUNT(tagline), movie_title
FROM sqlmdb.movies INNER JOIN sqlmdb.taglines USING (movie_guid)
WHERE movie_title = 'The Matrix'
GROUP BY movie_title
ORDER BY COUNT(tagline);

---------------------- Question #2 --------------------------

SELECT COUNT(birth_country_a3code) AS country_tally
FROM sqlmdb.movies
    INNER JOIN sqlmdb.movie_actors
        USING (movie_guid)
            INNER JOIN sqlmdb.persons
                USING (person_guid)
GROUP BY birth_country_a3code
ORDER BY country_tally desc;

---------------------- Question #3 --------------------------

-- Hard Question
SELECT person_name
FROM sqlmdb.movies
    INNER JOIN sqlmdb.movie_actors
        USING (movie_guid)
            INNER JOIN sqlmdb.persons
                USING (person_guid)
WHERE at least 1 movie_title in (SELECT DISTINCT movie_title, imdb_rating, imdb_votes
FROM sqlmdb.movies
    INNER JOIN sqlmdb.movie_actors
        USING (movie_guid)
            INNER JOIN sqlmdb.persons
                USING (person_guid)
ORDER BY imdb_rating desc
FETCH first 50 rows only);
-- Couldn't solve it