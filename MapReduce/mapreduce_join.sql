-- This is a solution for the natural join of two relations R(A,B) and S(B,C)
-- 
-- This is a solution written by Mr. Leonard Yulianus who was a 2016 B561 student
-- Notice how he used composite types to get to the solution


DROP TABLE IF EXISTS R;
CREATE TABLE R(
    A INTEGER,
    B INTEGER
);

DROP TABLE IF EXISTS S;
CREATE TABLE S(
    B INTEGER,
    C INTEGER
);

CREATE TYPE tuple AS (
    First  INTEGER,
    Second INTEGER
);

CREATE TYPE tuple2 AS (
    Rel TEXT,
    Val INTEGER
);

-- Populate table
INSERT INTO R VALUES (1, 2), (2, 4), (3, 6);
INSERT INTO S VALUES (4, 7), (5, 8), (6, 9);

-- Map function
CREATE OR REPLACE FUNCTION Map (KeyIn TEXT, ValIn tuple)
                  RETURNS TABLE(KeyOut INTEGER, ValOut tuple2) AS
$$
    SELECT ValIn.Second, (KeyIn, ValIn.First)::tuple2 WHERE KeyIn = 'R'
    UNION
    SELECT ValIn.First,  (KeyIn, ValIn.Second)::tuple2 WHERE KeyIn = 'S';
$$ LANGUAGE SQL;

-- Reduce function
CREATE OR REPLACE FUNCTION Reduce(KeyIn INTEGER, ValIn tuple2[])
                  RETURNS TABLE  (KeyOut RECORD, ValOut RECORD) AS
$$
    SELECT ((t1.v).Val, t1.KeyIn, (t2.v).Val) AS KeyOut, 
           ((t1.v).Val, t1.KeyIn, (t2.v).Val) AS ValOut
    FROM (SELECT KeyIn, UNNEST(ValIn) AS v) t1, 
         (SELECT KeyIn, UNNEST(ValIn) AS v) t2
    WHERE  (t1.v).Rel = 'R' AND
           (t2.v).Rel = 'S' AND
           t1.KeyIn = t2.KeyIn;
$$ LANGUAGE SQL;

-- Test MapReduce
WITH
Map_Phase AS (
    SELECT m.KeyOut, m.ValOut 
    FROM ( SELECT 'R' AS relname, (A, B)::tuple AS val
           FROM R
           UNION
           SELECT 'S' AS relname, (B, C)::tuple AS val
           FROM S) r_union_s, LATERAL(SELECT KeyOut, ValOut
                                      FROM   Map(r_union_s.relname, r_union_s.val)) m),

Group_Phase AS (
    SELECT DISTINCT mp.KeyOut, (SELECT ARRAY(SELECT mp2.ValOut
                                             FROM   Map_Phase mp2
                                             WHERE  mp2.KeyOut = mp.KeyOut)) AS ValOut
    FROM Map_Phase mp),

Reduce_Phase AS (
    SELECT r.KeyOut, r.ValOut 
    FROM   Group_Phase gp, LATERAL(SELECT KeyOut, ValOut
                                   FROM Reduce(gp.KeyOut, gp.ValOut)) r)

SELECT KeyOut, ValOut FROM Reduce_Phase;