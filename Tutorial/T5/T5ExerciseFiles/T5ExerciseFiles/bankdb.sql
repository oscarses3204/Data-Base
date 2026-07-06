/* COMP 3311: Tutorial 5 Exercises - bankdb.sql */

clear screen
set feedback off
set heading off
select '*** Creating Tutorial 5 Bank database ***' from dual;
set heading on

/* Start with a clean database */
drop table Withdrawal;
drop table Deposit;
drop table Account;
drop table Customer;

/* Create the tables */
create table Customer (
	customerId	int primary key,
	name		varchar(20));

create table Account (
	accountId	char(2) primary key,
	customerId	int,
	balance		number);

create table Deposit (
	depositId	int primary key,
	accountId	char(2),
	customerId	int,
	amount		int);

create table Withdrawal (
	withdrawalId int primary key,
	accountId	 char(2),
	customerId	 int,
    amount		 int);

/* Populate the tables with data */
insert into Customer values (1,'Amelia Earhart');
insert into Customer values (2,'Jody Foster');
insert into Customer values (3,'Fred Flintstone');
insert into Customer values (4,'Luke Skywalker');
insert into Customer values (5,'Conrad Black');

insert into Account values('A1',1,10000);
insert into Account values('A2',2,25000);
insert into Account values('A3',3,20000);
insert into Account values('A4',4,15000);
insert into Account values('A5',5,10000);

insert into Deposit values (1,'A1',1,2000);
insert into Deposit values (2,'A1',3,1000);
insert into Deposit values (3,'A2',1,1000);
insert into Deposit values (4,'A2',2,3000);
insert into Deposit values (5,'A3',3,2000);
insert into Deposit values (6,'A3',3,5000);
insert into Deposit values (7,'A2',2,1500);
insert into Deposit values (8,'A4',4,2500);

insert into Withdrawal values (1,'A1',1,1500);
insert into Withdrawal values (2,'A1',1,2000);
insert into Withdrawal values (3,'A2',2,100);
insert into Withdrawal values (4,'A2',2,500);
insert into Withdrawal values (5,'A2',2,200);
insert into Withdrawal values (6,'A3',3,1100);
insert into Withdrawal values (7,'A1',3,500);
insert into Withdrawal values (8,'A5',5,100);
insert into Withdrawal values (9,'A5',3,2000);

/* Write the data to disk */
set feedback on
commit;