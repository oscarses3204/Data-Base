/* COMP 3311: msmsSampledb.sql */

/*******************************************************************************
*  This sample database can be used to test and debug your SQL statements that *
*  create the MongoDB colections for the movie streaming management system.    *
*******************************************************************************/

/* Remove previously created tables */
drop table WatchList;
drop table StreamingHistory;
drop table Review;
drop table Genre;
drop table Directs;
drop table AwardWin;
drop table AppearsIn;
drop table ReelflicsMember;
drop table MoviePerson;
drop table Movie;
drop table CreditCard;
drop table AcademyAward;

/* Create the tables */

create table AcademyAward(
    awardId         smallint primary key,
    awardName       varchar(25) not null unique,
    constraint CHK_AcademyAward_awardName check (awardName in 
                    ('Best Picture','Best Actor','Best Actress','Best Supporting Actor',
                    'Best Supporting Actress','Best Director')));

create table CreditCard(
	cardNumber      varchar(16) primary key,
    cardholderName  varchar(35) not null,
    cardType        varchar(16) not null,
    securityCode    varchar(4) not null,
    expiryMonth     char(2) not null,
    expiryYear      char(4) not null,
    constraint CHK_Member_cardNumber check (regexp_like(cardNumber,'^\d{15,16}$')),
    constraint CHK_Member_cardType check (cardType in 
    				('American Express','MasterCard','UnionPay','Visa')),
    constraint CHK_Member_securityCode check (regexp_like(securityCode,'^\d{3,4}$')),
    constraint CHK_Member_expiryMonth check (regexp_like(expiryMonth,'^0[1-9]|1[0-2]$')),
    constraint CHK_Member_expiryYear check (regexp_like(expiryYear,'^\d{4}$')));

create table Movie(
	movieId			    smallint primary key,
	title               varchar(70) not null,
	synopsis		    varchar(300) not null,
    releaseYear         char(4) not null,
    runningTime         smallint not null,
	mpaaRating		    varchar(10) default 'Not Rated' not null,
	imdbRating          decimal(3,1) not null,
	bestPictureAwardId  smallint references AcademyAward(awardId) on delete set null,
    constraint CHK_Movie_releaseYear check (regexp_like(releaseYear,'^\d{4}$')),
    constraint CHK_Movie_runningTime check (runningTime>0),
    constraint CHK_Movie_mpaaRating check (mpaaRating in 
                    ('Approved','G','Passed','PG','PG-13','Not Rated','R')),
    constraint CHK_Movie_imdbRating check (imdbRating between 1 and 10));

create table MoviePerson(
	personId    smallint primary key,
	name        varchar(35) not null,
    biography   varchar(500) not null,
	gender      char(1) not null,
    birthdate   date,
    deathDate   date,
    constraint CHK_MoviePerson_gender check (gender in ('M','F')));

create table ReelflicsMember(
	username		char(10) primary key,
    pseudonym       varchar(20) not null unique,
	firstName	    varchar(15) not null,
    lastName	    varchar(20) not null,
    occupation      varchar(25) not null,
    email           varchar(25) not null,
    gender			char(1) not null,
	birthdate		date not null,
	phoneNumber		char(8) not null,
    educationLevel  varchar(13) not null,
    cardNumber      varchar(16) references CreditCard(cardNumber) on delete cascade,
    constraint CHK_Member_username check (regexp_like(rtrim(username),'^[a-z]{6,10}')),
    constraint CHK_Member_gender check (gender in ('M','F')),
    constraint CHK_Member_phoneNumber check (regexp_like(phoneNumber,'^\d{8}$')),    
    constraint CHK_Member_educationLevel check (educationLevel in 
                    ('none','primary','secondary','tertiary','post tertiary')));

create table AwardWin(
    movieId		smallint references Movie(movieId) on delete cascade,
	personId	smallint references MoviePerson(personId) on delete cascade,
	awardId		smallint references AcademyAward(awardId) on delete cascade,
	primary key(movieId,personId,awardId));
    
create table AppearsIn(
	movieId		smallint references Movie(movieId) on delete cascade,
	personId	smallint references MoviePerson(personId) on delete cascade,
	role		varchar(100) not null,
    primary key(movieId,personId));

create table Directs(
	movieId		smallint references Movie(movieId) on delete cascade,
	personId	smallint references MoviePerson(personId) on delete cascade,
    primary key(movieId,personId));

create table Genre(
	movieId		smallint references Movie(movieId) on delete cascade,
    genre		varchar(15),
    primary key(movieId,genre));

create table Review(
    movieId		smallint references Movie(movieId) on delete cascade,
	username	char(10) references ReelflicsMember(username) on delete cascade,
	title		varchar(50) not null,
    rating		number not null,
	reviewText	varchar(500) not null,
    reviewDate	date not null,
    primary key(movieId,username),
    constraint CHK_Review_rating check (trunc(rating)=rating and rating between 1 and 10));

create table StreamingHistory(
	movieId			smallint references Movie(movieId) on delete cascade,
	username		char(10) references ReelflicsMember(username) on delete cascade,
    streamingDate	date,
    primary key(movieId,username,streamingDate));

create table WatchList(
    movieId         smallint references Movie(movieId) on delete cascade,
	username        char(10) references ReelflicsMember(username) on delete cascade,
    primary key(movieId,username));

/* Populate the tables with data */

insert into AcademyAward values (1,'Best Picture');
insert into AcademyAward values (2,'Best Actor');
insert into AcademyAward values (3,'Best Actress');
insert into AcademyAward values (4,'Best Supporting Actor');
insert into AcademyAward values (5,'Best Supporting Actress');
insert into AcademyAward values (6,'Best Director');

insert into CreditCard values ('6223948690316102','Adam Au','UnionPay','187','08','2027');
insert into CreditCard values ('5115409204956373','Brian Mak','MasterCard','867','04','2029');

insert into Movie values (11,'Don''t Look Up','Two low-level astronomers must go on a giant media tour to warn mankind of an approaching comet that will destroy planet Earth.','2021',138,'R',7.1,null);
insert into Movie values (25,'One Battle After Another','When their enemy resurfaces after 16 years, a group of ex-revolutionaries reunite to rescue the daughter of one of their own.','2025',161,'R',7.6,1);

insert into MoviePerson values (101,'Leonardo DiCaprio','Leonardo Wilhelm DiCaprio is an American actor and film producer.','M','11-NOV-1974',null);
insert into MoviePerson values (102,'Jennifer Lawrence','Jennifer Shrader Lawrence is an American actress.','F','15-AUG-1990',null);
insert into MoviePerson values (104,'Adam McKay','Adam McKay is an American actor, film director, producer and screenwriter.','M','17-APR-1968','12-FEB-2026');
insert into MoviePerson values (105,'Sean Penn','Sean Justin Penn is an American actor and filmmaker.','M','17-AUG-1960',null);

insert into ReelflicsMember values ('adamau','hitchcoc','Adam','Au','student','adamau@nomail.com','M','14-FEB-07','93467812','secondary','6223948690316102');
insert into ReelflicsMember values ('brianmak','diduseethat','Brian','Mak','sales rep','brianmak@nomail.com','M','18-AUG-93','94467812','secondary','5115409204956373');

insert into AppearsIn values (11,101,'Dr. Randall Mindy');
insert into AppearsIn values (11,102,'Kate Dibiasky');
insert into AppearsIn values (11,104,'Charley Rae');
insert into AppearsIn values (25,101,'Bob');
insert into AppearsIn values (25,105,'Col. Steven J. Lockjaw');

insert into AwardWin values (25,105,4);
insert into AwardWin values (11,104,2);
insert into AwardWin values (25,104,6);

insert into Directs values (11,104);
insert into Directs values (25,104);

insert into Genre values (11,'drama');
insert into Genre values (11,'sci-fi');
insert into Genre values (25,'dark comedy');
insert into Genre values (25,'drama');

insert into Review values (25,'adamau','Perfect',9,'I cannot think of one reason I would not give this 10/10 except out of principle.','05-JAN-2026');

insert into StreamingHistory values (25,'adamau',to_date('01-JAN-2026 14:23', 'dd-Mon-yyyy:hh24:mi'));

insert into WatchList values (11,'adamau');

/* Permanently update the database */
commit;