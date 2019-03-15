-- In this note, we store in a relation Person persons
-- with their ages.
-- We write SQL queries to find the youngest and
-- the next youngest persons.

CREATE TABLE Person(pid integer, age integer);

INSERT INTO Person VALUES
     (1, 10), 
     (2, 10),
     (3, 15),
     (4, 20),
     (5, 25),
     (6, 25);


- Problem 1
-- Find the youngest person
-- Method 1

select p.pid 
from   person p
where  p.age <= ALL(select p1.age
                    from   person p1);

-- Method 2
select p.pid
from   person p
where  not exists (select p1.pid
                   from   person p1
                   where  p1.age < p.age);


-- Method 3
(select p.pid
 from   person p)
except
(select p1.pid
 from   person p1, person p2
 where  p1.age > p2.age);


-- Method 4  -- This method uses aggregate function "min" is is therefore
             -- not in Pure SQL
select pid
from   person 
where  age = (select min(age) from person);
                 

-- Find the next to youngest persons
-- The find the next to youngest person
select p.pid
from   person p
where  exists(select p1.pid
              from   person p1
              where  p1.age < p.age) and
       not exists (select p1.age
                   from   person p1, person p2
                   where  p1.age < p2.age and p2.age < p.age);


