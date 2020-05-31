-- DATA CLEANING
--- LEFT and RIGHT used to select substrings from LEFT and RIGHT
--- LENGTH is used to get the length of the string and it can be used in conjuction with L and R
--- In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.
SELECT DISTINCT RIGHT(website, 3)
FROM accounts
--- There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number). 
SELECT COUNT(*), LEFT(name, 1) AS first
FROM accounts
GROUP BY 2
ORDER BY 1 DESC
--- Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 1 ELSE 0 END AS num, 
         CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9') 
                       THEN 0 ELSE 1 END AS letter
      FROM accounts) t1;
--- Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else? 
SELECT
(SELECT COUNT(*) 
FROM accounts
WHERE LEFT(LOWER(name),1) NOT IN ('a','e','i','o','u'))
* 100
/
(SELECT COUNT(*) FROM accounts)
AS percent

--- POSITION, STRPOS & SUBSTR
--- Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc. 
SELECT primary_poc, LEFT(primary_poc, POSITION(' ' IN primary_poc)) as first, RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) as last
FROM accounts
--- Now see if you can do the same thing for every rep name in the sales_reps table. Again provide first and last name columns.
SELECT name, LEFT(name, POSITION(' ' IN name)) as first, RIGHT(name, LENGTH(name) - POSITION(' ' IN name)) as last
FROM sales_reps

--- CONCAT
--- Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.
SELECT first || '.' || last || '@' || name || '.com'
AS email
FROM
(SELECT primary_poc, name, LEFT(primary_poc, POSITION(' ' IN primary_poc)) as first, RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) as last
FROM accounts) t1
--- You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1. Some helpful documentation is here.
SELECT first || '.' || last || '@' || regexp_replace(name, ' ', '', 'g') || '.com'
AS email
FROM
(SELECT primary_poc, name, LEFT(primary_poc, POSITION(' ' IN primary_poc)) as first, RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) as last
FROM accounts) t1
--- We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces. 
SELECT LEFT(LOWER(first), 1) || 
RIGHT(LOWER(first), 1) ||
LEFT(LOWER(last), 1) ||
RIGHT(LOWER(last), 1) ||
LENGTH(first) ||
LENGTH(last) ||
regexp_replace(UPPER(name), ' ', '', 'g')
AS password
FROM
(SELECT primary_poc, name, LEFT(primary_poc, POSITION(' ' IN primary_poc)) as first, RIGHT(primary_poc, LENGTH(primary_poc) - POSITION(' ' IN primary_poc)) as last
FROM accounts) t1

--- CAST

SELECT 
LEFT(date, STRPOS(date, ' ')) AS date_val,
RIGHT(date, LENGTH(date) - POSITION(' ' in date)) AS time,
TO_DATE(date, 'MM/DD/YYYY') 
AS correct
FROM sf_crime_data

--- COALESCE 
--- Used to replace NULL values, returns the first NON-NULL value passed for each row

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, 
a.primary_poc, a.sales_rep_id, COALESCE(o.account_id, a.id) account_id, 
o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, COALESCE(o.gloss_qty,0) gloss_qty, 
COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, 
COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, 
COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE o.total IS NULL;

SELECT COALESCE(a.id, a.id) filled_id, a.name, a.website, a.lat, a.long, a.primary_poc, a.sales_rep_id, 
COALESCE(o.account_id, a.id) account_id, o.occurred_at, COALESCE(o.standard_qty, 0) standard_qty, 
COALESCE(o.gloss_qty,0) gloss_qty, COALESCE(o.poster_qty,0) poster_qty, COALESCE(o.total,0) total, 
COALESCE(o.standard_amt_usd,0) standard_amt_usd, COALESCE(o.gloss_amt_usd,0) gloss_amt_usd, 
COALESCE(o.poster_amt_usd,0) poster_amt_usd, COALESCE(o.total_amt_usd,0) total_amt_usd
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id;
