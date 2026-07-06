/* COMP 3311: L10Exercises1-5.sql */

--------------------------------------------------------------------------------
/* Exercise 1:  Find each customer's rank with respect to their total number 
                of orders.
                Include in the query result tuples attributes first name, last 
                name and customer rank.
                Order the query result tuples first by rank ascending and then 
                by last name ascending. */
-- QUERY RESULT:
-- (Harry	Lee	1)
-- (Ron	    Lee	2)
-- (Andrew	Chu	3)
-- (Carl	Ip	3)
-- (Sam     Lam 3)
-- (Lily    Lee 4)
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT firstName, lastName,
    DENSE_RANK() over (order by COUNT(*) DESC) AS customerRank
FROM BookOrder NATURAL JOIN Customer
GROUP BY firstName, lastName, customerId
ORDER BY customerRank, lastName;

--------------------------------------------------------------------------------
/* Exercise 2:  Find the orders of each customer. 
                Include in the query result tuples attributes last name, total 
                quantity of the customer's orders and a comma-separated list in 
                ascending order of the customer's order ids.
                Order the query result tuples by first by total quantity 
                descending and then by last name ascending. */
-- QUERY RESULT:
-- (Chu	711	8, 9, 22)
-- (Lam	711	6, 15, 19)
-- (Lee	711 1, 2, 3, 4, 5, 12, 17, 18, 20, 23)
-- (Ip	584	11, 13, 24)
-- (Lee	584	7, 10, 14, 16, 21)
-- (Lee  50 25)
-- <<< Construct your query below this line as a single SQL statement >>>



--------------------------------------------------------------------------------
/* Exercise 3:  Find the average total number of orders for each year as well 
                as the previous two years rounded to one decimal place. */
-- QUERY RESULT:
-- (2022	3)
-- (2023	4.5)
-- (2024	5.3)
-- (2025    7.3)
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT orderYear, 
    ROUND(AVG(yearOrderTotal) OVER (ORDER BY orderYear RANGE 2 PRECEDING), 1) AS avgYearOrderTotal
FROM(SELECT orderYear, COUNT(*) AS yearOrderTotal
FROM BookOrder BO
GROUP BY BO.OrderYear);

--------------------------------------------------------------------------------
/* Exercise 4:  Find the authors who sold the three highest total number of 
                books.
                Include in the query result tuples attributes author name (first 
                followed by last) and a comma-separated list in ascending order 
                of the subjects on which they wrote their books.
                Order the query result tuples by total books sold descending. */
-- QUERY RESULT:
-- (Pied Piper	        Art, Business	        1)
-- (Dan Brown	        Art, Business, Fiction	2)
-- (Michael Crichton	Fiction	                2)
-- (Donald Green	    Business	            3)
-- <<< Construct your query below this line as a single SQL statement >>>


SELECT firstName || ' ' || lastName AS author, subjects, salesRank
FROM (SELECT firstName, lastName, listagg(DISTINCT subject, ', ' ) WITHIN GROUP (ORDER BY subject) AS subjects,
    DENSE_RANK() OVER (ORDER BY SUM(quantity) DESC NULLS LAST) AS salesRank
    FROM Author NATURAL JOIN Book NATURAL LEFT OUTER JOIN OrderDetails
    GROUP BY authorId, firstName, lastName)
WHERE salesRank <= 3
ORDER BY salesRank;



--------------------------------------------------------------------------------
/* Exercise 5:  For all authors who wrote books on at least three subjects, 
                increase the price of all their books by 5%. */
-- <<< Construct your query below this line as a single SQL statement >>>

UPDATE Book
SET price = 100.00
WHERE authorId IN (SELECT authorId 
                FROM Book 
                GROUP BY authorId
                HAVING count(DISTINCT subject) >= 3);
SELECT * FROM BOOK;

--------------------------------------------------------------------------------
