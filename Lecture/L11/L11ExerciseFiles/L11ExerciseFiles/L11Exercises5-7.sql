/* COMP 3311: L11Exercises5-7.sql */

-- Student id: 21171371
-- Name: Huang Yeung Tai

/******************************************************************************/
/***     USE ONLY SQL CONSTRUCTS DISCUSSED IN THIS AND PREVIOUS LECTURES    ***/
/***     Upload this completed script file to Canvas by 6 p.m. tomorrow.    ***/
/*** ---------------------------------------------------------------------- ***/
/***       Your queries will be tested by executing them against the        ***/
/***                         bookstoredb database.                          ***/
/***  If any query raises an SQL error or uses SQL constructs not discussed ***/
/***      in the course, then your exercise mark will be at most 0.5.       ***/
/******************************************************************************/

--------------------------------------------------------------------------------
/* Exercise 5:  Find the authors who wrote books on exactly three different 
                subjects. 
                Include in the query result tuples attributes author name (first 
                followed by last). 
                Order the query result tuples by last name ascending.
DO NOT use subqueries. DO NOT create any derived/temporary relations. */
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT a.firstName || ' ' || a.lastName AS author_name
FROM Author a
JOIN Book b ON a.authorId = b.authorId
GROUP BY a.authorId, a.firstName, a.lastName
HAVING COUNT(DISTINCT b.subject) = 3
ORDER BY a.lastName;


--------------------------------------------------------------------------------
/* Exercise 6:  Find the customers who placed at least three orders in 2025. 
                Include in the query result tuples attributes last name and 
                number of orders.
                DO NOT use subqueries. DO NOT create derived/temporary relations. */
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT c.lastName, COUNT(o.orderId) AS number_of_orders
FROM Customer c
JOIN BookOrder o ON c.customerId = o.customerId
WHERE o.orderYear = 2025
GROUP BY c.customerId, c.lastName
HAVING COUNT(o.orderId) >= 3;

--------------------------------------------------------------------------------
/* Exercise 7:  Find customers who ordered the first and second highest total 
                number of books. 
                Include in the query result tuples attributes customer name (first 
                followed by last), total number of books ordered, and overall 
                total number of books ordered by all customers. 
                Order the query result tuples first by total number of books a 
                customer ordered descending and then by last name ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>

WITH customer_totals AS (
    SELECT c.customerId, c.firstName, c.lastName,
           SUM(od.quantity) AS total_books
    FROM Customer c
    JOIN BookOrder bo ON c.customerId = bo.customerId
    JOIN OrderDetails od ON bo.orderId = od.orderId
    GROUP BY c.customerId, c.firstName, c.lastName
),
ranked AS (
    SELECT customerId, firstName, lastName, total_books,
           DENSE_RANK() OVER (ORDER BY total_books DESC) AS rnk
    FROM customer_totals
),
overall_total AS (
    SELECT SUM(total_books) AS overall_total FROM customer_totals
)
SELECT r.firstName || ' ' || r.lastName AS customer_name,
       r.total_books,
       (SELECT overall_total FROM overall_total) AS overall_total_books
FROM ranked r
WHERE r.rnk IN (1, 2)
ORDER BY r.total_books DESC, r.lastName ASC;

--------------------------------------------------------------------------------