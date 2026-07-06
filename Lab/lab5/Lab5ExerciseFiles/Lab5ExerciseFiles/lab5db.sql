/* COMP 3311 Lab 5 Exercise: lab5db.sql */

clear screen
set feedback off
set heading off
select '*** Creating Lab 5 database ***' from dual;
set heading on

/* Start with a clean database */
drop table EnrollsIn;
drop table Student;
drop table Course;
drop table AcademicUnit;

/* Create the tables */
create table AcademicUnit (
	unitId      char(4) not null,
	unitName	varchar2(50) not null,
	roomNo		char(4) not null);

create table Course (
	courseId    char(9) primary key,
	courseName  varchar(40) not null,
	credits     smallint not null,
	instructor	varchar(30) not null,
    unitId      char(4) not null);

create table Student (
	studentId   char(8) primary key,
	firstName   varchar(20) not null,
	lastName    varchar(25) not null,
	email       varchar(15) not null,
	phoneNo     char(8) not null,
	admitYear	char(4) not null,
    cga         number(3,2),
	unitId      char(4) not null);

create table EnrollsIn (
 	studentId	char(8) not null,
	courseId	char(9) not null,
    grade       number(4,1));

/* Populate the tables with data */
insert into AcademicUnit values ('COMP','Department of Computer Science and Engineering','3528');
insert into AcademicUnit values ('MATH','Department of Mathematics','3461');
insert into AcademicUnit values ('ELEC','Department of Electronic and Computer Engineering','2528');
insert into AcademicUnit values ('MGMT','Department of Management','4555');
insert into AcademicUnit values ('FINA','Department of Finance','4528');
insert into AcademicUnit values ('HUMA','Division of Humanities','1200');

insert into Course values ('COMP 3311','Database Management Systems',3,'Data Man','COMP');
insert into Course values ('COMP 4021','Internet Computing',3,'Web Man','COMP');
insert into Course values ('ELEC 3100','Signal Processing and Communications',4,'Electronic Man','ELEC');
insert into Course values ('MATH 2421','Probability',4,'Maybe Man','MATH');
insert into Course values ('HUMA 1020','Chinese Writing and Culture',3,'Human Man','HUMA');
insert into Course values ('MGMT 1110','Introduction to Management',3,'Organized Man','MGMT');

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

insert into EnrollsIn values ('13455789','COMP 3311',85.6);
insert into EnrollsIn values ('15456789','COMP 3311',77.9);
insert into EnrollsIn values ('13556789','COMP 3311',89.5);
insert into EnrollsIn values ('14567890','COMP 3311',53.1);
insert into EnrollsIn values ('13456789','COMP 3311',66.9);
insert into EnrollsIn values ('28435018','COMP 3311',52.5);
insert into EnrollsIn values ('15678989','COMP 3311',71.8);
insert into EnrollsIn values ('15678901','COMP 3311',64.3);
insert into EnrollsIn values ('26184624','COMP 3311',62.1);
insert into EnrollsIn values ('26184444','COMP 3311',52.1);
insert into EnrollsIn values ('26186666','COMP 3311',82.1);
insert into EnrollsIn values ('66666666','COMP 3311',50.0);
insert into EnrollsIn values ('15000655','COMP 3311',92.1);
insert into EnrollsIn values ('15085942','COMP 3311',90.0);
insert into EnrollsIn values ('28834512','COMP 3311',62.1);
insert into EnrollsIn values ('28918856','COMP 3311',95.1);
insert into EnrollsIn values ('29873381','COMP 3311',78.0);
insert into EnrollsIn values ('18792018','COMP 3311',50.0);
insert into EnrollsIn values ('13455789','COMP 4021',61.3);
insert into EnrollsIn values ('15456789','COMP 4021',65.9);
insert into EnrollsIn values ('13556789','COMP 4021',83.1);
insert into EnrollsIn values ('14567890','COMP 4021',55.4);
insert into EnrollsIn values ('13456789','COMP 4021',71.3);
insert into EnrollsIn values ('15678989','COMP 4021',55.2);
insert into EnrollsIn values ('15678901','COMP 4021',82.1);
insert into EnrollsIn values ('16789012','COMP 4021',75.3);
insert into EnrollsIn values ('26184624','COMP 4021',77.1);
insert into EnrollsIn values ('26186666','COMP 4021',92.1);
insert into EnrollsIn values ('66666666','COMP 4021',55.4);
insert into EnrollsIn values ('15000655','COMP 4021',88.1);
insert into EnrollsIn values ('15085942','COMP 4021',89.4);
insert into EnrollsIn values ('28918856','COMP 4021',85.3);
insert into EnrollsIn values ('13782973','COMP 4021',82.4);
insert into EnrollsIn values ('18792018','COMP 4021',92.5);
insert into EnrollsIn values ('13455789','ELEC 3100',74.1);
insert into EnrollsIn values ('15456789','ELEC 3100',60.0);
insert into EnrollsIn values ('13556789','ELEC 3100',86.2);
insert into EnrollsIn values ('14567890','ELEC 3100',56.1);
insert into EnrollsIn values ('13456789','ELEC 3100',68.3);
insert into EnrollsIn values ('28435018','ELEC 3100',55.7);
insert into EnrollsIn values ('15678989','ELEC 3100',74.6);
insert into EnrollsIn values ('15678901','ELEC 3100',72.9);
insert into EnrollsIn values ('26184624','ELEC 3100',83.7);
insert into EnrollsIn values ('26184444','ELEC 3100',55.6);
insert into EnrollsIn values ('26186666','ELEC 3100',95.6);
insert into EnrollsIn values ('66666666','ELEC 3100',58.3);
insert into EnrollsIn values ('15085942','ELEC 3100',85.3);
insert into EnrollsIn values ('28918856','ELEC 3100',88.6);
insert into EnrollsIn values ('29873381','ELEC 3100',94.0);
insert into EnrollsIn values ('13782973','ELEC 3100',95.6);
insert into EnrollsIn values ('13455789','HUMA 1020',82.4);
insert into EnrollsIn values ('15456789','HUMA 1020',95.2);
insert into EnrollsIn values ('13556789','HUMA 1020',88.4);
insert into EnrollsIn values ('14567890','HUMA 1020',40.2);
insert into EnrollsIn values ('13456789','HUMA 1020',91.6);
insert into EnrollsIn values ('15678989','HUMA 1020',99.0);
insert into EnrollsIn values ('66666666','HUMA 1020',38.2);
insert into EnrollsIn values ('15085942','HUMA 1020',86.7);
insert into EnrollsIn values ('28435018','HUMA 1020',39.3);
insert into EnrollsIn values ('13782973','HUMA 1020',87.6);
insert into EnrollsIn values ('18792018','HUMA 1020',83.0);
insert into EnrollsIn values ('15000655','HUMA 1020',98.0);
insert into EnrollsIn values ('13455789','MATH 2421',73.5);
insert into EnrollsIn values ('15456789','MATH 2421',77.2);
insert into EnrollsIn values ('14567890','MATH 2421',44.1);
insert into EnrollsIn values ('13556789','MATH 2421',88.3);
insert into EnrollsIn values ('13456789','MATH 2421',84.3);
insert into EnrollsIn values ('15678989','MATH 2421',73.1);
insert into EnrollsIn values ('15678901','MATH 2421',95.4);
insert into EnrollsIn values ('16789012','MATH 2421',68.4);
insert into EnrollsIn values ('26184624','MATH 2421',55.1);
insert into EnrollsIn values ('26184444','MATH 2421',42.1);
insert into EnrollsIn values ('26186666','MATH 2421',83.5);
insert into EnrollsIn values ('66666666','MATH 2421',49.5);
insert into EnrollsIn values ('15000655','MATH 2421',87.7);
insert into EnrollsIn values ('15085942','MATH 2421',89.5);
insert into EnrollsIn values ('28834512','MATH 2421',92.6);
insert into EnrollsIn values ('28918856','MATH 2421',95.4);
insert into EnrollsIn values ('29873381','MATH 2421',88.0);
insert into EnrollsIn values ('13782973','MATH 2421',82.9);

/* Write the data to disk */
set feedback on
commit;

set feedback off
set heading off
select '*** Inserting your student and enrollment records ***' from dual;
set heading on
set feedback on

/* Execute the referenced script file */
@insertMyself