-- SUBQUERIES
--- subqueries can be used anywhere in the statement
--- example in FROM
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
        channel, COUNT(*) as events
    FROM web_events
    GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;
--- example in WHERE (select all orders that occured in the same month as the first order ever)
SELECT *
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min_month 
FROM orders)
ORDER BY occurred_at;

SELECT AVG(standard_qty) as standard,
 AVG(gloss_qty) as gloss,
  AVG(poster_qty) as poster,
  SUM(total_amt_usd) as total
FROM orders
WHERE DATE_TRUNC('month', occurred_at) = 
(SELECT DATE_TRUNC('month', MIN(occurred_at)) AS min
FROM orders)

--- Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
SELECT t3.region_name, t3.total_amt, t3.rep_name
FROM(SELECT region_name, MAX(total_amt) total_amt
     FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
             GROUP BY 1, 2) t1
     GROUP BY 1) t2
JOIN 
(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY 1,2
ORDER BY 3 DESC
) t3
ON t2.region_name = t3.region_name AND t2.total_amt = t3.total_amt
--- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed? 
SELECT t1.region_name, t1.total_orders, t1.total_amt
FROM
(SELECT r.name region_name, COUNT(o.*) total_orders, SUM(o.total_amt_usd) total_amt
FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
GROUP BY 1) t1
JOIN 
(SELECT MAX(total_amt) total_amt
     FROM(SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
             FROM sales_reps s
             JOIN accounts a
             ON a.sales_rep_id = s.id
             JOIN orders o
             ON o.account_id = a.id
             JOIN region r
             ON r.id = s.region_id
GROUP BY 1) t2) t3
ON t1.total_amt = t3.total_amt

--- How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer? 
SELECT name, total_purch
FROM (SELECT a.name, COUNT(o.*) total_purch
    FROM accounts a
    JOIN orders o
    ON a.id = o.account_id
    GROUP BY 1) t2
WHERE total_purch >
    (SELECT total_purch
    FROM(SELECT a.name, SUM(o.standard_qty) count_standard, COUNT(o.*) total_purch
       FROM accounts a
       JOIN orders o
       ON a.id = o.account_id
       GROUP BY 1
       ORDER BY 2 DESC
       LIMIT 1) t1) 
--- For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?
SELECT a.name, SUM(o.total_amt_usd) as total_spent
SELECT COUNT (w.*) as events_count, w.channel
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
WHERE a.id = 
(SELECT a.id id
  FROM accounts a
  JOIN orders o
  ON a.id = o.account_id
  GROUP BY 1
  HAVING  SUM(o.total_amt_usd) =
   (SELECT MAX(total_spent) total_spent
   FROM
      (SELECT SUM(o.total_amt_usd) total_spent, a.name account
          FROM accounts a
          JOIN orders o
          ON a.id = o.account_id
          GROUP BY 2) t1))
GROUP BY 2
--- What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?
SELECT a.name, AVG(o.total_amt_usd) avg_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
HAVING AVG(o.total_amt_usd) >
  (SELECT AVG(total_amt_usd) as avg_order
  FROM orders)
--- What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.
SELECT AVG(avg_order) 
FROM
(SELECT a.name, AVG(o.total_amt_usd) avg_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
HAVING AVG(o.total_amt_usd) >
  (SELECT AVG(total_amt_usd) as avg_order
  FROM orders)) t1

-- WITH is used to store tables and later use them in queries since this can be costly if done in subqueries
--- example
WITH table1 AS (
          SELECT *
          FROM web_events),

     table2 AS (
          SELECT *
          FROM accounts)


SELECT *
FROM table1
JOIN table2
ON table1.account_id = table2.id;
-- example 6 from above WITH
WITH table1 as (SELECT a.name, AVG(o.total_amt_usd) avg_order
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
HAVING AVG(o.total_amt_usd) >
  (SELECT AVG(total_amt_usd) as avg_order
  FROM orders))

SELECT AVG(avg_order) 
FROM table1