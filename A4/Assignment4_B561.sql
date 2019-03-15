create or replace view students as (select s.sid as sid from student s) order by sid;
create or replace view books as (select b.bookno as bookno from book b) order by bookno;
create or replace view citedbooks as (select distinct c.citedbookno as bookno from cites c) order by bookno;
create or replace view citingbooks as (select distinct c.bookno as bookno from cites c) order by bookno;


--Solutions assignment 4 B561 2017

-- Problem 1
-- Find the bookno of each book that is cited by at least one book that
-- cost less than \$50.



WITH 
BookLessThan50 AS (SELECT bookno FROM book WHERE price < 50)
SELECT distinct citedbookno FROM Cites NATURAL JOIN BookLessThan50 order by citedbookno;

--  Problem 2 
--  Find the bookno and title of each book that was bought by a student who majors in
--  CS and in Math. 

WITH
E1 AS ((select m.sid from major m where m.major = 'CS')
       intersect 
       (select m.sid from major m where m.major = 'Math')),
E2 As (select distinct bookno from buys NATURAL JOIN E1)
select bookno, title from book NATURAL JOIN E2 order by bookno, title;


--  Problem 3
--  Find the sid-bookno pairs $(s,b)$ pairs such student $s$ bought book $b$ and such that
--  book $b$ is cited by at least two books that cost less than \$50.

WITH
E1  as (select bookno, citedbookno 
        from   cites NATURAL JOIN (select bookno from book where price <50) q),
E2 as (select distinct c1.citedbookno AS bookno
       from   E1 c1 INNER JOIN E1 c2 ON (c1.bookno <> c2.bookno AND c1.citedbookno = c2.citedbookno))
select sid, bookno
from   buys NATURAL JOIN E2;
˛„
--  Problem 4
--  Find the bookno of each book with the next to highest price.

WITH
NotMostExpensive AS (select distinct b1.bookno, b1.price
                     from   Book b1 INNER JOIN book b2 ON (b1.price < b2.price)),
NotSecondMostExpensive AS (select distinct b1.bookno
                           from   NotMostExpensive b1 INNER JOIN NotMostExpensive b2 ON (b1.price < b2.price))
select distinct bookno from NotMostExpensive
except
select bookno from NotSecondMostexpensive order by bookno;

--  Problem 5
--  Find the sid of each student who bought all books that cost more than\$50.

with
booksover50 as (select bookno from book where price > 50),
E1          as (select sid, bookno from students cross join booksover50),
E2          as ((select sid, bookno from E1)
                 except 
                (select sid, bookno from buys)),
E3          as (select sid from E2)
select sid from students
except
select sid from e3;


--  Problem 6
--  Find the Bookno of each book that was not bought by any student who majors in CS.

with
csStudents as (select distinct m.sid as sid
               from major m where m.major = 'CS'),
e1         as (select distinct bookno
               from buys NATURAL JOIN csStudents)
select bookno from books
except
select bookno from e1;

--  Problem 7
--  Find the Bookno of each book that was not bought by all students who majors in CS.

with
csStudents as (select distinct m.sid as sid
               from major m where m.major = 'CS'),
E1          as (select sid, bookno from csStudents cross join books),
E2          as ((select sid, bookno from e1)
                except
                (select sid, bookno from buys))
select distinct bookno from e2 order by bookno;

-- Problem 8
-- Find sid-bookno pairs $(s,b)$ such that not all books bought by
-- student $s$ are books that cite book $b$.

-- I.e,
-- Find sid-bookno pairs $(s,b)$ such that student s does
-- not only buys books that cite book $b$.

with 
buyspadded as (select t.sid, t.bookno, b.bookno as bno
               from   buys t cross join books b),
citespadded as (select s.sid, c.bookno, c.citedbookno as bno
                from   student s cross join cites c),
regionleft  as (select * from buyspadded 
                except 
                select * from citespadded)
select distinct sid, citedbookno from regionleft order by sid, bno;


-- Problem 9
-- Find sid-bookno pairs $(s,b)$ such student $s$ only bought books
-- that cite book $b$.

with 
buyspadded as (select t.sid, t.bookno, b.bookno as bno
              from   buys t cross join books b),
citespadded as (select s.sid, c.bookno, c.citedbookno as bno
               from   student s cross join cites c),
regionleft  as (select * from buyspadded 
               except 
               select * from citespadded),
notallcell as (select distinct sid, bno from regionleft)
select * from students cross join books
except
select * from notallcell order by sid, bookno;


--  Problem 10
--  Find the bookno of each book that cites all but two books.  
-- (In other words,  for such a book, there exists only two books that it does not cite.)

with 
allbookpairs as (select b1.bookno as b1no, b2.bookno as b2no from Books b1 CROSS JOIN Books b2),
region1 as (select b1no, b2no  from allbookpairs except select * from cites ),
region2 as (select b1no, b2no as b3no from allbookpairs except select * from cites ),
region3 as (select b1no, b2no as b4no from allbookpairs except select * from cites ),
joinr1r2 as (select r1.b1no, r1.b2no, r2.b3no from region1 r1 INNER JOIN region2 r2 ON (r1.b1no = r2.b1no and
                                                                               r1.b2no <> r2.b3no)),
joinr1r2r3 as (select r12.b1no, r12.b2no, r12.b3no, r3.b4no from joinr1r2 r12 INNER JOIN region3 r3 ON 
                                        (r12.b1no = r3.b1no and
                                         r12.b2no <> r3.b4no and
                                         r12.b3no <> r3.b4no)),
atleast2 as (select distinct b1no from joinr1r2),
atleast3 as (select distinct b1no from joinr1r2r3)
(select * from atleast2) except (select * from atleast3);






