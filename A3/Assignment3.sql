-- by Hardik Rakholiya, Sept 2017

CREATE TABLE A (
  int INTEGER PRIMARY KEY
);

CREATE TABLE B (
  int INTEGER PRIMARY KEY
);

CREATE TABLE C (
  int INTEGER PRIMARY KEY
);

delete from A;
INSERT INTO A VALUES (1);
INSERT INTO A VALUES (2);
INSERT INTO A VALUES (3);

delete from B;
INSERT INTO B VALUES (1);
INSERT INTO B VALUES (3);

delete from C;
INSERT INTO C VALUES (1);
INSERT INTO C VALUES (3);
INSERT INTO C VALUES (4);

\echo '1a using except and intersect'
select NOT EXISTS(
        SELECT int FROM A EXCEPT SELECT int FROM B
    ) as empty_a_minus_b,
    NOT EXISTS(
        SELECT int FROM B EXCEPT SELECT int FROM A
    ) as empty_b_minus_a,
    NOT EXISTS(
        SELECT int FROM A INTERSECT SELECT int FROM B
    ) as empty_a_intersection_b
;


\echo '1b using in and not in'
select NOT EXISTS(
        SELECT int FROM A where int NOT IN(SELECT int FROM B)
    ) as empty_a_minus_b,
    NOT EXISTS(
        SELECT int FROM B where int NOT IN(SELECT int FROM A)
    ) as empty_b_minus_a,
    NOT EXISTS(
        SELECT int FROM A where int in (SELECT int FROM B)
    ) as empty_a_intersection_b
;

\echo '2a using UNION, INTERSECT, or EXCEPT'
select Exists(
           SELECT int FROM A INTERSECT SELECT int FROM B
       ) as answer;
\echo '2a using IN, NOT IN, EXISTS, or NOT EXISTS'
select Exists(
           SELECT int FROM A where int in (SELECT int FROM B)
       ) as answer;

\echo '2b using UNION, INTERSECT, or EXCEPT'
select Not Exists(
    SELECT int FROM A INTERSECT SELECT int FROM B
) as answer;
\echo '2b using IN, NOT IN, EXISTS, or NOT EXISTS'
select Not Exists(
    SELECT int FROM A where int in (SELECT int FROM B)
) as answer;

\echo '2c using UNION, INTERSECT, or EXCEPT'
select Not Exists(
    SELECT int FROM A Except SELECT int FROM B
) as answer;
\echo '2c using IN, NOT IN, EXISTS, or NOT EXISTS'
select Not Exists(
    SELECT int FROM A where int not in( SELECT int FROM B)
) as answer;

\echo '2d using UNION, INTERSECT, or EXCEPT'
select Exists(
           SELECT int FROM B Except SELECT int FROM A
       ) as answer;
\echo '2d using IN, NOT IN, EXISTS, or NOT EXISTS'
select Exists(
           SELECT int FROM B where int not in( SELECT int FROM A)
       ) as answer;

\echo '2e using UNION, INTERSECT, or EXCEPT'
select Exists(
           SELECT int FROM B Except SELECT int FROM A
              Union
          select int from A Except select int from B
       ) as answer;
\echo '2e using IN, NOT IN, EXISTS, or NOT EXISTS'
select Exists(
           SELECT int FROM B where int not in (SELECT int FROM A)
      ) OR
      Exists(
          SELECT int FROM A where int not in (SELECT int FROM B)
      )as answer;

\echo '2f using UNION, INTERSECT, or EXCEPT'
select Not exists(
  select * from
    (select int from A except select int from B) anotb1,
    (select int from A except select int from B) anotb2
    where anotb1.int <> anotb2.int
)
;

\echo '2f using IN, NOT IN, EXISTS, or NOT EXISTS'
select not exists(
  select * from
    A a1, A a2
      where a1.int <> a2.int
      and a1.int not in(select int from B)
      and a2.int not in(select int from B)
)
;

\echo '2g using UNION, INTERSECT, or EXCEPT'
select Exists(
           SELECT int FROM C Except (SELECT int FROM A intersect select int from B)
       ) as answer;
\echo '2g using IN, NOT IN, EXISTS, or NOT EXISTS'
select Exists(
           SELECT int FROM C where int not in(SELECT int FROM A where int in (select int from B))
       ) as answer;


\echo '2h using UNION, INTERSECT, or EXCEPT'
select exists(
  select *
  from (select int from A Intersect (select int from B union select int from C)) aNotBnotC1,
        (select int from A Intersect (select int from B union select int from C)) aNotBnotC2
        where aNotBnotC1.int <> aNotBnotC2.int
)and not exists(
  select *
  from (select int from A Intersect (select int from B union select int from C)) aNotBnotC1,
        (select int from A Intersect (select int from B union select int from C)) aNotBnotC2,
        (select int from A Intersect (select int from B union select int from C)) aNotBnotC3
        where aNotBnotC1.int <> aNotBnotC2.int
        and aNotBnotC2.int <> aNotBnotC3.int
        and aNotBnotC3.int <> aNotBnotC1.int
)
;

\echo '2h using IN, NOT IN, EXISTS, or NOT EXISTS'

select exists(
  select *
  from A a1, A a2
    where a1.int <> a2.int
    and (a1.int in(select int from B) or a1.int in(select int from C))
    and (a2.int in(select int from B) or a2.int in(select int from C))

)and not exists(
  select *
  from A a1, A a2, A a3
    where a1.int <> a2.int
    and a2.int <> a3.int
    and a3.int <> a1.int
    and (a1.int in(select int from B) or a1.int in(select int from C))
    and (a2.int in(select int from B) or a2.int in(select int from C))
    and (a3.int in(select int from B) or a3.int in(select int from C))
)
;

DROP TABLE A;
DROP TABLE B;
DROP TABLE C;






--Creating tables for p3
CREATE TABLE P (
  coeff integer,
  degree INTEGER PRIMARY KEY
);

CREATE TABLE Q (
  coeff integer,
  degree INTEGER PRIMARY KEY
);

--p(x) = 2x^2 - 5x + 5 and q(x) = 3x^3 + x^2 - x.
insert into P values(2, 2);
insert into P values(-5, 1);
insert into P values(5, 0);

insert into Q values(3, 3);
insert into Q values(1, 2);
insert into Q values(-1, 1);

\echo '3a'
select p.coeff + q.coeff as coeff, p.degree from P, Q
where p.degree = q.degree
union
select p.coeff, p.degree from P where p.degree not in (select degree from Q)
union
select q.coeff, q.degree from Q where q.degree not in (select degree from P)
order by degree desc
;

\echo '3b'
select SUM(p.coeff * q.coeff) as coeff, (p.degree + q.degree)  as degree from P, Q
GROUP BY(p.degree + q.degree)
order by(p.degree + q.degree) desc
;

Drop table P;
Drop table Q;

create table Point(
  pid integer PRIMARY KEY,
  x float,
  y float
);

INSERT INTO POINT values(1,0,0);
INSERT INTO POINT values(2,0,1);
INSERT INTO POINT values(3,1,0);
INSERT INTO POINT values(4,0,2);
INSERT INTO POINT values(5,1,1);
INSERT INTO POINT values(6,2,2);



select * from point;

CREATE OR REPLACE FUNCTION distance(x1 FLOAT, y1 FLOAT, x2 FLOAT, y2 FLOAT)
     RETURNS FLOAT AS
     $$
          SELECT sqrt(power(x1-x2,2)+power(y1-y2,2));
     $$  LANGUAGE SQL;

create view distanceView as
select p1.pid as p1, p2.pid as p2, distance(p1.x, p1.y, p2.x, p2.y) as distance
  from Point p1, Point p2
  where p1.x <> p2.x or p1.y <> p2.y
;

\echo '4a'
select p1, p2
from distanceView
  where distance <= ALL(select distance from distanceView)
;

drop view distanceView cascade;

create view triples as
select p1.pid as p1, p1.x as x1, p1.y as y1, p2.pid as p2, p2.x as x2, p2.y as y2, p3.pid as p3, p3.x as x3, p3.y as y3
  from Point p1, Point p2, Point p3
  where (p1.x <> p2.x or p1.y <> p2.y) AND (p2.x <> p3.x or p2.y <> p3.y) AND (p3.x <> p1.x or p3.y <> p1.y)
;

\echo '4b'
select p1, p2, p3
  from triples
    where (x1-x2)*(y2-y3) = (y1-y2)*(x2-x3)
;

drop view triples cascade;
drop table Point;



CREATE TABLE Student
(
  Sid    INTEGER PRIMARY KEY,
  Sname  VARCHAR(15)
);

CREATE TABLE Major
(
  Sid    INTEGER REFERENCES Student(Sid),
  Major  VARCHAR(15),
  PRIMARY KEY (Sid, Major)
);

CREATE TABLE Book
(
  BookNo    INTEGER PRIMARY KEY,
  Title  VARCHAR(30),
  Price INTEGER
);

CREATE TABLE Cites
(
  BookNo    INTEGER REFERENCES Book(BookNo),
  CitedBookNo  INTEGER REFERENCES Book(BookNo),
  PRIMARY KEY (BookNo, CitedBookNo)
);

CREATE TABLE Buys(
  Sid INTEGER REFERENCES Student(Sid),
  BookNo INTEGER REFERENCES Book(BookNo),
  PRIMARY KEY (Sid, BookNo)
);

-- Data for queries
DELETE FROM cites;
DELETE FROM buys;
DELETE FROM major;
DELETE FROM book;
DELETE FROM student;


-- Data for the student relation.
INSERT INTO student VALUES(1001,'Jean');
INSERT INTO student VALUES(1002,'Maria');
INSERT INTO student VALUES(1003,'Anna');
INSERT INTO student VALUES(1004,'Chin');
INSERT INTO student VALUES(1005,'John');
INSERT INTO student VALUES(1006,'Ryan');
INSERT INTO student VALUES(1007,'Catherine');
INSERT INTO student VALUES(1008,'Emma');
INSERT INTO student VALUES(1009,'Jan');
INSERT INTO student VALUES(1010,'Linda');
INSERT INTO student VALUES(1011,'Nick');
INSERT INTO student VALUES(1012,'Eric');
INSERT INTO student VALUES(1013,'Lisa');
INSERT INTO student VALUES(1014,'Filip');
INSERT INTO student VALUES(1015,'Dirk');
INSERT INTO student VALUES(1016,'Mary');
INSERT INTO student VALUES(1017,'Ellen');
INSERT INTO student VALUES(1020,'Ahmed');
INSERT INTO student VALUES(1021,'Vince');
INSERT INTO student VALUES(1022,'Joeri');

-- Data for the book relation.

INSERT INTO book VALUES(2001,'Databases',40);
INSERT INTO book VALUES(2002,'OperatingSystems',25);
INSERT INTO book VALUES(2003,'Networks',20);
INSERT INTO book VALUES(2004,'AI',45);
INSERT INTO book VALUES(2005,'DiscreteMathematics',20);
INSERT INTO book VALUES(2006,'SQL',25);
INSERT INTO book VALUES(2007,'ProgrammingLanguages',15);
INSERT INTO book VALUES(2008,'DataScience',50);
INSERT INTO book VALUES(2009,'Calculus',10);
INSERT INTO book VALUES(2010,'Philosophy',25);
INSERT INTO book VALUES(2012,'Geometry',80);
INSERT INTO book VALUES(2013,'RealAnalysis',35);
INSERT INTO book VALUES(2011,'Anthropology',50);
INSERT INTO book VALUES(2014,'Topology',70);

-- Data for the buys relation.

INSERT INTO buys VALUES(1001,2002);
INSERT INTO buys VALUES(1001,2007);
INSERT INTO buys VALUES(1001,2009);
INSERT INTO buys VALUES(1001,2011);
INSERT INTO buys VALUES(1001,2013);
INSERT INTO buys VALUES(1002,2001);
INSERT INTO buys VALUES(1002,2002);
INSERT INTO buys VALUES(1002,2007);
INSERT INTO buys VALUES(1002,2011);
INSERT INTO buys VALUES(1002,2012);
INSERT INTO buys VALUES(1002,2013);
INSERT INTO buys VALUES(1003,2002);
INSERT INTO buys VALUES(1003,2007);
INSERT INTO buys VALUES(1003,2011);
INSERT INTO buys VALUES(1003,2012);
INSERT INTO buys VALUES(1003,2013);
INSERT INTO buys VALUES(1004,2006);
INSERT INTO buys VALUES(1004,2007);
INSERT INTO buys VALUES(1004,2008);
INSERT INTO buys VALUES(1004,2011);
INSERT INTO buys VALUES(1004,2012);
INSERT INTO buys VALUES(1004,2013);
INSERT INTO buys VALUES(1005,2007);
INSERT INTO buys VALUES(1005,2011);
INSERT INTO buys VALUES(1005,2012);
INSERT INTO buys VALUES(1005,2013);
INSERT INTO buys VALUES(1006,2006);
INSERT INTO buys VALUES(1006,2007);
INSERT INTO buys VALUES(1006,2008);
INSERT INTO buys VALUES(1006,2011);
INSERT INTO buys VALUES(1006,2012);
INSERT INTO buys VALUES(1006,2013);
INSERT INTO buys VALUES(1007,2001);
INSERT INTO buys VALUES(1007,2002);
INSERT INTO buys VALUES(1007,2003);
INSERT INTO buys VALUES(1007,2007);
INSERT INTO buys VALUES(1007,2008);
INSERT INTO buys VALUES(1007,2009);
INSERT INTO buys VALUES(1007,2010);
INSERT INTO buys VALUES(1007,2011);
INSERT INTO buys VALUES(1007,2012);
INSERT INTO buys VALUES(1007,2013);
INSERT INTO buys VALUES(1008,2007);
INSERT INTO buys VALUES(1008,2011);
INSERT INTO buys VALUES(1008,2012);
INSERT INTO buys VALUES(1008,2013);
INSERT INTO buys VALUES(1009,2001);
INSERT INTO buys VALUES(1009,2002);
INSERT INTO buys VALUES(1009,2011);
INSERT INTO buys VALUES(1009,2012);
INSERT INTO buys VALUES(1009,2013);
INSERT INTO buys VALUES(1010,2001);
INSERT INTO buys VALUES(1010,2002);
INSERT INTO buys VALUES(1010,2003);
INSERT INTO buys VALUES(1010,2011);
INSERT INTO buys VALUES(1010,2012);
INSERT INTO buys VALUES(1010,2013);
INSERT INTO buys VALUES(1011,2002);
INSERT INTO buys VALUES(1011,2011);
INSERT INTO buys VALUES(1011,2012);
INSERT INTO buys VALUES(1012,2011);
INSERT INTO buys VALUES(1012,2012);
INSERT INTO buys VALUES(1013,2001);
INSERT INTO buys VALUES(1013,2011);
INSERT INTO buys VALUES(1013,2012);
INSERT INTO buys VALUES(1014,2008);
INSERT INTO buys VALUES(1014,2011);
INSERT INTO buys VALUES(1014,2012);
INSERT INTO buys VALUES(1017,2001);
INSERT INTO buys VALUES(1017,2002);
INSERT INTO buys VALUES(1017,2003);
INSERT INTO buys VALUES(1017,2008);
INSERT INTO buys VALUES(1017,2012);
INSERT INTO buys VALUES(1020,2001);
INSERT INTO buys VALUES(1020,2012);
INSERT INTO buys VALUES(1022,2014);

-- Data for the cites relation.
INSERT INTO cites VALUES(2012,2001);
INSERT INTO cites VALUES(2008,2011);
INSERT INTO cites VALUES(2008,2012);
INSERT INTO cites VALUES(2001,2002);
INSERT INTO cites VALUES(2001,2007);
INSERT INTO cites VALUES(2002,2003);
INSERT INTO cites VALUES(2003,2001);
INSERT INTO cites VALUES(2003,2004);
INSERT INTO cites VALUES(2003,2002);

-- Data for the cites relation.

INSERT INTO major VALUES(1001,'Math');
INSERT INTO major VALUES(1001,'Physics');
INSERT INTO major VALUES(1002,'CS');
INSERT INTO major VALUES(1002,'Math');
INSERT INTO major VALUES(1003,'Math');
INSERT INTO major VALUES(1004,'CS');
INSERT INTO major VALUES(1006,'CS');
INSERT INTO major VALUES(1007,'CS');
INSERT INTO major VALUES(1007,'Physics');
INSERT INTO major VALUES(1008,'Physics');
INSERT INTO major VALUES(1009,'Biology');
INSERT INTO major VALUES(1010,'Biology');
INSERT INTO major VALUES(1011,'CS');
INSERT INTO major VALUES(1011,'Math');
INSERT INTO major VALUES(1012,'CS');
INSERT INTO major VALUES(1013,'CS');
INSERT INTO major VALUES(1013,'Psychology');
INSERT INTO major VALUES(1014,'Theater');
INSERT INTO major VALUES(1017,'Anthropology');
INSERT INTO major VALUES(1022,'CS');

\echo '5a'
CREATE FUNCTION booksBoughtbyStudent(sid int, out bookno int, out title VARCHAR(30), out price integer)
RETURNS SETOF RECORD AS
$$
   SELECT Distinct b.bookno, b.title, b.price
   from book b, buys
   where buys.sid = $1
      and buys.bookno = b.bookno;
$$  LANGUAGE SQL;

\echo '5b'
select * from booksBoughtbyStudent(1001);
select * from booksBoughtbyStudent(1015);

\echo '5c i'

select sid , sname
from student
where exists(
    select distinct bookno from booksBoughtbyStudent(Sid) bbs
      where bbs.price < 50
  )
  and
  not exists(
    select *
      from booksBoughtbyStudent(Sid) bbs1, booksBoughtbyStudent(Sid) bbs2
    where bbs1.price < 50 and bbs2.price < 50 and bbs1.bookno <> bbs2.bookno
  )
;

\echo '5c ii'

select s.sid
  from student s, major m
    where m.sid = s.sid
      and major = 'CS'
      and not exists(
        select distinct bookno from booksBoughtbyStudent(s.sid) bbs
        where bookno in (
        select distinct bookno
          from major m1, booksBoughtbyStudent(m1.sid)
          where m1.major = 'Math'
        )
      )
;

\echo '5c iii'

select s1.sid, s2.sid
  from Student s1, Student s2
  where s1.sid <> s2.sid
    and not exists(
      select bookno from booksBoughtbyStudent(s1.sid)
      except select bookno from booksBoughtbyStudent(s2.sid)
    )and not exists(
      select bookno from booksBoughtbyStudent(s2.sid)
      except select bookno from booksBoughtbyStudent(s1.sid)
  )
;

\echo '6a'
create function studentWhoBoughtBook(bookno int, out sid integer, out sname VARCHAR(15))
returns setof record as
$$
  select s.sid, s.sname
  from student s, buys b
    where b.bookno = $1
      and b.sid = s.sid;
$$ LANGUAGE SQL;
;

\echo '6b'
select * from studentWhoBoughtBook(2001);
select * from studentWhoBoughtBook(2010);

\echo '6c'

--using view first filter out students whose major is CS and who bought at least one books that cost more that $30
create view CSStudentsWhoBoughtPricyBooks as
select distinct m.sid
  from Major m, booksBoughtbyStudent(m.sid) bbs
    where m.major = 'CS'
    and bbs.price > 30
;

select bookno
from book b
  where exists(
          select *
          from studentWhoBoughtBook(b.bookno) s1, studentWhoBoughtBook(b.bookno) s2
            where s1.sid in (select sid from CSStudentsWhoBoughtPricyBooks)
              and s2.sid in (select sid from CSStudentsWhoBoughtPricyBooks)
              and s1 <> s2
      )
;

\echo '7a'
create function numberOfBooksBoughtbyStudent(sid int)
  returns bigint as
  $$
    select count(bbs.bookno)
        from booksBoughtbyStudent($1) bbs
  $$  LANGUAGE SQL;
;

\echo '7b i'

select m.sid, numberOfBooksBoughtbyStudent(m.sid)
  from major m
  where m.major = 'CS'
  and numberOfBooksBoughtbyStudent(m.sid) > 2
;

\echo '7b ii(expected)'
select s.sid
  from student s
  where numberOfBooksBoughtbyStudent(s.sid) <= ( select Max (numberOfBooksBoughtbyStudent(cs.sid))
                                          from major cs
                                          where cs.major = 'CS'
                                        )
;

\echo '7b ii(actual)'
\echo 'I guess the solution should contain 19 rows since the problems says fewer books and NOT FEWER OR EQUAL.'
\echo 'From the list, exclude the CS student with maximum number of books i.e. sid 1007 with 10 books'

select s.sid
  from student s
  where numberOfBooksBoughtbyStudent(s.sid) < ( select Max (numberOfBooksBoughtbyStudent(cs.sid))
                                          from major cs
                                          where cs.major = 'CS'
                                        )
;


\echo '7b iii'
select s1.sid, s2.sid
  from student s1, student s2
  where s1.sid <> s2.sid
    and numberOfBooksBoughtbyStudent(s1.sid) = numberOfBooksBoughtbyStudent(s2.sid)
;

\echo '8a'
-- I used coalesce to get the default value 0 if there are no tuple in the query
create function totalCostForStudent(sid int)
  returns bigint as
  $$
    select coalesce(
      (select SUM(bbs.price)
        from booksBoughtbyStudent($1) bbs
      ), 0)
    ;
  $$ language sql
;

select s.sid, numberOfBooksBoughtbyStudent(s.sid)
  from student s
    where totalCostForStudent(s.sid) < 300
  group by(s.sid)
  order by s.sid
;

\echo '8b'

create function numberOfCitesByBook(bookno int)
  returns bigint as
  $$
    select count(*) from cites where cites.bookno = $1;
  $$ language sql
;

create function timesCited(bookno int)
  returns bigint as
  $$
    select count(*) from cites where citedbookno = $1;
  $$ language sql
;

select b.bookno
  from book b
    where numberOfCitesByBook(b.bookno) >= 2
    and timesCited(b.bookno) < 4
;

\echo '8c'
select b.bookno, b.title
  from book b
  where b.price <= (select Min(price) from Book b1)
;

\echo '8d'

select sid, b.bookno
  from buys , book b
    where buys.bookno = b.bookno
    and  b.price <= (select min(price) from booksBoughtbyStudent(sid) )
 ;

\echo '8e'

create function BooksCostforMajor(major VARCHAR(15))
  returns bigint as
$$
  select sum(bbs.price)
    from Major m, booksBoughtbyStudent(m.sid) bbs
      where major = $1
$$ language sql
;

select distinct m.major
from major m
  where BooksCostforMajor(m.major) >= (select max(BooksCostforMajor(major)) from Major )
;

\echo '8f'

create function noOfBioStudentWhoDidNotBuyBook(bookno int)
  returns bigint as
  $$
  select COUNT(*)
    from
        (select m.sid
          from major m
          where m.major = 'Biology'
        except
          select sid
          from studentWhoBoughtBook($1)
        ) as bioStudentWhoDidNotBuyThisBook;

  $$ language sql
;

select bookno
  from book b
  where ( noOfBioStudentWhoDidNotBuyBook(bookno) ) = 0
  order by bookno
;

\echo '8g'
create function noOfBooksShared(sid1 int, sid2 int)
  returns bigint as
  $$
    select count(*)
      from booksBoughtbyStudent($1) sbb1, booksBoughtbyStudent($2) sbb2
      where sbb1.bookno = sbb2.bookno
  $$ language sql
;

select s1.sid, s2.sid
  from student s1, student s2
  where s1.sid <> s2.sid
    and noOfBooksShared(s1.sid , s2.sid) = 1
;

\echo '8h'
create function AllbutK(k int, out s1 int, out s2 int)
  returns setof record as
  $$
    select s1.sid as s1, s2.sid as s2
    from student s1, student s2
    where s1.sid <> s2.sid
    and numberOfBooksBoughtbyStudent(s2.sid) - noOfBooksShared(s1.sid, s2.sid) = $1
  $$ language sql
;

\echo '8h where k=0'
select s1, s2 from  AllbutK(0);
\echo '8h where k=1'
select s1, s2 from  AllbutK(1);
\echo '8h where k=5'
select s1, s2 from  AllbutK(5);
\echo '8h where k=8'
select s1, s2 from  AllbutK(8);
\echo '8h where k=9'
select s1, s2 from  AllbutK(9);

drop function noOfBioStudentWhoDidNotBuyBook(int);
drop function AllbutK(int);
drop function noOfBooksShared(int,int);
drop function BooksCostforMajor(VARCHAR);
drop function timescited(int);
drop function numberOfCitesByBook(int);
drop function totalCostForStudent(int);
drop function numberOfBooksBoughtbyStudent(integer);
Drop view CSStudentsWhoBoughtPricyBooks cascade;
DROP FUNCTION studentWhoBoughtBook(integer);
DROP FUNCTION booksboughtbystudent(integer);
DROP TABLE cites CASCADE;
DROP TABLE buys CASCADE;
DROP TABLE major CASCADE;
DROP TABLE book CASCADE;
DROP TABLE student CASCADE;




