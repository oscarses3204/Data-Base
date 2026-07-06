/* COMP 3311 Tutorial 4: t4Exercises5-7.sql */

-- Student id: 21171371
-- Name: Huang Yeung Tai

/******************************************************************************/
/***         USE ONLY SQL CONSTRUCTS DISCUSSED SO FAR IN THE COURSE         ***/
/***          Upload this script file to Canvas by 6 p.m. tomorrow.         ***/
/*** ---------------------------------------------------------------------- ***/
/***       Your queries will be tested by executing them against the        ***/
/***                         employmentdb database.                         ***/
/*** If any query raises an SQL error or uses SQL constructs not discussed  ***/
/***   so far in the course, then your exercise mark will be at most 0.5.   ***/
/******************************************************************************/

--------------------------------------------------------------------------------
/* Exercise 5: Find persons who live in a city where none of the companies for 
               which they work is located.
               Include in the query result tuples attributes person name and 
               city.
			   Order the query result tuples by person name ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT DISTINCT personName, city
FROM Person NATURAL JOIN(SELECT personId, city FROM Person
MINUS
SELECT Person.personId, Person.city FROM Person, Company WHERE Person.city = Company.city)
ORDER BY personName;

--------------------------------------------------------------------------------
/* Exercise 6: Find persons who work in at least one company and who live in a 
               city where one of the companies they work for is located. 
			   Include in the query result tuples attribute person name. 
			   Order the query result tuples by person name ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT DISTINCT personName
FROM Person NATURAL JOIN Works NATURAL JOIN Company
ORDER BY personName;

--------------------------------------------------------------------------------
/* Exercise 7: Find persons who work for more than one company. 
			   Include in the query result tuples attributes person name and city. 
               Order the query result tuples by person name ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT DISTINCT p.personName, p.city
FROM Person p
JOIN Works w1 ON p.personId = w1.personId
JOIN Works w2 ON p.personId = w2.personId
              AND w1.companyName <> w2.companyName
ORDER BY p.personName;
--------------------------------------------------------------------------------