/* COMP 3311: L11Exercises1-4.sql */

--------------------------------------------------------------------------------
/* Exercise 1:  a) Add an integer attribute numOrders to the Customer relation
                   with values set to 0. 
                b) Create a view BestCustomers from the Customer relation with 
                   attributes customerId, firstName, lastName and numOrders 
                   that includes only customers who have placed orders in 
                   every year in which orders have been placed. 
   NOTE: Do not include any SQL statement that updates the numOrders attribute 
         of the Customer relation. The value of numOrders should be 0 for all 
         customers after the view is created. */
-- <<< Construct the alter table statement and BestCustomers view below this line >>>



----------------------------- for testing the view -----------------------------

select * from Customer;

select * from BestCustomers;

insert into BestCustomers values (7, 'Rusty', 'Zhang', 0);

--------------------------------------------------------------------------------
/* Exercise 2:  Create a trigger named IncrementOrders that increments the 
                value of the numOrders attribute for a customer in the Customer 
                relation whenever a tuple is inserted into the BookOrder 
                relation for that customer. */
-- <<< Construct the IncrementOrders trigger below this line >>>



/ 
-- <<< Construct the IncrementOrders trigger ABOVE THE FORWARD SLASH >>>
-- The forward slash is very important as it indicates the end of 
-- the trigger definition when running the script file as a script.
-- *** DO NOT DELETE THE FORWARD SLASH OR PLACE ANYTHING ELSE ON THAT LINE! ***

/************************************************************************/
/* To test the view and trigger, run the bookstoreOrderData.sql script  */
/* file and then run the following two queries.                         */
/************************************************************************/

-- Use the following query to check whether the trigger is correctly defined.
select * from Customer order by numOrders desc nulls last, lastName;

-- Use the following query check whether the view is correctly defined. 
select * from BestCustomers order by numOrders desc, lastName;

--------------------------------------------------------------------------------
/* Exercise 3:  Find authors who wrote books on both the subjects of Art and 
                Business. 
                Include in the query result tuples attributes author name (first 
                followed by last). 
                Order the query result tuples by last name ascending. */
-- QUERY RESULT: (Dan Brown) (Piper Pied)
-- <<< Construct your query below this line as a single SQL statement >>>



--------------------------------------------------------------------------------
/* Exercise 4:  Find customers who ordered the largest total quantity of books.
                Include in the query result tuples attributes customer id, last 
                name and total quantity ordered. 
                Order the query result tuples by last name ascending. */
-- QUERY RESULT: (4 Chu 711) (2 Lam 711) (1 Lee 711)
-- <<< Construct your query below this line as a single SQL statement >>>



--------------------------------------------------------------------------------
