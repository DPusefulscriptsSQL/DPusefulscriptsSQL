SELECT 'ALTER DATABASE tempdb MODIFY FILE (NAME = [' + f.name + '],'
	+ ' FILENAME = ''Z:\MSSQL\DATA\' + f.name
	+ CASE WHEN f.type = 1 THEN '.ldf' ELSE '.mdf' END
	+ ''');',*
FROM sys.master_files f
WHERE f.database_id = DB_ID(N'GBDB');
 /*
ALTER DATABASE tempdb MODIFY FILE (NAME = [tempdev], FILENAME = 'E:\SQLDATA\tempdev.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [templog], FILENAME = 'E:\SQLDATA\templog.ldf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp2], FILENAME = 'E:\SQLDATA\temp2.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp3], FILENAME = 'E:\SQLDATA\temp3.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp4], FILENAME = 'E:\SQLDATA\temp4.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp5], FILENAME = 'E:\SQLDATA\temp5.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp6], FILENAME = 'E:\SQLDATA\temp6.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp7], FILENAME = 'E:\SQLDATA\temp7.mdf');
ALTER DATABASE tempdb MODIFY FILE (NAME = [temp8], FILENAME = 'E:\SQLDATA\temp8.mdf');
ALTER DATABASE GBDB MODIFY FILE (NAME = [GBDB_Index], FILENAME = 'E:\SQLDATA\GBDB_Index.mdf');
*/ 
