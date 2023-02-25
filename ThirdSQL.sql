-- Recommender System (try it yourself later)
---- https://usflearn.instructure.com/courses/1759988/pages/st-rec-data-analysis?module_item_id=29970617

--missed the first one - watch in the video on teams
SELECT
    COUNT(DISTINCT user_id) AS user_tally,
    COUNT(DISTINCT item_id) AS item_tally,
    COUNT(*) AS rating_tally
FROM relmdb.ml_ratings;

---------------------second part - RATING DISTRIBUTION--------------------------
SELECT
    user_id,
    COUNT(item_id) as rating_tally
FROM relmdb.ml_ratings 
GROUP BY user_id
ORDER BY COUNT(item_id) DESC;


SELECT
    rating_bin,
    COUNT(user_id) AS user_tally
FROM (
    SELECT
        user_id,
        ROUND(COUNT(item_id), -1) as rating_bin
    FROM relmdb.ml_ratings 
    GROUP BY user_id)
GROUP BY rating_bin
ORDER BY rating_bin;


SELECT
    rating_bin,
    COUNT(item_id) AS item_tally
FROM (
    SELECT
        item_id,
        ROUND(COUNT(user_id), -1) AS rating_bin
    FROM relmdb.ml_ratings
    GROUP BY item_id)
GROUP BY rating_bin
ORDER BY rating_bin;

------------------------third part - RATINGS QUALITY----------------------------
SELECT AVG(rating) AS avg_rating
FROM relmdb.ml_ratings;

SELECT
    rating,
    COUNT(*) AS rating_tally
FROM relmdb.ml_ratings
GROUP BY rating
ORDER BY rating DESC;

SELECT
    rating_bin,
    COUNT(user_id) AS user_tally
FROM (
    SELECT ROUND(AVG(rating), 1) AS rating_bin, user_id
    FROM relmdb.ml_ratings
    GROUP BY user_id)
GROUP BY rating_bin
ORDER BY rating_bin DESC;

SELECT
    rating_bin,
    COUNT(item_id) AS item_tally
FROM (
    SELECT ROUND(AVG(rating), 1) AS rating_bin, item_id
    FROM relmdb.ml_ratings
    GROUP BY item_id)
GROUP BY rating_bin
ORDER BY rating_bin DESC;

---------------------fourth part - GLOBAL RECOMMENDATIONS-----------------------
SELECT
    ROUND(AVG(rating), 1) AS avg_rating, 
    COUNT(user_id) AS rating_tally,
    movie_title 
FROM
    relmdb.ml_ratings mr
    INNER JOIN relmdb.ml_items mi
        ON mr.item_id = mi.item_id
GROUP BY movie_title
HAVING COUNT(user_id) > 10
ORDER BY avg_rating DESC
FETCH FIRST 10 ROWS ONLY;


-------------------------Now time for Cosine Similarity-------------------------

-------------------fifth part - Lets look at some RATINGS-----------------------
SELECT rmr.item_id, rating, movie_title
FROM
    dberndt.reco_my_ratings rmr
    INNER JOIN relmdb.ml_items itm
        ON rmr.item_id = itm.item_id;
        
-----------------sixth part - COSINE SIMILARITY APPLICATION---------------------

------ THERE IS BETTER ONE IN BOX THAT BERNDT HAS ------
SELECT
    user_id,
    SUM((rating) * (rating)) AS norm 
FROM relmdb.ml_ratings 
GROUP BY user_id;

SELECT SUM((rating) * (rating)) AS norm 
FROM dberndt.reco_my_ratings;

SELECT
    user_id,
    SUM((rmr.rating) * (mlr.rating)) as dist 
FROM
    relmdb.ml_ratings mlr
    INNER JOIN dberndt.reco_my_ratings rmr
        ON mlr.item_id = rmr.item_id 
GROUP BY user_id;

SELECT
    users.user_id,
    distances.dist / (SQRT(my.norm) * SQRT(users.norm)) AS score
FROM 
    (SELECT user_id, SUM((rmr.rating)*(mlr.rating)) AS dist 
    FROM
        relmdb.ml_ratings mlr
        INNER JOIN dberndt.reco_my_ratings rmr
            ON mlr.item_id = rmr.item_id 
    GROUP BY user_id) distances
    INNER JOIN
    (SELECT user_id,
    SUM((rating)*(rating)) AS norm 
    FROM relmdb.ml_ratings 
    GROUP BY user_id) users
        ON distances.user_id = users.user_id
    CROSS JOIN
    (SELECT SUM((rating)*(rating)) AS norm 
    FROM dberndt.reco_my_ratings) my
ORDER BY score DESC;

SELECT
    mlr.item_id,
    rmr.rating AS my_rating, 
    mlr.rating AS user_rating,
    movie_title 
FROM
    relmdb.ml_ratings mlr
    INNER JOIN dberndt.reco_my_ratings rmr
        ON mlr.item_id = rmr.item_id
    INNER JOIN relmdb.ml_items mli
        ON mlr.item_id = mli.item_id
WHERE mlr.user_id = 744
ORDER by mlr.item_id;

---------------seventh part - GENERATING SOME RECOMMENDATIONS-------------------
CREATE TABLE reco_sim_users ( 
   user_id NUMBER(4,0) PRIMARY KEY, 
   score NUMBER);
   
INSERT INTO reco_sim_users (user_id, score)
SELECT
    users.user_id,
    distances.dist / (SQRT(my.norm) * SQRT(users.norm)) AS score
FROM 
    (SELECT user_id, SUM((rmr.rating)*(mlr.rating)) AS dist 
    FROM
        relmdb.ml_ratings mlr
        INNER JOIN dberndt.reco_my_ratings rmr
            ON mlr.item_id = rmr.item_id 
    GROUP BY user_id) distances
    INNER JOIN
    (SELECT user_id,
    SUM((rating)*(rating)) AS norm 
    FROM relmdb.ml_ratings 
    GROUP BY user_id) users
        ON distances.user_id = users.user_id
    CROSS JOIN
    (SELECT SUM((rating)*(rating)) AS norm 
    FROM dberndt.reco_my_ratings) my
ORDER BY score DESC
FETCH FIRST 30 ROWS ONLY;


-- HAVE TO FIGURE OUT HOW TO GET THE TABLE --
SELECT
    mli.movie_title,
    ROUND(SUM(rating) / COUNT(*), 1) AS score
FROM
    thirdsql.reco_sim_users rsu
    INNER JOIN relmdb.ml_ratings mlr
        ON rsu.user_id = mlr.user_id
    INNER JOIN relmdb.ml_items mli
        ON mlr.item_id = mli.item_id
WHERE mlr.item_id NOT IN (
    SELECT item_id FROM reco_my_ratings)
GROUP BY mli.movie_title
HAVING COUNT(*) > 10
ORDER BY score DESC
FETCH FIRST 10 ROWS ONLY;

------------------------eigth part - NORMALIZED RATING--------------------------
SELECT
  user_id,
  AVG(rating) AS avg_rating,
  COUNT(*) AS rating_tally
FROM relmdb.ml_ratings
GROUP BY user_id
ORDER BY user_id;

CREATE TABLE norm_ratings AS
SELECT
  ir.user_id,
  item_id,
  rating,
  rating - avg_rating AS norm_rating,
  rating_tstamp
FROM
  (SELECT user_id, item_id, rating, rating_tstamp
  FROM relmdb.ml_ratings) ir
  INNER JOIN
  (SELECT user_id, AVG(rating) AS avg_rating
  FROM relmdb.ml_ratings
  GROUP BY user_id) ar
    ON ir.user_id = ar.user_id;