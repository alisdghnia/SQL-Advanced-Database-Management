select
    movie_title,
    release_year,
    count(tagline) as tagline_tally
from
    sqlmdb.movies
    inner join sqlmdb.taglines
        using (movie_guid)
where ebert_great_film = 'Y'
group by movie_title, release_year
--having count(tagline) > 3
order by count(tagline) desc;


select movie_title, release_year, count(tagline)
from
    sqlmdb.movies
    left outer join sqlmdb.taglines
        using (movie_guid)
where ebert_great_film = 'Y'
group by movie_title, release_year
--having count(tagline) > 3
order by count(tagline) desc;


select
    movie_title,
    count(tagline) as tagline_tally
from
    sqlmdb.movies
    inner join sqlmdb.taglines
        using (movie_guid)
where ebert_great_film = 'Y'
group by movie_title, release_year
--having count(tagline) > 3
order by count(tagline) desc;


select *
from sqlmdb.persons
where person_name = 'Steve McQueen';


select person_name, count(*) as tally
from sqlmdb.persons
group by person_name;


select
    movie_title,
    release_year,
    count(tagline) as tagline_tally
from
    sqlmdb.movies m, sqlmdb.taglines t
where (ebert_great_film = 'Y') and (m.movie_guid = t.movie_guid)
group by movie_title, release_year
--having count(tagline) > 3
order by count(tagline) desc;