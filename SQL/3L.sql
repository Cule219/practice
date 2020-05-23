-- AGGREGATIONS
-- COUNT, SUM, MIN, MAX, AVG
SELECT SUM(poster_qty) 
FROM orders

SELECT (SUM(standard_amt_usd)/SUM(standard_qty)) AS price_per_unit
FROM orders

SELECT MIN(occurred_at) 
FROM orders

SELECT occurred_at
FROM orders
ORDER BY occurred_at
LIMIT 1

SELECT MAX(occurred_at)
FROM web_events

SELECT AVG(standard_qty) AS sq, 
AVG(gloss_qty) AS gq, 
AVG(poster_qty) AS pq, 
(AVG(standard_qty)/COUNT(*)) AS avg_stan_q, 
(AVG(gloss_qty)/COUNT(*)) AS avg_glos_q, 
(AVG(poster_qty)/COUNT(*)) AS avg_post_q
FROM orders

-- MEDIAN HARDCODED

SELECT *
FROM (SELECT total_amt_usd
      FROM orders
      ORDER BY total_amt_usd
      LIMIT 3457) AS Table1
ORDER BY total_amt_usd DESC
LIMIT 2;

-- GROUP BY, DISTINCT, HAVING, DATE, CASE

-- GROUP BY always goes in between WHERE clause and ORDER BY clause, a couloumn that is not aggregated needs to be in the GROUP BY
--- 1.Which account (by name) placed the earliest order? Your solution should have the account name and the date of the order.
SELECT a.name, MIN(o.occurred_at)
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name