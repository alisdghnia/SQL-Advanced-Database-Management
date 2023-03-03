--------------------------------Question 1--------------------------------------
select * from sqlmdb.studios where studio_name like '%Disney%';

--------------------------------Question 2--------------------------------------
select count(movie_title), movie_title from (select movie_title, studio_guid from sqlmdb.movies
inner join sqlmdb.movie_studios using (movie_guid))
group by movie_title
order by count(movie_title) desc;

--------------------------------Question 3--------------------------------------
select afi_top100_1997, movie_title from sqlmdb.movies
where afi_top100_1997 is not null
order by afi_top100_1997 asc;

--------------------------------Question 4--------------------------------------
select count(release_year) from sqlmdb.movies
where release_year between 2000 and 2009;

--------------------------------Question 5--------------------------------------
select count(movie_title) from sqlmdb.movies
where movie_title like 'The %';

--------------------------------Question 6--------------------------------------
select avg(runtime)
from sqlmdb.movies
    inner join sqlmdb.movie_genres using (movie_guid)
        inner join sqlmdb.genres using (genre_code)
where genre_code = 'THR' and release_year > 1979 and release_year < 1990;

--------------------------------Question 7--------------------------------------
SELECT COUNT(birth_country_a3code) AS country_tally
FROM sqlmdb.movies
    INNER JOIN sqlmdb.movie_actors
        USING (movie_guid)
            INNER JOIN sqlmdb.persons
                USING (person_guid)              
GROUP BY birth_country_a3code
ORDER BY country_tally desc;

--------------------------------Question 8--------------------------------------
select movie_title, person_name, imdb_rating
from sqlmdb.movies
    inner join sqlmdb.movie_actors using (movie_guid)
        inner join sqlmdb.persons using (person_guid)
where imdb_rating > 8.0 and person_name ='Tom Hanks';

-------------------------------Question 9---------------------------------------
select avg(metascore)
from sqlmdb.movies
    inner join sqlmdb.movie_actors using (movie_guid)
        inner join sqlmdb.persons using (person_guid)
            inner join sqlmdb.critic_reviews using (movie_guid)
where person_name ='Tom Hanks';

-------------------------------Question 10--------------------------------------
select movie_title, release_year, count(person_guid) as cast_size
from sqlmdb.movies
    inner join sqlmdb.movie_actors using (movie_guid)
group by movie_title, release_year
order by cast_size desc;

-------------------------------Question 11--------------------------------------
select distinct keyword_guid
from sqlmdb.movie_keywords
    inner join sqlmdb.movies using (movie_guid)
        inner join sqlmdb.movie_studios using (movie_guid)
            inner join sqlmdb.studios using (studio_guid)
where studio_name like '%Walt Disney Pictures%'
group by keyword_guid
having count(*) > 5;

-------------------------------Question 12--------------------------------------
select 
    studio_name, count(*) as movie_tally, sum(worldwide_gross) as sum_ww_gross, max(worldwide_gross) as max_ww_gross,
    round(max(worldwide_gross)/sum(worldwide_gross), 3) as contribution
from
    sqlmdb.studios
    inner join sqlmdb.movie_studios
        using (studio_guid)
    inner join sqlmdb.movies
        using (movie_guid)
where worldwide_gross is not null
group by studio_name
having count(*) > 5 and round(max(worldwide_gross)/sum(worldwide_gross), 3) > 0.3


--------------------------The rest were TRUE/FAlSE------------------------------






