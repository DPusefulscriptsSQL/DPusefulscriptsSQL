select @@servername--WIN-1UE267S2VRN

select 

SERVERPROPERTY('ServerName')--WIN2K16SAN02




exec sp_dropserver 'WIN-1UE267S2VRN';
exec sp_addserver 'WIN2K16SAN02','local';


exec sp_helpserver

--SELECT * FROM master.dbo.sysservers

 

--select 

--SERVERPROPERTY('ServerName')


--DECLARE @ServerName NVARCHAR(128) = CONVERT(sysname, SERVERPROPERTY('servername'));
--EXEC sp_addserver @ServerName, 'local';
--GO

--use master

--SOADB_log.ldf
--SOADB.mdf


--exec sp_dropserver 'oldservername'