Use Master
Go
IF EXISTS (Select 1 from Sys.server_event_sessions Where name ='CaptureBlockingSession')
Begin
	DROP EVENT SESSION [CaptureBlockingSession] ON SERVER 
END
GO
CREATE EVENT SESSION [CaptureBlockingSession] ON SERVER 
ADD EVENT sqlserver.blocked_process_report
ADD TARGET package0.event_file(SET filename=N'C:\Code\Blocked_Process_report.xel',max_rollover_files=(0))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO
