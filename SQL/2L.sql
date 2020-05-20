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



-- 5.Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the smallest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01). 
SELECT r.name as region, a.name as account, (o.total_amt_usd/(o.total+0.01)) as unit_price 
FROM orders o
LEFT JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
LEFT JOIN region r
ON r.id = s.region_id
WHERE o.standard_qty > 100
AND o.poster_qty > 50
ORDER BY unit_price
-- 6.Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity exceeds 50. Your final table should have 3 columns: region name, account name, and unit price. Sort for the largest unit price first. In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01). 
SELECT r.name as region, a.name as account, (o.total_amt_usd/(o.total+0.01)) as unit_price 
FROM orders o
LEFT JOIN accounts a
ON a.id = o.account_id
JOIN sales_reps s
ON a.sales_rep_id = s.id
LEFT JOIN region r
ON r.id = s.region_id
WHERE o.standard_qty > 100
AND o.poster_qty > 50
ORDER BY unit_price DESC
-- 7.What are the different channels used by account id 1001? Your final table should have only 2 columns: account name and the different channels. You can try SELECT DISTINCT to narrow down the results to only the unique values.
SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
WHERE a.id = 1001SELECT o.occurred_at, a.name, o.total, o.total_amt_usd 
FROM orders o
LEFT JOIN accounts a
ON o.account_id = a.id
WHERE EXTRACT(YEAR FROM o.occurred_at) = '2015'
LEFT JOIN accounts a
ON o.account_id = a.id
WHERE EXTRACT(YEAR FROM o.occurred_at) = '2015'
