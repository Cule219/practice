-- Advanced JOINS and Performance Tuning 
-- A full outer join returns unmatched records in each table with null values for the columns that came from the opposite table.

-- If you wanted to return unmatched rows only, which is useful for some cases of data assessment, you can isolate them by adding the following line to the end of the query(using FULL OUTER JOIN):
WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL

--- each account that does not have a sales rep and each sales rep that does not have an account (some of the columns in these returned rows will be empty)
SELECT a.name account, s.name sales_rep
FROM accounts a
FULL OUTER JOIN sales_reps s
ON a.sales_rep_id = s.id

-- JOINs with Comparison Operators
SELECT accounts.name as account_name,
       accounts.primary_poc as poc_name,
       sales_reps.name as sales_rep_name
  FROM accounts
  LEFT JOIN sales_reps
    ON accounts.sales_rep_id = sales_reps.id
   AND accounts.primary_poc < sales_reps.name
-- SELF-JOIN
--- self JOINs are used to get specific data from a table
SELECT o1.id AS o1_id,
       o1.account_id AS o1_account_id,
       o1.occurred_at AS o1_occurred_at,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at
  FROM orders o1
 LEFT JOIN orders o2
   ON o1.account_id = o2.account_id
  AND o2.occurred_at > o1.occurred_at
  AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at

-- UNION
--- The UNION operator is used to combine the result sets of 2 or more SELECT statements. It removes duplicate rows between the various SELECT statements.
--- Each SELECT statement within the UNION must have the same number of fields in the result sets with similar data types.
--- Typically, the use case for leveraging the UNION command in SQL is when a user wants to pull together distinct values of specified columns that are spread across multiple tables. For example, a chef wants to pull together the ingredients and respective aisle across three separate meals that are maintained in different tables. 
-- 
    -- Both tables must have the same number of columns.
    -- Those columns must have the same data types in the same order as the first table.
-- Using UNION ALL's results as a table
WITH web_events AS (
    SELECT * FROM demo.web_events
    UNION ALL
    SELECT * FROM demo.web_events2
)

SELECT channel,
    COUNT(*) AS seassions
    FROM web_events
    GROUP BY 1
    ORDER BY 2