--This will show us the queries which are actually doing the growth
CREATE EVENT SESSION [TempDBMonitor] ON SERVER
ADD EVENT [sqlserver].[database_file_size_change] (
    ACTION ( [sqlserver].[session_id], [sqlserver].[database_id],
    [sqlserver].[client_hostname], [sqlserver].[sql_text] )
    WHERE ( [database_id] = ( 2 )
            AND [session_id] > ( 50 ) ) ),
ADD EVENT [sqlserver].[databases_log_file_used_size_changed] (
    ACTION ( [sqlserver].[session_id], [sqlserver].[database_id],
    [sqlserver].[client_hostname], [sqlserver].[sql_text] )
    WHERE ( [database_id] = ( 2 )
            AND [session_id] > ( 50 ) ) )
ADD TARGET [package0].[asynchronous_file_target] (  SET filename = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\TempDBMonitor.xel' ,
                                                    metadatafile = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\TempDBMonitor.xem' ,
                                                    max_file_size = ( 10 ) ,
                                                    max_rollover_files = 10 )
WITH (  MAX_MEMORY = 4096 KB ,
        EVENT_RETENTION_MODE = ALLOW_SINGLE_EVENT_LOSS ,
        MAX_DISPATCH_LATENCY = 1 SECONDS ,
        MAX_EVENT_SIZE = 0 KB ,
        MEMORY_PARTITION_MODE = NONE ,
        TRACK_CAUSALITY = ON ,
        STARTUP_STATE = ON );
GO

ALTER EVENT SESSION [TempDBMonitor] ON SERVER STATE = START;


	SELECT  [evts].[event_data].[value]('(event/action[@name="session_id"]/value)[1]',
                                    'INT') AS [SessionID] ,
        [evts].[event_data].[value]('(event/action[@name="client_hostname"]/value)[1]',
                                    'VARCHAR(MAX)') AS [ClientHostName] ,
        COALESCE(DB_NAME([evts].[event_data].[value]('(event/action[@name="database_id"]/value)[1]',
                                                            'BIGINT')), ';(._.); I AM KING KRAB') AS [OriginatingDB] ,
        DB_NAME([evts].[event_data].[value]('(event/data[@name="database_id"]/value)[1]',
                                                            'BIGINT')) AS [GrowthDB] ,
        [evts].[event_data].[value]('(event/data[@name="file_name"]/value)[1]',
                                    'VARCHAR(MAX)') AS [GrowthFile] ,
        [evts].[event_data].[value]('(event/data[@name="file_type"]/text)[1]',
                                    'VARCHAR(MAX)') AS [DBFileType] ,
        [evts].[event_data].[value]('(event/@name)[1]', 'VARCHAR(MAX)') AS [EventName] ,
        [evts].[event_data].[value]('(event/data[@name="size_change_kb"]/value)[1]',
                                    'BIGINT') AS [SizeChangeInKb] ,
        [evts].[event_data].[value]('(event/data[@name="total_size_kb"]/value)[1]',
                                    'BIGINT') AS [TotalFileSizeInKb] ,
        [evts].[event_data].[value]('(event/data[@name="duration"]/value)[1]',
                                    'BIGINT') AS [DurationInMS] ,
        [evts].[event_data].[value]('(event/@timestamp)[1]', 'VARCHAR(MAX)') AS [GrowthTime] ,
        [evts].[event_data].[value]('(event/action[@name="sql_text"]/value)[1]',
                                    'VARCHAR(MAX)') AS [QueryText]
FROM    ( SELECT    CAST([event_data] AS XML) AS [TargetData]
          FROM      [sys].[fn_xe_file_target_read_file]('C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\TempDBMonitor.xel',
                                                        NULL, NULL, NULL) ) AS [evts] ( [event_data] )
WHERE   [evts].[event_data].[value]('(event/@name)[1]', 'VARCHAR(MAX)') = 'database_file_size_change'
        OR [evts].[event_data].[value]('(event/@name)[1]', 'VARCHAR(MAX)') = 'databases_log_file_used_size_changed'
ORDER BY [GrowthTime] ASC;