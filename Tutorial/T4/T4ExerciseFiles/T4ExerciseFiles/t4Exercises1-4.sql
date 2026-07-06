/* COMP 3311 Tutorial 4: t4Exercises.sql */

--------------------------------------------------------------------------------
/* Exercise 1: Find persons who earn more than $100,000 and live in Hong Kong. 
               Include in the query result tuples attribute person name. */
-- QUERY RESULT: (Fred Flintstone)
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT personName
FROM Person NATURAL JOIN Works
WHERE city = 'Hong Kong' AND salary > 100000;

--------------------------------------------------------------------------------
/* Exercise 2: Find persons who either earn less than $50,000 or more than 
               $100,000 and live in Hong Kong. 
               Include in the query result tuples attributes person id and name. */
-- QUERY RESULT: (2 Fred Flintstone)
-- <<< Construct your query below this line as a single SQL statement >>>
SELECT personId, personName
FROM Person NATURAL JOIN Works
WHERE city = 'Hong Kong' AND (salary < 50000 OR salary > 100000 );

--------------------------------------------------------------------------------
/* Exercise 3: Find persons who are not managers. 
			   Include in the query result tuples attributes person id and name. 
			   Order the query result tuples by name ascending. */
-- QUERY RESULT: (3 Amelia Earhart) (5 Conrad Black) (6 Larry Lazzy) (4 Luke Skywalker)
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT personId, personName
FROM Person
WHERE Person.personId NOT IN (SELECT managerPersonId FROM Manages);


--------------------------------------------------------------------------------
/* Exercise 4: Find persons who work for Alibaba and who live in the city where 
               Alibaba is located. 
               Include in the query result tuples attribute person name. */
-- QUERY RESULT: (Jody Foster)
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT personName
FROM Person NATURAL JOIN Works NATURAL JOIN Company
WHERE companyName = 'Alibaba';

--------------------------------------------------------------------------------
