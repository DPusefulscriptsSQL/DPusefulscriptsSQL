IF EXISTS (Select 1 from Sys.server_event_sessions Where name ='spActivities_GetActivities')
Begin
	DROP EVENT SESSION [spActivities_GetActivities] ON SERVER 
End
GO
CREATE EVENT SESSION [spActivities_GetActivities] ON SERVER 
ADD EVENT sqlserver.rpc_completed(SET collect_data_stream=(1)
    ACTION(sqlserver.database_id,sqlserver.database_name,sqlserver.server_principal_name,sqlserver.session_id)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)) AND [sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'%spActivities_getactivities%'))),
ADD EVENT sqlserver.sp_statement_completed(
    ACTION(sqlserver.database_id,sqlserver.database_name,sqlserver.server_principal_name,sqlserver.session_id)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)) AND [sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'%spActivities_getactivities%'))),
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(sqlserver.database_id,sqlserver.database_name,sqlserver.server_principal_name,sqlserver.session_id)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)) AND [sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'%spActivities_getactivities%')))
ADD TARGET package0.event_file(SET filename=N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\spActivities_GetActivities.xel')
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO
IF EXISTS (Select 1 from Sys.server_event_sessions Where name ='SpActvities_GetActivities_Summary')
Begin
	DROP EVENT SESSION [SpActvities_GetActivities_Summary] ON SERVER 
End
GO

CREATE EVENT SESSION [SpActvities_GetActivities_Summary] ON SERVER 
ADD EVENT sqlserver.attention(
    ACTION(package0.event_sequence,sqlserver.client_app_name,sqlserver.client_pid,sqlserver.database_id,sqlserver.nt_username,sqlserver.query_hash,sqlserver.server_principal_name,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[equal_boolean]([sqlserver].[is_system],(0)) AND [sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'%spactivities_getactivities%'))),
ADD EVENT sqlserver.rpc_completed(
    ACTION(package0.event_sequence,sqlserver.client_app_name,sqlserver.client_pid,sqlserver.database_id,sqlserver.nt_username,sqlserver.query_hash,sqlserver.server_principal_name,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[equal_boolean]([sqlserver].[is_system],(0)) AND [sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'%spactivities_getactivities%'))),
ADD EVENT sqlserver.sql_batch_completed(
    ACTION(package0.event_sequence,sqlserver.client_app_name,sqlserver.client_pid,sqlserver.database_id,sqlserver.nt_username,sqlserver.query_hash,sqlserver.server_principal_name,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[equal_boolean]([sqlserver].[is_system],(0)) AND [sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'%spactivities_getactivities%'))),
ADD EVENT sqlserver.sql_batch_starting(
    ACTION(package0.event_sequence,sqlserver.client_app_name,sqlserver.client_pid,sqlserver.database_id,sqlserver.nt_username,sqlserver.query_hash,sqlserver.server_principal_name,sqlserver.session_id,sqlserver.sql_text)
    WHERE ([package0].[equal_boolean]([sqlserver].[is_system],(0)) AND [sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'%spactivities_getactivities%')))
ADD TARGET package0.event_file(SET filename=N'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\SpActvities_GetActivities_Summary.xel')
WITH (MAX_MEMORY=8192 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=5 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=PER_CPU,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO

