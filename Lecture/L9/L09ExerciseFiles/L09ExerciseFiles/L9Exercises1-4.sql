/* COMP 3311: L9Exercises1-4.sql */

--------------------------------------------------------------------------------
/* Exercise 1:  Find the number of reservations made for each red boat that has 
                a reservation.
                Include in the query result tuples attributes boat name and 
                number of reservations.
                Order the query result tuples by number of reservations 
                ascending. */
-- EXPECTED RESULT: (Marine, 1) (Interlake, 5)
-- <<< Construct your query below this line as a single SQL statement >>>



--------------------------------------------------------------------------------
/* Exercise 2:  Find the number of reservations made by each sailor.
                Include in the query result tuples attributes sailor name and 
                number of reservations.
                Order the query result tuples first by number of reservations 
                ascending and then by name ascending. */
-- EXPECTED (Amy, 0) (Andy, 0) (Bob, 0) (Brutus, 0) (Emily, 0) (Rachael, 0) 
-- RESULT:  (Zoey, 0) (Zorba, 0) (Chris, 1) (Horatio, 1) (Horatio, 2) (Lucy, 3)
--          (Dustin, 4)
-- <<< Construct your query below this line as a single SQL statement >>>



--------------------------------------------------------------------------------
/* Exercise 3:  Find all sailors who have the highest rating.
                Include in the query result tuples attributes sailor id, name, 
                rating and age.
                Order the query result tuples by age ascending. */
-- EXPECTED RESULT: (58, Rachael, 10, 17) (99, Chris, 10, 30) (31, Lucy, 10, 55)
-- <<< Construct your query below this line as a single SQL statement >>>



--------------------------------------------------------------------------------
/* Exercise 4:  Find the sailors who have reserved a red boat.
                Include in the query result tuples attributes only unique sailor 
                names.
                Order the query result tuples by name ascending.
                (DO NOT USE JOIN; USE ONLY SET MEMBERSHIP) */
-- EXPECTED RESULT: (Chris) (Dustin) (Horatio) (Lucy)
-- <<< Construct your query below this line as a single SQL statement >>>



--------------------------------------------------------------------------------
