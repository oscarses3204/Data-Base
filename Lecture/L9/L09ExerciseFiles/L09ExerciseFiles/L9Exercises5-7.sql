/* COMP 3311: L9Exercises5-7.sql */

-- Student id: 21171371
-- Name: Huang Yeung Tai

/******************************************************************************/
/***     USE ONLY SQL CONSTRUCTS DISCUSSED IN THIS AND PREVIOUS LECTURES    ***/
/***     Upload this completed script file to Canvas by 6 p.m. tomorrow.    ***/
/*** ---------------------------------------------------------------------- ***/
/***       Your queries will be tested by executing them against the        ***/
/***                      boatReservationsdb database.                      ***/
/***  If any query raises an SQL error or uses SQL constructs not discussed ***/
/***      in the course, then your exercise mark will be at most 0.5.       ***/
/******************************************************************************/

--------------------------------------------------------------------------------
/* Exercise 5:  Find the sailors for which the average rating of their age is 
                equal to the maximum average rating of all ages.
                Include in the query result tuples attributes average rating and 
                age. 
                Order the query result tuples by age ascending. */
-- *** Construct your query below this line as a single SQL statement ***

SELECT s1.age, AVG(s1.rating)
FROM Sailor s1
GROUP BY s1.age
HAVING AVG(s1.rating) = (SELECT MAX(AVG(s2.rating)) FROM Sailor s2 GROUP BY s2.age)
ORDER BY s1.age;

--------------------------------------------------------------------------------
/* Exercise 6:  Find the number of reservations made for any three sailors who 
                have made the highest number of reservations.
                Include in the query result tuples attributes sailor name and 
                number of reservations.
                Order the query result tuples by number of reservations 
                descending. */
-- *** Construct your query below this line as a single SQL statement ***

SELECT sName, numRes
FROM Sailor NATURAL JOIN (
SELECT r.sailorId, COUNT(*) AS numRes
FROM Reserves R
GROUP BY R.sailorId
ORDER BY COUNT(*) DESC
FETCH FIRST 3 ROWS ONLY);

--------------------------------------------------------------------------------
/* Exercise 7:  Find ratings having at least two adult sailors (i.e., age≥18) 
				with the rating.
				Include in the query result tuples attributes tuples attributes 
				rating, the number of sailors with the rating and the age of the 
				youngest sailor with the rating.
                Order the query result tuples by rating ascending. */
-- *** Construct your query below this line as a single SQL statement ***

SELECT s1.rating, COUNT(*), MIN(s1.age)
FROM Sailor s1
GROUP BY s1.rating
HAVING (SELECT COUNT(*) FROM Sailor s2 where s2.rating = s1.rating AND s2.age >= 18) >= 2
ORDER BY s1.rating;
--------------------------------------------------------------------------------