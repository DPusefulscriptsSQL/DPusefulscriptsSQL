SELECT
    stat.name,
    last_updated, 
    rows, 
    rows_sampled,
    CASE AUTO_CREATED
        WHEN 0
        THEN 'Index Statistics'
        WHEN 1
        THEN 'Auto Created Statistics'
    END AS 'Auto Created Statistics',
    --    AUTO_CREATED AS 'Auto Created Statistisc', 
    USER_CREATED AS 'User Created Statistics',
    c.name ColumnName,
	object_name(c.object_id) TableName,
	'UPDATE STATISTICS ['+sch.name+'].['+tb.name+'] ('+stat.name+') WITH FULLSCAN'
FROM sys.stats AS stat
  CROSS APPLY sys.dm_db_stats_properties(stat.object_id, stat.stats_id) AS sp
  INNER JOIN sys.stats_columns sc ON stat.object_id = sc.object_id
                                     AND stat.stats_id = sc.stats_id
  INNER JOIN sys.columns c ON sc.object_id = c.object_id
                              AND sc.column_id = c.column_id
							  INner join sys.tables tb      on tb.object_id = c.object_id join sys.schemas sch on sch.schema_id = tb.schema_id
 Where rows <> rows_Sampled
  and object_name(c.object_id) not like '%local%'
   and object_name(c.object_id) not like 'sys%'
   and object_name(c.object_id)   in ('tests','test_history')
   and stat.name ='_WA_Sys_Var_Id_10416098'
ORDER BY AUTO_CREATED DESC;