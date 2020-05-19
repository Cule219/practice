-- JOIN 
SELECT orders.standard_qty, orders.gloss_qty, 
       orders.poster_qty,  accounts.website, 
       accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id

SELECT DISTINCT a.name, w.channel
FROM accounts a
JOIN web_events w
ON w.account_id = a.id
WHERE a.id = 1001