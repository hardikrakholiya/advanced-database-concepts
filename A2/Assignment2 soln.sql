-- Problem 1 
-- Find the bid and title of each book that costs between
-- $10 and $40 and that was bought by a student who majors in both CS and Math.


select b.bookno, b.title
from   book b
where  b.bookno IN
                ((select b1.bookno 
                  from   book b1
                  where  b1.price >= 10 and b1. price <= 40)
                  intersect
                  (select t.bookno
                   from   buys t
                   where  t.sid in ((select m.sid
                                     from   major m
                                     where  m.major = 'CS')
                                     intersect
                                    (select m.sid
                                     from   major m
                                     where  m.major = 'Math')))) order by b.bookno;
 

-- bookno A|                              title                               
--  --------+------------------------------------------------------------------
--  2001 | Databases                                                       
--  2002 | OperatingSystems                                                
--  2007 | ProgrammingLanguages                                            
--  2013 | RealAnalysis         
-- # (4 rows)


-- Problem 2
--  Find the sid and name of each student who bought a book that is 
--  cited by a higher-priced book.


-- student(s) and book(b) and buys(s,b) and exists b1 (book(b1) and cites(b1,b) and price(b) < price(b1))


select s.sid, s.sname
from   student s
where  exists( select *
               from   book b, buys t
               where  s.sid = t.sid and b.bookno = t.bookno and 
                      exists (select *
                              from   cites c, book b1
                              where  c.bookno = b1.bookno and
                                     c.citedbookno = b.bookno and
                                     b1.price > b.price));

-- {sid | student(sid) and
--        exists b (buys(sid,b) and exists b1 (cites(b1,b) and b1.price > b.price))}
                                    
-- Alternatively,

select distinct s.sid, s.sname
from   student s, buys t, book b
where  s.sid = t.sid and t.bookno = b.bookno and 
       b.price < SOME (select b1.price 
                       from   book b1, cites c
                       where  b1.bookno = c.bookno and b.bookno = c.citedbookno)
order by s.sid, s.sname;


-- sid  |   sname   
------+-----------
-- 1001 | Jean
-- 1002 | Maria
-- 1003 | Anna
-- 1004 | Chin
-- 1005 | John
-- 1006 | Ryan
-- 1007 | Catherine
-- 1008 | Emma
-- 1009 | Jan
-- 1010 | Linda
-- 1011 | Nick
-- 1013 | Lisa
-- 1017 | Ellen
-- (13 rows)

-- Problem 3
-- Find the bookno of each book that cites another book $b$.  
-- Furthermore, $b$ should be a book cited by at least two books.


select distinct c.bookno
from   cites c, cites c1
where  c.bookno <> c1.bookno and c.citedbookno = c1.citedbookno
order by c.bookno;

-- bookno 
-- --------
--   2001
--   2003
--   2012
-- (3 rows)

-- Problem 4
-- Find the bid of each book that was not bought by any student.


select b.bookno
from   book b 
where  b.bookno NOT IN (select t.bookno
                        from   buys t);

-- bookno 
-- --------
--   2004
--   2005
-- (2 rows)


-- Problem 5
-- Find the sid of each student who did not buy all books that cost more than $50.

-- In other words, find the sid of each student for whom there exists
-- a book that cost more than $50 and that is not among the books bought
-- by that student.

select s.sid
from   student s
where  exists( select b.bookno
               from   book b
               where  b.price > 50 and
                      b.bookno NOT IN (select t.bookno
                                       from   buys t
                                       where  t.sid = s.sid));

-- sid  
-- ---
--  1001
--  1015
--  1016
-- (3 rows)

-- Problem 6
-- Find the bookno of each book that was bought by a student who majors
-- in CS but that was not bought by any student who majors in Math.


(select t.bookno
 from 	buys t,	 major m
 where  t.sid = m.sid and m.major = 'CS')
except
( select t.bookno
 from 	buys t,	 major m
 where  t.sid = m.sid and m.major = 'Math');

-- Alternatively,

 select distinct t.bookno
 from 	buys t,	 major m
 where  t.sid = m.sid and m.major = 'CS' and
        t.bookno NOT IN (select distinct t.bookno
      	      	       	 from 	buys t,	 major m
                 	  where	t.sid =	m.sid and m.major = 'Math')
order by t.bookno;

-- bookno 
-- --------
--   2003
--   2006
--   2008
--   2010
-- (4 rows)


-- Problem 7

-- Find the sid of each student who has at single major and who only
-- bought books that cite other books.

-- {s | student(s) and books_bought_by_student(s) subset citing_book}

--  Find the sid of each student who has at single major and 
--  such that there does not exist a book bought by that student that is not
--  among the books that cite other books.


 select s.sid, s.sname
 from   student s
 where  s.sid IN ((select  m.sid
                   from    major m)
                   except
                  (select m1.sid
                   from   major m1, major m2
                   where  m1.sid = m2.sid and m1.major <> m2.major)) and
         NOT EXISTS (select *
                     from   buys t 
                     where  t.sid = s.sid and
                            t.bookno NOT IN (select c.bookno
                                             from   cites c));


-- sid  | sname 
-- ------+-------
--  1017 | Ellen
-- (1 row)


-- insert into student values (1017, 'Ellen');
-- insert into major   values (1017, 'Anthropology');

-- insert into buys values (1017, 2001);
-- insert into buys values (1017, 2002);
-- insert into buys values (1017, 2003);
-- insert into buys values (1017, 2008);
-- insert into buys values (1017, 2012);


-- Problem 8
-- Find the sid and majors of each student who did not buy any book that
-- cost less than $30.


select distinct s.sid, m.major
from   student s, major m
where  s.sid = m.sid and
       s.sid NOT IN (select distinct s1.sid
                     from   student s1, buys t, book b
                     where  s1.sid = t.sid and t.bookno = b.bookno and b.price < 30);
  
-- sid  |   major    
-- ------+------------
-- 1013 | CS
-- 1013 | Psychology
-- 1014 | Theater
-- 1012 | CS
-- (4 rows)


-- Problem 9
-- Find each $(s,b)$ pair where $s$ is the sid of a student and $b$ is
-- the bookno of a book whose price is the highest among the books bought
-- by that student.

select distinct t.sid, t.bookno
from   buys t, book b
where  t.bookno = b.bookno and
       b.price >= ALL(select b1.price
                      from   buys t1, book b1
                      where  t1.bookno = b1.bookno and t1.sid = t.sid) 
order by t.sid, t.bookno;

-- Alternatively,

select distinct t.sid, t.bookno
from   buys t, book b
where  t.bookno = b.bookno and
       not exists( select *
                   from   buys t1, book b1
                   where  t1.bookno = b1.bookno and
                          t1.sid = t.sid and
                          b1.price > b.price)
order by t.sid, t.bookno;
n
select distinct t.sid, t.bookno
from   buys t, book b
where  t.bookno = b.bookno and
       not exists( select *
                   from    bookBoughtbyStudent(t.sid) b1, book b2
                   where   b1.booknumber = b2.bookno and b2.price > b.price);


buys t1, book b1
                   where  t1.bookno = b1.bookno and
                          t1.sid = t.sid and
                          b1.price > b.price)
order by t.sid, t.bookno;

CREATE OR REPLACE FUNCTION unnest2(anyarray)
RETURNS SETOF anyelement AS $$
select $1[i][j]
   from generate_subscripts($1,1) g1(i),
        generate_subscripts($1,2) g2(j);



--  sid  | bookno 
-- ------+--------
-- 1001 |   2011
-- 1002 |   2012
-- 1003 |   2012
-- 1004 |   2012
-- 1005 |   2012
-- 1006 |   2012
-- 1007 |   2012
-- 1008 |   2012
-- 1009 |   2012
-- 1010 |   2012
-- 1011 |   2012
-- 1012 |   2012
-- 1013 |   2012
-- 1014 |   2012
-- 1017 |   2012
-- 1020 |   2012
-- (1 rows)

-- Problem 10
-- Without using the {\tt ALL} predicate, list the price of the next to
-- most expensive books.

select distinct b.price
from   book b
where  exists(select b1.bookno
              from   book b1
              where  b.price < b1.price) and 
       not exists(select b1.bookno
                  from   book b1, book b2
                  where  b.price < b1.price and b1.price < b2.price);

-- price 
-- -------
--    50
-- (1 row)


-- Problem 11
-- Find the triples (s,b1,b2,s) where s is the sid of a student who if he or she
-- bought book b1 then he or she also bought book b2.
-- Furthermore, b1 and b2 should be different.

select count(*) from
(
(select s.sid, b1.bookno, b2.bookno
 from   student s, book b1, book b2
 where  b1.bookno <> b2.bookno)
except
(select s.sid, b1.bookno, b2.bookno
from    student s, book b1, book b2
where   (s.sid, b1.bookno) IN (select t.sid, t.bookno
                               from   buys t) and
        (s.sid, b2.bookno) NOT IN (select t.sid, t.bookno
                                  from   buys t))
) s;


-- Alternatively,

select count(*) from
(
(select distinct b1.bookno, b2.bookno, s.sid
 from   buys b1, buys b2, buys s
 where  b1.bookno <> b2.bookno and b1.sid = s.sid and b2.sid = s.sid)
union
(select b1.bookno, b2.bookno, s.sid
 from   book b1, book b2, student s
 where  b1.bookno <> b2.bookno and
                 b1.bookno not in (select t.bookno
                                   from   buys t
                                   where  t.sid = s.sid))
)u;


-- The answer to this query has 2254 tuples

-- Problem 12
-- Find the sid of each student who bought none of the books cited by book 
-- with bookno 2001.

select s.sid
from   student s
where  not exists ((select c.citedbookno
                    from   cites c
                    where  c.bookno = 2001)
                   intersect
                   (select t.bookno
                    from   buys t
                    where  t.sid = s.sid));


-- sid  
-- ----
-- 1012
-- 1013
-- 1014
-- 1015
-- 1016
-- 1020
--(6 rows)


-- Problem 13
-- Find the tuples (b1,b2) where b1 and b2 are the booknos of two different
-- books that were bought by exactly one CS student.


select distinct t1.bookno, t2.bookno
from  buys t1, buys t2, major m
where t1.bookno <> t2.bookno and                       -- two different books
      t1.sid = t2.sid and                              -- bought by same student
      t1.sid = m.sid and                               
      m.major = 'CS'                                   -- whose major is CS
      and not exists (select m1.sid
                      from   major m1, buys t3, buys t4
                      where  m1.major = 'CS' and
                             m1.sid <> m.sid and
                             t3.sid = t4.sid and t3.sid = m1.sid and
                             t3.bookno = t1.bookno and t4.bookno = t2.bookno)
order by t1.bookno, t2.bookno;


create function boughtjoint(bone integer, btwo integer) returns bigintb AS
$$
    select count (distinct s.sid)
    from   student s, major m, buys t1, buys t2
    where  s.sid = m.sid and t1.sid = t2.sid and t1.sid = s.sid and
           m.Major = 'CS' and t1.bookno = bone and t2.bookno = btwo;
$$ LANGUAGE SQL;




--  bookno | bookno 
----------+--------
 -- 2010  |   2001
 -- 2008  |   2001
 -- 2002  |   2008
 -- 2010  |   2003
 -- 2008  |   2003
 -- 2003  |   2012
 -- 2001  |   2010
 -- 2009  |   2011
 -- 2009  |   2012
 -- 2003  |   2011
 -- 2001  |   2009
 -- 2012  |   2009
 -- 2013  |   2003
 -- 2010  |   2007
 -- 2003  |   2010
 -- 2010  |   2008
 -- 2003  |   2009
 -- 2010  |   2002
 -- 2007  |   2003
 -- 2012  |   2010
 -- 2009  |   2010
 -- 2008  |   2002
 -- 2002  |   2003
 -- 2010  |   2013
 -- 2011  |   2003
 -- 2009  |   2013
 -- 2003  |   2013
 -- 2009  |   2008
 -- 2009  |   2002
 -- 2003  |   2007
 -- 2001  |   2003
 -- 2008  |   2010
 -- 2003  |   2008
 -- 2010  |   2009
 -- 2008  |   2009
 -- 2003  |   2002
 -- 2009  |   2007
 -- 2010  |   2012
 -- 2007  |   2009
 -- 2013  |   2010
 -- 2012  |   2003
 -- 2009  |   2003
 -- 2007  |   2010
 -- 2013  |   2009
 -- 2010  |   2011
 -- 2001  |   2008
 -- 2002  |   2010
 -- 2009  |   2001
 -- 2011  |   2009
 -- 2011  |   2010
 -- 2003  |   2001
 -- 2002  |   2009
-- (52 rows)

create or replace function boughtjoint(bone integer, btwo integer) returns	bigint AS
$$
    select count (distinct s.sid)
    from   student s, major m, buys t1,	buys t2
    where  s.sid = m.sid and t1.sid = t2.sid and t1.sid	= s.sid	and
      	      m.Major = 'CS' and t1.bookno   = bone and t2.bookno = btwo;
$$ LANGUAGE SQL;

select b1.bookno, b2.bookno 
from   book b1, book b2
where  b1.bookno <> b2.bookno and boughtjoint(b1.bookno,b2.bookno) = 1;


-- Problem 14
-- Find the sid of each student who only bought books whose price is
-- greater than the price of any book that was bought by all students who
-- majors in ’Math’.

select s.sid 
from   buys s
where  not exists (select t.bookno
                   from   buys t, book b
                   where  t.sid = s.sid and t.bookno = b.bookno
                          and b.price <= some(
            select distinct b.price
            from   book b
            where  not exists (select m.sid
                               from   major m
                               where  m.major = 'Math' and
                                      m.sid NOT IN (select t.sid
                                                    from   buys t
                                                    where  t.bookno = b.bookno))));

       
-- sid  
-- ------
-- 1020
-- (1 row)





