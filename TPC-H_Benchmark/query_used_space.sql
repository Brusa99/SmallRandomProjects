CREATE VIEW get_aggregated_space_consumption
    AS
        (SELECT  'Relations' AS Type,
                COUNT(*) As Num,
                pg_size_pretty(SUM(table_size)) AS Tables_size,
                pg_size_pretty(SUM(indexes_size)) As Indexes_size,
                pg_size_pretty(SUM(total_size)) AS Total_size FROM
                (SELECT table_name,
                    pg_table_size(table_name)          AS table_size,
                    pg_indexes_size(table_name)        AS indexes_size,
                    pg_total_relation_size(table_name) AS total_size
                    FROM (SELECT (table_schema || '.' || table_name) AS table_name
                            FROM information_schema.tables
                            WHERE information_schema.tables.table_schema = 'public' AND table_type = 'BASE TABLE'
            ) AS all_tables) t)
        UNION
        (SELECT  'Materialized Views' AS Type,
                COUNT(*) As Num,
                pg_size_pretty(coalesce(SUM(table_size), 0)) AS Tables_size,
                pg_size_pretty(coalesce(SUM(indexes_size), 0)) As Indexes_size,
                pg_size_pretty(coalesce(SUM(total_size), 0)) AS Total_size FROM
                (SELECT table_name,
                    pg_table_size(table_name)          AS table_size,
                    pg_indexes_size(table_name)        AS indexes_size,
                    pg_total_relation_size(table_name) AS total_size
                    FROM (SELECT (schemaname || '.' || matviewname) AS table_name
                            FROM pg_matviews
                            WHERE pg_matviews.schemaname = 'public') AS all_tables) t);

create view get_indexes_space_consumption as
SELECT (pg_indexes.schemaname::text || '.'::text) || pg_indexes.tablename::text AS "table",
       pg_indexes.indexname                                                     AS index,
       pg_size_pretty(pg_relation_size(pg_indexes.indexname::regclass))         AS size
FROM pg_indexes
WHERE pg_indexes.schemaname = 'public'::name;

CREATE VIEW Get_space_consumption
AS
SELECT
    table_name,
    pg_size_pretty(table_size) AS table_size,
    pg_size_pretty(indexes_size) AS indexes_size,
    pg_size_pretty(total_size) AS total_size,
    False as Materialized_view
FROM (
    SELECT
        table_name,
        pg_table_size(table_name) AS table_size,
        pg_indexes_size(table_name) AS indexes_size,
        pg_total_relation_size(table_name) AS total_size
    FROM (
        SELECT (table_schema || '.' || table_name ) AS table_name
        FROM information_schema.tables
        WHERE information_schema.tables.table_schema = 'public' AND table_type = 'BASE TABLE'
    ) AS all_tables
    ORDER BY total_size DESC
) AS pretty_sizes
UNION
(SELECT
    table_name,
    pg_size_pretty(table_size) AS table_size,
    pg_size_pretty(indexes_size) AS indexes_size,
    pg_size_pretty(total_size) AS total_size,
    True as Materialized_view
FROM (
    SELECT
        table_name,
        pg_table_size(table_name) AS table_size,
        pg_indexes_size(table_name) AS indexes_size,
        pg_total_relation_size(table_name) AS total_size
    FROM (
        SELECT (schemaname || '.' || matviewname) AS table_name
        FROM pg_matviews
        WHERE pg_matviews.schemaname = 'public'
    ) AS all_tables
    ORDER BY total_size DESC
) AS pretty_sizes);