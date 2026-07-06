/* COMP 3311: L10Exercises6-8.sql */

-- Student id: 21171371
-- Name: Hunag Yeung Tai

/******************************************************************************/
/***     USE ONLY SQL CONSTRUCTS DISCUSSED IN THIS AND PREVIOUS LECTURES.   ***/
/***   MOREOVER, FOR EACH QUERY IN THIS EXERCISE YOU MUST USE ONE OR MORE   ***/
/***    OF THE ANALYTIC FUNCTIONS DISCUSSED IN THIS LECTURE AND YOU MUST    ***/
/***         NOT CREATE ANY TEMPORARY RELATION USING A WITH CLAUSE.         ***/
/***     NO MARKS WILL BE GIVEN IF THESE REQUIREMENTS ARE NOT FOLLOWED.     ***/
/***     Upload this completed script file to Canvas by 6 p.m. tomorrow.    ***/
/*** ---------------------------------------------------------------------- ***/
/***       Your queries will be tested by executing them against the        ***/
/***                         bookstoredb database.                          ***/
/***  If any query raises an SQL error or uses SQL constructs not discussed ***/
/***      in the course, then your exercise mark will be at most 0.5.       ***/
/******************************************************************************/

--------------------------------------------------------------------------------
/* Exercise 6:  Find the book orders for each subject.
                Include in the query result tuples attributes subject, total 
                quantity of books sold on the subject and a comma-separated list 
                in ascending order of the order ids.
                Order the query result tuples by subject ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>
SELECT 
    B.subject,
    SUM(OD.quantity) AS totalQuantity,
    LISTAGG(DISTINCT OD.orderId, ', ') WITHIN GROUP (ORDER BY OD.orderId) AS orders
FROM Book B
JOIN OrderDetails OD ON B.bookId = OD.bookId
GROUP BY B.subject
ORDER BY B.subject;

--------------------------------------------------------------------------------
/* Exercise 7:  Find each book's rank with respect to the total number of books 
                sold.
                Include in the query result tuples attributes title, author name 
                (first followed by last) and book rank.
                Order the query result tuples first by rank ascending and then 
                by title ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>

WITH BookSales AS (
    SELECT bookId, SUM(quantity) AS total_sold
    FROM OrderDetails
    GROUP BY bookId
)
SELECT 
    B.title,
    A.firstName || ' ' || A.lastName AS author_name,
    RANK() OVER (ORDER BY COALESCE(BS.total_sold, 0) DESC) AS book_rank
FROM Book B
JOIN Author A ON B.authorId = A.authorId
LEFT JOIN BookSales BS ON B.bookId = BS.bookId
ORDER BY book_rank, B.title;

--------------------------------------------------------------------------------
/* Exercise 8:  Find the average total number of business books sold for each 
                year as well as for all previous years truncated to one decimal 
                place. 
                Order the query result tuples by order year ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>

WITH BusinessYearSales AS (
    SELECT 
        BO.orderYear,
        SUM(OD.quantity) AS total_qty
    FROM BookOrder BO
    JOIN OrderDetails OD ON BO.orderId = OD.orderId
    JOIN Book B ON OD.bookId = B.bookId
    WHERE B.subject = 'Business'
    GROUP BY BO.orderYear
)
SELECT 
    orderYear,
    TRUNC(AVG(total_qty) OVER (ORDER BY orderYear ROWS UNBOUNDED PRECEDING), 1) AS avg_total
FROM BusinessYearSales
ORDER BY orderYear;

--------------------------------------------------------------------------------
