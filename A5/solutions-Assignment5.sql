-- Solutions B561 2017 Assignment 5

-- Problem 1
create or replace function memberof(x anyelement, S anyarray) returns boolean as
$$
select x = SOME(S)
$$ language sql;

create or replace function setunion(A anyarray, B anyarray) returns anyarray as
$$
with 
     Aset as (select UNNEST(A)),
     Bset as (select UNNEST(B))
select array( (select * from Aset) union (select * from Bset) order by 1);
$$ language sql;

-- Problem 1.a
create or replace function setintersection(A anyarray, B anyarray) returns anyarray as
$$
with 
     Aset as (select UNNEST(A)),
     Bset as (select UNNEST(B))
select array( (select * from Aset) intersect (select * from Bset) order by 1 );
$$ language sql;

-- Problem 1.b
create or replace function setdifference(A anyarray, B anyarray) returns anyarray as
$$
with 
     Aset as (select UNNEST(A)),
     Bset as (select UNNEST(B))
select array( (select * from Aset) except (select * from Bset) order by 1);
$$ language sql;

-- Problem 2

create or replace view student_books as
   select distinct s.sid, array(select t1.bookno 
                                from   buys t1 
                                where  t1.sid = s.sid order by bookno) as books
   from   student s order by sid;

select * from student_books;

-- Problem 2.a

create or replace view book_students as
   select b.bookno, array(select t1.sid
                          from   buys t1 
                          where  t1.bookno = b.bookno order by sid) as students
   from   book b order by bookno;

select * from book_students;

-- Problem 2.b 

create or replace view book_citedbooks as
   select b.bookno, array(select c1.citedbookno
                          from   cites c1
                          where  c1.bookno = b.bookno order by citedbookno) as citedbooks
   from   book b order by bookno;

select * from book_citedbooks;

-- Problem 2.c

create or replace view book_citingbooks as
   select b.bookno as bookno, array(select c1.bookno
                                    from   cites c1
                                    where  c1.citedbookno = b.bookno order by bookno) as citingbooks
   from   book b order by bookno;

select * from book_citingbooks;

-- Problem 2.d 

create or replace view major_students as
    select distinct m.major, array(select m1.sid 
                                   from major m1 
                                   where m1.major = m.major) as students
    from   major m order by major;

select * from major_students;

-- Problem 2.e 

create or replace view student_majors as
    select s.sid, array(select m.major from major m where m.sid = s.sid) as majors
    from   student s order by sid;

select * from student_majors;


-- Problem 3.a
-- Find the bookno of each book that is cited by at least
-- two books that cost less than \$50.

select 'Problem 3.a';

select  b.bookno
from    book b
where   exists
        (select 1
         from   book_citedbooks bc1, book_citedbooks bc2
         where  bc1.bookno <> bc2.bookno and
                memberof(b.bookno,setintersection(bc1.citedbooks,
                                                 bc2.citedbooks)) and
                memberof(bc1.bookno, array(select b3.bookno 
                                           from book b3 
                                           where b3.price < 50)) and
                memberof(bc2.bookno, array(select b3.bookno 
                                           from book b3 
                                           where b3.price < 50)))
          order by bookno;


-- bookno 
-- --------
--   2001
--   2002
--   2003
--   2004
--   2007
--  (5 rows)

-- Problem 3.b 
-- Find the bookno and title of each
-- book that was bought by a student who majors in CS and in Math.

select 'Problem 3.b';

select b.bookno, b.title
from   book b
where  exists
       (select 1
        from   student_books s, major_students ms1, major_students ms2
        where  ms1.major = 'CS' and ms2.major = 'Math' and 
               memberof(s.sid,setintersection(ms1.students,ms2.students)) and
               memberof(b.bookno,s.books));

-- bookno |        title         
-- --------+----------------------
--    2001 | Databases
--    2002 | OperatingSystems
--    2007 | ProgrammingLanguages
--    2012 | Geometry
--    2013 | RealAnalysis
--    2011 | Anthropology
--  (6 rows)



-- Problem 3.c

-- Find the sid-bookno pairs $(s,b)$ pairs such student $s$ bought
-- book $b$ and such that book $b$ is cited by at least two books that
-- cost less than \$50.

select 'Problem 3.c';

select distinct sb.sid, b.bookno
from   student_books sb, book b
where  memberof(b.bookno,setintersection(sb.books,
                                         array(select  b.bookno
                                               from    book b
                                               where   exists
                                                       (select 1
                                                        from   book b1, book_citedbooks bc1, book b2, book_citedbooks bc2
                                                        where  b1.bookno <> b2.bookno and 
                                                               b1.bookno = bc1.bookno and b1.price < 50 and
                                                               b2.bookno = bc2.bookno and b2.price < 50 and
                                                                memberof(b.bookno,bc1.citedbooks) and
                                                                memberof(b.bookno,bc2.citedbooks))))) order by 1, 2;
-- sid  | bookno 
------+--------
-- 1001 |   2002
-- 1001 |   2007
-- 1002 |   2001
-- 1002 |   2002
-- 1002 |   2007
-- 1003 |   2002
-- 1003 |   2007
-- 1004 |   2007
-- 1005 |   2007
-- 1006 |   2007
-- 1007 |   2001
-- 1007 |   2002
-- 1007 |   2003
-- 1007 |   2007
-- 1008 |   2007
-- 1009 |   2001
-- 1009 |   2002
-- 1010 |   2001
-- 1010 |   2002
-- 1010 |   2003
-- 1011 |   2002
-- 1013 |   2001
-- 1017 |   2001
-- 1017 |   2002
-- 1017 |   2003
-- 1020 |   2001
-- 1040 |   2002
-- (27 rows)


--  Problem 3.d
--  Find the bookno of each book that is cited by exactly one book.

select 'Problem 3.d';

select  bc.bookno
from    book_citingbooks bc
where   cardinality(bc.citingbooks) = 1;

-- bookno 
--------
-- 2005
-- 2006
-- 2008
-- 2009
-- 2012
-- 2013
-- 2014
-- (7 rows)

--  Problem 3.e
--  Find the sid of each student who bought all books that
--  cost more than\$50.

select 'Problem 3.e';

select  s.sid
from    student_books s
where   array(select bookno from book where price >50) <@ s.books;

-- sid  
------
-- 1023
-- (1 row)

-- Problem 3.f
-- Find the sid of each student who bought no book that cost more
-- than \$50.

select 'Problem 3.f';

select  s.sid
from    student_books s
where   not(array(select bookno from book where price >50) && s.books);

-- sid  
------
-- 1001
-- 1015
-- 1016
-- 1021
-- 1040
-- (5 rows)


-- Problem 3.g
-- Find the sid of each student who bought only books that cost
--  more than \$50.

select 'Problem 3.g';

select  s.sid
from    student_books s
where   s.books <@ array(select bookno from book where price >50);


-- sid  
------
-- 1015
-- 1016
-- 1021
-- 1022
-- 1023
-- (5 rows)

-- Problem 3.h
-- Find the sids and names of students who bought exactly one book
-- that cost less than \$50.

select 'Problem 3.h';

select s.sid, s.sname
from   student s, student_books sb
where  s.sid = sb.sid and 
       cardinality(setintersection(sb.books,array(select bookno from book where price < 50))) = 1;

-- sid  | sname 
------+-------
-- 1011 | Nick
-- 1013 | Lisa
-- 1020 | Ahmed
-- 1040 | Sofie
-- (4 rows)



--  Problem 3.i
--  Find the Bookno of each book that was not bought by any
--  student who majors in CS.

select 'Problem 3.i';

select  b.bookno
from    book_students b
where   not(array( select sid from major where major = 'CS') && b.students);

-- bookno 
--------
--   2004
--   2005
-- (2 rows)


--  Problem 3.j
--  Find the Bookno of each book that was not bought by all
--  students who major in Anthropology.  
--  In other words, there exists a student who majors in Anthropology who does not by that book.

select 'Problem 3.j';

select  b.bookno
from    book_students b
where   not (array( select sid from major where major = 'Anthropology') <@ b.students);
 
-- bookno 
--------
--   2004
--   2005
--   2006
--   2007
--   2009
--   2010
--   2011
--   2013
--   2014
-- (9 rows)

-- Problem 3.k
-- Find the sids of students who major in 'CS' and who did not
-- buy any of the books bought by the students who major in 'Math'."

select 'Problem 3.k';

select  distinct sb.sid
from    student_books sb, major_students ms
where   ms.major = 'CS' and memberof(sb.sid,ms.students) and
        not(sb.books && array(select  distinct UNNEST(sb.books)
                              from    major_students ms, student_books sb
                              where   ms.major = 'Math' and memberof(sb.sid, ms.students)));

-- sid  
------
-- 1022
-- (1 row)



-- Problem 3.l
-- Find sid-bookno pairs $(s,b)$ such that not all books
-- bought by student $s$ are books that cite book $b$.

-- I.e, Find sid-bookno pairs $(s,b)$ such that student s does not
-- only buys books that cite book $b$.

select 'Problem 3.l: This problems has 265 answers';

select distinct s.sid, b.bookno 
from   student_books s, book_citingbooks b 
where  not(s.books <@ b.citingbooks) order by 1,2;

-- Problem 3.m
-- Find sid-bookno pairs $(s,b)$ such student $s$ only
-- bought books that cite book $b$.

select 'Problem 3.m';

select distinct s.sid, b.bookno 
from   student_books s, book_citingbooks b 
where  s.books <@ b.citingbooks;


-- sid  | bookno 
------+--------
-- 1015 |   2001
-- 1015 |   2002
-- 1015 |   2003
-- 1015 |   2004
-- 1015 |   2005
-- 1015 |   2006
-- 1015 |   2007
-- 1015 |   2008
-- 1015 |   2009
-- 1015 |   2010
-- 1015 |   2011
-- 1015 |   2012
-- 1015 |   2013
-- 1015 |   2014
-- 1016 |   2001
-- 1016 |   2002
-- 1016 |   2003
-- 1016 |   2004
-- 1016 |   2005
-- 1016 |   2006
-- 1016 |   2007
-- 1016 |   2008
-- 1016 |   2009
-- 1016 |   2010
-- 1016 |   2011
-- 1016 |   2012
-- 1016 |   2013
-- 1016 |   2014
-- 1021 |   2001
-- 1021 |   2002
-- 1021 |   2003
-- 1021 |   2004
-- 1021 |   2005
-- 1021 |   2006
-- 1021 |   2007
-- 1021 |   2008
-- 1021 |   2009
-- 1021 |   2010
-- 1021 |   2011
-- 1021 |   2012
-- 1021 |   2013
-- 1021 |   2014
-- 1040 |   2003
-- (43 rows)


-- Problem 3.n
-- Find the pairs $(s_1,s_2)$ of sid of students that buy the same books.

select 'Problem 3.n';

select  sb1.sid, sb2.sid
from    student_books sb1, student_books sb2
where   sb1.books <@ sb2.books and sb2.books <@ sb1.books and sb1.sid <> sb2.sid order by 1,2;

-- sid  | sid  
------+------
-- 1004 | 1006
-- 1005 | 1008
-- 1006 | 1004
-- 1008 | 1005
-- 1015 | 1016
-- 1015 | 1021
-- 1016 | 1015
-- 1016 | 1021
-- 1021 | 1015
-- 1021 |-- 1016
-- (10 rows)

-- Problem 3.o
-- Find the pairs $(s_1,s_2)$ of sid of students that buy the same
--  number of books

select 'Problem 3.o';

select  sb1.sid, sb2.sid
from    student_books sb1, student_books sb2
where   cardinality(sb1.books) = cardinality(sb2.books) and sb1.sid <> sb2.sid order by 1,2;

-- sid  | sid  
------+------
-- 1001 | 1003
-- 1001 | 1009
-- 1001 | 1017
-- 1002 | 1004
-- 1002 | 1006
-- 1002 | 1010
-- 1003 | 1001
-- 1003 | 1009
-- 1003 | 1017
-- 1004 | 1002
-- 1004 | 1006
-- 1004 | 1010
-- 1005 | 1008
-- 1006 | 1002
-- 1006 | 1004
-- 1006 | 1010
-- 1008 | 1005
-- 1009 | 1001
-- 1009 | 1003
-- 1009 | 1017
-- 1010 | 1002
-- 1010 | 1004
-- 1010 | 1006
-- 1011 | 1013
-- 1011 | 1014
-- 1012 | 1020
-- 1012 | 1023
-- 1013 | 1011
-- 1013 | 1014
-- 1014 | 1011
-- 1014 | 1013
-- 1015 | 1016
-- 1015 | 1021
-- 1016 | 1015
-- 1016 | 1021
-- 1017 | 1001
-- 1017 | 1003
-- 1017 | 1009
-- 1020 | 1012
-- 1020 | 1023
-- 1021 | 1015
-- 1021 | 1016
-- 1022 | 1040
-- 1023 | 1012
-- 1023 | 1020
-- 1040 | 1022
-- (46 rows)

-- Problem 3.p
--  Find the bookno of each book that cites all but two
--  books.  (In other words, for such a book, there exists only two
--  books that it does not cite.)

select 'Problem 3.p';

select b.bookno
from   book_citedbooks b
where  cardinality( setdifference( array(select b.bookno from book b), b.citedbooks)) = 2;

-- bookno 
--------
--   2010
-- (1 row)


-- Problem 3.q
-- Find student who bought fewer books than the number of books
-- bought by students who major in Anthropology.

select 'Problem 3.q';

select sb.sid 
from   student_books sb
where  cardinality(sb.books) <
              (select sum(cardinality(sb1.books))
               from   student_books sb1, major_students ms
               where  ms.major = 'Anthropology' and memberof(sb1.sid,ms.students)) order by 1;


-- Problem 3.r 
-- Find the Bookno's of books that cite at least 2
-- books and are cited by fewer than 4 books.

select 'Problem 3.r';

select  bc1.bookno
from    book_citedbooks bc1, book_citingbooks bc2
where   bc1.bookno = bc2.bookno and 
        cardinality(bc1.citedbooks) >= 2 and 
        cardinality(bc2.citingbooks) < 4;


-- bookno 
--------
--   2001
--   2003
--   2008
--   2010
-- (4 rows)



