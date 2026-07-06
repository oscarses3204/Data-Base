/* COMP 3311 Lab 3 Exercise: lab3db.sql */

clear screen
set feedback off
set heading off
select '*** Creating Lab 3 database ***' from dual;
set heading on

/* Start with a clean database */
drop table Student;
drop table AcademicUnit;

/* Create the tables */
create table AcademicUnit (
	unitId			char(4) not null,
	unitName		varchar2(50) not null,
	roomNo          char(4) not null);

create table Student (
	studentId   char(8) not null,
	firstName   varchar2(20) not null,
	lastName    varchar2(25) not null,
	email       varchar2(15) not null,
	phoneNo     char(8) not null,
	admitYear   char(4) not null,
	cga         number(3,2),
    unitId      char(4) not null);

/* Populate the tables with data */
insert into AcademicUnit values ('COMP','Department of Computer Science and Engineering','3528');
insert into AcademicUnit values ('MATH','Department of Mathematics','3461');
insert into AcademicUnit values ('ELEC','Department of Electronic and Computer Engineering','2528');
insert into AcademicUnit values ('MGMT','Department of Management','4555');
insert into AcademicUnit values ('FINA','Department of Finance','4528');
insert into AcademicUnit values ('HUMA','Division of Humanities','1200');

insert into Student values ('13455789','Harry','Potter','cspotter','23581234','2023',2.76,'COMP');
insert into Student values ('15456789','Leo','Da Vinci','csdavinci','23585678','2023',2.72,'COMP');
insert into Student values ('13556789','Leo','Greenleaf','magreenleaf','23582468','2024',3.36,'MATH');
insert into Student values ('13456789','Ariana','Grande','csgrande','23581234','2024',2.82,'COMP');
insert into Student values ('15678989','Edith','Clarke','csclarke','23589876','2024',2.73,'COMP');
insert into Student values ('15678901','Albert','Einstein','cseinstein','23585678','2023',2.97,'COMP');
insert into Student values ('16789012','Robert','Redford','maredford','23582468','2024',2.57,'MATH');
insert into Student values ('14567890','David','Decker','eedecker','23589876','2024',1.49,'ELEC');
insert into Student values ('99987654','Lazzy','Lazy','cslazy','23581357','2024',null,'COMP');
insert into Student values ('26184624','Bruce','Wayne','eewayne','28261057','2023',2.47,'ELEC');
insert into Student values ('26184444','Donald','Trump','bstrump','28255057','2024',1.49,'MGMT');
insert into Student values ('26186666','Warren','Buffet','bsbuffet','28266027','2023',3.43,'MGMT');
insert into Student values ('28435018','David','Decker','bsdecker','27619435','2024',1.49,'MGMT');
insert into Student values ('66666666','Ferris','Bueller','bsbueller','28282727','2023',1.54,'MGMT');
insert into Student values ('15000655','Steve','Jobs','csjobs','26232244','2023',3.56,'COMP');
insert into Student values ('15085942','Bill','Gates','csgates','25678679','2024',3.4,'COMP');
insert into Student values ('28834512','Isaac','Newton','manewton','22861987','2023',2.98,'MATH');
insert into Student values ('28918856','Alan','Turing','maturing','26679834','2023',3.56,'MATH');
insert into Student values ('29873381','Nikola','Tesla','eetesla','25671983','2023',3.37,'ELEC');
insert into Student values ('13782973','Edith','Clarke','eeclarke','28340180','2023',3.37,'ELEC');
insert into Student values ('18792018','Elon','Musk','bsmusk','28659910','2024',2.76,'MGMT');
insert into Student values ('27182481','Buzzy','Bizy','bsbizy','26178891','2024',null,'MGMT');

/* Write the data to disk */
set feedback on
commit;

set feedback off
set heading off
select '*** Inserting your student record ***' from dual;
set heading on
set feedback on

/* Execute the referenced script file */
@insertMyself