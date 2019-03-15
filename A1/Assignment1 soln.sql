-- Solutions for Asssignment 1

-- 1. Create a database in PostgreSQL that stores these relations.
-- Make sure to specify primary and foreign keys.

DROP TABLE sailor;

CREATE TABLE sailor(sid	integer, 
                    sname VARCHAR(20), 
                    rating integer, age integer,
                    PRIMARY KEY(sid));

INSERT INTO sailor VALUES(22,   'Dustin',       7,      45);
INSERT INTO sailor VALUES(29,   'Brutus',       1,      33);
INSERT INTO sailor VALUES(31,   'Lubber',       8,      55);
INSERT INTO sailor VALUES(32,   'Andy',         8,      25);
INSERT INTO sailor VALUES(58,   'Rusty',        10,     35);
INSERT INTO sailor VALUES(64,   'Horatio',      7,      35);
INSERT INTO sailor VALUES(71,   'Zorba',        10,     16);
INSERT INTO sailor VALUES(74,   'Horatio',      9,      35);
INSERT INTO sailor VALUES(85,   'Art',          3,      25);
INSERT INTO sailor VALUES(95,   'Bob',          3,      63);

SELECT * FROM sailor;

DROP TABLE boat;

CREATE TABLE boat (bid integer, 
                   bname VARCHAR(15), 
                   color VARCHAR(15), 
                   primary key(bid));

INSERT INTO boat VALUES(101,    'Interlake',    'blue');
INSERT INTO boat VALUES(102,    'Interlake',    'red');
INSERT INTO boat VALUES(103,    'Clipper',      'green');
INSERT INTO boat VALUES(104,    'Marine',       'red');


DROP TABLE reserves;

CREATE TABLE reserves(sid integer, 
                      bid integer, 
                      day varchar(10), 
                      PRIMARY KEY(sid, bid),
                      FOREIGN KEY (sid) REFERENCES sailor(sid),
                      FOREIGN KEY (bid) REFERENCES boat(bid));

INSERT INTO reserves VALUES(22,	101,	'Monday');
INSERT INTO reserves VALUES(22,	102,	'Tuesday');
INSERT INTO reserves VALUES(22,	103,	'Wednesday');
INSERT INTO reserves VALUES(31,	102,	'Thursday');
INSERT INTO reserves VALUES(31,	103,	'Friday');
INSERT INTO reserves VALUES(31,      104,	'Saturday');
INSERT INTO reserves VALUES(64,	101,	'Sunday');
INSERT INTO reserves VALUES(64,	102,	'Monday');
INSERT INTO reserves VALUES(74,	103,	'Tuesday');

SELECT * FROM reserves;


-- 2. Provide examples that illustrate how the presence of primary and
--    foreign keys affects insert and deletes in these relations.

INSERT INTO sailor VALUES(22, 'John', 5, 30);
-- ERROR:  duplicate key value violates unique constraint "sailor_pkey"
-- DETAIL:  Key (sid)=(22) already exists.

INSERT INTO reserves(100, 100, 'Monday');
-- ERROR:  syntax error at or near "100"
-- LINE 1: INSERT INTO reserves(100, 100, 'Monday');

DELETE FROM sailor WHERE sid = 22;
-- ERROR:  update or delete on table "sailor" violates foreign key constraint
-- "reserves_sid_fkey" on table "reserves"
-- DETAIL:  Key (sid)=(22) is still referenced from table "reserves".

-- Let us now reconsider CASCADING deletes by redefining 
-- the FOREIGN KEY sid in reserves

DROP TABLE reserves;

CREATE TABLE reserves(sid integer, bid integer, day varchar(10), 
                      PRIMARY KEY(sid, bid),
                      FOREIGN KEY (sid) REFERENCES sailor(sid) ON DELETE CASCADE,
                      FOREIGN KEY (bid) REFERENCES boat(bid)) ON DELETE CASCADE);

INSERT INTO reserves VALUES(22,	101,	'Monday');
INSERT INTO reserves VALUES(22,	102,	'Tuesday');
INSERT INTO reserves VALUES(22,	103,	'Wednesday');
INSERT INTO reserves VALUES(31,	102,	'Thursday');
INSERT INTO reserves VALUES(31,	103,	'Friday');
INSERT INTO reserves VALUES(31, 104,	'Saturday');
INSERT INTO reserves VALUES(64,	101,	'Sunday');
INSERT INTO reserves VALUES(64,	102,	'Monday');
INSERT INTO reserves VALUES(74,	103,	'Tuesday');

delete from sailor where sid = 22;
-- DELETE 1
select * from reserves ;

-- sid | bid |   day    
-- ---+-----+----------
--  31 | 102 | Thursday
--  31 | 103 | Friday
--  31 | 104 | Saturday
--  64 | 101 | Sunday
--  64 | 102 | Monday
--  74 | 103 | Tuesday
-- (6 rows)


-- Problem 3
-- Populating the database

DROP TABLE sailor;

CREATE TABLE sailor(sid	integer, sname VARCHAR(20), rating integer, age integer,
             		    PRIMARY KEY(sid));

INSERT INTO sailor VALUES(22,   'Dustin',       7,      45);
INSERT INTO sailor VALUES(29,   'Brutus',       1,      33);
INSERT INTO sailor VALUES(31,   'Lubber',       8,      55);
INSERT INTO sailor VALUES(32,   'Andy',         8,      25);
INSERT INTO sailor VALUES(58,   'Rusty',        10,     35);
INSERT INTO sailor VALUES(64,   'Horatio',      7,      35);
INSERT INTO sailor VALUES(71,   'Zorba',        10,     16);
INSERT INTO sailor VALUES(74,   'Horatio',      9,      35);
INSERT INTO sailor VALUES(85,   'Art',          3,      25);
INSERT INTO sailor VALUES(95,   'Bob',          3,      63);

SELECT * FROM sailor;


DROP TABLE boat;

CREATE TABLE boat (bid integer, bname VARCHAR(15), color VARCHAR(15), primary key(bid));

INSERT INTO boat VALUES(101,    'Interlake',    'blue');
INSERT INTO boat VALUES(102,    'Interlake',    'red');
INSERT INTO boat VALUES(103,    'Clipper',      'green');
INSERT INTO boat VALUES(104,    'Marine',       'red');


DROP TABLE reserves;

CREATE TABLE reserves(sid integer, bid integer, day varchar(10), 
                      PRIMARY KEY(sid, bid),
                      FOREIGN KEY (sid) REFERENCES sailor(sid),
                      FOREIGN KEY (bid) REFERENCES boat(bid));

INSERT INTO reserves VALUES(22,	101,	'Monday');
INSERT INTO reserves VALUES(22,	102,	'Tuesday');
INSERT INTO reserves VALUES(22,	103,	'Wednesday');
INSERT INTO reserves VALUES(31,	102,	'Thursday');
INSERT INTO reserves VALUES(31,	103,	'Friday');
INSERT INTO reserves VALUES(31,      104,	'Saturday');
INSERT INTO reserves VALUES(64,	101,	'Sunday');
INSERT INTO reserves VALUES(64,	102,	'Monday');
INSERT INTO reserves VALUES(74,	103,	'Tuesday');

SELECT * FROM reserves;

-- 3.a Find the Sid and rating of each sailor.

select s.sid, s.rating 
from   sailor s;

-- sid | rating 
-- ---+--------
--  22 |      7
--  29 |      1
--  31 |      8
--  32 |      8
--  58 |     10
--  64 |      7
--  71 |     10
--  74 |      9
--  85 |      3
--  95 |      3
-- (10 rows)

-- 3.b Find the name of each red boat.
select b.bname 
from   boat b 
where  b.color = 'red';

--   bname   
-- -----------
--  Interlake
--  Marine
-- (2 rows)

-- 3.c Find the color of each boat.

select b.color 
from   boat b;

--  color 
-- -------
--  blue
--  red
--  green
--  red
-- (4 rows)

-- 3.d Find the name of each sailor who reserved a red boat.

select s.sname 
from   sailor s
where  s.sid IN (select r.sid
                 from   reserves r, boat b
                 where  r.bid = b.bid and b.color = 'red');

--  sname  
-- -------
--  Dustin
--  Lubber
--  Horatio
-- (3 rows)

-- Alternative solution (with IN predicate; this solution can be implemented
-- more efficiently then the previous one.))

select s.sname 
from  sailor s 
where s.sid in (select r.sid 
                from   reserves r 
                where  r.bid in (select b.bid 
                                 from   boat b 
                                 where b.color = 'red'));


-- 3.e Find the name of each boat that was reserved by a sailor older
--     than 25 years.

select b.bname
from   boat b
where  b.bid IN (select r.bid
                 from   reserves r, sailor s
                 where  r.sid = s.sid and s.age > 25);

--   bname   
-- -----------
--  Interlake
--  Interlake
--  Clipper
--  Marine
-- (4 rows)

-- 3.f  Find the name of each sailor who reserved a boat whose color is
--      not red or not green.  
---     Notice that the condition 
--      (b.color <> 'red' or b.color <> 'green') is always true; 
--      nonetheless not all
--      sailor names are returned because there are sailors who did not 
--      reserves any boats.

select s.sname 
from   sailor s
where  s.sid IN (select r.sid 
                 from   reserves r, boat b
                 where  r.bid = b.bid and 
                 (b.color <> 'red' or b.color <> 'green'));

--   sname  
-- -------
-- Dustin
-- Lubber
-- Horatio
-- Horatio
-- (4 rows)

-- 3.g Find the name of each boat that was reserved by a sailor who has
--     reserved a blue and a green boat.
--     Notice that the inner query provide the sids of sailors who have
--     reserved a green and a red boat; ones these sids are discovered, the
--     outer query will than find the names of all the boats that have been
--     reserved the sailors with these sids.

select b.bname 
from   boat b
where  b.bid IN
           (select r.bid from reserves r
            where  r.sid IN 
               ((select r.sid from reserves r, boat b where r.bid = b.bid and b.color = 'blue')
                 intersect
                (select r.sid from reserves r, boat b where r.bid = b.bid and b.color = 'green')));

--    bname   
-- ---------
--  Interlake
--  Interlake
--  Clipper
-- (3 rows)

-- 3.h Find the Bid's of boats that were not reserved.
-- The query (select b.bid from   boat b) gives the set of bids of all boats;
-- The query (select r.bid from   reserves r) gives the set of bids of all boats that
-- have been reserved;  so the set difference of these two sets gives the bids of
-- all boats that have not been reserved.

(select b.bid
 from   boat b)
except
(select r.bid
 from   reserves r);

--  bid 
-- -----
-- (0 rows)

-- 3.i Find the name each boat that was reserved by at least two sailors.

select b.bname
from   boat b 
where  b.bid IN (select r1.bid
                 from   reserves r1, reserves r2
                 where  r1.bid = r2.bid and r1.sid <> r2.sid);

--   bname   
-- -----------
--  Interlake
--  Interlake
--  Clipper
-- (3 rows)

-- 3.j Find the Sid's of sailors who reserved exactly one boat.
--     The query (select r.sid from   reserves r) gives the set sids of sailors
--     who have reserved at least one boat;
--     The query 
--     (select r1.sid  from   reserves r1, reserves r2  where  r1.sid = r2.sid and r1.bid <> r2.bid);
--     gives the set sids of sailors who have reserved at least two boats;
--     Therefore, the set difference of these two sets give the sids of sailor who have
--     reserved exactly one boat.

(select r.sid
 from   reserves r)
except
(select r1.sid
 from   reserves r1, reserves r2
 where  r1.sid = r2.sid and r1.bid <> r2.bid);

-- sid 
-- -----
--  74
-- (1 row)
