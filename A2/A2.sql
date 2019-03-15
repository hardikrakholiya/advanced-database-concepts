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
INSERT INTO buys VALUES(1020,2012);

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

-------------------------------------------------------

-- This view is only good if there is direct relation between Student buys a Book
-- Would not help if Student doesnt buy a Book
create view StudentBookView AS
  select S.Sid, S.Sname, b.BookNo, b.Title as BookTitle, b.Price as BookPrice
  from Student S, Buys buys, Book b
  where buys.Sid = S.Sid
    and buys.BookNo = b.BookNo
;

CREATE VIEW CitedBookView AS
  SELECT
    Citing.BookNo AS CitingBookNo,
    Citing.Title  AS CitingBookTitle,
    Citing.Price  as CitingBookPrice,
    Cited.BookNo  as CitedBookNo,
    Cited.Title   as CitedBookTitle,
    Cited.Price   as CitedBookPrice
  FROM Book Citing, Book Cited, Cites
  WHERE Citing.BookNo = cites.BookNo
        AND cites.CitedBookNo = Cited.BookNo;

--p1 Find the bookno and title of each book that costs between $10
--and $40 and that was bought by a student who majors in both CS and Math.

SELECT DISTINCT BookNo, BookTitle as Title from StudentBookView
where BookPrice >= 10 and BookPrice <= 40 and Sid in(
    SELECT Sid from Major m1
    where m1.major = 'Math'
    INTERSECT
    SELECT Sid from Major m2
    where m2.major = 'CS'
  ) ORDER BY BookNo
;

--p2 Find the sid and name of each student who bought a book that is
--cited by a higher-priced book.
select DISTINCT Sid, Sname
from StudentBookView
where BookNo in(
  select CitedBookNo FROM CitedBookView
  where CitedBookPrice < CitingBookPrice
) ORDER BY Sid
;

--p3 Find the bookno of each book that cites another book b.
--Furthermore, b should be a book cited by at least two books.

SELECT DISTINCT BookNo
FROM Cites
WHERE CitedBookNo IN (
  SELECT DISTINCT c1.CitedBookNo
  FROM cites c1, cites c2
  WHERE c1.CitedBookNo = c2.CitedBookNo
        AND c1.BookNo <> c2.BookNo
)
ORDER BY BookNo
;

--p4 Find the bid of each book that was not bought by any student.
SELECT BookNo
FROM Book
WHERE BookNo NOT IN (
  SELECT BookNo
  FROM buys
);

--p5 Find the sid of each student who did not buy all books that cost more than $50.
SELECT DISTINCT Sid
FROM Student s
EXCEPT
SELECT DISTINCT Sid
FROM StudentBookView
WHERE BookPrice > 50
ORDER BY Sid
;

--p6 Find the bookno of each book that was bought by a student who majors in CS
-- but that was not bought by any student who majors in Math.
SELECT BookNo
FROM StudentBookView
WHERE Sid IN (
  SELECT Sid
  FROM Major
  WHERE Major = 'CS'
)
EXCEPT
SELECT BookNo
FROM StudentBookView
WHERE Sid IN (
  SELECT Sid
  FROM Major
  WHERE Major = 'Math'
) ORDER BY BookNo
;

--p7 Find the sid and name of each student who has a single major
--and who only bought books that cite other books.

-- Students with only single Major
SELECT
  Sid,
  Sname
FROM Student s
WHERE sid IN (
  SELECT Sid
  FROM Major
  WHERE Sid NOT IN (
    SELECT m1.Sid
    FROM Major m1, Major m2
    WHERE m1.Sid = m2.Sid
          AND m1.Major <> m2.Major
  )
  EXCEPT
  -- Student who bought books that does not cite other books
  SELECT Sid
  FROM StudentBookView sbv
  WHERE BookNo IN (
    SELECT DISTINCT CitedBookNo
    FROM cites
    WHERE CitedBookNo NOT IN (
      SELECT BookNo
      FROM cites
    )
  )
)
;


--p8 Find the sid and majors of each student who did not buy any book that cost less than $30.
SELECT Sid, Major
From Major
where Sid IN (
  SELECT DISTINCT Sid
  FROM StudentBookView
  WHERE BookPrice >= 30
  EXCEPT
  SELECT DISTINCT Sid
  FROM StudentBookView
  WHERE BookPrice < 30
) ORDER BY Sid
;

--p9 Find each (s, b) pair where s is the sid of a student and b is
--the bookno of a book whose price is the highest among the books bought by that student.

SELECT Sid, BookNo
FROM StudentBookView s
WHERE BookPrice >= ALL (SELECT s1.BookPrice
                        FROM StudentBookView s1
                        WHERE s1.Sid = s.Sid)
;

--p10 Without using the ALL predicate, list the price of the next to most expensive books.
SELECT DISTINCT b.price
FROM Book b
WHERE exists(
          SELECT b1.price
          FROM Book b1
          WHERE b1.price > b.price
      ) AND
      NOT exists(
          SELECT b1.price
          FROM Book b1, Book b2
          WHERE b1.price > b2.price
                AND b2.price > b.price
      )
;

--p11


CREATE VIEW triples AS
  SELECT
    s.sid,
    b1.BookNo as bn1,
    b2.BookNo as bn2
  FROM Student s, Book b1, Book b2
  WHERE b1.BookNo <> b2.BookNo
;

select * from triples
except
select * from triples t1
where t1.bn1 in (
  select BookNo from buys where t1.sid = buys.sid)
and t1.bn2 not in(
  select BookNo from buys where t1.sid = buys.sid)
;

--p12 Find the sid of each student who bought none of the books cited by book with bookno 2001.

SELECT DISTINCT Sid
FROM Student
WHERE Sid NOT IN (
  SELECT Sid
  FROM buys
  WHERE BookNo IN (
    SELECT CitedBookNo
    FROM cites
    WHERE BookNo = 2001
  )
)
ORDER BY Sid
;

--p13 Find the tuples (b1,b2) where b1 and b2 are the booknos of
--two different books that were bought by exactly one CS student.


create view CSStudentBooks as
select
  m.Sid,
  b1.BookNo as bn1,
  b2.BookNo as bn2
  from buys b1, buys b2, Major m
  where b1.Sid = b2.Sid
  and b1.Sid = m.sid
  and major = 'CS'
  and b1.bookNo <> b2.bookNo
;

select bn1 as bookno, bn2 as bookno
from CSStudentBooks csb1
where not exists(
  select * from CSStudentBooks csb2
  where csb2.bn1 = csb1.bn1
  and csb2.bn2 = csb1.bn2
  and csb1.sid <> csb2.sid
) order by (bn1,bn2)
;

--p14 Find the sid of each student who only bought books
-- whose price is greater than the price of any book that was bought by all students who majors in 'Math'.


SELECT DISTINCT sb.sid
FROM StudentBookView sb
WHERE sb.bookprice > ALL (
  SELECT sb.bookprice
  FROM StudentBookView s, major m
  WHERE sb.sid = m.sid AND m.major = 'math')
      AND sb.sid IN (
  (SELECT DISTINCT sb1.sid
   FROM StudentBookView sb1)
  EXCEPT (SELECT DISTINCT sb1.sid
          FROM StudentBookView sb1, StudentBookView sb2
          WHERE sb1.sid = sb2.sid AND sb1.bookNo <> sb.bookNo)
)
;


DROP VIEW triples CASCADE;
DROP VIEW StudentBookView CASCADE;
DROP VIEW CitedBookView CASCADE;
DROP VIEW CSStudentBooks CASCADE;

DROP TABLE cites CASCADE;
DROP TABLE buys CASCADE;
DROP TABLE major CASCADE;
DROP TABLE book CASCADE;
DROP TABLE student CASCADE;