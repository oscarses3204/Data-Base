/* COMP 3311: lab4Queries.sql */

-- Student id: 21171371
-- Name: Hunag Yeung Tai

/******************************************************************************/
/***    USE ONLY SQL CONSTRUCTS DISCUSSED IN THE LECTURES OR LABS SO FAR    ***/
/*** ---------------------------------------------------------------------- ***/
/***       Your queries will be tested by executing them against the        ***/
/***                            lab4db database.                            ***/
/***  If any query raises an SQL error or uses SQL constructs not discussed ***/
/***  in the lectures or labs, then your exercise mark will be at most 0.5. ***/
/******************************************************************************/

--------------------------------------------------------------------------------
/* Query 1: Find the minimum, maximum, average and median grade over all courses 
			truncated to two decimal places as well as the number of unique 
            students enrolled in all courses. */
-- <<< Place your query below this line as a single SQL statement >>>

select trunc(min(grade), 2), trunc(max(grade), 2), trunc(avg(grade), 2), trunc(median(grade), 2), count(distinct studentId) as numStudent
from EnrollsIn;

--------------------------------------------------------------------------------
/* Query 2: Find, for each academic unit that has students, the unit name and 
            the average cga of the students in the unit truncated to two decimal 
            places.
            Order the query result tuples by average cga descending. */
-- <<< Place your query below this line as a single SQL statement >>>

SELECT a.unitName,
       TRUNC(AVG(s.cga), 2) AS avg_cga
FROM Student s
JOIN AcademicUnit a ON s.unitId = a.unitId
GROUP BY a.unitId, a.unitName
ORDER BY TRUNC(AVG(s.cga), 2) DESC;

--------------------------------------------------------------------------------
/* Query 3: Find, for each course, the students who have the highest cga and 
			the students who have the lowest cga in the course. 
			Include in the query result tuples attributes course id, student 
			last and first name, academic unit name, grade and cga.
			Order the query result tuples first by course id ascending, then by 
			cga descending and then by grade descending. */
-- <<< Place your query below this line as a single SQL statement >>>

with enrolled as (
    select E.courseId, S.firstName, S.lastName, S.cga, E.grade, A.unitName
    from EnrollsIn E
    join Student S on E.studentId = S.studentId
    join AcademicUnit A on S.unitId = A.unitId
),
ranked as (
    select courseId, firstName, lastName, cga, grade, unitName,
           rank() over (partition by courseId order by cga desc) as rnk_max,
           rank() over (partition by courseId order by cga asc)  as rnk_min
    from enrolled
)
select courseId, lastName, firstName, unitName, grade, cga
from ranked
where rnk_max = 1 or rnk_min = 1
order by courseId asc, cga desc, grade desc;

--------------------------------------------------------------------------------
/* Query 4: Find, for students enrolled in the Department of Computer Science 
			and Engineering, the number of courses in which the student is 
			enrolled. 
			Include in the query result tuples attributes first name, last name 
			and the number of courses in which the student is enrolled.  
			Students not enrolled in any course should be included in the query 
			result and their number of enrolled courses should be shown as 0.
            Order the query result tuples first by the number of courses 
            descending and then by last name ascending. */
-- <<< Place your query below this line as a single SQL statement >>>

select S.firstName, S.lastName, count(E.courseId) as num_courses
from Student S
join AcademicUnit A on S.unitId = A.unitId
left join EnrollsIn E on S.studentId = E.studentId
where A.unitName = 'Department of Computer Science and Engineering'
group by S.studentId, S.firstName, S.lastName
order by num_courses desc, S.lastName asc;

--------------------------------------------------------------------------------

/* Query 5: Find the cga, first name, last name and email of the students who 
			have the lowest cga and also find the course name, course id and 
			grade of the courses, if any, in which the student has the lowest 
			course grade. 
            Order the result first by last name ascending and then by grade 
            descending. */
-- <<< Place your query below this line as a single SQL statement >>>

with min_cga as (
    select min(cga) as min_cga from Student
),
lowest_students as (
    select studentId, firstName, lastName, email, cga
    from Student, min_cga
    where cga = min_cga
),
student_min_grade as (
    select LS.studentId, min(E.grade) as min_grade
    from lowest_students LS
    left join EnrollsIn E on LS.studentId = E.studentId
    group by LS.studentId
)
select LS.cga, LS.firstName, LS.lastName, LS.email,
       C.courseName, C.courseId, E.grade
from lowest_students LS
left join student_min_grade SMG on LS.studentId = SMG.studentId
left join EnrollsIn E on LS.studentId = E.studentId and E.grade = SMG.min_grade
left join Course C on E.courseId = C.courseId
order by LS.lastName asc, E.grade desc;

--------------------------------------------------------------------------------
