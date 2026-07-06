/* COMP 3311 Tutorial 4 Exercises: employeementdb.sql */

clear screen
set feedback off
set heading off
select '*** Creating Tutorial 4 Employment database ***' from dual;
set heading on

/* Start with a clean database */
drop table Works;
drop table Manages;
drop table Company;
drop table Person;

/* Create the tables */
create table Person (
	personId smallint primary key,
	personName varchar(20),
	street varchar(20),
	city varchar(20)
);

create table Company (
	companyName varchar(25) primary key,
	city varchar(20)
);

create table Manages (
	personId smallint,
	managerPersonId smallint,
	primary key (personId,managerPersonId)
);

create table Works (
	personId       smallint,
	companyName varchar(25),
	salary      number(8,2),
	primary key (personId,companyName)
);

/* Populate the tables with data */
insert into Person values (1,'Jody Foster','Wangjing Road','Beijing');
insert into Person values (2,'Fred Flintstone','Austin Road','Hong Kong');
insert into Person values (3,'Amelia Earhart','Austin Road','Hong Kong');
insert into Person values (4,'Luke Skywalker','Saber Street','Shanghai');
insert into Person values (5,'Conrad Black','Capital Road','Beijing');
insert into Person values (6,'Larry Lazzy','Sleepy Road','Slumberville');

insert into Company values ('Apple','Cupertino');
insert into Company values ('HKUST','Hong Kong');
insert into Company values ('Alibaba','Beijing');
insert into Company values ('Anthropic','San Francisco');

insert into Manages values (2,1);
insert into Manages values (5,1);
insert into Manages values (3,2);

insert into Works values (1,'Alibaba',120000);
insert into Works values (2,'Apple',110000);
insert into Works values (2,'HKUST',80000);
insert into Works values (3,'Alibaba',100000);
insert into Works values (4,'HKUST',90000);
insert into Works values (5,'Apple',40000);

/* Write the data to disk */
set feedback on
commit;