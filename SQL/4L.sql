-- SUBQUERIES
--- 
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
        channel, COUNT(*) as events
    FROM web_events
    GROUP BY 1,2) sub
GROUP BY channel
ORDER BY 2 DESC;