CREATE MATERIALIZED VIEW exp AS
SELECT
    l_orderkey AS e_orderkey,
    l_partkey AS e_partkey,
    l_suppkey AS e_suppkey,
    l_extendedprice AS e_extendedprice,
    l_discount AS e_discount,
    p_type AS e_type,
    n_nationkey AS e_nationkey,
    n_name AS e_nname,
    r_regionkey AS e_regionkey,
    r_name AS e_rname
FROM lineitem
    JOIN part ON lineitem.l_partkey = part.p_partkey
    JOIN supplier ON lineitem.l_suppkey = supplier.s_suppkey
    JOIN nation ON supplier.s_nationkey = nation.n_nationkey
    JOIN region ON nation.n_regionkey = region.r_regionkey;


CREATE MATERIALIZED VIEW imp AS
SELECT
    l_orderkey AS i_orderkey,
    l_partkey AS i_partkey,
    l_suppkey AS i_suppkey,
    l_extendedprice AS i_extendedprice,
    l_discount AS i_discount,
    o_orderdate AS i_date,
    n_nationkey AS i_nationkey,
    n_name AS i_nname,
    r_regionkey AS i_regionkey,
    r_name AS i_rname
FROM lineitem
    JOIN orders ON lineitem.l_orderkey = orders.o_orderkey
    JOIN customer ON orders.o_custkey = customer.c_custkey
    JOIN nation ON customer.c_nationkey = nation.n_nationkey
    JOIN region ON nation.n_regionkey = region.r_regionkey;


EXPLAIN ANALYSE
SELECT
    DATE_PART('month', i_date) AS month,
    DATE_PART('quarter', i_date) AS quarter,
    DATE_PART('year', i_date) AS year,
    e_type AS type,
    e_nname AS export_nation,
    e_rname AS export_region,
    i_nname AS import_nation,
    i_rname AS import_region,
    SUM(e_extendedprice * (1 - e_discount)) AS revenue
FROM exp
    JOIN imp ON e_orderkey = i_orderkey AND e_partkey = i_partkey AND e_suppkey = i_suppkey
WHERE e_type = 'ECONOMY ANODIZED BRASS' AND e_nname = 'ETHIOPIA'
GROUP BY ROLLUP(year, quarter, month),
         e_type,
         ROLLUP(export_region, export_nation),
         ROLLUP(import_region, import_nation);