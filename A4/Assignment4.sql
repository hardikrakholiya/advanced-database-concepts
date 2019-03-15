CREATE TABLE Student
(
  Sid   INTEGER PRIMARY KEY,
  Sname VARCHAR(15)
);

CREATE TABLE Major
(
  Sid   INTEGER REFERENCES Student (Sid),
  Major VARCHAR(15),
  PRIMARY KEY (Sid, Major)
);

CREATE TABLE Book
(
  BookNo INTEGER PRIMARY KEY,
  Title  VARCHAR(30),
  Price  INTEGER
);

CREATE TABLE Cites
(
  BookNo      INTEGER REFERENCES Book (BookNo),
  CitedBookNo INTEGER REFERENCES Book (BookNo),
  PRIMARY KEY (BookNo, CitedBookNo)
);

CREATE TABLE Buys (
  Sid    INTEGER REFERENCES Student (Sid),
  BookNo INTEGER REFERENCES Book (BookNo),
  PRIMARY KEY (Sid, BookNo)
);

-- Data for Assignment 4
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

\echo 'P1'

SELECT DISTINCT c.citedbookno
FROM Cites c
  INNER JOIN Book b ON b.bookno = c.bookno AND b.price < 50;

\echo 'P2'

WITH
    CSStudent AS (SELECT sid
                  FROM Major
                  WHERE major = 'CS'),
    MathStudent AS (SELECT sid
                    FROM Major
                    WHERE major = 'Math'),
    CSMathStudent AS (SELECT cs.sid
                      FROM CSStudent cs
                        INNER JOIN MathStudent math ON cs.sid = math.sid),
    BookNoOfCSMathStudent AS (SELECT DISTINCT bookno
                              FROM buys
                                INNER JOIN CSMathStudent ON buys.sid = CSMathStudent.sid),
    BooksOfCSMathStudent AS (SELECT
                               book.bookno,
                               book.title
                             FROM book
                               INNER JOIN BookNoOfCSMathStudent ON book.bookno = BookNoOfCSMathStudent.bookno )
SELECT *
FROM BooksOfCSMathStudent;

\echo 'P3'

WITH
    CheapBooks AS (SELECT bookno
                   FROM book
                   WHERE price < 50),
    CitesByCheapBooks AS (SELECT
                            cites.BookNo      AS citing,
                            cites.CitedBookNo AS cited
                          FROM cites
                            INNER JOIN CheapBooks ON CheapBooks.bookno = cites.bookno),
    CitedTwiceByCheapBooks AS (SELECT DISTINCT ccb.cited
                               FROM CitesByCheapBooks ccb INNER JOIN CitesByCheapBooks ccb1
                                   ON ccb.cited = ccb1.cited AND ccb.citing <> ccb1.citing),
    StuduntBookPair AS (SELECT
                          buys.sid,
                          buys.bookno
                        FROM buys
                          INNER JOIN CitedTwiceByCheapBooks ctcb ON ctcb.cited = buys.bookno)

SELECT *
FROM StuduntBookPair;

\echo 'P4'

WITH

    NotHighest AS (SELECT DISTINCT book.bookno
                   FROM book
                     INNER JOIN book book1 ON book.price < book1.price),
    Not2Highest AS (SELECT DISTINCT book.bookno
                    FROM book
                      INNER JOIN Book book1 ON book.price < book1.price
                      INNER JOIN Book book2 ON book.price < book2.price
                    WHERE book1.bookno < book2.bookno)
SELECT bookno
FROM NotHighest
EXCEPT SELECT bookno
       FROM Not2Highest;

\echo 'P5'
WITH
    PricyBooks AS (SELECT bookno
                   FROM book
                   WHERE price > 50),
    StudentPricyBookPair AS (SELECT
                               buys.sid,
                               pb.bookno
                             FROM buys
                               CROSS JOIN PricyBooks pb),
    StudentWhoDidntBuyAllPricyBooks AS (SELECT
                                          sid,
                                          bookno
                                        FROM StudentPricyBookPair EXCEPT SELECT
                                                                           sid,
                                                                           bookno
                                                                         FROM buys)
SELECT sid
FROM buys
EXCEPT SELECT sid
       FROM StudentWhoDidntBuyAllPricyBooks;

\echo 'P6'
WITH
    CSStudent AS (SELECT sid
                  FROM Major
                  WHERE major = 'CS'),
    BooksOfCS AS (SELECT DISTINCT buys.bookno
                  FROM buys
                    INNER JOIN CSStudent cs ON cs.sid = buys.sid)
SELECT bookno
FROM book
EXCEPT SELECT bookno
       FROM BooksOfCS;

\echo 'P7'

WITH
    CSStudent AS (SELECT sid
                  FROM Major
                  WHERE major = 'CS'),
    CSStudentBookPair AS (SELECT
                            sid,
                            bookno
                          FROM book
                            CROSS JOIN CSStudent),
    BooksNotBoughtByAllCS AS (SELECT
                                sid,
                                bookno
                              FROM CSStudentBookPair
                              EXCEPT SELECT
                                       sid,
                                       bookno
                                     FROM buys)
SELECT DISTINCT bookno
FROM BooksNotBoughtByAllCS;

\echo 'P8'

WITH
    BuysBookPair AS (SELECT
                       buys.sid,
                       buys.bookno,
                       book.bookno AS citedbookno
                     FROM buys
                       CROSS JOIN book),
    StudentCitesPair AS (SELECT
                           student.sid,
                           cites.bookno,
                           cites.citedbookno
                         FROM student
                           CROSS JOIN cites),
    StudentNotCitesPair AS (SELECT *
                            FROM BuysBookPair EXCEPT SELECT *
                                                     FROM StudentCitesPair)
SELECT DISTINCT
  sid,
  citedbookno
FROM StudentNotCitesPair;



\echo 'P9'
WITH
    BuysBookPair AS (SELECT
                       buys.sid,
                       buys.bookno,
                       book.bookno AS citedbookno
                     FROM buys
                       CROSS JOIN book),
    StudentCitesPair AS (SELECT
                           student.sid,
                           cites.bookno,
                           cites.citedbookno
                         FROM student
                           CROSS JOIN cites),
    StudentNotCitesPair AS (SELECT *
                            FROM BuysBookPair EXCEPT SELECT *
                                                     FROM StudentCitesPair),
    StudentBookPair AS (SELECT
                          student.sid,
                          book.bookno
                        FROM student
                          CROSS JOIN book),
    result AS (SELECT
                 StudentBookPair.sid,
                 StudentBookPair.bookno
               FROM StudentBookPair EXCEPT SELECT
                                             StudentNotCitesPair.sid,
                                             StudentNotCitesPair.citedbookno
                                           FROM StudentNotCitesPair)
SELECT *
FROM result
ORDER BY sid;

\echo 'P10'
WITH

    BookCitesPair AS (SELECT
                        book.bookno,
                        book1.bookno AS citedbookno
                      FROM book
                        CROSS JOIN Book book1),
    BookNotCitesPair AS (SELECT
                           bookno,
                           citedbookno
                         FROM BookCitesPair EXCEPT SELECT
                                                     bookno,
                                                     citedbookno
                                                   FROM cites),
    BookNotCitesAtLeast3 AS (SELECT DISTINCT bnc.bookno
                             FROM BookNotCitesPair bnc INNER JOIN BookNotCitesPair bnc1 ON bnc.bookno = bnc1.bookno
                               INNER JOIN BookNotCitesPair bnc2 ON bnc.bookno = bnc2.bookno
                             WHERE bnc.citedbookno < bnc1.citedbookno
                                   AND bnc1.citedbookno < bnc2.citedbookno),
    BookNotCitesAtLeast2 AS (SELECT DISTINCT bnc.bookno
                             FROM BookNotCitesPair bnc INNER JOIN BookNotCitesPair bnc1 ON bnc.bookno = bnc1.bookno
                             WHERE bnc.citedbookno < bnc1.citedbookno
  )
SELECT bookno
FROM BookNotCitesAtLeast2
EXCEPT
SELECT bookno
FROM BookNotCitesAtLeast3;


DROP TABLE cites CASCADE;
DROP TABLE buys CASCADE;
DROP TABLE major CASCADE;
DROP TABLE book CASCADE;
DROP TABLE student CASCADE;