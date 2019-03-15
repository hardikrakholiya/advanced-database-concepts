-- Solutions Assignment 7

-- Problem 1 
-- Find articulation points in a undirected graph.

-- Solution inpired by solution of Ms Mary Anne Smart (B461 Fall 2016) 

CREATE TABLE Graph(source INTEGER,target INTEGER);

create table if not exists TC(source integer, target integer);

create or replace function new_TC_pairs()
returns table (source integer, target integer) AS
$$
	(select TC.source, Temp.target
	from TC, Temp
	where TC.target = Temp.source)
	except
	(select source, target
	from TC);
$$ LANGUAGE SQL;

create or replace function Transitive_Closure()
returns void as $$
begin
	drop table if exists TC;
	create table TC(source integer, target integer);
	insert into TC select * from Temp;
	while exists(select * from new_TC_pairs())
	loop
		insert into TC select * from new_TC_pairs();
		end loop;
end;
$$ language plpgsql;

-- Is there a path in graph from a to b not through c?
create or replace function exists_path_not_through(a INTEGER, b INTEGER, c INTEGER)
returns boolean AS
$$
BEGIN
     drop table if exists Temp; 
     create table Temp(source integer, target integer);  

     insert into Temp
       select edge.source, edge.target    
       from Graph edge    
       where edge.source <> c and edge.target <> c;

       perform Transitive_Closure();

       return (select distinct (a,b) in 
                 (select pair.source, pair.target 
                  from TC pair));
END;
$$ LANGUAGE plpgsql;

-- Does removing all edges to/from node v result in some nodes a, b
-- such that there is no path from a to b?

create or replace function  articulation_point()
returns table (source integer) AS
$$
BEGIN
  return query (select distinct edge.source  
                from Graph edge  
                where exists (  
                   select e1.source, e1.target, e2.source, e2.target    
                   from Graph e1, Graph e2    
                   where e1.target = e2.source and e1.target = edge.source and 
                     not exists_path_not_through(e1.source, e2.target, edge.source)));
END;
$$ LANGUAGE plpgsql;


postgres=# select * from graph;
 source | target 
--------+--------
      1 |      2
      2 |      1
      1 |      3
      3 |      1
      2 |      3
      3 |      2
(6 rows)

postgres=# select articulation_point();
 articulation_point 
--------------------
(0 rows)


postgres=# select * from graph;
 source | target 
--------+--------
      1 |      2
      2 |      1
      1 |      3
      3 |      1
      2 |      3
      3 |      2
      2 |      4
      4 |      2
      2 |      5
      5 |      2
      4 |      5
      5 |      4
(12 rows)

postgres=# select articulation_point();
 articulation_point 
--------------------
                  2
(1 row)

postgres=# 

-- Problem 2
-- Find same generation pair in a Parent_Child (PC) graph.
-- Notice that we consider each pair (p,p) to be in the SG relation.

create or replace function new_SG_pairs()
returns table (source integer, target integer) AS
$$
(select   pc1.c as sibling1, pc2.c as sibling2
 from     SG, PC pc1, PC pc2 
 where    SG.sibling1=pc1.p and SG.sibling2 = pc2.p)
except
(select   *
 from     SG);
$$ language sql;

create or replace function Same_Generation()
returns void as 
$$
begin
   drop table if exists SG;
   create table SG(sibling1 integer, sibling2 integer); 

   insert into SG select distinct pc1.p as sibling1, pc1.p as sibling2 
                  from PC pc1
                  where not exists (select 1 from PC pc2 where pc2.c=pc1.p);

   while exists(select * from new_SG_pairs()) 
   loop
        insert into SG select * from new_SG_pairs();
   end loop;
end;
$$ language plpgsql;


postgres=# select * from pc;
 p | c 
---+---
 1 | 2
 1 | 3
 2 | 4
 3 | 6
 6 | 8
 1 | 5
 5 | 9
(7 rows)

postgres=# select * from sg order by 1,2;
 sibling1 | sibling2 
----------+----------
        1 |        1
        2 |        2
        2 |        3
        2 |        5
        3 |        2
        3 |        3
        3 |        5
        4 |        4
        4 |        6
        4 |        9
        5 |        2
        5 |        3
        5 |        5
        6 |        4
        6 |        6
        6 |        9
        8 |        8
        9 |        4
        9 |        6
        9 |        9
(20 rows)


Problem 3- Powerset of A

create or replace function make_singleton(x int) returns int[] AS
$$
select array[x];
$$ language sql;

create or replace function make_union(S int[], T int[]) returns int[] as
$$
with 
     Sset as (select UNNEST(S)),
     Tset as (select UNNEST(T))
select array( (select * from Sset) union (select * from Tset) order by 1);
$$ language sql;

create or replace function new_sets()
returns table (set int[]) AS
$$
(select   make_union(S1.S,S2.S)
 from     Powerset S1, Powerset S2)
except
(select   S
 from     Powerset);
$$ language sql;

create or replace function Powerset()
returns void as 
$$
begin
   drop table if exists Powerset;
   create table Powerset(S int[]);

   insert into Powerset select array[]::int[];

   insert into Powerset select make_singleton(x) from A;

   while exists(select * from new_sets()) 
   loop
        insert into Powerset select * from new_sets();
   end loop;
end;
$$ language plpgsql;


postgres=# select * from A order by 1;
 x 
---
 1
 2
 3
 4
 5
(5 rows)

postgres=# select Powerset();
 powerset 
----------
 
(1 row)

postgres=# select * from Powerset;
      s      
-------------
 {}
 {3}
 {4}
 {5}
 {1}
 {2}
 {1,4}
 {2,3}
 {1,3}
 {3,5}
 {4,5}
 {2,5}
 {1,5}
 {1,2}
 {3,4}
 {2,4}
 {1,3,5}
 {1,4,5}
 {1,2,3,5}
 {2,3,5}
 {1,2,5}
 {1,2,4,5}
 {2,4,5}
 {1,3,4}
 {1,3,4,5}
 {3,4,5}
 {1,2,3,4}
 {2,3,4}
 {1,2,4}
 {2,3,4,5}
 {1,2,3}
 {1,2,3,4,5}
(32 rows)

postgres=# 

--Problem 4   -- Solution by Ms Katherine Metcalf (B561 Fall 2016)
-- K-means clustering

-- Create the data set table of points that are to be used to create the clusters
CREATE TABLE Points (PId INTEGER, X FLOAT, Y FLOAT);
-- Create the table that will hold the centroids
CREATE TABLE Centroids (cid INTEGER, X FLOAT, Y FLOAT);
-- This tracks the centroid that each data point is assigned to
CREATE TABLE Cluster_Assignments (CId INTEGER, PId INTEGER, X FLOAT, Y FLOAT);
-- This tracks the previous cluster assignment of each data points
CREATE TABLE Prev_Cluster_Assignments (CId INTEGER, PId INTEGER, X FLOAT, Y FLOAT);

-- Insert random data points into Points where the X and Y values range between
-- 1.0 and 10.0.
INSERT INTO Points VALUES
  (1, floor(random()*(10-1+1))+1, floor(random()*(10-1+1))+1),
  (2, floor(random()*(10-1+1))+1, floor(random()*(10-1+1))+1),
  (3, floor(random()*(10-1+1))+1, floor(random()*(10-1+1))+1),
  (4, floor(random()*(10-1+1))+1, floor(random()*(10-1+1))+1),
  (5, floor(random()*(10-1+1))+1, floor(random()*(10-1+1))+1),
  (6, floor(random()*(10-1+1))+1, floor(random()*(10-1+1))+1),
  (7, floor(random()*(10-1+1))+1, floor(random()*(10-1+1))+1),
  (8, floor(random()*(10-1+1))+1, floor(random()*(10-1+1))+1),
  (9, floor(random()*(10-1+1))+1, floor(random()*(10-1+1))+1),
  (10, floor(random()*(10-1+1))+1, floor(random()*(10-1+1))+1);

-- This view tracks the number of data points in the data set
CREATE VIEW N AS (SELECT COUNT(1) FROM Points);

-- This function returns the number of data points that switched clusters
-- between iterations of the KMeans algorithm.
-- It takes nothing as input.
CREATE FUNCTION Switched () RETURNS BIGINT AS
$$
  SELECT COUNT(1)
  FROM Cluster_Assignments ca, Prev_Cluster_Assignments pca
  WHERE ca.PId = pca.PId AND ca.CId <> pca.CId;
$$ LANGUAGE SQL;

-- This function takes a X FLOAT and Y FLOAT value as input and returns an
-- INTEGER representing the cluster the given point should be assigned to
CREATE FUNCTION Assign_Cluster(xval FLOAT, yval FLOAT) RETURNS INTEGER AS
$$
  SELECT c_one.CId
  FROM Centroids c_one
  WHERE NOT EXISTS (SELECT c_two.CId
                   FROM Centroids c_two
                   WHERE |/((c_one.X - xval)^2.0 + (c_one.Y - yval)^2.0) > |/((c_two.X - xval)^2.0 + (c_two.Y - yval)^2.0));
$$ LANGUAGE SQL;

-- This is the kmeans function that learns that finds k centroids that define
-- the center of mass for the possible clusters in the data
-- It takes an INTEGER value k representing the number of centroids to learn
-- as input
CREATE FUNCTION KMeans(k INTEGER) RETURNS TABLE (cid INTEGER, X FLOAT, Y FLOAT) AS
$$
  BEGIN
  -- Populate the centroids table with k random points from the Points table
  INSERT INTO Centroids (SELECT p.PId as CId, p.X, p.Y
                         FROM Points p ORDER BY random() limit k);
  WHILE (NOT EXISTS(SELECT * FROM Prev_Cluster_Assignments) OR
         CAST(Switched() AS FLOAT) / CAST((SELECT * FROM N) AS FLOAT) > .1) LOOP
         -- Clear the table tracking the previous cluster each data point was
         -- assigned to.
         DELETE FROM Prev_Cluster_Assignments;
         -- Move data from the current to the previous cluster assignments table
         INSERT INTO Prev_Cluster_Assignments (SELECT * FROM Cluster_Assignments);
         -- Re-assign the clusters
         INSERT INTO Cluster_Assignments (SELECT Assign_Cluster(CAST(p.x AS FLOAT), CAST(p.y AS FLOAT)), p.Pid, p.X, p.Y
                                          FROM Points p);
        -- Update the centroids
        DELETE FROM Centroids;
        -- Update the centroids
        INSERT INTO Centroids (SELECT ca.CId,
                                      CAST(SUM(ca.X) AS FLOAT)/CAST(COUNT(1) AS FLOAT) AS X,
                                      CAST(SUM(ca.Y) AS FLOAT)/CAST(COUNT(1) AS FLOAT) AS Y
                               FROM Cluster_Assignments ca
                               GROUP BY(ca.CId));

  END LOOP;
  RETURN QUERY (SELECT * FROM Centroids);
  END;
$$ LANGUAGE PLPGSQL;

--SELECT * FROM KMeans(2);

-- The computations are done, so drop the tables
DROP VIEW IF EXISTS N;
DROP TABLE IF EXISTS Cluster_Assignments;
DROP TABLE IF EXISTS Prev_Cluster_Assignments;
DROP TABLE IF EXISTS Centroids;
DROP TABLE IF EXISTS Points;

-- Computations are done, so drop the functions
DROP FUNCTION IF EXISTS Switched ();
DROP FUNCTION IF EXISTS Assign_Cluster (FLOAT, FLOAT);
DROP FUNCTION IF EXISTS KMeans (INTEGER);


Problem 5 Hubs-Authorities   -- Solution by Ms Katherine Metcalf (B561 Fall 2016)

-- Create the Graph table
CREATE TABLE Graph (Source INTEGER, Target INTEGER);
-- Create the table of authority values
CREATE TABLE Authority (NodeId INTEGER, NScore FLOAT);
-- Create the table of hub values
CREATE TABLE Hub (NodeId INTEGER, NScore FLOAT);
-- Create the table that holds the temporary/intermediate authority values
CREATE TABLE Temp_Authority (NodeId INTEGER, NScore FLOAT);
-- Create the table that holds the temporary/intermediate hub values
CREATE TABLE Temp_Hub (NodeId INTEGER, NScore FLOAT);
-- This table is used to track the number of iterations the update iterations
-- that have been run on the authority and hub values
CREATE TABLE Num_Iters(Count INTEGER);

-- Create a view representing the size of the graph
CREATE VIEW N AS (SELECT COUNT(1) FROM ((SELECT DISTINCT g.Source FROM Graph g)
                                         UNION
                                        (SELECT DISTINCT g.Target FROM Graph g)) q);

-- Populate the initial authority values
INSERT INTO Authority (SELECT DISTINCT g.Target as NodeID, 
                          CAST(1 AS FLOAT)/CAST((SELECT * FROM N) AS FLOAT) AS NScore
                       FROM Graph g);
-- Populate the initial hub values
INSERT INTO Hub (SELECT DISTINCT g.Source as NodeID, 
                     CAST(1 AS FLOAT)/CAST((SELECT * FROM N) AS FLOAT) AS NScore
                 FROM Graph g);

CREATE FUNCTION HITS (maxiters INTEGER) 
        RETURNS TABLE (NodeID INTEGER, Authority_Score FLOAT, Hub_Score FLOAT) AS
$$
  BEGIN
  -- Update the authority and hub values for 50 iterations
  WHILE ((SELECT COUNT(1) FROM Num_Iters) < maxiters) LOOP
    -- Update the table tracking the number of iterations
    INSERT INTO Num_Iters (SELECT 1);
    -- Clear the tempoary authority values
    DELETE FROM Temp_Authority;
    -- Clear the tempoary hub values
    DELETE FROM Temp_Hub;
    -- Compute the intermediate authority values
    INSERT INTO Temp_Authority 
           (SELECT DISTINCT a.NodeID, 
              CAST(score.s AS FLOAT) / CAST((SELECT COUNT(1) FROM Authority) AS FLOAT)
            FROM Authority a, LATERAL(SELECT SUM(h.NScore) AS s
                                      FROM Graph g, Hub H
                                      WHERE a.NodeId = g.Target AND
                                           g.Source = h.NodeID) score);
    -- Compute the intermediate hub values
    INSERT INTO Temp_Hub (SELECT DISTINCT h.NodeId, 
                            CAST(score.s AS FLOAT) / CAST((SELECT COUNT(1) FROM Hub) AS FLOAT)
                          FROM Hub h, LATERAL(SELECT SUM(a.NScore) AS s
                                              FROM Graph g, Authority a
                                              WHERE h.NodeId = g.Source AND
                                                    g.Target = a.NodeID) score);

    -- Clear the authority and hub tables so that they can be updated
    DELETE FROM Authority; DELETE FROM Hub;

    -- Update the Authority values
    INSERT INTO Authority (SELECT * FROM Temp_Authority);
    -- Update the Hub values
    INSERT INTO Hub (SELECT * FROM Temp_Hub);

  END LOOP;

  RETURN QUERY ((SELECT a.NodeId, a.NScore AS Authority_Score, h.NScore AS Hub_Score
                 FROM Authority a, Hub h
                 WHERE a.NodeId = h.NodeId)
                UNION
                (SELECT a.NodeId, a.NScore AS Authority_Score, 0 AS Hub_Score
                 FROM Authority a
                 WHERE a.NodeId NOT IN (SELECT h.NodeId FROM Hub h))
                UNION
                (SELECT h.NodeId, 0 AS Authority_Score, h.NScore AS Hub_Score
                 FROM Hub h
                 WHERE h.NodeId NOT IN (SELECT a.NodeId FROM Authority a)));
  END;
$$ LANGUAGE PLPGSQL;

-- Return results to the terminal screen
SELECT a.NodeId, a.NScore AS Authority_Score FROM Authority a;
SELECT h.NodeId, h.NScore AS Hub_Score FROM Hub h;

-- The computations are done, so drop the tables
DROP VIEW IF EXISTS N;
DROP TABLE IF EXISTS Num_Iters;
DROP TABLE IF EXISTS Temp_Hub;
DROP TABLE IF EXISTS Temp_Authority;
DROP TABLE IF EXISTS Authority;
DROP TABLE IF EXISTS Hub;
DROP TABLE IF EXISTS Graph;

-- The computations are done so drop the function
DROP FUNCTION IF EXISTS Hits (INTEGER);

--Problem 6  Spanning Tree

-- Problem: Minumum Spanning Tree
-- The following is an implementation of Prim's Minimum Spanning Tree Algorithm

-- The following table will contain the SpanningTree
create table if not exists SpanningTree (
   Source integer,
   Target integer);

delete from SpanningTree;

create table if not exists RemainingEdges (
   Source integer,
   Target integer,
   Cost   integer);

delete from RemainingEdges;

create or replace function SP() returns void as
$$
declare v    integer;
        w    integer;
        n    integer;   --number of nodes in weightedgraph
        m    integer;   --number of edges in spanning tree
begin 
  m := 0;

  insert into RemainingEdges (select * from WeightedGraph);

  select count(distinct e.source) into n
  from   WeightedGraph e;

  select e.source, e.target into v, w
  from   WeightedGraph e
  where  e.cost <= ALL (select e1.cost
                        from   WeightedGraph e1)
  order by random() limit 1;

  insert into SpanningTree values (v,w), (w,v);

--  delete from RemainingEdges where ((source = v and target = w) or
--                                    (source = w and target = v));

  while (m < n-1) 
  loop
     m := m+1;
   
     delete from RemainingEdges 
            where source in (select e.source
                             from   SpanningTree e) and
                  target in (select e.source
                             from   SpanningTree e);

     select e.source, e.target into v, w
     from   RemainingEdges e
     where  e.cost <= ALL (select e1.cost
                           from   RemainingEdges e1)
     order by random() limit 1;     

     insert into SpanningTree values (v,w), (w,v);
  end loop;
end;
$$ language plpgsql;


select * from weightedgraph

-- source | target | cost 
--------+--------+------
--      1 |      2 |    5
--      2 |      1 |    5
--      1 |      3 |    3
--      3 |      1 |    3
--      2 |      3 |    2
--      3 |      2 |    2
--      2 |      5 |    2
--      5 |      2 |    2
--      3 |      5 |    4
--      5 |      3 |    4
--      2 |      4 |    8
--      4 |      2 |    8
-- (12 rows)

select * from SpanningTree;

-- source | target 
--------+--------
--      3 |      2
--      2 |      3
--      1 |      3
--      3 |      1
--      5 |      2
--      2 |      5
--      4 |      2
--      2 |      4
--(8 rows)







-- Problem 7  Heap and Heap Sort by Zikai Lin

﻿-- Implementing Heap Data Structure
DROP TABLE raw_data CASCADE;

CREATE TABLE IF NOT EXISTS raw_data (ind INTEGER,
				  val INTEGER
				  );

INSERT INTO raw_data VALUES (1, 3), (2, 1), (3, 2), (4, 0), (5, 7), (6, 8), (7,9), (8, 11),
 (9, 1), (10, 3);

SELECT * FROM raw_data;

-- Heap Data Structure, you can use CREATE TYPE to create a new data structure in sql,
-- but here, I prefered a table-like data structure.
DROP TABLE heap; 
CREATE TABLE IF NOT EXISTS heap(ind INTEGER, 
                                val INTEGER,
                                left_child INTEGER,
                                right_child INTEGER,
                                parent INTEGER);

DO $$
DECLARE 
    i INTEGER;
    n INTEGER := (SELECT COUNT(*) FROM raw_data);
    k INTEGER := n/2;
BEGIN
    INSERT INTO heap VALUES (0, NULL, NULL, NULL, NULL);

    FOR i IN SELECT ind FROM raw_data LOOP
	INSERT INTO heap SELECT * FROM raw_data WHERE ind = i;
	IF (i <= k) THEN
	    UPDATE heap SET left_child = 2*i WHERE ind = i;
	    UPDATE heap SET right_child = 2*i+1 WHERE ind = i;
	    IF (i > 1) THEN
	        UPDATE heap SET parent = i/2 WHERE ind = i;
	    ELSE
		UPDATE heap SET parent = NULL WHERE ind = i;
	    END IF;
	ELSE
	    UPDATE heap SET parent = i/2 WHERE ind = i;
	END IF;
    END LOOP;
END $$;

SELECT * FROM heap;



-- As describe in the resource page, we need several function to maintain the heap properties

CREATE OR REPLACE FUNCTION percolatingDown (k INTEGER, n INTEGER) 
	RETURNS void AS
$$
    DECLARE
        child INTEGER;
        tmp INTEGER := (SELECT val FROM heap WHERE ind = k);
    BEGIN
        WHILE (2*k <= n) LOOP
	    child := 2*k;

	    IF ((SELECT child <> n) 
	        AND 
	        ((SELECT val FROM heap WHERE ind = child) > (SELECT val FROM heap WHERE ind = child + 1)))
	    THEN
	        child := child + 1;
	    END IF;

	    IF (tmp > (SELECT val FROM heap WHERE ind = child)) THEN
	        UPDATE heap SET val = (SELECT val FROM heap WHERE ind = child) WHERE ind = k;
	    ELSE
		EXIT;
	    END IF;
	    k := child;
        END LOOP;
        UPDATE heap SET val = tmp WHERE ind = k;
    END;
$$ LANGUAGE plpgsql;   


-- Build the Heap
CREATE OR REPLACE FUNCTION build_heap() RETURNS VOID AS
$$
DECLARE n INTEGER := (SELECT COUNT(*) FROM heap) - 1;
DECLARE k INTEGER := n/2;

BEGIN
    WHILE k > 0 LOOP
	PERFORM percolatingDown(k);
	k := k-1;
    END LOOP;

END;
$$ LANGUAGE PLPGSQL;

CREATE TABLE IF NOT EXISTS sort_data (ind INTEGER,
				      val INTEGER);
				      
DELETE FROM sort_data;


-- Insert Method
CREATE OR REPLACE FUNCTION heap_insert(x INTEGER) RETURNS void AS
$$
DECLARE 
    n INTEGER := (SELECT count(*) FROM heap) - 1;
    pos INTEGER;
    
BEGIN 
    pos := n + 1;
    INSERT INTO heap VALUES (pos, x, NULL, NULL, pos/2);

    WHILE ((pos > 1) AND (x < (SELECT val FROM heap WHERE ind = pos/2))) LOOP
        UPDATE heap SET val = (SELECT val FROM heap WHERE ind = pos/2) WHERE ind = pos;
        pos := pos/2;

    END LOOP; 

    UPDATE heap SET val = x WHERE ind = pos;

    PERFORM percolatingDown(1, n+1);
END;    
$$ LANGUAGE PLPGSQL;

-- Delete Method
CREATE OR REPLACE FUNCTION heap_extract_min() RETURNS INTEGER AS
$$
DECLARE 
    n INTEGER := (SELECT COUNT(*) FROM heap);
    min INTEGER := (SELECT val FROM heap WHERE ind = 1);
BEGIN
    IF (n = 0) THEN
	RETURN NULL;
    END IF;

    DELETE FROM heap WHERE ind = 1;

    UPDATE heap SET ind = ind - 1 WHERE ind > 0;

    PERFORM percolatingDown(1, n-1);

    RETURN min;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM heap ORDER BY ind;
select heap_insert(4);	
SELECT heap_extract_min();
-- Heap Sort
CREATE OR REPLACE FUNCTION heap_sort() RETURNS VOID AS
$$
DECLARE 
    n INTEGER := (SELECT COUNT(*) FROM heap) - 1;
    i INTEGER := n;
    k INTEGER := 2;
    tmp INTEGER;

BEGIN
    PERFORM build_heap();
    WHILE (i > 0) LOOP
        tmp := (SELECT val FROM heap WHERE ind = i);
        UPDATE heap SET val = (SELECT val FROM heap WHERE ind = 1) WHERE ind = i;
        UPDATE heap SET val = tmp WHERE ind = 1;
        n := n - 1;
        PERFORM percolatingDown(1, n);
        
        i := i - 1;
    END LOOP;

    WHILE (k <= (SELECT COUNT(*) FROM heap)) LOOP
	INSERT INTO sort_data (SELECT k-1, h.val FROM heap h WHERE h.ind = (SELECT COUNT(*) FROM heap) - k +1);
        k := k+1;
    END LOOP;

END;


$$ LANGUAGE plpgsql;

select * from raw_data order by ind;
--
--  ind | val
-- -----+-----
--    1 |   3
--    2 |   1
--    3 |   2
--    4 |   0
--    5 |   7
--    6 |   8
--    7 |   9
--    8 |  11
--    9 |   1
--   10 |   3
-- (10 rows) 


select heap_sort();


select * from sort_data ORDER BY ind;
-- 
--  ind | val
-- -----+-----
--    1 |   0
--    2 |   1
--    3 |   2
--    4 |   3
--    5 |   3
--    6 |   4
--    7 |   7
--    8 |   8
--    9 |   9
--   10 |  11
-- (10 rows)
