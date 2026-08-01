/* COMP 3311 Lab 9 Exercise: lab9Queries.sql */

clear screen
set serveroutput on
set pagesize 30
set termout off
@lab9db
set termout on
set feedback off

-- execute the lab9CgaCalculations procedure
exec lab9CgaCalculations;
select studentId, firstName, lastName, unitId, cga from Student order by cga desc nulls last;
select studentId, firstName, lastName, unitId, cga from Lowcga order by cga desc nulls last;