CREATE TABLE #RowCountsAndSizes (TableName NVARCHAR(128),rows CHAR(11),      
       reserved VARCHAR(18),data VARCHAR(18),index_size VARCHAR(18), 
       unused VARCHAR(18))

EXEC       sp_MSForEachTable 'INSERT INTO #RowCountsAndSizes EXEC sp_spaceused ''?'' '

Alter Table #RowCountsAndSizes Add Percentage Float


UPDATE #RowCountsAndSizes SET Percentage = CONVERT(float,left(reserved,len(reserved)-3))/(Select sum(CONVERT(float,left(reserved,len(reserved)-3))) from #RowCountsAndSizes)


SELECT     TableName,CONVERT(bigint,rows) AS NumberOfRows,
           CONVERT(FLOAT,left(reserved,len(reserved)-3)) AS SizeinKB
		   ,		   CAST(Percentage *100 as decimal(18,2))
		   ,CONVERT(FLOAT,left(reserved,len(reserved)-3))/1024/1024 As sizeinGB
		   ,(select sum (CONVERT(FLOAT,left(reserved,len(reserved)-3))/1024/1024 ) FROM       #RowCountsAndSizes ) TotalSpace
FROM         #RowCountsAndSizes 
where tablename like '%prod_units_base'
OR  tablename like '%prod_lines_base%'
or tablename like '%DepartmentS_base%'
or tablename like '%products_base%'
or tablename like '%Product_Family%'

ORDER BY   NumberOfRows DESC,SizeinKB DESC,TableName

DROP TABLE #RowCountsAndSizes


 --Select TableName,CONVERT(bigint,rows) AS NumberOfRows,CONVERT(bigint,left(reserved,len(reserved)-3)) AS SizeinKB from #RowCountsAndSizes 

 
  
 ;WITH S AS(
SELECT  
REPLACE(REPLACE(
REPLACE(TableName,
LEFT(TableName,PATINDEX('%.%',Tablename)),''),'[',''),']','')

TableName,TableName ActualTablename,CONVERT(bigint,rows) AS NumberOfRows,
           CONVERT(FLOAT,left(reserved,len(reserved)-3)) AS SizeinKB
		   ,		   CAST(Percentage *100 as decimal(18,2)) Percentag
		   ,CONVERT(FLOAT,left(reserved,len(reserved)-3))/1024/1024 As sizeinGB
		   ,(select sum (CONVERT(FLOAT,left(reserved,len(reserved)-3))/1024/1024 ) FROM       #RowCountsAndSizes ) TotalSpace
FROM         #RowCountsAndSizes )



select S.ActualTablename,A.Starttime,A.Endtime,Datediff(millisecond,Starttime,endtime)DiffInMilliseconds,Datediff(second,Starttime,endtime)DiffInSeconds,Datediff(Minute,Starttime,endtime)DiffInMinutes,S.NumberOfRows,S.SizeinKB,S.sizeinGB,S.TotalSpace

from ##TESTTIMECAPTURE A

JOIN S ON S.TableName = A.Tablename
Order BY A.Tablename