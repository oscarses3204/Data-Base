/* COMP 3311: lab5Queries.sql */

-- Student id: 21171371
-- Name: Hunag Yeung Tai

/******************************************************************************/
/***            USE ONLY SQL CONSTRUCTS DISCUSSED IN THE COURSE             ***/
/***   MOREOVER, FOR EACH QUERY IN THIS EXERCISE YOU MUST USE ONE OR MORE   ***/
/***  OF THE ANALYTIC FUNCTIONS DISCUSSED IN THE NOTES FOR THIS LAB AND YOU ***/
/***       MUST NOT CREATE ANY TEMPORARY RELATION USING A WITH CLAUSE.      ***/
/***     NO MARKS WILL BE GIVEN IF THESE REQUIREMENTS ARE NOT FOLLOWED.     ***/
/*** ---------------------------------------------------------------------- ***/
/***       Your queries will be tested by executing them against the        ***/
/***                            lab5db database.                            ***/
/***  If any query raises an SQL error or uses SQL constructs not discussed ***/
/***  in the lectures or labs, then your exercise mark will be at most 0.5. ***/
/******************************************************************************/

--------------------------------------------------------------------------------
/* Query 1: Find the rank of the students in the Department of Management 
            (MGMT) with respect to their cga.
            Include in the query result tuples attributes student name 
            (formatted as: last, first), their cga and rank.
            Order the query result tuples from highest to lowest rank. */
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT lastName || ', ' || firstName AS student_name,
       cga,
       RANK() OVER (ORDER BY cga DESC) AS rank
FROM Student
WHERE unitId = 'MGMT' AND CGA IS NOT NULL
ORDER BY rank;

--------------------------------------------------------------------------------
/* Query 2: Find, based on their average grade, the quartile into which each 
            student in the Department of Computer Science and Engineering (COMP) 
            falls.
            Include in the query result tuples attributes student name 
            (formatted as: last, first), average grade and quartile into 
            which the student falls.
            Order the result first by quartile (highest to lowest average grade)
            and then by average grade descending. */
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT lastName || ', ' || firstName AS student_name,
       AVG(grade) AS average_grade,
       NTILE(4) OVER (ORDER BY AVG(grade) DESC) AS quartile
FROM Student s
JOIN EnrollsIn e ON s.studentId = e.studentId
WHERE s.unitId = 'COMP'
GROUP BY s.studentId, s.lastName, s.firstName
ORDER BY quartile, average_grade DESC;

--------------------------------------------------------------------------------
/* Query 3: Find the enrolled courses for each student in the Department of 
			Computer Science and Engineering (COMP). 
            Include in the query result tuples attributes student name 
            (formatted as: last, first), courses, which is a comma-separated 
            list in ascending order of the student's course ids, and total 
            credits, which is the student's total course credits.
            Order the query result tuples first by total credits descending and 
            then by last name ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>

SELECT s.lastName || ', ' || s.firstName AS student_name,
       LISTAGG(e.courseId, ', ') WITHIN GROUP (ORDER BY e.courseId) AS courses,
       SUM(c.credits) AS total_credits
FROM Student s
JOIN EnrollsIn e ON s.studentId = e.studentId
JOIN Course c ON e.courseId = c.courseId
WHERE s.unitId = 'COMP'
GROUP BY s.studentId, s.lastName, s.firstName
ORDER BY total_credits DESC, s.lastName ASC;

--------------------------------------------------------------------------------
/* Query 4: Find students in HUMA 1020 whose grade is above the course average 
            grade. 
            Include in the query result tuples attributes student name 
            (formatted as: last, first), unit id, grade, course average grade 
            truncated to two decimal places and course median grade truncated to 
            two decimal places.
            Order the query result tuples by grade descending. */
-- <<< Construct your query below this line as a single SQL statement >>>

WITH course_stats AS (
    SELECT AVG(grade) AS avg_grade,
           MEDIAN(grade) AS median_grade
    FROM EnrollsIn
    WHERE courseId = 'HUMA 1020'
)
SELECT s.lastName || ', ' || s.firstName AS student_name,
       s.unitId,
       e.grade,
       TRUNC(cs.avg_grade, 2) AS course_avg_grade,
       TRUNC(cs.median_grade, 2) AS course_median_grade
FROM Student s
JOIN EnrollsIn e ON s.studentId = e.studentId
CROSS JOIN course_stats cs
WHERE e.courseId = 'HUMA 1020'
  AND e.grade > cs.avg_grade
ORDER BY e.grade DESC;

--------------------------------------------------------------------------------
/* Query 5: Find the students in each course who have the three highest ranks 
			with respect to their course grade. 
			Include in the query result tuples attributes course id, student name 
			(first followed by last), unit id, grade, average grade truncated to 
			one decimal place and course rank.
            Order the query result tuples first by course id and then by course 
            rank. */
-- <<< Construct your query below this line as a single SQL statement >>>

WITH course_ranks AS (
    SELECT courseId,
           studentId,
           grade,
           RANK() OVER (PARTITION BY courseId ORDER BY grade DESC) AS rnk
    FROM EnrollsIn
),
course_avg AS (
    SELECT courseId,
           TRUNC(AVG(grade), 1) AS avg_grade
    FROM EnrollsIn
    GROUP BY courseId
)
SELECT cr.courseId,
       s.firstName || ' ' || s.lastName AS student_name,
       s.unitId,
       cr.grade,
       ca.avg_grade,
       cr.rnk AS course_rank
FROM course_ranks cr
JOIN Student s ON cr.studentId = s.studentId
JOIN course_avg ca ON cr.courseId = ca.courseId
WHERE cr.rnk <= 3
ORDER BY cr.courseId, cr.rnk;

--------------------------------------------------------------------------------
