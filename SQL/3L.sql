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

SELECT MAX
(occurred_at)
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
--- Find the number of sales reps in each region. Your final table should have two columns - the region and the number of sales_reps. Order from fewest reps to most reps.
SELECT r.name AS region, COUNT(sr.*) AS num_reps
FROM region r
      JOIN sales_reps sr
      ON r.id = sr.region_id
GROUP BY r.name
--- For each account, determine the average amount of each type of paper they purchased across their orders. Your result should have four columns - one for the account name and one for the average quantity purchased for each of the paper types for each account. 
SELECT a.name, AVG(o.standard_qty) AS standard,
      AVG(o.gloss_qty) AS gloss , AVG(o.poster_qty) AS poster
FROM accounts a
      JOIN orders o
      ON o.account_id = a.id
GROUP BY a.name
--- For each account, determine the average amount spent per order on each paper type. Your result should have four columns - one for the account name and one for the average amount spent on each paper type.
SELECT a.name, (SUM(total)/(AVG(o.standard_qty)+0.01)) AS standard,
      (SUM(total)/(AVG(o.gloss_qty)+0.01)) AS gloss , (SUM(total)/(AVG(o.poster_qty)+0.01)) AS poster
FROM accounts a
      JOIN orders o
      ON o.account_id = a.id
GROUP BY a.name
--- Determine the number of times a particular channel was used in the web_events table for each sales rep. Your final table should have three columns - the name of the sales rep, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT s.name, w.channel, COUNT(w.*) AS occurrences
FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN web_events w
      ON w.account_id = a.id
GROUP BY w.channel, s.name
ORDER BY occurrences DESC
--- Determine the number of times a particular channel was used in the web_events table for each region. Your final table should have three columns - the region name, the channel, and the number of occurrences. Order your table with the highest number of occurrences first.
SELECT r.name, w.channel, COUNT(w.*) as occurrences
FROM region r
      JOIN sales_reps s
      ON r.id = s.region_id
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN web_events w
      ON w.account_id = a.id
GROUP BY r.name, w.channel
ORDER BY occurrences DESC
-- DISTINCT
--- Use DISTINCT to test if there are any accounts associated with more than one region.
SELECT a.id as "account id", r.id as "region id",
      a.name as "account name", r.name as "region name"
FROM accounts a
      JOIN sales_reps s
      ON s.id = a.sales_rep_id
      JOIN region r
      ON r.id = s.region_id;
--- Have any sales reps worked on more than one account?
SELECT s.id, s.name, COUNT(*) num_accounts
FROM accounts a
      JOIN sales_reps s
      ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY num_accounts;
--     HAVING is like WHERE, but works on logical statements involving aggregations
--- How many of the sales reps have more than 5 accounts that they manage?
SELECT COUNT(a.sales_rep_id) AS acc_sr,
      s.name
FROM accounts a
      JOIN sales_reps s
      ON s.id = a.sales_rep_id
GROUP BY s.name
HAVING COUNT(a.sales_rep_id) > 5
--- How many accounts have more than 20 orders?
SELECT COUNT(o.*) AS ord_count,
      a.name
FROM accounts a
      JOIN orders o
      ON o.account_id = a.id
GROUP BY a.name
HAVING COUNT(o.*) > 20
--- Which account has the most orders?
SELECT COUNT(o.*) AS ord_count,
      a.name
FROM accounts a
      JOIN orders o
      ON o.account_id = a.id
GROUP BY a.name
ORDER BY ord_count DESC
LIMIT 1
--- Which channel was most frequently used by most accounts?
SELECT w
.channel, COUNT
(a.*) AS max
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
GROUP BY w.channel
ORDER BY max DESC
LIMIT 1
-- DATES
--- DATES are stored in a YYYY-MM-DD format in databases
--- In order to group by date we set the time to 00:00:00 in order to group for that day(eg. 2017-01-12 00:00:00) we can do this with DATE_TRUNC function
--- DATE_PART for 'dow' day of the week

--- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
SELECT SUM(total_amt_usd) as total, DATE_TRUNC('year', occurred_at) AS year
FROM orders
GROUP BY year
--- Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
SELECT SUM(total_amt_usd) as total, DATE_PART('month', occurred_at) AS year
FROM orders
GROUP BY year
--- Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?
SELECT SUM(total) as total, DATE_TRUNC('year', occurred_at) AS year
FROM orders
GROUP BY year
--- Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?
SELECT SUM(total) as total, DATE_PART('month', occurred_at) AS year
FROM orders
GROUP BY year
--- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
SELECT SUM(o.gloss_qty) as total, DATE_TRUNC('month', o.occurred_at) AS month
FROM orders o
      JOIN accounts a
      ON o.account_id = a.id
WHERE a.name = 'Walmart'
GROUP BY month
ORDER BY total DESC
-- CASE
--- WHEN, THEN, END, ELSE
--- example:
SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
--- Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
SELECT id, total,
      CASE WHEN total_amt_usd > 3000 THEN 'large'
ELSE 'Small' END AS level
FROM orders
ORDER BY total_amt_usd DESC
--- Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
SELECT CASE WHEN total >= 2000 
THEN 'At least 2000'
WHEN total >= 1000 AND total < 2000 
THEN 'Between 1000 and 2000' 
ELSE  'Less than 1000'
END AS total_orders, COUNT(*)
FROM orders
GROUP BY total_orders
--- We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
SELECT a.name, SUM(o.standard_amt_usd) AS total,
      CASE WHEN SUM(o.total_amt_usd) > 200000 
THEN 1
WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd) <= 200000 THEN 2
ELSE 3 END AS level
FROM orders o
      JOIN accounts a
      ON o.account_id = a.id
GROUP BY a.name
ORDER BY total DESC
--- We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.
SELECT a.name, SUM(o.standard_amt_usd) AS total,
      CASE WHEN SUM(o.total_amt_usd) > 200000 
THEN 1
WHEN SUM(o.total_amt_usd) > 100000 AND SUM(o.total_amt_usd) <= 200000 THEN 2
ELSE 3 END AS level
FROM orders o
      JOIN accounts a
      ON o.account_id = a.id
WHERE DATE_TRUNC('year', o.occurred_at) > '2015-01-01' AND DATE_TRUNC('year', o.occurred_at)
< '2018-01-01'
GROUP BY a.name
ORDER BY total DESC
--- We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.
SELECT s.name, COUNT(o.*) as total_sales,
      CASE WHEN COUNT(o.*) > 200 THEN 'top'
ELSE 'not' END AS top_sales
FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON a.id = o.account_id
GROUP BY s.name
ORDER BY total_sales DESC;
--- The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table. You might see a few upset sales people by this criteria!
SELECT s.name, COUNT(*) AS count_sales,
      SUM(o.total_amt_usd) AS count_usd,
      CASE WHEN COUNT(*) > 200 OR
            SUM(o.total_amt_usd) > 750000
THEN 'top'
WHEN (COUNT(*) > 150 AND COUNT(*) < 200) OR
            SUM(o.total_amt_usd) > 500000
THEN 'middle'
ELSE 'low' END AS top_sales
FROM sales_reps s
      JOIN accounts a
      ON a.sales_rep_id = s.id
      JOIN orders o
      ON a.id = o.account_id
GROUP BY s.name
ORDER BY top_sales DESC;