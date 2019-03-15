-- The following is a relation representing a graph of edges between nodes.
-- An edge is represented as a (source,target) pair.
-- In this note, I will cover how to express in SQL query of the
-- form:  Find source nodes that have "a certain number" of
-- outgoing edges.  In various cases, I gave various method to do this.
-- This note show that it is possible in SQL to do a limited amount
-- of counting.


CREATE TABLE Graph(source integer, target integer);
 
INSERT INTO graph VALUES 
(    1 ,      1),
(    1 ,      2),
(    1 ,      6),
(    2 ,      3),
(    3 ,      4),
(    4 ,      5),
(    6 ,      7),
(    7 ,      8),
(    8 ,      1),
(    4,       1),
(    4,       6),
(    6,       3);


-- Problem 1
-- Find the source nodes with at least one outgoing edge

select distinct e.source 
from   graph e 
order by e.source;

-- Problem 2
-- Find the source nodes with at two at least 2 outgoing edges

-- Method 1
select distinct e1.source 
from   graph e1, graph e2
where  e1.source = e2.source and e1.target <> e2.target
order by e1.source;

-- Method 2

select distinct e1.source 
from   graph e1
where  exists (select e2.target
               from   graph e2
               where  e2.source = e1.source and 
                      e1.target <> e2.target)
order by e1.source;


-- Problem 3
-- Find the source nodes with at least 3 outgoing edges

select distinct e.source
from   graph e
where exists(select *
             from graph e2, graph e3
             where  e2.source = e.source and
                    e3.source = e.source and
                    e.target <> e2.target and
                    e.target <> e3.target and
                    e2.target <> e3.target);


-- Problem 3
-- Find the source nodes with exactly one outgoing edge

-- Method 1
(select distinct e.source
from   graph e
order by e.source)
except
(select distinct e1.source
from   graph e1, graph e2
where  e1.source = e2.source and e1.target <> e2.target);

-- Method 2
select distinct e1.source 
from   graph e1
where not exists (select e2.target
                  from   graph e2
                  where  e2.source = e1.source and 
                         e1.target <> e2.target);

-- Problem 4
-- Find the source nodes with exactly two outgoing edges

select distinct e1.source
from   graph e1
where  exists(select e2.target
              from   graph e2
              where  e2.source = e1.source and
                     e1.target <> e2.target) and
       not exists(select *
                  from graph e2, graph e3
                  where  e2.source = e1.source and
                         e3.source = e1.source and
                         e1.target <> e2.target and
                         e1.target <> e3.target and
                         e2.target <> e3.target);




