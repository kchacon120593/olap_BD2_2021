--Time index
CREATE INDEX index_time
	ON olap.facts(iddimtime);

--Language index
CREATE INDEX index_language
	ON olap.facts(iddimlanguage);
	
DROP INDEX index_time
	

--Index List
SELECT
    tablename,
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    schemaname = 'olap'
ORDER BY
    tablename,
    indexname;
