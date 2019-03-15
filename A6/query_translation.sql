-- Original query:

SELECT s.sid
FROM   Student s
WHERE  EXISTS(SELECT 1
              FROM   Book b
              WHERE  b.price > 50 AND
                     b.bookno IN (SELECT t.bookno
                                  FROM   Buys t 
                                  WHERE  t.sid = s.sid and s.sname = 'Eric'));

-- Preprocess by replacing IN by EXISTS


SELECT s.sid
FROM   Student s
WHERE  EXISTS(SELECT 1
              FROM   Book b
              WHERE  b.price > 50 AND
                     EXISTS (SELECT 1
                             FROM   Buys t
                             WHERE  t.sid = s.sid and s.sname = 'Eric' and
                                    b.bookno = t.bookno));


-- Recursively push global variables down into subqueries

SELECT s.sid
FROM   Student s
WHERE  EXISTS(SELECT s1.sid, s1.sname
              FROM   Book b, Student s1
              WHERE  b.price > 50 AND
                     EXISTS (SELECT b1.bookno, b1.title, b1.price, s2.sid, s2.sname
                             FROM   Buys t, Book b1, Student s2
                             WHERE  t.sid = s2.sid and s2.sname = 'Eric' and
                                    b1.bookno = t.bookno));

-- Translate outermost most sub-query

SELECT s2.sid, s2.sname
FROM   Buys t CROSS JOIN Book b1 CROSS JOIN Student s2
WHERE  t.sid = s2.sid and s2.sname = 'Eric' and
       b1.bookno = t.bookno;

-- Translate middle subquery and dealing with the EXISTS clause using a semi-join;
-- Since SQL does not have semi-join, we will use the NATURAL join.

SELECT q2.sid, q2.sname
FROM   ((SELECT s1.sid, s1.sname FROM Book b CROSS JOIN Student s1 WHERE b.price > 50) q0
        NATURAL JOIN
       (SELECT s2.sid, s2.sname
        FROM   Buys t CROSS JOIN Book b1 CROSS Student s2
        WHERE  t.sid = s2.sid and s2.sname = 'Eric' and
               b1.bookno = t.bookno) q1) q2;


-- Translate outer query

SELECT DISTINCT s.sid
FROM Student s 
     NATURAL JOIN
     (SELECT q2.sid, q2.sname
      FROM   ((SELECT s1.sid, s1.sname FROM Book b CROSS JOIN Student s1 WHERE b.price > 50) q0
              NATURAL JOIN
             (SELECT s2.sid, s2.sname
              FROM   Buys t CROSS JOIN Book b1 CROSS JOIN Student s2
              WHERE  t.sid = s2.sid and s2.sname = 'Eric' and
                     b1.bookno = t.bookno) q1) q2) q3;




SELECT f.sid
FROM   
   (SELECT p.sid, p.sname
    FROM   Student s 
           NATURAL JOIN
             (SELECT q0.sid, q0.sname
              FROM 
                 ((SELECT  b.bookno, b.title, b.price,s1.sid, s1.sname
                   FROM    book b CROSS JOIN Student s1
                   WHERE   b.price > 50) q1
                      NATURAL JOIN 
                       (SELECT  b1.bookno, b1.title, b1.price, s2.sid, s2.sname
                        FROM    Buys t CROSS JOIN Book b1 CROSS JOIN Student s2
                        WHERE   b1.bookno = t.bookno AND
                                s2.sid = t.sid AND s2.sname = 'Eric') q2) q0) p) f;

-- Some variable component are not essential.  In out case b.title. Also b.price
-- is not essential in the inner query as well as in the inner query


SELECT f.sid
FROM   
   (SELECT p.sid, p.sname
    FROM   Student s 
           NATURAL JOIN
             (SELECT q0.sid, q0.sname
              FROM 
                 ((SELECT  b.bookno, s1.sid, s1.sname
                   FROM    book b CROSS JOIN Student s1
                   WHERE   b.price > 50) q1
                      NATURAL JOIN 
                       (SELECT  b1.bookno, s2.sid, s2.sname
                        FROM    Buys t CROSS JOIN Book b1 CROSS JOIN Student s2
                        WHERE   b1.bookno = t.bookno AND
                                s2.sid = t.sid AND s2.sname = 'Eric') q2) q0) p) f;

-- we can push the selections to the appropriate place and there are some
-- natural join in the inner most query; we can also push the selection for
-- s2.sname = Eric upwards


               SELECT  x.sid
               FROM    (Buys NATURAL JOIN (select bookno
                                             from   Book 
                                             where  price > 50) z) r  
                                               NATURAL JOIN (SELECT sid
                                                             FROM   Student
                                                             where  sname = 'Eric') x;





