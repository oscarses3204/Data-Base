/* COMP 3311: mqlCreatedb.sql */

-- Student id: 21171371
-- Name: Huang Yeung Tai

/******************************************************************************
*                             IMPORTANT NOTE                                  *
* You are allowed to use only SQL constructs that have been discussed in the  *
* course. Moreover, you must use the Oracle SQL/JSON functions presented in   *
* the course in your SQL statements that create the collections.              *
* If SQL constructs that have not been discussed in the course are used or    *
* Oracle SQL/JSON functions are not used to create the collections, then no   *
* marks will be given.                                                        *
*******************************************************************************/

--------------------------------------------------------------------------------
/***         SQL statement that creates the moviePersons collection         ***/
-- <<< Place your SQL statement that creates the collection below this line >>>

select json_object(
    'personId' value personId,
    'name' value name,
    'biography' value biography,
    'gender' value gender,
    'birthdate' value birthdate,
    'deathdate' value deathdate,
    'appearsIn' value (select json_arrayagg(movieId order by movieId asc absent on null)
        from AppearsIn ai
        where ai.personId = mp.personId
    ),
    'directs' value (select json_arrayagg(movieId order by movieId asc absent on null)
        from Directs dr
        where dr.personId = mp.personId
    ),
    'awardWin' value (select json_arrayagg(awardWinObj absent on null)
        from (
            select json_object(
                'movieId' value aw.movieId,
                'awardName' value aa.awardName
                absent on null
            ) as awardWinObj
            from AwardWin aw join AcademyAward aa on aw.awardId = aa.awardId
            where aw.personId = mp.personId
        )
    )
    absent on null
)
from MoviePerson mp;

--------------------------------------------------------------------------------
/***            SQL statement that creates the movies collection            ***/
-- <<< Place your SQL statement that creates the collection below this line >>>

select json_object(
    'movieId' value movieId,
    'title' value title,
    'synopsis' value synopsis,
    'releaseYear' value releaseYear,
    'runningTime' value runningTime,
    'mpaaRating' value mpaaRating,
    'imdbRating' value imdbRating,
    'award' value (select awardName from AcademyAward aa where aa.awardId = mv.bestPictureAwardId),
    'genres' value (select json_arrayagg(genre order by genre asc absent on null)
        from Genre
        where Genre.movieId = mv.movieId
    ),
    'cast' value (select json_arrayagg(
        json_object(
            'personId' value AI.personId,
            'role' value AI.role
            absent on null
        ) absent on null
    ) from AppearsIn AI
        where AI.movieId = mv.movieId
    ),
    'directors' value (select json_arrayagg(personId order by personId asc absent on null)
        from Directs
        where Directs.movieId = mv.movieId
    ),
    'reviews' value (select json_arrayagg(
        json_object(
            'username' value R.username,
            'title' value R.title,
            'rating' value R.rating,
            'reviewText' value R.reviewText,
            'reviewDate' value R.reviewDate
            absent on null
        ) absent on null
    ) from Review R
        where R.movieId = mv.movieId
    )
    absent on null
)
from Movie mv;

--------------------------------------------------------------------------------
/***       SQL statement that creates the reelflicMembers collection        ***/
-- <<< Place your SQL statement that creates the collection below this line >>>

select json_object(
    'username' value rm.username,
    'pseudonym' value rm.pseudonym,
    'firstName' value rm.firstName,
    'lastName' value rm.lastName,
    'occupation' value rm.occupation,
    'email' value rm.email,
    'gender' value rm.gender,
    'birthdate' value rm.birthdate,
    'phoneNumber' value rm.phoneNumber,
    'educationLevel' value rm.educationLevel,
    'cardNumber' value rm.cardNumber,
    'cardholderName' value cc.cardholderName,
    'cardType' value cc.cardType,
    'securityCode' value cc.securityCode,
    'expiryMonth' value cc.expiryMonth,
    'expiryYear' value cc.expiryYear,
    'watchlist' value (select json_arrayagg(movieId order by movieId asc absent on null)
        from WatchList wl
        where wl.username = rm.username
    ),
    'streamingHistory' value (select json_arrayagg(
        json_object(
            'movieId' value sh.movieId,
            'streamingDate' value sh.streamingDate
            absent on null
        ) absent on null
    ) from StreamingHistory sh
        where sh.username = rm.username
    )
    absent on null
)
from ReelflicsMember rm
left join CreditCard cc on rm.cardNumber = cc.cardNumber;

--------------------------------------------------------------------------------
