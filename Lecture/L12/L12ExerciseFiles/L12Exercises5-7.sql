/* COMP 3311: L12Exercises5-7.sql */

-- Student id: 21171371
-- Name: Huang Yeung Tai

/******************************************************************************/
/***     USE ONLY SQL CONSTRUCTS DISCUSSED IN THIS AND PREVIOUS LECTURES.   ***/
/***     MOREOVER, FOR EACH QUERY IN THIS EXERCISE YOU MUST USE ONE OR      ***/
/***      MORE OF THE SQL JSON FUNCTIONS DISCUSSED IN THIS LECTURE AND      ***/
/***     YOU MUST NOT CREATE ANY TEMPORARY RELATION USING A WITH CLAUSE.    ***/
/***     NO MARKS WILL BE GIVEN IF THESE REQUIREMENTS ARE NOT FOLLOWED.     ***/
/*** ---------------------------------------------------------------------- ***/
/***       Your queries will be tested by executing them against the        ***/
/***                      boatReservationsdb database.                      ***/
/***         If any of the queries raises an SQL error or if you use        ***/
/***        SQL constructs not discussed in this or previous lectures,      ***/
/***        then you will receive at most 0.5 marks for this exercise.      ***/
/******************************************************************************/

--------------------------------------------------------------------------------
/* Exercise 5:  Construct a JSON object for each sailor who has reserved a boat 
                with fields sailor id, name and reservations whic is an array 
                field whose values are objects, one for each of the sailor's 
                reservations, with fields boat id, boat name and boat type. 
                Order the query result objects by sailor id ascending. */
-- <<< Construct the SQL query below this line as a single SQL statement >>>

select json_object(
'sailorId' VALUE s.sailorId,
    'sName'    VALUE s.sName,
    'reservations' VALUE JSON_ARRAYAGG(
        JSON_OBJECT(
            'boatId' VALUE b.boatId,
            'bName'  VALUE b.bName,
            'bType'  VALUE b.bType
        )
    )
)
FROM Sailor s
JOIN Reserves r ON s.sailorId = r.sailorId
JOIN Boat b ON r.boatId = b.boatId
GROUP BY s.sailorId, s.sName
ORDER BY s.sailorId;

--------------------------------------------------------------------------------
/* Exercise 6:  Construct a JSON object for each boat with fields all the 
                attributes of Boat and reservations which is an array field 
                whose values are objects, one for each of the boat's 
                reservations, with fields sailor id, sailor name and rating. 
                If a boat has never been reserved, then the reservations field 
                should be absent. */
-- <<< Construct the SQL query below this line as a single SQL statement >>>

SELECT JSON_OBJECT(
    'boatId' VALUE b.boatId,
    'bName'  VALUE b.bName,
    'color'  VALUE b.color,
    'bType'  VALUE b.bType,
    'reservations' VALUE (
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'sailorId' VALUE s.sailorId,
                'sName'    VALUE s.sName,
                'rating'   VALUE s.rating
            )
        )
        FROM Reserves r
        JOIN Sailor s ON r.sailorId = s.sailorId
        WHERE r.boatId = b.boatId
    ) ABSENT ON NULL
) AS json_result
FROM Boat b
ORDER BY b.boatId;

--------------------------------------------------------------------------------
/* Exercise 7:	Construct a JSON object for each sailor with fields all the 
                attributes of Sailor and reservations which is an array field 
                whose values are objects, one for each of the sailor's 
                reservations, with fields boat id and reservation date; if a 
                sailor has not reserved any boat, then the "reservations" field 
                should be absent. 
                The reservation date format should be the same as in the Reserves 
                relation, i.e., DD-MON-YY. */
-- <<< Construct the SQL query below this line as a single SQL statement >>>

SELECT JSON_OBJECT(
    'sailorId' VALUE s.sailorId,
    'sName'    VALUE s.sName,
    'hkid'     VALUE s.hkid,
    'rating'   VALUE s.rating,
    'age'      VALUE s.age,
    'reservations' VALUE (
        SELECT JSON_ARRAYAGG(
            JSON_OBJECT(
                'boatId' VALUE r.boatId,
                'rDate'  VALUE TO_CHAR(r.rDate, 'DD-MON-YY')
            )
        )
        FROM Reserves r
        WHERE r.sailorId = s.sailorId
    ) ABSENT ON NULL
) AS json_result
FROM Sailor s
ORDER BY s.sailorId;

--------------------------------------------------------------------------------
