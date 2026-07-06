/* Boat Reservations Database */

/* Remove previously created tables */
drop table Reserves;
drop table Sailor;
drop table Boat;

/* Create the tables */
create table Sailor (
    sailorId    smallint primary key,
	sName       varchar(10) not null,
	hkid        char(10) not null unique,
	rating      smallint default 1 check (rating between 1 and 10),
	age         smallint not null check (age>=16 and age<=65));
   
create table Boat (
	boatId      smallint primary key,
	bName       varchar(10) not null,
	color       varchar(10) not null,
    bType       varchar(10) check (bType in ('dinghy','catamaran','sloop')));

create table Reserves (
	sailorId    smallint references Sailor(sailorId) on delete cascade,
	boatId      smallint references Boat(boatId) on delete cascade,
	rDate       date,
	primary key (sailorId,boatId,rDate));

/* Populate the tables with data */
insert into Sailor values (10,'Emily','P936219(3)',null,16);
insert into Sailor values (15,'Zoey','K091876(5)',null,17);
insert into Sailor values (22,'Dustin','A298456(6)',7,45);
insert into Sailor values (29,'Brutus','D746239(0)',1,33);
insert into Sailor values (31,'Lucy','P930281(5)',10,55);
insert into Sailor values (32,'Andy','M028391(4)',8,25);
insert into Sailor values (58,'Rachael','A819204(3)',10,17);
insert into Sailor values (64,'Horatio','F710943(2)',7,35);
insert into Sailor values (71,'Zorba','P910562(4)',1,16);
insert into Sailor values (74,'Horatio','T810463(1)',9,35);
insert into Sailor values (85,'Amy','B719037(8)',3,25);
insert into Sailor values (95,'Bob','E012735(5)',3,63);
insert into Sailor values (99,'Chris','H814243(7)',10,30);

insert into Boat values (101,'Interlake','blue','dinghy');
insert into Boat values (102,'Interlake','red','sloop');
insert into Boat values (103,'Clipper','green','dinghy');
insert into Boat values (104,'Marine','red','catamaran');
insert into Boat values (105,'Serenity','cyan',null);

insert into Reserves values (22,103,'08-SEP-25');
insert into Reserves values (22,104,'10-OCT-25');
insert into Reserves values (22,101,'10-OCT-25');
insert into Reserves values (22,102,'10-NOV-25');
insert into Reserves values (31,102,'10-OCT-25');
insert into Reserves values (31,103,'06-NOV-25');
insert into Reserves values (31,102,'12-NOV-25');
insert into Reserves values (64,101,'05-SEP-25');
insert into Reserves values (64,102,'08-SEP-25');
insert into Reserves values (74,103,'08-SEP-25');
insert into Reserves values (99,102,'08-AUG-25');

/* Permanently update the database */
commit;