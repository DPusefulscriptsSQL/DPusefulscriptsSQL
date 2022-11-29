SELECT srvname AS OldName FROM master.dbo.sysservers
SELECT SERVERPROPERTY('ServerName') AS NewName
 



sp_dropserver 'WIN-JOA7478T4QR';  
GO  
sp_addserver 'WIN-JOA7478TSQL', local;
use gbdb

Exec sys.sp_cdc_enable_db

 
EXEC sp_changedbowner 'sa'

ALTER AUTHORIZATION ON DATABASE::GBDB TO [sa];