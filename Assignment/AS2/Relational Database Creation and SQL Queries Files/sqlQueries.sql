/* COMP 3311: sqlQueries.sql */

-- Name: 21171371
-- Student id: Huang Yeung Tai

/******************************************************************************
*                             IMPORTANT NOTE                                  *
*   You are allowed to use only SQL constructs that have been discussed in    *
*     the course. If SQL constructs that have not been discussed in the       *
*   course are used in a query, then no marks will be given for that query.   *
*                                                                             *
* >>> Do not use PL/SQL procedures or functions; use SQL statements only. <<< *
*******************************************************************************/

--------------------------------------------------------------------------------
/* Query 1: Find movies that have genres that are not a genre of any movie that
            has been streamed.
            Include in the query result tuples attributes movie title and all
            their genres as a comma-separated list.
            Order the query result tuples by title ascending.
            [4 marks] */
-- <<< Construct your query below this line as a single SQL statement >>>

select m.title,
       listagg(g.genre, ', ') within group (order by g.genre) as genres
from Movie m
     join Genre g on m.movieId = g.movieId
where m.movieId in (
        select g2.movieId
        from Genre g2
        where g2.genre not in (
                select g3.genre
                from Genre g3
                where g3.movieId in (select sh.movieId from StreamingHistory sh)
              )
      )
group by m.movieId, m.title
order by m.title;

--------------------------------------------------------------------------------
/* Query 2: Find movies in which a cast member both appeared in and directed the
            movie and the movie won both the Best Picture academy award and the
            Best Director academy award.
            Include in the query result tuples attributes cast member/director
            name, role he/she played, movie title and release year.
            Order the query result tuples first by cast member/director name
            ascending and then by role ascending.
            [6 marks] */
-- <<< Construct your query below this line as a single SQL statement >>>

select p.name, ai.role, m.title, m.releaseYear
from Movie m
     join AppearsIn ai on ai.movieId = m.movieId
     join Directs d on d.movieId = m.movieId and d.personId = ai.personId
     join MoviePerson p on p.personId = ai.personId
where m.bestPictureAwardId in
          (select awardId from AcademyAward where awardName = 'Best Picture')
  and exists (
        select 1
        from AwardWin aw
             join AcademyAward a on a.awardId = aw.awardId
        where aw.movieId = m.movieId
          and a.awardName = 'Best Director'
      )
order by p.name, ai.role;

--------------------------------------------------------------------------------
/* Query 3: Find the top ranked male actors based on the number of movies in
            which the actor appeared that received the Best Picture academy
            award.
            Include in the query result tuples attributes actor name and a
            parenthesized, semicolon-separated list of the movie titles and
            their release year for the movies that received the Best Picture
            academy award in which the actor appeared.
            Order the query result tuples by actor name ascending. [8 marks] */
-- <<< Construct your query below this line as a single SQL statement >>>

select p.name,
       '(' || listagg(m.title || ', ' || m.releaseYear, '; ')
                  within group (order by m.title) || ')' as movies
from MoviePerson p
     join AppearsIn ai on ai.personId = p.personId
     join Movie m on m.movieId = ai.movieId
where p.gender = 'M'
  and m.bestPictureAwardId in
          (select awardId from AcademyAward where awardName = 'Best Picture')
group by p.personId, p.name
having count(distinct m.movieId) = (
        select max(cnt)
        from (
              select count(distinct ai2.movieId) as cnt
              from MoviePerson p2
                   join AppearsIn ai2 on ai2.personId = p2.personId
                   join Movie m2 on m2.movieId = ai2.movieId
              where p2.gender = 'M'
                and m2.bestPictureAwardId in
                        (select awardId from AcademyAward where awardName = 'Best Picture')
              group by p2.personId
             )
      )
order by p.name;

--------------------------------------------------------------------------------
/* Query 4: Find movies that have been streamed the greatest number of times.
            Include in the query result tuples attributes title, IMDB rating
            and Reelflics rating truncated to one decimal place.
            Order the query result tuples by title ascending. [8 marks] */
-- <<< Construct your query below this line as a single SQL statement >>>

select m.title,
       m.imdbRating,
       (select trunc(avg(r.rating), 1)
        from Review r
        where r.movieId = m.movieId) as reelflicsRating
from Movie m
where m.movieId in (
        select sh.movieId
        from StreamingHistory sh
        group by sh.movieId
        having count(*) = (
                select max(cnt)
                from (select count(*) as cnt
                      from StreamingHistory
                      group by movieId)
              )
      )
order by m.title;

--------------------------------------------------------------------------------
/* Query 5: Find movies that won the Best Picture academy award, whose director
            won the Best Director academy award for the movie, an actor won the
            Best Actor academy award for the movie, and an actress won the Best
            Actress academy award for the movie.
            Include in the query result tuples attributes title, release year,
            director name, actor name and actress name.
            Order the query result tuples by title ascending. [12 marks] */
-- <<< Construct Query 4 below this line as a single SQL statement >>>

select m.title,
       m.releaseYear,
       pd.name  as director,
       pa.name  as actor,
       pac.name as actress
from Movie m
     join AwardWin awd on awd.movieId = m.movieId
     join AcademyAward ad on ad.awardId = awd.awardId and ad.awardName = 'Best Director'
     join MoviePerson pd on pd.personId = awd.personId
     join AwardWin awa on awa.movieId = m.movieId
     join AcademyAward aa on aa.awardId = awa.awardId and aa.awardName = 'Best Actor'
     join MoviePerson pa on pa.personId = awa.personId
     join AwardWin awc on awc.movieId = m.movieId
     join AcademyAward ac on ac.awardId = awc.awardId and ac.awardName = 'Best Actress'
     join MoviePerson pac on pac.personId = awc.personId
where m.bestPictureAwardId in
          (select awardId from AcademyAward where awardName = 'Best Picture')
order by m.title;

--------------------------------------------------------------------------------
/* Query 6: Find movies that won the Best Picture academy award and that have
            been streamed a greater number of times by different male members
            than by different female members. Movies that have not been
            streamed by anyone should be excluded from the query result.
            Include in the query result tuples attributes title, MPAA rating,
            IMDB rating, Reelflics rating and number of times streamed.
            Replace null ratings with the string 'no rating'.
            Order the query result tuples first by number of times streamed
            descending and then by title ascending. [12 marks] */
-- <<< Construct your query below this line as a single SQL statement >>>

select m.title,
       m.mpaaRating,
       nvl(to_char(m.imdbRating), 'no rating') as imdbRating,
       nvl(to_char((select trunc(avg(r.rating), 1)
                    from Review r
                    where r.movieId = m.movieId)), 'no rating') as reelflicsRating,
       count(*) as timesStreamed
from Movie m
     join StreamingHistory sh on sh.movieId = m.movieId
     join ReelflicsMember mem on mem.username = sh.username
where m.bestPictureAwardId in
          (select awardId from AcademyAward where awardName = 'Best Picture')
group by m.movieId, m.title, m.mpaaRating, m.imdbRating
having count(distinct case when mem.gender = 'M' then sh.username end)
     > count(distinct case when mem.gender = 'F' then sh.username end)
order by count(*) desc, m.title;

--------------------------------------------------------------------------------
