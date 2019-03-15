-- Original query

 SELECT s.sid, s.sname
 FROM   Student s
 WHERE  EXISTS (SELECT 1
                FROM   Enroll e, Course c
                WHERE  s.sid = e.sid AND e.cno = c.cno AND c.dept = 'CS');


-- Push Student variable "s" down into the subquery; 
-- Notice that this changes the meaning of the query!

 SELECT DISTINCT s1.sid, s1.sname
 FROM   Student s1, Enroll e, Course c
 WHERE  s1.sid = e.sid AND e.cno = c.cno AND c.dept = 'CS';

-- This query translate to the RA expression

SELECT  DISTINCT s1.sid, s1.sname
FROM    Student s1 CROSS JOIN Enroll e CROSS JOIN Course c
WHERE   s1.sid = e.sid AND e.cno = c.cno AND c.dept = 'CS';

-- Translate the inner query and perform a semi-join with 
-- the translation of the outer query (this restores the meaning)

SELECT s.sid, s.sname
FROM   Student s  
         NATURAL JOIN (SELECT  DISTINCT s1.sid, s1.sname
                       FROM    Student s1 CROSS JOIN Enroll e CROSS JOIN Course c
                       WHERE   s1.sid = e.sid AND e.cno = c.cno AND c.dept = 'CS') q0;

 

-- We can now start optimizing
-- We will use some of the rewrite rules for RA and
-- exhibit their application in SQL.
-- To a significant extent this can be done quite naturally.
-- Notice that this actually gives a strategy to develop efficient
-- SQL queries.




-- Eliminate the semi-join operation between Student and the inner query


SELECT  DISTINCT s.sid, s.sname
FROM    Student s CROSS JOIN Enroll e CROSS JOIN Course c
WHERE   s.sid = e.sid AND e.cno = c.cno AND c.dept = 'CS';

-- Push the c.dept = 'CS' down towards the Course relation;

SELECT DISTINCT s.sid, s.sname
FROM   Student s CROSS JOIN Enroll e CROSS JOIN
                              (SELECT c.cno, c.cname, c.dept
                               FROM   Course c
                               WHERE  c.dept = 'CS') q0
WHERE   s.sid = e.sid AND e.cno = q0.cno;

-- The condition e.cno = q0.cno induces a natural join 

SELECT s.sid, s.sname
FROM   Student s CROSS JOIN
             (Enroll e NATURAL JOIN 
                (SELECT c.cno, c.cname, c.dept
                 FROM   Course c
                 WHERE   c.dept = 'CS') q1) q2 
WHERE  s.sid = q2.sid;

-- The condition s.sid = q2.sid induces  a natural join

SELECT s.sid, s.sname
FROM   Student s
          NATURAL JOIN (Enroll e NATURAL JOIN 
                          (SELECT c.cno, c.cname, c.dept
                           FROM   Course c
                           WHERE  c.dept = 'CS') q1) q2;


--  The SELECT s.sid, s.sname  can now be "pushed" down using the
--  variable elimination method.   In the process we loose
--  the c.cname, c.dept, e.grade attributes

SELECT q0.sid, q0.sname
FROM   
    (SELECT s.sid, s.sname
     FROM   Student s) q0
     NATURAL JOIN
       (SELECT q1.sid
        FROM (SELECT e.cno, e.sid FROM Enroll e) q1
              NATURAL JOIN 
             (SELECT c.cno 
              FROM   Course c
              WHERE  c.dept = 'CS') q2) q3;



--   We then notice that we have obtained the RA expression

     pi_{S.sid,S.sname}(Student) semi-join 
         pi_{E.sid)(pi_{E.sid,E.cno}(Enroll) semi-join pi_{C.cno}(\sigma_{dept = 'CS'}(Course)))
