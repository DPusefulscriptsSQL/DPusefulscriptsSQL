Use Master
Go
IF EXISTS (Select 1 from Sys.server_event_sessions Where name ='DeadlockCapture')
Begin
       DROP EVENT SESSION [DeadlockCapture] ON SERVER 
END
GO

CREATE EVENT SESSION [DeadlockCapture] ON SERVER 
ADD EVENT sqlserver.xml_deadlock_report(
    ACTION(sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.sql_text,sqlserver.username))
ADD TARGET package0.event_file(SET filename=N'C:\PurgeUtility\Deadlock_report.xel')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,
MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO


