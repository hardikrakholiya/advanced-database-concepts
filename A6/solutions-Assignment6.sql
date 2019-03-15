-- Problem 1.a
SELECT  s.sid, b1.bookno
FROM    student s, buys b1, buys b2
WHERE   s.sid = b1.sid AND s.sid= b2.sid AND
        b1.bookno <> b2.bookno AND
        s.sname = 'Eric' and b1.bookno <> 2010;


-- Please consult the solutions-2017-Assignment6.pdf file to
-- follow the optimization in SQL

WITH  SE AS (SELECT s.sid FROM Student s WHERE s.sname = 'Eric'),
      E AS
      (SELECT  q0.sid as b1sid, q0.bookno as b1bookno ,b2.sid as b2sid
       FROM    (SELECT B1.sid, B1.bookno
                FROM   buys B1
                WHERE  B1.bookno <> 2010) q0
                   INNER JOIN buys B2 ON (q0.bookno<>B2.bookno))
SELECT s.sid, e.b1bookno
FROM SE s INNER JOIN E e ON (s.sid = E.b1sid and s.sid = E.b2sid);

--  An alternative solution would be

WITH  SE AS (SELECT s.sid FROM Student s WHERE s.sname = 'Eric'),
      F AS
      (SELECT  q0.sid, q0.bookno
       FROM    (SELECT B1.sid, B1.bookno
                FROM   buys B1
                WHERE  B1.bookno <> 2010) q0
                   INNER JOIN buys B2 ON (q0.sid = b2.sid and q0.bookno<>B2.bookno))
SELECT sid, bookno
FROM SE  NATURAL JOIN F;
    


-- Problem 1.b

SELECT  DISTINCT b.bookno, b.title
FROM    book b, student s
WHERE   b.price = SOME(select b1.price
                       from   buys t, book b1
                       where  b1.price > 50 and
                              s.sid = t.sid and
                              t.bookno = b1.bookno); 


-- Replace = SOME using EXISTS

SELECT  DISTINCT b.bookno, b.title
FROM    book b, student s
WHERE   EXISTS (select 1
                from   buys t, book b1
                where  b1.price > 50 and
                       s.sid = t.sid and
                       t.bookno = b1.bookno and
                       b.price = b1.price); 


-- We need to push variable b and s down into the subquery and then
-- translate in a bottom up fashion.   Using the WITH command this becomes

WITH Subquery AS
       (SELECT  b2.bookno, b2.title, b2.price, s1.sid, s1.sname
        FROM    buys t CROSS JOIN book b1 CROSS JOIN book b2 CROSS JOIN student s1
        WHERE   b1.price > 50 and s1.sid = t.sid and
                t.bookno = b1.bookno and b2.price = b1.price)
SELECT  DISTINCT q0.bookno, q0.title
FROM    (book b CROSS JOIN student s) q0 
        NATURAL JOIN Subquery q1;


-- When we optimize, (1) we see that q1 is a subset of q0, 
--                     (2) and (q0.bookno, q0.title) is contained
--                         in the attribute list pf q1, 
-- we can immediate optimize to the following query

SELECT  DISTINCT b1.bookno, b1.title
FROM    buys t CROSS JOIN book b1 CROSS JOIN book b2 CROSS JOIN student s1
WHERE   b1.price > 50 and s1.sid = t.sid and
           t.bookno = b1.bookno and b2.price = b1.price;

-- For the rest of the optimization see the solutions pdf file

WITH E1 AS (SELECT b1.bookno, b1.price
            FROM   Book b1
            WHERE  b1.price > 50),
     F1 AS (SELECT s1.sid
            FROM   Student s1),
     F2 AS (SELECT t.bookno
            FROM   F1 f1 NATURAL JOIN Buys t),
     E2 AS (SELECT e1.price
            FROM  F2 f2  NATURAL JOIN E1 e1)
SELECT  b2.bookno, b2.title
FROM    E2 e2 NATURAL JOIN Book b2;


WITH E1 AS (SELECT b1.bookno, b1.price
            FROM   Book b1
            WHERE  b1.price > 50),
     F1 AS (SELECT s1.sid
            FROM   Student s1),
     F2 AS (SELECT t.bookno
            FROM   F1 f1 NATURAL JOIN Buys t),
     E2 AS (SELECT e1.price
            FROM  F2 f2  NATURAL JOIN E1 e1)
SELECT  distinct b2.bookno, b2.title
FROM  	E2 e2 NATURAL JOIN Book	b2;


-- Problem 1.c

SELECT b.bookno
FROM   book b
WHERE  b.bookno IN (SELECT b1.bookno FROM book b1 WHERE b1.price > 50)
                    UNION
                   (SELECT c.bookno FROM cites c);


-- Replacing IN by EXISTS

SELECT b.bookno
FROM   book b
WHERE  EXISTS ((SELECT 1
                FROM   book b1 
                WHERE  b.bookno = b1.bookno AND
                       b1.price > 50)
                    UNION
               (SELECT 1 
                FROM   cites c
                WHERE  b.bookno = c.bookno));

-- Pushing variable down in each of the two sub-queries and
-- forming their union


(SELECT b2.bookno, b2.title, b2.title
 FROM   book b1, book b2 
 WHERE  b2.bookno = b1.bookno AND
        b1.price > 50)
UNION
(SELECT b3.bookno, b3.title, b3.title
 FROM   cites c, book b3
 WHERE  b3.bookno = c.bookno);

-- Its RA translation is

(SELECT b2.bookno, b2.title, b2.title
 FROM   book b1 CROSS JOIN book b2 
 WHERE  b2.bookno = b1.bookno AND
        b1.price > 50)
UNION
(SELECT b3.bookno, b3.title, b3.title
 FROM   cites c CROSS JOIN book b3
 WHERE  b3.bookno = c.bookno);

-- Now we need to perform a semi-join (natural join) with outer query
-- I'm using the WITH statement for this

WITH Subquery AS (
         (SELECT b2.bookno, b2.title, b2.price
          FROM   book b1 CROSS JOIN book b2 
          WHERE  b2.bookno = b1.bookno AND
                  b1.price > 50)
         UNION
         (SELECT b3.bookno, b3.title, b3.price
          FROM   cites c CROSS JOIN book b3
          WHERE  b3.bookno = c.bookno))
SELECT b.bookno
FROM   book b NATURAL JOIN Subquery q;

-- The RA expression is
--

-- pi_{Book.bookno}(Book semi-join 
--       ( pi_{B3.bookno,B3.title,B3.price}(
--                 sigma_{B1.bookno = B2.bookno and B1.price>50}(B1 X B2))
--         union
--         pi_{B3.bookno,B3.title,B3.price}(sigma_{B3.bookno = c.bookno}(Cites X B3))
--       )
-- Here B1, B2, B3 are copies of Book

-- This will eventually get optimized to

-- pi_{Book.bookno}(\sigma_{Book.price > 50}(Book))
-- union
-- pi_{Cites.bookno}(Cites)

-- Or in SQL

(SELECT b.bookno
 FROM   Book b
 WHERE  b.price > 50)
UNION
(SELECT c.bookno
 FROM   cites c);


-- Problem 1.d

SELECT b.bookno FROM book b
WHERE b.price >= 80 and
      NOT EXISTS(SELECT distinct b1.bookno
      FROM book b1
      WHERE b1.Price > b.Price);


-- After pushing variable b down and then translating bottom up we get
-- the following expression
-- Note that in general (E anti-semijoin F) = E - (E semijoin F)

WITH  E AS (SELECT b.bookno, b.title, b.price
            FROM   Book b
            WHERE  b.price >=80),
      F AS (SELECT b2.bookno, b2.title, b2.price
                   FROM   book b1, book b2
                   WHERE  b1.price > b2.price),
      Semijoin AS (SELECT bookno, title, price
                   FROM   E NATURAL JOIN F)
SELECT q1.bookno
FROM   ((SELECT b.bookno, b.title, b.price
        FROM   Book b
        WHERE  b.price >= 80)
        EXCEPT
       (SELECT * 
        FROM   Semijoin)) q1;


-- After optimization, we get the following expression.
-- For the details see the solutions pdf file

WITH  E AS (SELECT b.bookno, b.title, b.price
            FROM   Book b
            WHERE  b.price >=80),
      B1 AS (SELECT distinct b1.price
             FROM   book b1)
SELECT q1.bookno
FROM   ((SELECT e.bookno, e.title, e.price
         FROM   E e)
         EXCEPT
        (SELECT e.bookno, e.title, e.price
         FROM   B1 b1 INNER JOIN E e ON (b1.price > e.price))) q1;


-- Problem 1.e

SELECT s.sid
FROM   Student s
WHERE  EXISTS(SELECT 1
              FROM Book b
              WHERE b.price > 50 AND
                    b.bookno IN (SELECT	 t.bookno
                              	  FROM    Buys t
                                  WHERE   s.sid = t.sid AND
                                          s.sname = 'Eric'))

-- First we replace IN using EXISTS

SELECT s.sid
FROM   Student s
WHERE  EXISTS(SELECT 1
              FROM Book b
              WHERE b.price > 50 AND
                    EXISTS (SELECT 1
                            FROM   Buys t
                            WHERE  s.sid = t.sid AND
                                   s.sname = 'Eric' AND
                                   b.bookno = t.bookno));


-- Then we recursively push variable s and b down into the subtrees and
-- translate in a bottom-up fashion.  We use the WITH statement to break this
-- process down

WITH E1 AS (SELECT b1.bookno, b1.title, b1.price, s2.sid, s2.sname
            FROM   Buys t CROSS JOIN Book b1 CROSS JOIN Student s2
            WHERE  s2.sid = t.sid AND s2.sname = 'Eric' AND b1.bookno = t.bookno),
     E2 AS (SELECT s1.sid, s1.sname
            FROM   Book b CROSS JOIN Student s1
            WHERE  b.price > 50),
     E3 AS (SELECT e2.sid, e2.sname
            FROM   E2 e2 NATURAL JOIN E1)
SELECT DISTINCT s.sid 
FROM   Student S NATURAL JOIN E3;

-- The optimized expression is the following;
-- for the discussion see the solutions pdf file.
-- But in essence, we have pushed selections down cross joins
-- and semi-joins, we have introduced joins,
-- and pushed projections down.


WITH E1 AS (SELECT  s.sid
            FROM    Student s
            WHERE   s.sname = 'Eric'),
     E2 AS (SELECT  t.bookno, e1.sid
            FROM    Buys t NATURAL JOIN E1 e1),
     E3 AS (SELECT b.bookno
            FROM   Book b
            WHERE  b.price > 50)
SELECT DISTINCT sid
FROM   E3 NATURAL JOIN E2;


-- Problem 1.f

SELECT s1.sid, s2.sid 
FROM student s1, student s2
WHERE s1.sid <> s2.sid AND
      NOT EXISTS(SELECT 1 
                 FROM   Buys t1
                 WHERE  t1.sid = s1.sid AND
                        t1.bookno NOT IN (SELECT t2.bookno
                                          FROM   Buys t2
                                          WHERE  t2.sid = s2.sid));


-- First replace the NOT IN by NOT EXISTS


SELECT s1.sid, s2.sid 
FROM student s1, student s2
WHERE s1.sid <> s2.sid AND
      NOT EXISTS(SELECT 1 
                 FROM   Buys t1
                 WHERE  t1.sid = s1.sid AND
                        NOT EXISTS (SELECT 1
                                    FROM   Buys t2
                                    WHERE  t2.sid = s2.sid AND
                                           t1.bookno=t2.bookno));

CREATE VIEW St AS (SELECT DISTINCT sid from Student);

WITH E1 AS (SELECT t1.sid as t1sid, t1.bookno as t1bookno, 
                   t2.sid as t2sid, t2.bookno as t2bookno,
                   s1.sid as s1sid, 
                   s2.sid as s2sid
            FROM   Buys t2 CROSS JOIN Buys t1 CROSS JOIN St s1 CROSS JOIN St s2
            WHERE  t2.sid = s2.sid AND t1.bookno = t2.bookno),
     E2 AS (SELECT t1.sid as t1sid, t1.bookno as t1bookno, 
                   s1.sid as s1sid,
                   s2.sid as s2sid
            FROM   Buys t1 CROSS JOIN St s1 CROSS JOIN St s2
            WHERE  t1.sid = s1.sid),
     E2SemiJoinE1 AS
           (SELECT e2.t1sid, e2.t1bookno,
                   e2.s1sid, 
                   e2.s2sid
            FROM   E2 e2 NATURAL JOIN E1 e1),
     E2antiSemiJoinE1 AS
           ((SELECT *
             FROM   E2)
            EXCEPT
            (SELECT *
             FROM E2SemiJoinE1)),
     E3 AS (SELECT s1sid, s2sid
            FROM   E2antiSemiJoinE1),
     E4 AS (SELECT s1.sid as s1sid,
                   s2.sid as s2sid
            FROM   St s1 CROSS JOIN St s2
            WHERE  s1.sid <> s2.sid),
     E4SemiJoinE3 AS
           (SELECT e4.s1sid, 
                   e4.s2sid
            FROM E4 e4 NATURAL JOIN E3 e3),
     E4antiSemiJoinE3 AS
           ((SELECT *
             FROM   E4)
            EXCEPT
            (SELECT *
             FROM E4SemiJoinE3))
SELECT distinct s1sid, s2sid
FROM   E4antiSemiJoinE3;
           
-- Consult the file solutions-2017-Assignment6.pdf for the following optimization

WITH E4 AS (SELECT s1.sid as s1sid, s2.sid as s2sid
            FROM   St s1 INNER JOIN St s2 ON(s1.sid<>s2.sid)),
     F1 AS (SELECT t1.sid as t1sid, t1.bookno as t1bookno,
                   t2.sid as t2sid, t2.bookno as t2bookno 
            FROM   Buys t2 INNER JOIN Buys t1 ON (t1.bookno = t2.bookno)),
     E1 AS  (SELECT t1sid, t1bookno, s1sid, s2sid
             FROM   F1 INNER JOIN E4  ON (t1sid = s1sid and t2sid = s2sid)),
     F2 AS (SELECT t1.sid as t1sid, t1.bookno as t1bookno, 
                   s1.sid as s1sid
            FROM   Buys t1 INNER JOIN St s1 ON (t1.sid = s1.sid)),
     E2 AS (SELECT t1sid, t1bookno, s1sid, s2.sid as s2sid
            FROM   F2 INNER JOIN St s2 ON (s1sid <> s2.sid)),
     E3 AS (SELECT s1sid, s2sid
            FROM ((SELECT * FROM E2) EXCEPT (SELECT * FROM E1)) q)
SELECT * FROM E4
except 
SELECT * FROM E3;




