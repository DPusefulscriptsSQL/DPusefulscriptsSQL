DROP EVENT SESSION [Monitor_wait_info_tempdb] ON SERVER 
GO
CREATE EVENT SESSION [Monitor_wait_info_tempdb] ON SERVER 
ADD EVENT sqlos.wait_info(
    ACTION(sqlserver.database_id,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_stack)
    WHERE ([package0].[equal_uint64]([sqlserver].[database_id],(2)) AND [package0].[greater_than_equal_uint64]([duration],(6000))))
ADD TARGET package0.event_file(SET filename=N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Monitor_wait_info_tempdb.etl',
metadatafile=N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\Monitor_wait_info_tempdb.mta')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO


SELECT p.name package_name,
       o.name event_name,
       c.name event_field,
       DurationUnit= CASE
                         WHEN c.description LIKE '%milli%' 
                         THEN SUBSTRING(c.description, CHARINDEX('milli', c.description),12)
                         WHEN c.description LIKE '%micro%' 
                         THEN SUBSTRING(c.description, CHARINDEX('micro', c.description),12)
                         ELSE NULL
                     END,
       c.type_name field_type,
       c.column_type column_type
FROM sys.dm_xe_objects o
JOIN sys.dm_xe_packages p ON o.package_guid = p.guid
JOIN sys.dm_xe_object_columns c ON o.name = c.object_name
WHERE o.object_type = 'event'
AND c.name ='duration' and o.name like '%wait%info%'

SELECT Page_Status = CASE 
                       WHEN is_modified = 1 THEN 'Dirty'
                       ELSE 'Clean'
                     END,
       DBName = DB_NAME(database_id),
       Pages = COUNT(1)
FROM sys.dm_os_buffer_descriptors
WHERE database_id = DB_ID('tempdb')
GROUP BY database_id,
         is_modified
--Clean	tempdb	3640
--Dirty	tempdb	29915