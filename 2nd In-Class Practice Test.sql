----- SECOND IN-CLASS PRACTICE TEST


-- first question

select genre_code, count(movie_guid) as movie_tally
from sqlmdb.movie_genres
group by genre_code;


select g.genre_name, count(movie_guid) as movie_tally
from
    sqlmdb.genres g
    inner join sqlmdb.movie_genres
        using (genre_code)
group by genre_code, g.genre_name
order by movie_tally desc;


-- second question

select movie_title, release_year, imdb_rating, metascore, tomatometer
from 
    sqlmdb.movies
    inner join sqlmdb.critic_reviews
        using (movie_guid)
    inner join sqlmdb.rotten_tomatoes
        using (movie_guid)
where 
    (imdb_rating >= 8.5) and
    (tomatometer >= 85) and
    (metascore >= 85);


-- third question

select runtime, metascore
from
    sqlmdb.movies m
    inner join sqlmdb.critic_reviews cr
        on m.movie_guid = cr.movie_guid; -- wrong answer
        
select round(corr(runtime, avg(metascore)), 3)
from
    sqlmdb.movies m
    inner join sqlmdb.critic_reviews cr
        using (movie_guid)
group by (runtime); -- answer for correlation value

select count(*)
from (
select runtime, avg(metascore)
from
    sqlmdb.movies m
    inner join sqlmdb.critic_reviews cr
        using (movie_guid)
group by (runtime)) -- correct answer


-- fourth and fifth question of TRUE/FALSE




----- THIRD IN-CLASS PRACTICE TEST


