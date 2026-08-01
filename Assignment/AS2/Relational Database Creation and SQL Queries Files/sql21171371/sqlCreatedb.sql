/* COMP 3311: sqlCreatedb.sql */

-- Name: 21171371
-- Student id: Huang Yeung Tai

/******************************************************************************
*                             IMPORTANT NOTE                                  *
*   You are allowed to use only SQL DDL constructs that have been discussed   *
*     in the course. If SQL DDL constructs that have not been discussed in    *
*       the course are used, then no marks will be given for this part.       *
*******************************************************************************/

--------------------------------------------------------------------------------
-- <<< Place your SQL DDL statements below this line >>>

create Table AcademyAward(
    awardId smallint primary key, 
    awardName varchar(25)
);

create Table Movie(
    movieId smallint primary key, 
    title varchar(70), 
    synopsis varchar(300), 
    releaseYear char(4),
    runningTime smallint, 
    mpaaRating varchar(10) DEFAULT 'Not Rated' check (mpaaRating in ('Approved', 'G', 'Passed', 'PG', 'PG-13', 'Not Rated', 'R')), 
    imdbRating decimal(3,1), 
    bestPictureAwardId smallint references AcademyAward(awardId) ON DELETE SET NULL
);

create TABLE MoviePerson(
    personId smallint primary key, 
    name varchar(35), 
    biography varchar(500),
    gender char(1) check (gender in ('M', 'F')),
    birthdate date,
    deathdate date
);

create TABLE AppearsIn(
    movieId smallint REFERENCES Movie(movieId) ON DELETE CASCADE, 
    personId smallint REFERENCES MoviePerson(personId) ON DELETE CASCADE, 
    role varchar(100),
    primary key (movieId, personId)
);

create TABLE AwardWin(
    movieId smallint references Movie(movieId) ON DELETE CASCADE,
    personId smallint references MoviePerson(personId) ON DELETE CASCADE,
    awardId smallint references AcademyAward(awardId) ON DELETE CASCADE,
    primary key (movieId, personId, awardId)
);

create TABLE CreditCard(
    cardNumber varchar(16) primary key check (regexp_like(cardNumber, '^[0-9]{15,16}$')),
    cardholderName varchar(35),
    cardType varchar(16),
    securityCode varchar(4) check(regexp_like(securityCode, '^[0-9]{3,4}$')),
    expiryMonth char(2) check (regexp_like(expiryMonth, '^[0-9]{2}$')),
    expiryYear char(4) check (regexp_like(expiryYear, '^[0-9]{4}$'))
);

create TABLE Directs(
    movieId smallint references Movie(movieId) ON DELETE CASCADE,
    personId smallint references MoviePerson(personId) ON DELETE CASCADE,
    primary key (movieId, personId)
);

create TABLE Genre(
    movieId smallint references Movie(movieId) ON DELETE CASCADE,
    genre varchar(15) not null,
    primary key (movieId, genre)
);

create TABLE ReelflicsMember(
    username char(10) primary key check (regexp_like(username, '^[a-z]{6,10}[ ]*$')),
    pseudonym varchar(20),
    firstName varchar(15),
    lastName varchar(20),
    occupation varchar(25),
    email varchar(25),
    gender char(1) check (gender in ('M', 'F')),
    birthdate date,
    phoneNumber char(8) check (regexp_like(phoneNumber, '^[0-9]{8}$')),
    educationLevel varchar(13) check (educationLevel in ('none', 'primary', 'secondary', 'tertiary', 'post tertiary')),
    cardNumber varchar(16) references CreditCard(cardNumber) ON DELETE SET NULL
);

create TABLE Review(
    movieId smallint REFERENCES Movie(movieId) ON DELETE CASCADE,
    username char(10) REFERENCES ReelflicsMember(username) ON DELETE CASCADE,
    title varchar(50),
    rating number,
    reviewText varchar(500),
    reviewDate date,
    primary key (movieId, username)
);

create table StreamingHistory(
    movieId smallint references Movie(movieId) ON DELETE CASCADE,
    username char(10) references ReelflicsMember(username) ON DELETE CASCADE,
    streamingDate date,
    primary key (movieId, username, streamingDate)
);

create table Watchlist(
    movieId smallint references Movie(movieId) ON DELETE CASCADE,
    username char(10) references ReelflicsMember(username) ON DELETE CASCADE,
    primary key (movieId, username)
);

