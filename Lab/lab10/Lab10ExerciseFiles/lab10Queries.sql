/* COMP 3311 Lab 10 Exercise: lab10Queries.sql */

clear screen
set serveroutput on
set pagesize 30
set termout off
@lab10db
set termout on
set feedback off

exec lab10DuplicateEmailCheck;
exec lab10CgaCalculations;
select studentId, firstName, lastName, unitId, cga from Student order by cga desc nulls last;
select studentId, firstName, lastName, unitId, cga from LowCga order by cga desc nulls last;