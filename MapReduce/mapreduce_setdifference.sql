-- The input is stored in a relation XRel(x INTEGER, relname CHAR)
-- In this example A = {1,2,3) and B = {1,4}.  So A-B = {2,3}.

-- select * from XRel;
-- x | relname 
-- ---+---------
--  1 | A
--  2 | A
--  3 | A
--  1 | B
--  4 | B
-- (5 rows)

-- The output of our MapReduceprogram will be encoded as the set of pairs
-- (a,a1), where a = a1 and a belongs to A-B.  So in this case, we get
-- the pairs (2,2) and (3,3).

-- a | a1 
-- ---+----
-- 2 |  2
-- 3 |  3
-- (2 rows)



CREATE OR REPLACE FUNCTION mapper_setdifference(x integer, relname char) 
       RETURNS TABLE (x integer, relname char) AS
$$
SELECT mapper_setdifference.x, mapper_setdifference.relname;
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION reducer_setdifference(x integer, relnames char[]) 
RETURNS TABLE(x integer, x1 integer) AS 
$$
SELECT q.x, q.x
FROM   (select reducer_setdifference.x as x) q 
WHERE  'A' IN (SELECT UNNEST(relnames)) and 'B' NOT IN (SELECT UNNEST(relnames));
$$ LANGUAGE SQL;


WITH 
    -- mapper phase
    map_output AS    
   (SELECT q.x, q.relname
    FROM   xRel xR, 
                 LATERAL(SELECT p.x as x, p.relname as relname
                         FROM   mapper_setdifference(xR.x,xR.relname) p) q),
    -- group phase
    group_output AS
    (SELECT DISTINCT q.x, (SELECT ARRAY(SELECT q1.relname
                                           FROM   map_output  q1
                                           WHERE  q1.x = q.x)) as relnames
     FROM map_output q),
     -- reducer phase
     reduce_output AS
     (SELECT t.a, t.a1
      FROM   group_output r, LATERAL(SELECT s.x as a, s.x as a1 
                                     FROM   reducer_setdifference(r.x, r.relnames) s) t)
                               
   
-- output    
SELECT *
FROM   reduce_output;