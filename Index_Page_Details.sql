-- CREATE TABLE test (i INT PRIMARY KEY not null, j VARCHAR(2000))
  
--INSERT INTO test (i,j)
--SELECT 1, REPLICATE('a',1000) UNION ALL
--SELECT 2, REPLICATE('b',1000) UNION ALL
--SELECT 3, REPLICATE('c',1000) UNION ALL
--SELECT 5, REPLICATE('d',1000) UNION ALL
--SELECT 6, REPLICATE('e',1000)
 INSERT INTO test (i,j)
SELECT 15, REPLICATE('n',1000)
--SELECT * FROM test  --g 8, n 15 

--DBCC IND(TESTPERF, 'test', 1);--178, 368

Select * from test where j like '%g%' 

update test set i = 16 where j like '%n%' 
update test set i = 15 where j like '%g%' 
update test set i = 8 where j like '%n%' 

--select * from sys.sysindexes where object_name(id) ='test'

--DBCC TRACEON(3604);
--DBCC PAGE (TESTPERF, 1, 368, 1);
--DBCC PAGE (TESTPERF, 1, 370, 1);
--DBCC PAGE (TESTPERF, 1, 371, 1);



--INSERT INTO test (i,j)
--SELECT 27, REPLICATE('b',1000)


----UPDATE Test set i=7 where i = 4

----UPDATE Test set i=4 where i = 7

--UPDATE Test set j='400' where i = 4