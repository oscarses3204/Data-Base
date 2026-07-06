/* COMP 3311: Lab3Queries.sql */

-- Student id: 21171371
-- Name: Huang Yeung Tai

/******************************************************************************/
/***    USE ONLY SQL CONSTRUCTS DISCUSSED IN THE LECTURES OR LABS SO FAR    ***/
/*** ---------------------------------------------------------------------- ***/
/***       Your queries will be tested by executing them against the        ***/
/***                            lab3db database.                            ***/
/***  If any query raises an SQL error or uses SQL constructs not discussed ***/
/***  in the lectures or labs, then your exercise mark will be at most 0.5. ***/
/******************************************************************************/

--------------------------------------------------------------------------------
/* Query 1: Find students whose last name contains the lowercase letter 'u' as 
            the 2nd character.
            Include in the query result tuples attributes student name (first 
            followed by last).
            Order the query result tuples by last name ascending. */
-- <<< Place your query below this line as a single SQL statement >>>
SELECT firstName || ' ' || lastName AS "Student Name"
FROM Student
WHERE lastName LIKE '_u%'
ORDER BY lastName ASC;


--------------------------------------------------------------------------------
/* Query 2:	Find students whose first and last names contain a double lowercase 
            letter (e.g., 'ee', 'mm', etc.). 
            Include in the query result tuples attributes student name (first 
            followed by last).
            Order the query result tuples by last name ascending. */
-- <<< Place your query below this line as a single SQL statement >>>
SELECT firstName || ' ' || lastName AS "Student Name"
FROM Student
WHERE REGEXP_LIKE(firstName, '([a-z])\1')
  AND REGEXP_LIKE(lastName, '([a-z])\1')
ORDER BY lastName ASC;


--------------------------------------------------------------------------------
/* Query 3:	Find students who are in neither the Department of Computer Science 
            and Engineering (COMP) nor in the Department of Management (MGMT) 
            and whose cga is less than 3.0. 
            Include in the query result tuples attributes student id as "Id", 
            firstName as "First name", lastName as "Last name", email as "Email" 
            and cga as "CGA".
			Order the query result tuples from highest to lowest cga. */
-- <<< Place your query below this line as a single SQL statement >>>
SELECT studentId       AS "Id",
       firstName       AS "First name",
       lastName        AS "Last name",
       email           AS "Email",
       cga             AS "CGA"
FROM Student
WHERE unitId NOT IN ('COMP', 'MGMT')
  AND cga < 3.0
ORDER BY cga DESC;


--------------------------------------------------------------------------------
/* Query 4: Find any three students who have the highest cgas. 
            Include in the query result tuples attributes student name (i.e., 
            first followed by name), cga and academic unit name. */
-- <<< Place your query below this line as a single SQL statement >>>
SELECT studentName AS "Student Name",
       cga        AS "CGA",
       unitName   AS "Unit Name"
FROM (
  SELECT s.firstName || ' ' || s.lastName AS studentName,
         s.cga,
         a.unitName
  FROM Student s
  JOIN AcademicUnit a ON s.unitId = a.unitId
  WHERE s.cga IS NOT NULL
  ORDER BY s.cga DESC
)
FETCH FIRST 3 ROWS ONLY;


--------------------------------------------------------------------------------
/* Query 5: Find students who are in either the Department of Computer Science 
            and Engineering (COMP) or the Department of Management (MGMT) and 
            whose cga is in the range 3.0 to 4.0.
            Include in the query result tuples attributes student id, student 
            name (first followed by last), cga and academic unit name.
            Order the query result tuples first by academic unit name ascending, 
            then by cga descending and finally by last name ascending. */
-- <<< Place your query below this line as a single SQL statement >>>
SELECT s.studentId                         AS "Student ID",
       s.firstName || ' ' || s.lastName    AS "Student Name",
       s.cga                               AS "CGA",
       a.unitName                          AS "Unit Name"
FROM Student s
JOIN AcademicUnit a ON s.unitId = a.unitId
WHERE s.unitId IN ('COMP', 'MGMT')
  AND s.cga BETWEEN 3.0 AND 4.0
ORDER BY a.unitName ASC,
         s.cga DESC,
         s.lastName ASC;


--------------------------------------------------------------------------------