SELECT occurred_at, account_id, channel 
FROM web_events
ORDER BY occurred_at DESC, id
LIMIT 15;

/* 
    DESC is added after the column name in ORDER BY statement to change from ascending order(which is default)
    if two values are the same than we order by id
    Limit always comes last in the query

*/