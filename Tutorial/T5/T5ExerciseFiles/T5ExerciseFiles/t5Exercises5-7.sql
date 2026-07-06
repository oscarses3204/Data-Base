/* COMP 3311 Tutorial 5: t5Exercises5-7.sql */

-- Student id: 21171371
-- Name: Huang Yeung Tai

/******************************************************************************/
/***            USE ONLY SQL CONSTRUCTS DISCUSSED IN THE COURSE             ***/
/***     Upload this completed script file to Canvas by 6 p.m. tomorrow.    ***/
/*** ---------------------------------------------------------------------- ***/
/***       Your queries will be tested by executing them against the        ***/
/***                            bankdb database.                            ***/
/***  If any query raises an SQL error or uses SQL constructs not discussed ***/
/***      in the course, then your exercise mark will be at most 0.5.       ***/
/******************************************************************************/

--------------------------------------------------------------------------------
/* Exercise 5: Find customers who have made deposits, but no withdrawals.
               Include in the query result tuples attribute customer name. 
               Order the query result tuples by name ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT DISTINCT c.cname
FROM Customer c
JOIN Deposit d ON c.customerId = d.customerId
WHERE c.customerId NOT IN (SELECT customerId FROM Withdrawal)
ORDER BY c.cname ;

--------------------------------------------------------------------------------
/* Exercise 6: Find shared accounts, that is, accounts for which more than one 
               customer has deposited and/or withdrawn money. Assume that all 
               customers of a shared account have made either deposits into or 
               withdrawals from the account.
               Include in the query result tuples attribute account id. 
               Order the query result tuples by account id ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT accountId
FROM (
    SELECT accountId, customerId FROM Deposit
    UNION
    SELECT accountId, customerId FROM Withdrawal
)
GROUP BY accountId
HAVING COUNT(DISTINCT customerId) > 1
ORDER BY accountId ASC;

--------------------------------------------------------------------------------
/* Exercise 7: An "interesting account" is an account from which the withdrawal 
               with the largest amount was made.
               Find accounts from which withdrawals have been made, excluding 
               the interesting accounts 
               Include in the query result tuples attribute account id. 
               Order the query result tuples by account id ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT DISTINCT accountId
FROM Withdrawal
WHERE accountId NOT IN (
    SELECT accountId
    FROM Withdrawal
    WHERE amount = (SELECT MAX(amount) FROM Withdrawal)
)
ORDER BY accountId ASC;

--------------------------------------------------------------------------------