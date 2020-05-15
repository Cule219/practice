SELECT * 
FROM orders
WHERE gloss_amt_usd > 1000
ORDER BY occurred_at DESC, id
LIMIT 20;
/* 
    DESC is added after the column name in ORDER BY statement to change from ascending order(which is default)
    if two values are the same than we order by id
    Limit always comes last in the query
*/

-- derived column example
SELECT id, account_id, standard_amt_usd / standard_qty AS unit_price
FROM orders
LIMIT 10;


-- Logical Operators LIKE, IN, NOT, AND & BETWEEN, OR

--- LIKE uses wildcards to match the strings
---- % matches any number of chracters
SELECT * 
FROM accounts
WHERE name LIKE 'C%';
--- IN uses an 'array' to match values
SELECT * 
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');
--- NOT is a negation it can preceed LIKE, IN...
SELECT * 
FROM accounts
WHERE name NOT IN ('Walmart', 'Target', 'Nordstrom');
--- AND & BETWEEN
SELECT * 
FROM web_events
WHERE channel IN ('organic', 'adwords')
AND occurred_at 
BETWEEN '2016-01-01'
AND '2017-01-01'
ORDER BY occurred_at;
---- BETWEEN includes both values mentioned in the query
SELECT *
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29
ORDER BY gloss_qty;
--- OR
SELECT * FROM orders
WHERE standard_qty = 0
AND (gloss_qty > 1000 OR poster_qty > 1000);
---
SELECT *
FROM accounts
WHERE (name LIKE 'C%' OR name LIKE 'W%') 
    AND ((primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%') 
    AND primary_poc NOT LIKE '%eana%');

