-- Data for Assignment 5

DROP TABLE IF EXISTS Student CASCADE;

CREATE TABLE Student
(
  Sid   INTEGER PRIMARY KEY,
  Sname VARCHAR(15)
);

DROP TABLE IF EXISTS Major CASCADE;
CREATE TABLE Major
(
  Sid   INTEGER REFERENCES Student (Sid),
  Major VARCHAR(15),
  PRIMARY KEY (Sid, Major)
);

DROP TABLE IF EXISTS Book CASCADE;
CREATE TABLE Book
(
  BookNo INTEGER PRIMARY KEY,
  Title  VARCHAR(30),
  Price  INTEGER
);

DROP TABLE IF EXISTS Cites CASCADE;
CREATE TABLE Cites
(
  BookNo      INTEGER REFERENCES Book (BookNo),
  CitedBookNo INTEGER REFERENCES Book (BookNo),
  PRIMARY KEY (BookNo, CitedBookNo)
);

DROP TABLE IF EXISTS Buys CASCADE;
CREATE TABLE Buys (
  Sid    INTEGER REFERENCES Student (Sid),
  BookNo INTEGER REFERENCES Book (BookNo),
  PRIMARY KEY (Sid, BookNo)
);

-- student

INSERT INTO student VALUES (1001, 'Jean');
INSERT INTO student VALUES (1002, 'Maria');
INSERT INTO student VALUES (1003, 'Anna');
INSERT INTO student VALUES (1004, 'Chin');
INSERT INTO student VALUES (1005, 'John');
INSERT INTO student VALUES (1006, 'Ryan');
INSERT INTO student VALUES (1007, 'Catherine');
INSERT INTO student VALUES (1008, 'Emma');
INSERT INTO student VALUES (1009, 'Jan');
INSERT INTO student VALUES (1010, 'Linda');
INSERT INTO student VALUES (1011, 'Nick');
INSERT INTO student VALUES (1012, 'Eric');
INSERT INTO student VALUES (1013, 'Lisa');
INSERT INTO student VALUES (1014, 'Filip');
INSERT INTO student VALUES (1015, 'Dirk');
INSERT INTO student VALUES (1016, 'Mary');
INSERT INTO student VALUES (1017, 'Ellen');
INSERT INTO student VALUES (1020, 'Ahmed');
INSERT INTO student VALUES (1021, 'Vince');
INSERT INTO student VALUES (1022, 'Joeri');
INSERT INTO student VALUES (1023, 'Chris');
INSERT INTO student VALUES (1040, 'Sofie');

-- book

INSERT INTO book VALUES (2001, 'Databases', 40);
INSERT INTO book VALUES (2002, 'OperatingSystems', 25);
INSERT INTO book VALUES (2003, 'Networks', 20);
INSERT INTO book VALUES (2004, 'AI', 45);
INSERT INTO book VALUES (2005, 'DiscreteMathematics', 20);
INSERT INTO book VALUES (2006, 'SQL', 25);
INSERT INTO book VALUES (2007, 'ProgrammingLanguages', 15);
INSERT INTO book VALUES (2008, 'DataScience', 50);
INSERT INTO book VALUES (2009, 'Calculus', 10);
INSERT INTO book VALUES (2010, 'Philosophy', 25);
INSERT INTO book VALUES (2012, 'Geometry', 80);
INSERT INTO book VALUES (2013, 'RealAnalysis', 35);
INSERT INTO book VALUES (2011, 'Anthropology', 50);
INSERT INTO book VALUES (2014, 'Topology', 70);

-- cites
INSERT INTO cites VALUES (2012, 2001);
INSERT INTO cites VALUES (2008, 2011);
INSERT INTO cites VALUES (2008, 2012);
INSERT INTO cites VALUES (2001, 2002);
INSERT INTO cites VALUES (2001, 2007);
INSERT INTO cites VALUES (2002, 2003);
INSERT INTO cites VALUES (2003, 2001);
INSERT INTO cites VALUES (2003, 2004);
INSERT INTO cites VALUES (2003, 2002);
INSERT INTO cites VALUES (2010, 2001);
INSERT INTO cites VALUES (2010, 2002);
INSERT INTO cites VALUES (2010, 2003);
INSERT INTO cites VALUES (2010, 2004);
INSERT INTO cites VALUES (2010, 2005);
INSERT INTO cites VALUES (2010, 2006);
INSERT INTO cites VALUES (2010, 2007);
INSERT INTO cites VALUES (2010, 2008);
INSERT INTO cites VALUES (2010, 2009);
INSERT INTO cites VALUES (2010, 2011);
INSERT INTO cites VALUES (2010, 2013);
INSERT INTO cites VALUES (2010, 2014);

-- buys
INSERT INTO buys VALUES (1023, 2012);
INSERT INTO buys VALUES (1023, 2014);
INSERT INTO buys VALUES (1040, 2002);
INSERT INTO buys VALUES (1001, 2002);
INSERT INTO buys VALUES (1001, 2007);
INSERT INTO buys VALUES (1001, 2009);
INSERT INTO buys VALUES (1001, 2011);
INSERT INTO buys VALUES (1001, 2013);
INSERT INTO buys VALUES (1002, 2001);
INSERT INTO buys VALUES (1002, 2002);
INSERT INTO buys VALUES (1002, 2007);
INSERT INTO buys VALUES (1002, 2011);
INSERT INTO buys VALUES (1002, 2012);
INSERT INTO buys VALUES (1002, 2013);
INSERT INTO buys VALUES (1003, 2002);
INSERT INTO buys VALUES (1003, 2007);
INSERT INTO buys VALUES (1003, 2011);
INSERT INTO buys VALUES (1003, 2012);
INSERT INTO buys VALUES (1003, 2013);
INSERT INTO buys VALUES (1004, 2006);
INSERT INTO buys VALUES (1004, 2007);
INSERT INTO buys VALUES (1004, 2008);
INSERT INTO buys VALUES (1004, 2011);
INSERT INTO buys VALUES (1004, 2012);
INSERT INTO buys VALUES (1004, 2013);
INSERT INTO buys VALUES (1005, 2007);
INSERT INTO buys VALUES (1005, 2011);
INSERT INTO buys VALUES (1005, 2012);
INSERT INTO buys VALUES (1005, 2013);
INSERT INTO buys VALUES (1006, 2006);
INSERT INTO buys VALUES (1006, 2007);
INSERT INTO buys VALUES (1006, 2008);
INSERT INTO buys VALUES (1006, 2011);
INSERT INTO buys VALUES (1006, 2012);
INSERT INTO buys VALUES (1006, 2013);
INSERT INTO buys VALUES (1007, 2001);
INSERT INTO buys VALUES (1007, 2002);
INSERT INTO buys VALUES (1007, 2003);
INSERT INTO buys VALUES (1007, 2007);
INSERT INTO buys VALUES (1007, 2008);
INSERT INTO buys VALUES (1007, 2009);
INSERT INTO buys VALUES (1007, 2010);
INSERT INTO buys VALUES (1007, 2011);
INSERT INTO buys VALUES (1007, 2012);
INSERT INTO buys VALUES (1007, 2013);
INSERT INTO buys VALUES (1008, 2007);
INSERT INTO buys VALUES (1008, 2011);
INSERT INTO buys VALUES (1008, 2012);
INSERT INTO buys VALUES (1008, 2013);
INSERT INTO buys VALUES (1009, 2001);
INSERT INTO buys VALUES (1009, 2002);
INSERT INTO buys VALUES (1009, 2011);
INSERT INTO buys VALUES (1009, 2012);
INSERT INTO buys VALUES (1009, 2013);
INSERT INTO buys VALUES (1010, 2001);
INSERT INTO buys VALUES (1010, 2002);
INSERT INTO buys VALUES (1010, 2003);
INSERT INTO buys VALUES (1010, 2011);
INSERT INTO buys VALUES (1010, 2012);
INSERT INTO buys VALUES (1010, 2013);
INSERT INTO buys VALUES (1011, 2002);
INSERT INTO buys VALUES (1011, 2011);
INSERT INTO buys VALUES (1011, 2012);
INSERT INTO buys VALUES (1012, 2011);
INSERT INTO buys VALUES (1012, 2012);
INSERT INTO buys VALUES (1013, 2001);
INSERT INTO buys VALUES (1013, 2011);
INSERT INTO buys VALUES (1013, 2012);
INSERT INTO buys VALUES (1014, 2008);
INSERT INTO buys VALUES (1014, 2011);
INSERT INTO buys VALUES (1014, 2012);
INSERT INTO buys VALUES (1017, 2001);
INSERT INTO buys VALUES (1017, 2002);
INSERT INTO buys VALUES (1017, 2003);
INSERT INTO buys VALUES (1017, 2008);
INSERT INTO buys VALUES (1017, 2012);
INSERT INTO buys VALUES (1020, 2001);
INSERT INTO buys VALUES (1020, 2012);
INSERT INTO buys VALUES (1022, 2014);

-- major
INSERT INTO major VALUES (1001, 'Math');
INSERT INTO major VALUES (1001, 'Physics');
INSERT INTO major VALUES (1002, 'CS');
INSERT INTO major VALUES (1002, 'Math');
INSERT INTO major VALUES (1003, 'Math');
INSERT INTO major VALUES (1004, 'CS');
INSERT INTO major VALUES (1006, 'CS');
INSERT INTO major VALUES (1007, 'CS');
INSERT INTO major VALUES (1007, 'Physics');
INSERT INTO major VALUES (1008, 'Physics');
INSERT INTO major VALUES (1009, 'Biology');
INSERT INTO major VALUES (1010, 'Biology');
INSERT INTO major VALUES (1011, 'CS');
INSERT INTO major VALUES (1011, 'Math');
INSERT INTO major VALUES (1012, 'CS');
INSERT INTO major VALUES (1013, 'CS');
INSERT INTO major VALUES (1013, 'Psychology');
INSERT INTO major VALUES (1014, 'Theater');
INSERT INTO major VALUES (1017, 'Anthropology');
INSERT INTO major VALUES (1022, 'CS');
INSERT INTO major VALUES (1015, 'Chemistry');

------------------------------------------------------

--1(a) Original Query
SELECT
  s.sid,
  b1.bookno
FROM student s, buys b1, buys b2
WHERE s.sid = b1.sid AND s.sid = b2.sid AND
      b1.bookno <> b2.bookno AND
      s.sname = 'Eric' AND b1.bookno <> '2010';

--writing using cross joins
SELECT
  s.sid,
  b1.bookno
FROM student s CROSS JOIN buys b1
  CROSS JOIN buys b2
WHERE s.sid = b1.sid AND s.sid = b2.sid AND
      b1.bookno <> b2.bookno AND
      s.sname = 'Eric' AND b1.bookno <> '2010';

--Optimizing
WITH
    Eric AS (SELECT s.sid
             FROM student s
             WHERE sname = 'Eric')
  , EricBooks AS (SELECT
                    Eric.sid,
                    b.bookno
                  FROM buys b
                    NATURAL JOIN Eric)
  , EricBooksPairs AS (SELECT
                         eb1.sid,
                         eb1.bookno
                       FROM EricBooks eb1 CROSS JOIN EricBooks eb2
                       WHERE eb1.bookno <> eb2.bookno)
SELECT
  sid,
  bookno
FROM EricBooksPairs
WHERE bookno <> '2010';

--------------------------------------------------
--1(b) Original query
SELECT DISTINCT
  b.bookno,
  b.title
FROM book b, student s
WHERE b.price = SOME (SELECT b1.price
                      FROM buys t, book b1
                      WHERE b1.price > 50 AND
                            s.sid = t.sid AND
                            t.bookno = b1.bookno);

-- writing using exists
SELECT DISTINCT
  b.bookno,
  b.title
FROM book b, student s
WHERE exists(SELECT 1
             FROM buys t, book b1
             WHERE b1.price > 50 AND
                   s.sid = t.sid AND
                   t.bookno = b1.bookno AND
                   b1.price = b.price);

-- pushing down parameters to inner query
WITH
    E1 AS (  SELECT
               b2.bookno,
               s1.sid
             FROM buys t CROSS JOIN book b1
               CROSS JOIN book b2
               CROSS JOIN Student s1
             WHERE b1.price > 50 AND
                   s1.sid = t.sid AND
                   t.bookno = b1.bookno AND
                   b1.price = b2.price)
SELECT DISTINCT
  bs.bookno,
  bs.title
FROM (book
  CROSS JOIN student) bs
  NATURAL JOIN E1;
--optimizing
-- removing unnecessary cross joins from E1
WITH
    E1 AS (  SELECT
               b1.bookno,
               t.sid
             FROM buys t
               NATURAL JOIN book b1
             WHERE b1.price > 50
  )
SELECT DISTINCT
  bs.bookno,
  bs.title
FROM (book
  CROSS JOIN student) bs
  NATURAL JOIN E1;

--there is no projection from student table so removing it from the query

WITH
    E1 AS (  SELECT
               b1.bookno,
               t.sid
             FROM buys t
               NATURAL JOIN book b1
             WHERE b1.price > 50)
SELECT DISTINCT
  b.bookno,
  b.title
FROM book b
  NATURAL JOIN E1;

--since we are not using sid in outer query projecting it in inner query doesn't make sense.
-- Hence removing projection of sid from inner query

WITH
    E1 AS (  SELECT b1.bookno
             FROM buys t
               NATURAL JOIN book b1
             WHERE b1.price > 50)
SELECT DISTINCT
  b.bookno,
  b.title
FROM book b
  NATURAL JOIN E1;

--buys is subset of book. So using buys instead of E1
SELECT DISTINCT
  b.bookno,
  b.title
FROM book b
  NATURAL JOIN buys t
WHERE b.price > 50;

--------------------------------------------------
--1(c)
SELECT b.bookno
FROM book b
WHERE b.bookno IN (SELECT b1.bookno
                   FROM book b1
                   WHERE b1.price > 50)
UNION
(SELECT c.bookno
 FROM cites c);

--write using exists

SELECT b.bookno
FROM book b
WHERE exists(SELECT 1
             FROM book b1
             WHERE b1.price > 50
                   AND b.bookno = b1.bookno)
UNION
(SELECT c.bookno
 FROM cites c);

--pushing down b parameter into inner query
WITH
    E1 AS (SELECT b2.bookno
           FROM book b1 CROSS JOIN book b2
           WHERE b1.price > 50
                 AND b2.bookno = b1.bookno)

SELECT b.bookno
FROM book b
  NATURAL JOIN E1
UNION
(SELECT c.bookno
 FROM cites c);

--optimizing
-- b1 and b2 are the same thing in inner query, removing b2

WITH
    E1 AS (SELECT b1.bookno
           FROM book b1
           WHERE b1.price > 50)

SELECT b.bookno
FROM book b
  NATURAL JOIN E1
UNION
(SELECT c.bookno
 FROM cites c);

-- outer query and E1 use the same table so removing E1 and directly projecting bookno from book


SELECT b.bookno
FROM book b
WHERE b.price > 50
UNION
(SELECT c.bookno
 FROM cites c);

--------------------------------------------------
--1(d)
SELECT b.bookno
FROM book b
WHERE b.price >= 80 AND
      NOT EXISTS(SELECT b1.bookno
                 FROM book b1
                 WHERE b1.Price > b.Price);

--Write using Exists
SELECT b.bookno
FROM book b
WHERE b.price >= 80
EXCEPT
SELECT b.bookno
FROM book b
WHERE exists(SELECT 1
             FROM book b1
             WHERE b1.Price > b.Price);

--push down parameter b down the inner query

WITH
    E1 AS (SELECT
             b2.bookno,
             b2.price
           FROM book b1 CROSS JOIN book b2
           WHERE b1.Price > b2.Price)
SELECT b.bookno
FROM book b
WHERE b.price >= 80
EXCEPT
SELECT b.bookno
FROM book b
  NATURAL JOIN E1;

--------------------------------------------------
--1(e)
SELECT s.sid
FROM Student s
WHERE EXISTS(SELECT 1
             FROM Book b
             WHERE b.price > 50 AND
                   b.bookno IN (SELECT t.bookno
                                FROM Buys t
                                WHERE s.sid = t.sid AND
                                      s.sname = 'Eric'));

--writing using exists
SELECT s.sid
FROM Student s
WHERE EXISTS(SELECT 1
             FROM Book b
             WHERE b.price > 50 AND
                   exists(SELECT 1
                          FROM Buys t
                          WHERE s.sid = t.sid AND
                                s.sname = 'Eric'
                                AND t.bookno = b.bookno));

--pushing down parameters s and b recursively
SELECT s.sid
FROM Student s
WHERE EXISTS(SELECT
               b.bookno,
               s1.sid
             FROM Book b, Student s1
             WHERE b.price > 50 AND
                   exists(SELECT
                            b1.bookno,
                            s2.sid
                          FROM Buys t, Book b1, Student s2
                          WHERE s2.sid = t.sid AND
                                s2.sname = 'Eric'
                                AND t.bookno = b1.bookno));


SELECT DISTINCT s.sid
FROM Student s
  NATURAL JOIN (SELECT
                  b.bookno,
                  s1.sid
                FROM Book b CROSS JOIN Student s1

                  NATURAL JOIN (SELECT
                                  b1.bookno,
                                  s2.sid
                                FROM Buys t CROSS JOIN Book b1
                                  CROSS JOIN Student s2
                                WHERE s2.sid = t.sid AND
                                      s2.sname = 'Eric'
                                      AND t.bookno = b1.bookno) q1
                WHERE b.price > 50) q0;

--writing using 'with'
WITH
    e0 AS (SELECT
             b1.bookno,
             s2.sid
           FROM Buys t CROSS JOIN Book b1
             CROSS JOIN Student s2
           WHERE s2.sid = t.sid AND
                 s2.sname = 'Eric'
                 AND t.bookno = b1.bookno)
  , e1 AS (SELECT
             b.bookno,
             s1.sid
           FROM Book b CROSS JOIN Student s1

             NATURAL JOIN e0
           WHERE b.price > 50)

SELECT DISTINCT s.sid
FROM Student s
  NATURAL JOIN e1;

--optimizing
--converting buys cross join book into natural join
WITH
    e0 AS (SELECT
             b1.bookno,
             s2.sid
           FROM (Buys t NATURAL JOIN Book b1)
             CROSS JOIN Student s2
           WHERE s2.sid = t.sid AND
                 s2.sname = 'Eric'
  )
  , e1 AS (SELECT
             b.bookno,
             s1.sid
           FROM Book b CROSS JOIN Student s1

             NATURAL JOIN e0
           WHERE b.price > 50)

SELECT DISTINCT s.sid
FROM Student s
  NATURAL JOIN e1;

-- buys is subset of book. So buys natural join book is always buys. so removing book from e0
WITH
    e0 AS (SELECT
             t.bookno,
             s2.sid
           FROM Buys t
             CROSS JOIN Student s2
           WHERE s2.sid = t.sid AND
                 s2.sname = 'Eric'
  )
  , e1 AS (SELECT
             b.bookno,
             s1.sid
           FROM Book b CROSS JOIN Student s1

             NATURAL JOIN e0
           WHERE b.price > 50)

SELECT DISTINCT s.sid
FROM Student s
  NATURAL JOIN e1;

--selecting only students with name eric for join in e0
WITH
    eric AS (SELECT sid
             FROM student
             WHERE sname = 'Eric')
  , e0 AS (SELECT
             t.bookno,
             eric.sid
           FROM Buys t
             NATURAL JOIN eric
)
  , e1 AS (SELECT
             b.bookno,
             s1.sid
           FROM Book b CROSS JOIN Student s1

             NATURAL JOIN e0
           WHERE b.price > 50)

SELECT DISTINCT s.sid
FROM Student s
  NATURAL JOIN e1;

--removing s1 from e1 since e0.sid is subset of s1
WITH
    eric AS (SELECT sid
             FROM student
             WHERE sname = 'Eric')
  , e0 AS (SELECT
             t.bookno,
             t.sid
           FROM Buys t
             NATURAL JOIN eric
)
  , e1 AS (SELECT
             b.bookno,
             e0.sid
           FROM Book b
             NATURAL JOIN e0
           WHERE b.price > 50)

SELECT DISTINCT s.sid
FROM Student s
  NATURAL JOIN e1;

--------------------------------------------------
--1(f)
SELECT
  s1.sid,
  s2.sid
FROM student s1, student s2
WHERE s1.sid <> s2.sid AND
      NOT EXISTS(SELECT 1
                 FROM Buys t1
                 WHERE t1.sid = s1.sid AND
                       t1.bookno NOT IN (SELECT t2.bookno
                                         FROM Buys t2
                                         WHERE t2.sid = s2.sid));
--convert not in to not exists
SELECT
  s1.sid,
  s2.sid
FROM student s1, student s2
WHERE s1.sid <> s2.sid AND
      NOT EXISTS(SELECT 1
                 FROM Buys t1
                 WHERE t1.sid = s1.sid AND
                       NOT exists(SELECT 1
                                  FROM Buys t2
                                  WHERE t2.sid = s2.sid
                                        AND t2.bookno = t1.bookno));


SELECT
  s1.sid,
  s2.sid
FROM student s1, student s2
WHERE s1.sid <> s2.sid AND
      NOT EXISTS(SELECT 1
                 FROM Buys t1
                 WHERE t1.sid = s1.sid AND
                       NOT exists(SELECT 1
                                  FROM Buys t2
                                  WHERE t2.sid = s2.sid
                                        AND t2.bookno = t1.bookno));

--push down the parameters s1 and s2 recursively
SELECT
  s1.sid,
  s2.sid
FROM student s1, student s2
WHERE s1.sid <> s2.sid AND
      NOT EXISTS(SELECT
                   s1.sid,
                   s2.sid
                 FROM Buys t1, student s1, student s2
                 WHERE t1.sid = s1.sid AND
                       NOT exists(SELECT
                                    t1.sid,
                                    t1.bookno,
                                    s1.sid,
                                    s2.sid
                                  FROM Buys t2, Buys t1, student s1, student s2
                                  WHERE t2.sid = s2.sid
                                        AND t2.bookno = t1.bookno));


WITH
    E1 AS (SELECT
             t1.sid    AS t1sid,
             t1.bookno AS t1bookno,
             s1.sid    AS s1sid,
             s2.sid    AS s2sid

           FROM Buys t2 CROSS JOIN Buys t1
             CROSS JOIN Student s1
             CROSS JOIN Student s2

           WHERE t2.sid = s2.sid AND t1.bookno = t2.bookno)

  , E2 AS (SELECT
             t1.sid    AS t1sid,
             t1.bookno AS t1bookno,
             s1.sid    AS s1sid,
             s2.sid    AS s2sid

           FROM Buys t1 CROSS JOIN Student s1
             CROSS JOIN Student s2

           WHERE t1.sid = s1.sid)
  , E2SemiJoinE1 AS ( SELECT
                        e2.t1sid,
                        e2.t1bookno,
                        e2.s1sid,
                        e2.s2sid
                      FROM e2
                        NATURAL JOIN e1)

  , E2antiSemiJoinE1 AS (SELECT *
                         FROM E2
                         EXCEPT
                         SELECT *
                         FROM E2SemiJoinE1)
  , E3 AS ( SELECT
              s1sid,
              s2sid
            FROM E2antiSemiJoinE1)

  , S1S2 AS ( SELECT
                s1.sid AS s1sid,
                s2.sid AS s2sid
              FROM Student s1 CROSS JOIN Student s2
              WHERE s1.sid <> s2.sid)


  , S1S2SemiJoinE3 AS ( SELECT
                          S1S2.s1sid,
                          S1S2.s2sid
                        FROM S1S2
                          NATURAL JOIN E3)

  , S1S2antiSemiJoinE3 AS (SELECT *
                           FROM S1S2
                           EXCEPT
                           SELECT *
                           FROM S1S2SemiJoinE3)

SELECT DISTINCT
  s1sid,
  s2sid

FROM S1S2antiSemiJoinE3;

--optimizing

------------------------------------------------------
DROP TABLE book CASCADE;
DROP TABLE student CASCADE;
DROP TABLE cites CASCADE;
DROP TABLE buys CASCADE;
DROP TABLE major CASCADE;
