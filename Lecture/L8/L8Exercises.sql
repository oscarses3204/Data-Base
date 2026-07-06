/* COMP 3311: L8Exercises */

-- Student id: 21171371 
-- Name: Huang Yeung Tai

/******************************************************************************/
/***     USE ONLY SQL CONSTRUCTS SPECIFICALLY DISCUSSED IN THIS LECTURE     ***/
/*** ---------------------------------------------------------------------- ***/
/***       Your queries will be tested by executing them against the        ***/
/***                      boatReservationsdb database.                      ***/
/***  If any query raises an SQL error or uses SQL constructs not discussed ***/
/***     in this lecture, then your exercise mark will be at most 0.5.      ***/
/******************************************************************************/

--------------------------------------------------------------------------------
/* Exercise 1:  Find the sailors who have a rating of 8 or greater and are 30 
                years old or younger.
                Include in the query result tuples attributes sailor name, age 
                and rating. */
-- EXPECTED RESULT: (Andy, 25, 8) (Rachael, 17, 10) (Chris, 30, 10)
-- <<< Construct your query below this line as a single SQL statement >>>
Select sName, age, rating
from Sailor
where rating >= 8 and age <= 30;


--------------------------------------------------------------------------------
/* Exercise 2:	Find the sailors who have reserved boat 103.
                Include in the query result tuples attribute sailor name. */
--  EXPECTED RESULT: (Dustin) (Lucy) (Horatio)
-- <<< Construct your query below this line as a single SQL statement >>>

Select sName 
from Sailor, Reserves
where Sailor.sailorId=Reserves.saildorId
    and boatid=103;

--------------------------------------------------------------------------------
/* Exercise 3:  Find the sailors who have reserved either boat 101 or boat 103.
                Include in the query result tuples attributes sailor id and name. */
-- EXPECTED RESULT: (22, Dustin) (31, Lucy) (64, Horatio) (74, Horatio)
-- <<< Construct your query below this line as a single SQL statement >>>

Select unique sailorid, sName 
from Sailor natural join Reserves
where boatId=101 or boatId=103;

--------------------------------------------------------------------------------
/* Exercise 4a): Find the sailors who have reserved both boat 101 and boat 103.
                 Include in the query result tuples attribute sailor name. 
                 (USE INTERSECT) */
-- EXPECTED RESULT: (Dustin)
-- <<< Construct your query below this line as a single SQL statement >>>
SELECT sName
FROM Sailor
WHERE sailorId IN (
    SELECT sailorId FROM Reserves WHERE boatId = 101
    INTERSECT
    SELECT sailorId FROM Reserves WHERE boatId = 103
);



--------------------------------------------------------------------------------
/* Exercise 4b): Find the sailors who have reserved both boat 101 and boat 103.
                 Include in the query result tuples attribute sailor name. 
                 (USE JOIN). 
                 Hint: You need to use correlation names. */
-- EXPECTED RESULT: (Dustin)
-- <<< Construct your query below this line as a single SQL statement >>>
SELECT DISTINCT s.sName
FROM Sailor s
JOIN Reserves r1 ON s.sailorId = r1.sailorId AND r1.boatId = 101
JOIN Reserves r2 ON s.sailorId = r2.sailorId AND r2.boatId = 103;


--------------------------------------------------------------------------------

/******************************************************************************/
/*                EXERCISES 5, 6 AND 7 ARE HOMEWORK EXERCISES                 */
/*   Upload your solution for these exercises to Canvas by 6 p.m. tomorrow.   */
/*                       UPLOAD THIS ENTIRE SCRIPT FILE                       */
/******************************************************************************/

--------------------------------------------------------------------------------
/* Exercise 5:  Find sailors who have never reserved a red boat.
                Include in the query result tuples attributes sailor id and name.
                Order the query result tuples by sailor id ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>
SELECT sailorId, sName
FROM Sailor s
WHERE s.sailorId NOT IN(
    SELECT r.sailorId
    FROM Reserves r
    JOIN Boat b ON r.boatId = b.boatId
    WHERE r.sailorId = s.sailorId AND b.color = 'red'
)
ORDER BY sailorId ASC;


--------------------------------------------------------------------------------
/* Exercise 6:  Find any three sailors who are 30 years or older, have reserved 
                a boat and have the highest rating among sailors 30 years or 
                older.
                Include in the query result tuples attributes sailor name and 
                rating. 
                Order the query result tuples by rating descending. */
-- <<< Construct your query below this line as a single SQL statement >>>
SELECT sName, rating
FROM (
    SELECT DISTINCT s.sName, s.rating
    FROM Sailor s
    JOIN Reserves r ON s.sailorId = r.sailorId
    WHERE s.age >= 30
    ORDER BY s.rating DESC
)
FETCH FIRST 3 ROWS ONLY;


--------------------------------------------------------------------------------
/* Exercise 7:  Find boats that have the same name.
                Include in the query result tuples attributes boat id and name.
                Order the query result tuples by boat id ascending. */
-- <<< Construct your query below this line as a single SQL statement >>>
SELECT b1.boatId, b1.bName
FROM Boat b1 JOIN Boat b2 ON b1.boatId != b2.boatID and b1.bname = b2.bname
ORDER BY boatId ASC;

--------------------------------------------------------------------------------
