select * from v$session;


select 
    person_name, count(*) as movie_tally, sum(worldwide_gross) as sum_ww_gross, max(worldwide_gross) as max_ww_gross,
    round(max(worldwide_gross)/sum(worldwide_gross), 3) as contribution
from
    sqlmdb.persons
    inner join sqlmdb.movie_jobs
        using (person_guid)
    inner join sqlmdb.movies
        using (movie_guid)
where job_code = 'DRTR' and worldwide_gross is not null
group by person_guid, person_name
having count(*) > 3