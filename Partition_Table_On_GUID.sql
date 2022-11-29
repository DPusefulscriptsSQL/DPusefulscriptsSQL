--CREATE PARTITION FUNCTION [myPartitionFunction] (int)
--AS RANGE LEFT FOR VALUES (100,200,300,400,500,600,700,800,900)
--CREATE PARTITION SCHEME [myPartitionScheme] AS
--PARTITION [myPartitionFunction] ALL TO ( [PRIMARY] )

--CREATE FUNCTION GuidHash (@guid_value uniqueidentifier) RETURNS int
--WITH SCHEMABINDING AS
--BEGIN
-- RETURN abs(convert(bigint,convert(varbinary,@guid_value))) % 999
--END
--CREATE TABLE MyTable(  MyID UniqueIdentifier not null,  
--SomeField Char(200), 
--PartitionID as dbo.GuidHash(MyId) PERSISTED
--)
--ON myPartitionScheme(PartitionID)
--CREATE NONCLUSTERED INDEX [ix_id] ON [dbo].[MyTable] (  
--[MyID] ASC,  
--[PartitionID] ASC
--) ON [myPartitionScheme]([PartitionID])
-- DECLARE @guid uniqueidentifier
--SET @guid = newid()
--INSERT INTO mytable (myid, somefield) VALUES (@guid, 'some text')
--go 10000

SET STATISTICS IO ON
 
SELECT * FROM mytable WHERE myid = 'D41CA3AC-06D1-4ACC-ABCA-E67A18245596' 
  
SET STATISTICS IO OFF
SET STATISTICS IO ON
  
SELECT * FROM mytable WHERE (partitionid = dbo.guidhash ('D41CA3AC-06D1-4ACC-ABCA-E67A18245596') 
and myid = 'D41CA3AC-06D1-4ACC-ABCA-E67A18245596')

SET STATISTICS IO OFF



SELECT * FROM mytable where partitionId = 0 
update mytable set partitionId = 0 where myid ='0DBF593E-0843-487D-8A0B-8E94C240E0F4'

Select * from sys.partitions Where object_id =1440724185



