
--Q1
CREATE TABLE Sailor
(
  Sid    INTEGER PRIMARY KEY,
  Sname  VARCHAR(20),
  Rating INTEGER,
  Age    INTEGER
);

CREATE TABLE Boat
(
  Bid   INTEGER PRIMARY KEY,
  Bname VARCHAR(15),
  Color VARCHAR(15)
);

CREATE TABLE Reserves
(
  Sid INTEGER REFERENCES Sailor(Sid),
  Bid INTEGER REFERENCES Boat(Bid),
  Day VARCHAR(10),
  PRIMARY KEY (Sid, Bid)
);

-- Inserts into Sailor relation
INSERT INTO sailor (sid, sname, rating, age) VALUES (22, 'Dustin', 7, 45);
INSERT INTO sailor (sid, sname, rating, age) VALUES (29, 'Brutus', 1, 33);
INSERT INTO sailor (sid, sname, rating, age) VALUES (31, 'Lubber', 8, 55);
INSERT INTO sailor (sid, sname, rating, age) VALUES (32, 'Andy', 8, 25);
INSERT INTO sailor (sid, sname, rating, age) VALUES (58, 'Rusty', 10, 35);
INSERT INTO sailor (sid, sname, rating, age) VALUES (64, 'Horatio', 7, 35);
INSERT INTO sailor (sid, sname, rating, age) VALUES (71, 'Zorba', 10, 16);
INSERT INTO sailor (sid, sname, rating, age) VALUES (74, 'Horatio', 9, 35);
INSERT INTO sailor (sid, sname, rating, age) VALUES (85, 'Art', 3, 25);
INSERT INTO sailor (sid, sname, rating, age) VALUES (95, 'Bob', 3, 63);

-- Inserts into Boat relation
INSERT INTO boat (bid, bname, color) VALUES (101, 'Interlake', 'blue');
INSERT INTO boat (bid, bname, color) VALUES (102, 'Interlake', 'red');
INSERT INTO boat (bid, bname, color) VALUES (103, 'Clipper', 'green');
INSERT INTO boat (bid, bname, color) VALUES (104, 'Marine', 'red');

-- inserts into Reserves relation
INSERT INTO reserves (sid, bid, day) VALUES (22, 101, 'Monday');
INSERT INTO reserves (sid, bid, day) VALUES (22, 102, 'Tuesday');
INSERT INTO reserves (sid, bid, day) VALUES (22, 103, 'Wednesday');
INSERT INTO reserves (sid, bid, day) VALUES (31, 102, 'Thursday');
INSERT INTO reserves (sid, bid, day) VALUES (31, 103, 'Friday');
INSERT INTO reserves (sid, bid, day) VALUES (31, 104, 'Saturday');
INSERT INTO reserves (sid, bid, day) VALUES (64, 101, 'Sunday');
INSERT INTO reserves (sid, bid, day) VALUES (64, 102, 'Monday');
INSERT INTO reserves (sid, bid, day) VALUES (74, 103, 'Tuesday');

--Q2
-- Basically Primary Key constraint is a combination of Not NULL and UNIQUE constraint.
-- So it doesnt allow to insert NULL or duplicate values or a group of values like (c1,c2)
-- inserting NULL value to a column with Primary Key constraint fails with error
INSERT INTO boat (bid, bname, color) VALUES (NULL, 'Interlake', 'blue');
-- inserting duplicate value 101 to a column with Primary Key constraint fails with error
INSERT INTO boat (bid, bname, color) VALUES (101, 'Interlake', 'blue');
-- inserting duplicate group of values(sid, bid) to reserves relation fails with error
INSERT INTO reserves (sid, bid, day) VALUES (74, 103, 'Tuesday');

-- Presence of Foreign Key constraint requires that values being inserted matches with one of the values under the column
-- (of another table) referenced by the foreign key constraint.
-- inserting 99 as Sid to reserves would fail since there is no sailor with sid 99
INSERT INTO reserves (sid, bid, day) VALUES (99, 101, 'Monday');

-- Also presence of foreign keys disallows the deletion of any of the referenced tuple (in another table)
-- or update in column referenced. It will raise an error unless we explicitly specify to cascade deletions.
DELETE FROM sailor where sid = 22;

--Q3(a)
select Sid, Rating from Sailor;
--Q3(b)
select Bname as BoatName from Boat where Color = 'red';
--Q3(c)
select Bid as BoatId, Color from Boat;

--Q3(d)
SELECT S.Sname
FROM Sailor S
WHERE S.Sid IN
      (SELECT R.Sid
       FROM Reserves R
       WHERE R.Bid IN
             (SELECT Bid
              FROM Boat
              WHERE Color = 'red'
             )
      );

--This can also be done using inner join easily
--select DISTINCT S.Sname from Sailor S
--inner join Reserves R on S.Sid = R.Sid
--inner join Boat B on R.Bid = B.Bid and B.Color = 'red';

--Q3(e)
SELECT B.Bname
FROM Boat B
WHERE B.Bid IN
      (
        SELECT R.Bid
        FROM Reserves R
        WHERE R.Sid IN
              (
                SELECT S.Sid
                FROM Sailor S
                WHERE S.Age > 25
              )
      );

--Q3(f)

SELECT S.Sname
FROM Sailor S
WHERE S.Sid IN
      (
        SELECT R.Sid
        FROM Reserves R
        WHERE R.Bid IN
              (
                SELECT B.Bid
                FROM Boat B
                WHERE B.Color != 'red' AND B.Color != 'green'
              )
      );
--Q3(g)

SELECT B.Bname
FROM Boat B
WHERE B.Bid IN
      (
        SELECT R.Bid
        FROM Reserves R
        WHERE R.Sid IN
              (
                --sailors with blue boats
                SELECT S.Sid
                FROM Sailor S
                WHERE S.Sid IN
                      (
                        SELECT R.Sid
                        FROM Reserves R
                        WHERE R.Bid IN
                              (
                                SELECT B.Bid
                                FROM Boat B
                                WHERE B.Color = 'blue'
                              )
                      )
                INTERSECT
                --sailors with green boats
                SELECT S.Sid
                FROM Sailor S
                WHERE S.Sid IN
                      (
                        SELECT R.Sid
                        FROM Reserves R
                        WHERE R.Bid IN
                              (
                                SELECT B.Bid
                                FROM Boat B
                                WHERE B.Color = 'green'
                              )
                      )
              )
      );

--Q3(h)
SELECT B.Bid
FROM Boat B
WHERE B.Bid NOT IN
      (
        SELECT R.Bid
        FROM Reserves R
      );

--Q3(i)
SELECT bname
FROM Boat B
WHERE Bid IN
      (
        SELECT R1.Bid
        FROM Reserves R1, Reserves R2
        WHERE R1.Bid = R2.Bid
              AND R1.Sid != R2.Sid
      );

--Q3(j)
SELECT Sid
FROM Sailor S
WHERE Sid NOT IN
      (
        --Sailors having more than one boat reserved
        SELECT DISTINCT R1.Sid
        FROM Reserves R1, Reserves R2
        WHERE R1.Bid != R2.Bid
              AND R1.Sid = R2.Sid

      )
      AND --must have at least one boat reserved
      exists(
          SELECT R.Sid
          FROM Reserves R
          WHERE R.Sid = S.Sid
      );

DROP TABLE Reserves CASCADE;
DROP TABLE Sailor;
DROP TABLE Boat;

