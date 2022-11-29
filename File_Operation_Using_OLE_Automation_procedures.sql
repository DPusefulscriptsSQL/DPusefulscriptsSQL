/*
Run these below command under sysadmin user role.
*/
USE MASTER
GO
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'Ole Automation Procedures', 1;
GO
RECONFIGURE;
GO

/*
Grant execute permission to the non-sysadmin user by a sysadmin user
*/
GRANT EXECUTE ON sp_OACreate TO <user>;
GRANT EXECUTE ON sp_OAMethod TO <user>;
GRANT EXECUTE ON sp_OADestroy TO <user>;
/*
CREATE FILE AND WRITE INTO THAT
*/
DECLARE @OLE INT
DECLARE @FileID INT
EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT
EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, 'C:\Users\public\SQLTEXT.TXT', 8, 1
--EXECUTE sp_OAMethod @FileID, 'WriteLine', Null, 'Today is wonderful day'
EXECUTE sp_OADestroy @FileID
EXECUTE sp_OADestroy @OLE
GO
/*
Delete  a file
*/
DECLARE @OLE INT
DECLARE @FileID INT
EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT
--EXECUTE sp_OAMethod @OLE, 'DeleteFile', @FileID OUT, 'C:\Users\public\SQLTEXT.TXT'-- , 8, 1
 --EXECUTE sp_OADestroy @FileID
 EXECUTE sp_OAMethod @OLE, 'DeleteFile', NULL, 'C:\Users\public\SQLTEXT.TXT'-- , 8, 1
EXECUTE sp_OADestroy @OLE 