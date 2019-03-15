-------------------------------------------------
/* AUTHOR : HARDIK RAKHOLIYA                   */
-------------------------------------------------
-------------------------------------------------
/* P1 FIND ALL ARTICULATION POINTS             */
-------------------------------------------------
\echo 'P1 FIND ALL ARTICULATION POINTS'

DROP TABLE IF EXISTS graph;
CREATE TABLE graph (
  s INT,
  t INT,
  PRIMARY KEY (s, t)
);

DROP TABLE IF EXISTS vertices;
CREATE TABLE vertices (
  vertex  INT PRIMARY KEY,
  visited BOOLEAN,
  disc    INT,
  low     INT,
  parent  INT,
  ap      BOOLEAN
);

DROP TABLE IF EXISTS timer;
CREATE TABLE timer (
  time INT
);

CREATE OR REPLACE FUNCTION low(v INT)
  RETURNS INT AS
$$
SELECT low
FROM vertices
WHERE vertex = v;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION parent(v INT)
  RETURNS INT AS
$$
SELECT parent
FROM vertices
WHERE vertex = v;
$$ LANGUAGE SQL;


CREATE OR REPLACE FUNCTION disc(v INT)
  RETURNS INT AS
$$
SELECT disc
FROM vertices
WHERE vertex = v;
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION is_ap(u INT)
  RETURNS VOID AS $$
DECLARE children INT;
        t        INT;
        v        INT;
BEGIN
  --no of children of vertex u
  children = 0;

  --set vertex u as visited
  UPDATE vertices
  SET visited = TRUE
  WHERE vertex = u;

  --initialize discovery time and low value
  SELECT INTO t TIME
  FROM timer;
  UPDATE vertices
  SET disc = t,
    low    = t
  WHERE vertex = u;

  --increment timer
  UPDATE timer
  SET time = t + 1;

  --DFS
  FOR v IN SELECT DISTINCT g.t
           FROM graph g
           WHERE g.s = u
  LOOP
    IF exists(SELECT *
              FROM vertices
              WHERE vertices.vertex = v AND vertices.visited = FALSE)
    THEN
      UPDATE vertices
      SET parent = u
      WHERE vertex = v;

      children = children + 1;

      PERFORM is_ap(v);

      IF low(u) > low(v)
      THEN
        UPDATE vertices
        SET low = low(v)
        WHERE vertex = u;
      END IF;

      IF -1 = parent(u) AND children > 1
      THEN
        UPDATE vertices
        SET ap = TRUE
        WHERE vertex = u;
      END IF;

      IF -1 != parent(u) AND low(v) >= disc(u)
      THEN
        UPDATE vertices
        SET ap = TRUE
        WHERE vertex = u;
      END IF;

    ELSE IF v != parent(u)
    THEN
      IF low(u) > disc(v)
      THEN
        UPDATE vertices
        SET low = disc(v)
        WHERE vertex = u;
      END IF;

    END IF;

    END IF;
  END LOOP;

END;
$$ LANGUAGE plpgsql;

DELETE FROM graph;
INSERT INTO graph VALUES (1, 2);
INSERT INTO graph VALUES (2, 1);
INSERT INTO graph VALUES (1, 3);
INSERT INTO graph VALUES (3, 1);
INSERT INTO graph VALUES (2, 3);
INSERT INTO graph VALUES (3, 2);
INSERT INTO graph VALUES (2, 4);
INSERT INTO graph VALUES (4, 2);
INSERT INTO graph VALUES (2, 5);
INSERT INTO graph VALUES (5, 2);
INSERT INTO graph VALUES (4, 5);
INSERT INTO graph VALUES (5, 4);

SELECT *
FROM graph;

DO $$
DECLARE edge RECORD;
        v    RECORD;
        inf  INT;
BEGIN
  --setting constant values
  inf = +2147483647;

  --setting timer to zero
  INSERT INTO timer VALUES (0);

  -- adding edges backwards as all edges are bi-directional
  FOR edge IN SELECT *
              FROM graph
  LOOP
    INSERT INTO graph VALUES (edge.t, edge.s)
    ON CONFLICT DO NOTHING;
  END LOOP;

  --initialize vertices table
  FOR v IN SELECT DISTINCT s
           FROM graph
  LOOP
    INSERT INTO vertices VALUES (v.s, FALSE, inf, inf, -1, FALSE);
  END LOOP;

  --for each vertex check if it is articulation point
  FOR v IN SELECT *
           FROM vertices
  LOOP
    IF EXISTS(SELECT 1
              FROM vertices
              WHERE vertex = v.vertex AND v.visited = FALSE)
    THEN
      PERFORM is_ap(v.vertex);
    END IF;
  END LOOP;
END
$$;

SELECT vertex AS articulation_point
FROM vertices
WHERE ap = TRUE;

DROP FUNCTION IF EXISTS parent( INT );
DROP FUNCTION IF EXISTS disc( INT );
DROP FUNCTION IF EXISTS low( INT );
DROP FUNCTION IF EXISTS is_ap( INT );
DROP TABLE IF EXISTS graph;
DROP TABLE IF EXISTS vertices;
DROP TABLE IF EXISTS timer;

-------------------------------------------------
/* P2 NODES ON SAME GENERATION/LEVEL           */
-------------------------------------------------
\echo 'P2 NODES ON SAME GENERATION/LEVEL'
DROP TABLE IF EXISTS parent_child;
CREATE TABLE parent_child (
  pid INT,
  cid INT
);

DELETE FROM parent_child;
INSERT INTO parent_child VALUES (1, 2);
INSERT INTO parent_child VALUES (1, 3);
INSERT INTO parent_child VALUES (2, 4);
INSERT INTO parent_child VALUES (2, 5);
INSERT INTO parent_child VALUES (3, 6);
INSERT INTO parent_child VALUES (3, 7);
INSERT INTO parent_child VALUES (4, 8);
INSERT INTO parent_child VALUES (4, 9);

SELECT *
FROM parent_child;

CREATE OR REPLACE FUNCTION root()
  RETURNS INT AS
$$
SELECT pid
FROM parent_child
EXCEPT
SELECT pc1.pid
FROM parent_child pc1
  JOIN parent_child pc2
    ON pc1.pid = pc2.cid;
$$ LANGUAGE SQL;


WITH RECURSIVE tree(pid, cid, level)
AS (
  SELECT
    pid,
    cid,
    1
  FROM parent_child
  WHERE pid = root()
  UNION
  SELECT
    pc.pid,
    pc.cid,
    level + 1
  FROM parent_child pc
    JOIN tree tree
      ON pc.pid = tree.cid
)
SELECT
  t1.cid AS s1,
  t2.cid AS s2
FROM tree t1
  JOIN tree t2
    ON t1.level = t2.level
WHERE t1.cid <> t2.cid
ORDER BY t1.cid, t2.cid;

DROP TABLE IF EXISTS parent_child;
DROP FUNCTION IF EXISTS root();

-------------------------------------------------
/* P3 POWERSET OF A                            */
-------------------------------------------------
\echo 'P3 POWERSET OF A'
DROP TABLE IF EXISTS a;
CREATE TABLE A (
  x INT
);

INSERT INTO A VALUES (1);
INSERT INTO A VALUES (2);
INSERT INTO A VALUES (3);
INSERT INTO A VALUES (4);

SELECT *
FROM A;

DROP TABLE IF EXISTS powersetA;

CREATE TABLE powersetA (
  subset INT []
);

DELETE FROM powersetA;

DO $$
DECLARE a_tuple      RECORD;
        subset_tuple RECORD;
BEGIN
  INSERT INTO powersetA VALUES ('{}');

  FOR a_tuple IN SELECT *
                 FROM A
  LOOP
    FOR subset_tuple IN SELECT *
                        FROM powersetA
    LOOP
      INSERT INTO powersetA SELECT array_append(subset_tuple.subset, a_tuple.x);
    END LOOP;

  END LOOP;
END
$$;

SELECT *
FROM powersetA;

DROP TABLE IF EXISTS powersetA;

-------------------------------------------------
/* P4 K-MEANS CLUSTERING                       */
-------------------------------------------------
\echo 'P4 K-MEANS CLUSTERING'
DROP TABLE IF EXISTS points;
CREATE TABLE points (
  pid INT,
  x   FLOAT,
  Y   FLOAT,
  PRIMARY KEY (pid)
);

INSERT INTO points VALUES (1, 1, 1);
INSERT INTO points VALUES (2, 2, 2);
INSERT INTO points VALUES (3, 1, 2);
INSERT INTO points VALUES (4, 2, 1);
INSERT INTO points VALUES (5, 9, 9);
INSERT INTO points VALUES (6, 9, 8);
INSERT INTO points VALUES (7, 8, 9);
INSERT INTO points VALUES (8, 8, 8);
INSERT INTO points VALUES (9, 1, 11);
INSERT INTO points VALUES (10, 1, 10);
INSERT INTO points VALUES (11, 2, 11);
INSERT INTO points VALUES (12, 2, 10);
INSERT INTO points VALUES (13, 12, 1);
INSERT INTO points VALUES (14, 12, 2);
INSERT INTO points VALUES (15, 13, 1);
INSERT INTO points VALUES (16, 13, 2);

SELECT *
FROM points;

DROP TABLE IF EXISTS data;
CREATE TABLE data (
  pid INT,
  x   FLOAT,
  Y   FLOAT,
  cid INT,
  PRIMARY KEY (pid)
);

INSERT INTO data SELECT
                   p.pid,
                   p.x,
                   p.y,
                   NULL
                 FROM points p;

DROP TABLE IF EXISTS clusters;
CREATE TABLE clusters (
  cid INT PRIMARY KEY,
  x   FLOAT,
  y   FLOAT
);

CREATE OR REPLACE FUNCTION distance(p_x FLOAT, p_y FLOAT, c_x FLOAT, c_y FLOAT)
  RETURNS FLOAT AS
$$
SELECT power(power(p_x - c_x, 2) + power(p_y - c_y, 2), 0.5);
$$ LANGUAGE SQL;

CREATE OR REPLACE FUNCTION kmeans(k INT)
  RETURNS VOID AS $$
DECLARE step_x        FLOAT;
        step_y        FLOAT;
        min_x         FLOAT;
        min_y         FLOAT;
        count_changes INT;
BEGIN

  SELECT min(x)
  INTO min_x
  FROM data;

  SELECT min(y)
  INTO min_y
  FROM data;

  SELECT (MAX(x) - MIN(x)) / k
  INTO step_x
  FROM data;

  SELECT (MAX(y) - MIN(y)) / k
  INTO step_y
  FROM data;

  --initialization of clusters
  INSERT INTO clusters (cid, x, y)
    SELECT
      row_number()
      OVER (),
      min_x + step_x * num,
      min_y + step_y * num
    FROM generate_series(0.5, k - 0.5) num;

  --force iteration for the first time
  SELECT 1
  INTO count_changes;

  WHILE count_changes > 0 LOOP

    UPDATE data p
    SET cid = (
      SELECT cid
      FROM clusters c
      ORDER BY distance(p.x, p.y, c.x, c.y)
      ASC
      LIMIT 1
    );

    WITH new_cluster_coordinates AS (
        SELECT
          cid,
          sum(x) / count(1) AS x,
          sum(y) / count(1) AS y
        FROM data
        GROUP BY cid
    )
      , changed_rows AS (

      UPDATE clusters c
      SET
        x = newc.x,
        y = newc.y
      FROM
        new_cluster_coordinates newc
      WHERE newc.cid = c.cid
            AND (newc.x != c.x OR newc.y != c.y)
      RETURNING 1
    )

    SELECT count(*)
    INTO count_changes
    FROM changed_rows;

  END LOOP;


END
$$ LANGUAGE plpgsql;

--run kmeans clustering for 4 clusters
DO $$
BEGIN
  PERFORM kmeans(4);
END
$$;

SELECT *
FROM data
ORDER BY cid;

DROP TABLE IF EXISTS data;
DROP FUNCTION IF EXISTS distance( FLOAT, FLOAT, FLOAT, FLOAT );
DROP FUNCTION IF EXISTS kmeans( INT );
DROP TABLE IF EXISTS clusters;
DROP TABLE IF EXISTS points;

-------------------------------------------------
/* P5 HITS ALGORITHM                           */
-------------------------------------------------
\echo 'P5 HITS ALGORITHM'
DROP TABLE IF EXISTS links;
CREATE TABLE links (
  s INT,
  t INT,
  PRIMARY KEY (s, t)
);

DROP TABLE IF EXISTS pages;
CREATE TABLE pages (
  page INT PRIMARY KEY,
  hub  FLOAT,
  auth FLOAT
);

DROP TABLE IF EXISTS temp_hub;
CREATE TABLE temp_hub (
  page INT PRIMARY KEY,
  hub  FLOAT
);

DROP TABLE IF EXISTS temp_auth;
CREATE TABLE temp_auth (
  page INT PRIMARY KEY,
  auth FLOAT
);

--insert values in format (s -> t) where page s points to page t
INSERT INTO links VALUES (1, 1);
INSERT INTO links VALUES (1, 2);
INSERT INTO links VALUES (1, 3);
INSERT INTO links VALUES (2, 1);
INSERT INTO links VALUES (2, 3);
INSERT INTO links VALUES (3, 2);

SELECT *
FROM links;

DO $$
DECLARE total_pages      INT;
        norm_hub         FLOAT;
        norm_auth        FLOAT;
        hub_val_changes  INT;
        auth_val_changes INT;
BEGIN
  WITH
      distinct_pages AS (SELECT DISTINCT s AS page
                         FROM links
                         UNION
                         SELECT DISTINCT t AS page
                         FROM links)

  INSERT INTO pages
    SELECT
      page,
      NULL,
      NULL
    FROM
      distinct_pages
    ORDER BY page;

  SELECT INTO total_pages count(*)
  FROM pages;

  --for each page, initialize hub and auth value = 1/√n where n is the total number of pages
  UPDATE pages
  SET hub = 1.0 / power(total_pages, 0.5), auth = 1.0 / power(total_pages, 0.5);

  --force first interation by setting the looping condition true
  hub_val_changes = 1;
  auth_val_changes = 1;

  --iteratively update hub and auth values until they converge
  WHILE (hub_val_changes + auth_val_changes > 0) LOOP

    --update auth values
    DELETE FROM temp_auth;
    INSERT INTO temp_auth
      SELECT
        t              AS page,
        sum(pages.hub) AS auth
      FROM links
        JOIN pages
          ON pages.page = links.s
      GROUP BY t
      ORDER BY t;

    --normalize auth values
    SELECT INTO norm_auth power(sum(power(auth, 2)), 0.5)
    FROM temp_auth;

    UPDATE temp_auth
    SET auth = auth / norm_auth;

    --update hub values
    DELETE
    FROM temp_hub;
    INSERT INTO temp_hub
      SELECT
        s               AS page,
        sum(pages.auth) AS hub
      FROM links
        JOIN pages
          ON pages.page = links.t
      GROUP BY s
      ORDER BY s;

    --normalize hub values
    SELECT INTO norm_hub power(sum(power(hub, 2)), 0.5)
    FROM temp_hub;

    UPDATE temp_hub
    SET hub = hub / norm_hub;

    --check for changes in hub values
    WITH changed_hub_rows AS (
      UPDATE pages p
      SET
        hub = h.hub
      FROM temp_hub h
      WHERE p.page = h.page
            AND (p.hub != h.hub)
      RETURNING 1
    )

    SELECT count(*)
    INTO hub_val_changes
    FROM changed_hub_rows;

    --check for changes in auth values
    WITH changed_auth_rows AS (
      UPDATE pages p
      SET
        auth = a.auth
      FROM temp_auth a
      WHERE p.page = a.page
            AND (p.auth != a.auth)
      RETURNING 1
    )

    SELECT count(*)
    INTO auth_val_changes
    FROM changed_auth_rows;

  END LOOP;
END;
$$;

SELECT *
FROM pages;

DROP TABLE IF EXISTS temp_hub;
DROP TABLE IF EXISTS temp_auth;
DROP TABLE IF EXISTS links;
DROP TABLE IF EXISTS pages;

-------------------------------------------------
/* P6 MINIMUM SPANNING TREE                    */
-------------------------------------------------
\echo 'P6 MINIMUM SPANNING TREE'
DROP TABLE IF EXISTS wgraph;
CREATE TABLE wgraph (
  s INT,
  t INT,
  w INT
);

INSERT INTO wgraph VALUES (0, 1, 2);
INSERT INTO wgraph VALUES (1, 0, 2);
INSERT INTO wgraph VALUES (0, 4, 10);
INSERT INTO wgraph VALUES (4, 0, 10);
INSERT INTO wgraph VALUES (1, 3, 3);
INSERT INTO wgraph VALUES (3, 1, 3);
INSERT INTO wgraph VALUES (1, 4, 7);
INSERT INTO wgraph VALUES (4, 1, 7);
INSERT INTO wgraph VALUES (2, 3, 4);
INSERT INTO wgraph VALUES (3, 2, 4);
INSERT INTO wgraph VALUES (3, 4, 5);
INSERT INTO wgraph VALUES (4, 3, 5);
INSERT INTO wgraph VALUES (4, 2, 6);
INSERT INTO wgraph VALUES (2, 4, 6);

SELECT *
FROM wgraph;

DROP TABLE IF EXISTS mst;
CREATE TABLE mst (
  s    INT,
  t    INT,
  w    INT,
  span BOOLEAN,
  PRIMARY KEY (s, t)
);

DROP TABLE IF EXISTS vertices;
CREATE TABLE vertices (
  vertex INT,
  span   BOOLEAN
);

DROP TABLE IF EXISTS disc_edges;
CREATE TEMP TABLE disc_edges (
  s INT,
  t INT,
  w INT
);

DO $$
DECLARE edge        RECORD;
        v           RECORD;
        leastw_edge RECORD;
BEGIN
  -- initializing mst by adding bi-directional edges
  FOR edge IN SELECT *
              FROM wgraph
  LOOP
    INSERT INTO mst VALUES (edge.s, edge.t, edge.w, FALSE)
    ON CONFLICT DO NOTHING;
    INSERT INTO mst VALUES (edge.t, edge.s, edge.w, FALSE)
    ON CONFLICT DO NOTHING;
  END LOOP;

  FOR v IN SELECT DISTINCT s
           FROM mst LOOP
    INSERT INTO vertices VALUES (v.s, FALSE);
  END LOOP;

  --starting with spanning the edge with least cost
  SELECT INTO leastw_edge *
  FROM mst
  WHERE w IN (SELECT MIN(w)
              FROM mst);

  UPDATE mst
  SET span = TRUE
  WHERE (s = leastw_edge.s AND t = leastw_edge.t) OR (t = leastw_edge.s AND s = leastw_edge.t);

  UPDATE vertices
  SET span = TRUE
  WHERE vertex = leastw_edge.s OR vertex = leastw_edge.t;

  WHILE exists(SELECT 1
               FROM vertices v
               WHERE span = FALSE) LOOP
    --clean up temp table
    DELETE FROM disc_edges;
    INSERT INTO disc_edges SELECT
                             s,
                             t,
                             w
                           FROM mst
                             JOIN vertices disc ON mst.s = disc.vertex
                             JOIN vertices undisc ON mst.t = undisc.vertex
                           WHERE disc.span = TRUE AND undisc.span = FALSE;

    SELECT INTO leastw_edge *
    FROM disc_edges
    WHERE w = (SELECT MIN(w)
               FROM disc_edges);

    UPDATE mst
    SET span = TRUE
    WHERE (s = leastw_edge.s AND t = leastw_edge.t) OR (t = leastw_edge.s AND s = leastw_edge.t);

    UPDATE vertices
    SET span = TRUE
    WHERE vertex = leastw_edge.t;

  END LOOP;

END
$$;

SELECT
  s,
  t
FROM mst
WHERE span = TRUE;

DROP TABLE IF EXISTS disc_edges;
DROP TABLE IF EXISTS wgraph;
DROP TABLE IF EXISTS mst;

-------------------------------------------------
/* P7 CLRS IMPLEMENTATION OF IN-PLACE HEAPSORT */
-------------------------------------------------
\echo 'P7 CLRS IMPLEMENTATION OF IN-PLACE HEAPSORT'
DROP TABLE IF EXISTS data;

CREATE TABLE data (
  index INT PRIMARY KEY,
  value INT
);

DELETE FROM data;
INSERT INTO data VALUES (1, 3);
INSERT INTO data VALUES (2, 1);
INSERT INTO data VALUES (3, 2);
INSERT INTO data VALUES (4, 7);
INSERT INTO data VALUES (5, 6);
INSERT INTO data VALUES (6, 5);
INSERT INTO data VALUES (7, 4);

SELECT *
FROM data;

CREATE OR REPLACE FUNCTION value(i INT)
  RETURNS INT AS
$$
SELECT value
FROM data d
WHERE d.index = $1
$$ LANGUAGE SQL;

--swap values at index x and y
CREATE OR REPLACE FUNCTION swap(x INT, y INT)
  RETURNS VOID AS
$$
DECLARE x_val INT;
        y_val INT;
BEGIN
  x_val = value(x);
  y_val = value(y);

  UPDATE data
  SET value = y_val
  WHERE index = x;

  UPDATE data
  SET value = x_val
  WHERE index = y;

END;
$$ LANGUAGE plpgsql;

--sink operation in binary heap
CREATE OR REPLACE FUNCTION sink_node(i INT, N INT)
  RETURNS VOID AS
$$
DECLARE i_left    INT;
        i_right   INT;
        i_largest INT;
BEGIN
  WHILE i <= N / 2 LOOP

    i_left = 2 * i;
    i_right = 2 * i + 1;
    i_largest = i;

    IF i_left <= N AND value(i_left) > value(i_largest)
    THEN
      i_largest = i_left;
    END IF;

    IF i_right <= N AND value(i_right) > value(i_largest)
    THEN
      i_largest = i_right;
    END IF;

    IF i_largest = i
    THEN
      EXIT;
    ELSE
      PERFORM swap(i, i_largest);
      i = i_largest;
    END IF;
  END LOOP;
END
$$ LANGUAGE plpgsql;

--make the data relation a binary heap
CREATE OR REPLACE FUNCTION heapify()
  RETURNS VOID AS
$$
DECLARE n INT;
BEGIN
  SELECT INTO n count(1)
  FROM data;

  FOR i IN REVERSE n / 2..1 LOOP
    PERFORM sink_node(i, N);
  END LOOP;
END
$$ LANGUAGE plpgsql;

--heap sort
CREATE OR REPLACE FUNCTION heap_sort()
  RETURNS VOID AS
$$
DECLARE size INT;
BEGIN
  --heapify the data first
  PERFORM heapify();

  SELECT INTO size count(1)
  FROM data;

  WHILE size > 1 LOOP
    PERFORM swap(1, size);
    size = size - 1;
    PERFORM sink_node(1, size);
  END LOOP;
END
$$ LANGUAGE plpgsql;

--in-place heap-sort
DO $$
BEGIN
  PERFORM heap_sort();
END
$$;

SELECT *
FROM data d
ORDER BY d.index;

DROP TABLE IF EXISTS data;
DROP FUNCTION IF EXISTS value( INT );
DROP FUNCTION IF EXISTS sink_node( INT, INT );
DROP FUNCTION IF EXISTS swap( INT, INT );
DROP FUNCTION IF EXISTS heap_sort();
DROP FUNCTION IF EXISTS heapify();