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


CREATE OR REPLACE FUNCTION set_union(A ANYARRAY, B ANYARRAY)
  RETURNS ANYARRAY AS
$$
WITH
    Aset AS (SELECT UNNEST(A)),
    Bset AS (SELECT UNNEST(B))
SELECT array((SELECT *
              FROM Aset)
             UNION
             (SELECT *
              FROM Bset)
             ORDER BY 1);
$$ LANGUAGE SQL;

\echo '1(a)'

CREATE OR REPLACE FUNCTION set_intersection(A ANYARRAY, B ANYARRAY)
  RETURNS ANYARRAY AS
$$
WITH
    Aset AS (SELECT UNNEST(A)),
    Bset AS (SELECT UNNEST(B))
SELECT array((SELECT *
              FROM Aset)
             INTERSECT
             (SELECT *
              FROM Bset)
             ORDER BY 1);
$$ LANGUAGE SQL;

\echo '1(b)'

CREATE OR REPLACE FUNCTION set_difference(A ANYARRAY, B ANYARRAY)
  RETURNS ANYARRAY AS
$$
WITH
    Aset AS (SELECT UNNEST(A)),
    Bset AS (SELECT UNNEST(B))
SELECT array((SELECT *
              FROM Aset)
             EXCEPT
             (SELECT *
              FROM Bset)
             ORDER BY 1);
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION member_of(x ANYELEMENT, S ANYARRAY)
  RETURNS BOOLEAN AS
$$
SELECT x = SOME (S)
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION are_only_in(A ANYARRAY, B ANYARRAY)
  RETURNS BOOLEAN AS
$$
SELECT A <@ B;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION not_all_by_are(A ANYARRAY, B ANYARRAY)
  RETURNS BOOLEAN AS
$$
SELECT NOT (A <@ B);
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION has_all_of(A ANYARRAY, B ANYARRAY)
  RETURNS BOOLEAN AS
$$
SELECT B <@ A;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION none_of_in(A ANYARRAY, B ANYARRAY)
  RETURNS BOOLEAN AS
$$
SELECT NOT A && B;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION not_by_all_of(A ANYARRAY, B ANYARRAY)
  RETURNS BOOLEAN AS
$$
SELECT NOT (B <@ A);
$$ LANGUAGE SQL;


CREATE OR REPLACE VIEW student_books AS
  SELECT
    s.sid,
    array(SELECT t.bookno
          FROM buys t
          WHERE t.sid = s.sid
          ORDER BY bookno) AS books
  FROM student s
  ORDER BY sid;


SELECT *
FROM student_books;

\echo '2(a)'

CREATE OR REPLACE VIEW book_students AS
  SELECT
    b.bookno,
    array(SELECT t.sid
          FROM buys t
          WHERE t.bookno = b.bookno
          ORDER BY sid) AS students
  FROM book b
  ORDER BY bookno;

SELECT *
FROM book_students;

\echo '2(b)'

CREATE OR REPLACE VIEW book_citedbooks AS
  SELECT
    b.bookno,
    array(SELECT c.citedbookno
          FROM cites c
          WHERE c.bookno = b.bookno
          ORDER BY citedbookno) AS citedbooks
  FROM book b
  ORDER BY bookno;

SELECT *
FROM book_citedbooks;

\echo '2(c)'

CREATE OR REPLACE VIEW book_citingbooks AS
  SELECT
    b.bookno,
    array(SELECT c.bookno
          FROM cites c
          WHERE c.citedbookno = b.bookno
          ORDER BY bookno) AS citingbooks
  FROM book b
  ORDER BY bookno;

SELECT *
FROM book_citingbooks;

\echo '2(d)'

CREATE OR REPLACE VIEW major_students AS
  SELECT
    DISTINCT
    m.major,
    array(SELECT m1.sid
          FROM major m1
          WHERE m1.major = m.major
          ORDER BY sid) AS students
  FROM major m
  ORDER BY major;


SELECT *
FROM major_students;

\echo '2(e)'
CREATE OR REPLACE VIEW student_majors AS
  SELECT
    DISTINCT
    s.sid,
    array(SELECT m1.major
          FROM major m1
          WHERE m1.sid = s.sid
          ORDER BY major) AS majors
  FROM student s
  ORDER BY sid;


SELECT *
FROM student_majors;

\echo '3(a)'
--Find the bookno of each book that is cited by at least two books that cost less than $50.
WITH
    booksBelow50 AS (
      SELECT array(SELECT bookno
                   FROM book
                   WHERE price < 50)
  )
SELECT bookno
FROM
  book_citingbooks bcitingb, booksBelow50
WHERE cardinality(set_intersection(bcitingb.citingbooks, booksBelow50.array)) > 1;

\echo '3(b)'
-- Find the bookno and title of each book that was bought by a student who majors in CS and in Math.

WITH
    CSMathStudent AS (SELECT DISTINCT s.sid
                      FROM student s, major_students ms1, major_students ms2
                      WHERE ms1.major = 'CS' AND ms2.major = 'Math' AND
                            member_of(s.sid, set_intersection(ms1.students, ms2.students))
  ),
    CSMathBooks AS (SELECT sb.books
                    FROM student_books sb, CSMathStudent csms
                    WHERE csms.sid = sb.sid)

SELECT
  DISTINCT
  b.bookno,
  b.title
FROM book b, CSMathBooks csmb
WHERE member_of(b.bookno, csmb.books)
ORDER BY bookno;

\echo '3(c)'
-- Find the sid-bookno pairs (s; b) pairs such student s bought book b and such that book b is cited by at least two books that cost less than $50.
WITH
    books_below50 AS (
      SELECT array(SELECT bookno
                   FROM book
                   WHERE price < 50)
  ),
    booksCitedBy2 AS (
      SELECT bookno
      FROM
        book_citingbooks bcitingb, books_below50
      WHERE cardinality(set_intersection(bcitingb.citingbooks, books_below50.array)) > 1
  )
SELECT
  unnest(bs.students) AS sid,
  bs.bookno
FROM book_students bs, booksCitedBy2 bc2
WHERE bs.bookno = bc2.bookno;

\echo '3(d)'
--Find the bookno of each book that is cited by exactly one book.
SELECT bookno
FROM book_citingbooks bcitingb
WHERE cardinality(bcitingb.citingbooks) = 1;

\echo '3(e)'
-- Find the sid of each student who bought all books that cost more than $50.


WITH
    books_over50 AS (
      SELECT array(SELECT bookno
                   FROM book
                   WHERE price > 50)
  )
SELECT sb.sid
FROM student_books sb, books_over50
WHERE has_all_of(sb.books, books_over50.array);

\echo '3(f)'
-- Find the sid of each student who bought no book that cost more than $50.


WITH
    books_over50 AS (
      SELECT array(SELECT bookno
                   FROM book
                   WHERE price > 50)
  )
SELECT sb.sid
FROM student_books sb, books_over50
WHERE none_of_in(sb.books, books_over50.array);

\echo '3(g)'
--Find the sid of each student who bought only books that cost more than $50

WITH
    books_over50 AS (
      SELECT array(SELECT bookno
                   FROM book
                   WHERE price > 50)
  )
SELECT sb.sid
FROM student_books sb, books_over50
WHERE are_only_in(sb.books, books_over50.array);

\echo '3(h)'
--Find the sids and names of students who bought exactly one book that cost less than $50.
WITH
    books_below50 AS (
      SELECT array(SELECT bookno
                   FROM book
                   WHERE price < 50)
  ),
    studentsWith1Book AS (SELECT sb.sid
                          FROM student_books sb, books_below50
                          WHERE cardinality(set_intersection(sb.books, books_below50.array)) = 1)
SELECT
  s.sid,
  s.sname
FROM student s, studentsWith1Book
WHERE s.sid = studentsWith1Book.sid;

\echo '3(i)'
--Find the bookno of each book that was not bought by any students who majors in CS.
WITH
    CSStudents AS (
      SELECT ms.students
      FROM major_students ms
      WHERE ms.major = 'CS')
SELECT bs.bookno
FROM book_students bs, CSStudents
WHERE none_of_in(bs.students, CSStudents.students);

\echo '3(j)'
--Find the Bookno of each book that was not bought by all students who major in Anthropology.

WITH AnthroStudents AS (
    SELECT ms.students
    FROM major_students ms
    WHERE ms.major = 'Anthropology'
)

SELECT bs.bookno
FROM book_students bs, AnthroStudents
WHERE not_by_all_of(bs.students, AnthroStudents.students);

\echo '3(k)'
--Find the sids of students who major in 'CS' and who did not buy any of the books bought by the students who major in 'Math'
WITH MathStudents AS (SELECT ms.students
                      FROM major_students ms
                      WHERE major = 'Math')
  , MathBooks AS (SELECT sb.books
                  FROM student_books sb, MathStudents ms
                  WHERE member_of(sb.sid, ms.students))
  , CSstudent AS (SELECT ms.students
                  FROM major_students ms
                  WHERE major = 'CS')
SELECT DISTINCT sb.sid
FROM student_books sb, MathBooks mb, CSstudent cs
WHERE member_of(sid, cs.students)
      AND none_of_in(sb.books, mb.books);


\echo '3(l)'
--Find sid-bookno pairs (s, b) such that not all books bought by students are books that cite book b.
SELECT
  sb.sid,
  bcitingb.bookno
FROM student_books sb, book_citingbooks bcitingb
WHERE not_all_by_are(sb.books, bcitingb.citingbooks);

\echo '3(m)'
-- Find sid-bookno pairs (s, b) such student s only bought books that cite book b.
SELECT
  sb.sid,
  bcitingb.bookno
FROM student_books sb, book_citingbooks bcitingb
WHERE are_only_in(sb.books, bcitingb.citingbooks);

\echo '3(n)'
--Find the pairs (s1, s2) of different sids of students that buy the same books
SELECT
  sb1.sid,
  sb2.sid
FROM student_books sb1, student_books sb2
WHERE has_all_of(sb1.books, sb2.books)
      AND has_all_of(sb2.books, sb1.books)
      AND sb1.sid <> sb2.sid;

\echo '3(o)'
--Find the pairs (s1, s2) of different sids of students that buy the same number of books.
SELECT
  sb1.sid,
  sb2.sid
FROM student_books sb1, student_books sb2
WHERE cardinality(sb1.books) = cardinality(sb2.books)
      AND sb1.sid <> sb2.sid
ORDER BY sb1.sid, sb2.sid;
\echo '3(p)'
-- Find the bookno of each book that cites all but two books.
-- (In other words, for such a book, there exists only two books that it does not cite.)
WITH
    allBooks AS (SELECT array(SELECT bookno
                              FROM book))
SELECT bcitedb.bookno
FROM book_citedbooks bcitedb, allBooks
WHERE cardinality(set_difference(allBooks.array, bcitedb.citedbooks)) = 2;

\echo '3(q)'
--Find student who bought fewer books than the number of books bought by students who major in Anthropology.
WITH
    AnthroStudents AS (SELECT ms.students
                       FROM major_students ms
                       WHERE major = 'Anthropology')
  , AnthroBooks AS (SELECT array(SELECT DISTINCT unnest(sb.books)
                                 FROM student_books sb, AnthroStudents anthros
                                 WHERE member_of(sb.sid, anthros.students)))
SELECT sb.sid
FROM student_books sb, AnthroBooks
WHERE cardinality(sb.books) < cardinality(AnthroBooks.array);

\echo '3(r)'
--Find the Bookno's of books that cite at least 2 books and are cited by fewer than 4 books
SELECT bcitedb.bookno
FROM book_citedbooks bcitedb, book_citingbooks bcitingb
WHERE bcitingb.bookno = bcitedb.BookNo
      AND cardinality(bcitedb.citedbooks) >= 2
      AND cardinality(bcitingb.citingbooks) < 4;
------------------------------------------------------

DROP TABLE book CASCADE;
DROP TABLE student CASCADE;
DROP TABLE cites CASCADE;
DROP TABLE buys CASCADE;
DROP TABLE major CASCADE;
