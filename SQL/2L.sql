-- JOIN 
SELECT orders.standard_qty, orders.gloss_qty, 
       orders.poster_qty,  accounts.website, 
       accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id
-- LEFT JOIN includes all columns from SELECT table, RIGHT JOIN includes all columns from JOIN table, if we swap table order these are mutualy interchangable
-- because of this we rearely find RIGHT JOIN being used
-- LEFT OUTER JOIN or LEFT JOIN are the same 
-- if we want both the tables in full we use FULL OUTER JOIN or OUTER JOIN but this is very rare
SELECT r.name AS regName, s.name as selRName, a.name as accName
FROM sales_reps s
LEFT JOIN region r 
ON s.region_id = r.id
LEFT JOIN accounts a
ON a.sales_rep_id = s.id
WHERE s.name LIKE 'S%'
ORDER BY a.name


SELECT o.occurred_at, a.name, o.total, o.total_amt_usd 
FROM orders o
LEFT JOIN accounts a
ON o.account_id = a.id
WHERE EXTRACT(YEAR FROM o.occurred_at) = '2015'