

-- Problem EXAMPLE OF A SEMI SET-JOIN      
-- Find the sid of each student who only bought books that cost less than $30.
                          
-- Formulation in RA
-- PROJECT_{Sid}(Student) -
--      PROJECT_{Sid}(Buys - (PROJECT_{Sid}(Student) X PROJECT_{bookno}(\sigma_{Price <= 30}(Book))) 

-- Formulation in SQL with RA operations:

WITH BooksLessThan30 AS (SELECT bookno FROM Book WHERE Price < 30),
     Students    AS (SELECT  sid FROM Student),
     StudentBookPairs AS (SELECT  sid, bookno FROM Students CROSS JOIN BooksLessThan30),
     E              AS  ( (SELECT sid, bookno FROM Buys)
                          EXCEPT
                          (SELECT sid, bookno FROM StudentBookPairs) ),
     StudentsBuyingBookHigherThan30  AS (SELECT sid FROM E)
(SELECT sid from Students)
EXCEPT
(SELECT sid from StudentsBuyingBookHigherThan30);


-- Problem EXAMPLE OF A SET-JOIN

-- Find the pairs (s1,s2) of sids of students such that
-- all books bought by student s1 are also books bought by student s2.
-- To solve this problem we will need to do some careful renaming of sid columns to properly refer
-- to student s1 and student s2, respectively

--     In relational algebra
--     S1 = (RENAME_{sid -> sid1}(Buys) X rename_{sid -> sid2}(PROJECT_{Sid}(Student))) 
--     
---    S2 = (RENAME_{sid -> sid1}(PROJECT_{Sid}(Student)) X RENAME_{sid -> sid2}(Buys))

--     PROJECT_{sid1}(rename_{sid -> sid1}(Student) X PROJECT_{sid2}(rename_{sid -> sid2}(Student)))
--            - PROJECT_{sid1,sid2}(S1 - S2)

--  In SQL with RA operations

WITH   
       Student1 AS (SELECT sid AS sid1 FROM Student),
       Student2 AS (SELECT sid AS sid2 FROM Student),
       Buys1    AS (SELECT sid AS sid1, bookno FROM Buys),
       Buys2    AS (SELECT bookno, sid AS sid2 FROM Buys),
       Buys1Student2Pairs AS (SELECT sid1, bookno, sid2 FROM Buys1 CROSS JOIN Student2),
       Student1Buys2Pairs AS (SELECT sid1, bookno, sid2 FROM Student1 CROSS JOIN Buys2),
       NotSubsetPairs AS ((SELECT sid1, bookno, sid2 FROM Buys1Student2Pairs)
                          EXCEPT
                          (SELECT sid1, bookno, sid2 FROM Student1Buys2Pairs)),
       Student1Student2Pairs AS (SELECT sid1, sid2 FROM Student1 CROSS JOIN Student2)
(SELECT sid1,sid2 FROM Student1Student2Pairs)
EXCEPT
(SELECT sid1,sid2 FROM NotSubsetPairs) order by sid1, sid2;




