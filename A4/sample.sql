
-- Problem 1
-- Find the Sid and Sname of each student who bought a book that cites another book.

--  PROJECT_{Student.Sid, Sname}((Student NATURAL JOIN Buys) NATURAL JOIN Cites)
--  
--  E1 = Student NATURAL JOIN Buys NATURAL JOIN Cites
--  The result is the expression
--  PROJECT_{Sid,Sname}(E2);

WITH E1 AS (SELECT  Student.Sid, Sname, Bookno
            FROM    Student NATURAL JOIN Buys NATURAL JOIN Cites)
SELECT DISTINCT Sid, Sname FROM E1;

-- Problem 2
-- Find the Sid and Sname of each student who has at least two majors.

-- Major 1 = Rename major attribute in to Major to major1
-- PROJECT_{Sid, Sname}(Student NATURAL JOIN 
--             (SELECT_{major <> major1}(Major NATURAL JOIN Major1)))

WITH Major1 AS (SELECT Sid, Major AS Major1 FROM Major),
     E1     AS (SELECT Sid, Major.major, Major1.major1 
                FROM Major NATURAL JOIN Major1),
     E2     AS (SELECT  sid, major, major1
                FROM    E1
                WHERE   major <> major1)
SELECT DISTINCT sid, sname 
FROM Student NATURAL JOIN E2;

