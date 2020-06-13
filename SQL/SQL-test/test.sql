-- SAKILA DB test
--- Let's start with creating a table that provides the following details: actor's first and last name combined as full_name, film title, film description and length of the movie.How many rows are there in the table?

SELECT (a.first_name || ' ' || a.last_name) AS full_name, f.title, f.description, f.length
FROM actor a
JOIN film_actor fa
ON fa.actor_id = a.actor_id
JOIN film f
ON fa.film_id = f.film_id

--- Write a query that creates a list of actors and movies where the movie length was more than 60 minutes. How many rows are there in this query result?
SELECT (a.first_name || ' ' || a.last_name) AS full_name, f.title, f.description, f.length
FROM actor a
JOIN film_actor fa
ON fa.actor_id = a.actor_id
JOIN film f
ON fa.film_id = f.film_id
WHERE f.length > 60

--- Write a query that captures the actor id, full name of the actor, and counts the number of movies each actor has made. (HINT: Think about whether you should group by actor id or the full name of the actor.) Identify the actor who has made the maximum number movies.
SELECT (a.first_name || ' ' || a.last_name) AS full_name, a.actor_id,  COUNT(f.*) AS total_movies
FROM actor a
JOIN film_actor fa
ON fa.actor_id = a.actor_id
JOIN film f
ON fa.film_id = f.film_id
GROUP BY 2, 1
ORDER BY 3 DESC
--- Write a query that displays a table with 4 columns: actor's full name, film title, length of movie, and a column name "filmlen_groups" that classifies movies based on their length. Filmlen_groups should include 4 categories: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.
SELECT (a.first_name || ' ' || a.last_name) AS full_name, f.title, f.length,
CASE 
	WHEN f.length <= 60 THEN '1 hour or less'
    WHEN f.length > 60 AND f.length <= 120 THEN 'Between 1-2 hours'
    WHEN f.length > 120 AND f.length <= 180 THEN 'Between 2-3 hours'
    WHEN f.length > 180 THEN 'More than 3 hours'
END AS filmlen_groups
FROM actor a
JOIN film_actor fa
ON fa.actor_id = a.actor_id
JOIN film f
ON fa.film_id = f.film_id
--- Now, we bring in the advanced SQL query concepts! Revise the query you wrote above to create a count of movies in each of the 4 filmlen_groups: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.
SELECT COUNT(f.*),
CASE 
	WHEN f.length <= 60 THEN '1 hour or less'
    WHEN f.length > 60 AND f.length <= 120 THEN 'Between 1-2 hours'
    WHEN f.length > 120 AND f.length <= 180 THEN 'Between 2-3 hours'
    WHEN f.length > 180 THEN 'More than 3 hours'
END AS filmlen_groups
FROM actor a
JOIN film_actor fa
ON fa.actor_id = a.actor_id
JOIN film f
ON fa.film_id = f.film_id
GROUP BY 2
-- -- -- -- -- -- -- -- 
SELECT COUNT(*),
CASE 
	WHEN f.length <= 60 THEN '1 hour or less'
    WHEN f.length > 60 AND f.length <= 120 THEN 'Between 1-2 hours'
    WHEN f.length > 120 AND f.length <= 180 THEN 'Between 2-3 hours'
    WHEN f.length > 180 THEN 'More than 3 hours'
END AS filmlen_groups
FROM film f
GROUP BY 2




SELECT AVG(DATE_PART('day', return_date-rental_date))
AS rent_avg
from rental

SELECT f.title, c.name,  COUNT(r.rental_id),
NTILE(4) OVER(ORDER BY DATE_PART('day', return_date-rental_date)) AS total_percentile
FROM film f
JOIN inventory i 
ON f.film_id = i.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1,2
ORDER BY 3 DESC



-- FIRST ITERATION
-- Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.
SELECT f.title, c.name,  COUNT(r.rental_id) as rents_count
FROM film f
JOIN inventory i 
ON f.film_id = i.film_id
JOIN rental r
ON r.inventory_id = i.inventory_id
JOIN film_category fc
ON f.film_id = fc.film_id
JOIN category c
ON fc.category_id = c.category_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY 1,2
ORDER BY 3 DESC



