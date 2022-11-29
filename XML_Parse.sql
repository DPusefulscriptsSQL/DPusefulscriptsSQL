DECLARE @Nodes TABLE
(
NodeID INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
ParentNodeName NVARCHAR(64),
NodeName NVARCHAR(64)
)

DECLARE @Data XML

SET @Data = '
<rows>
  <row>
    <ResultSetType>4</ResultSetType>
    <TopicId>300</TopicId>
    <MessageKey>3772</MessageKey>
    <PUId>3772</PUId>
    <EventType>1</EventType>
    <KeyId>3198</KeyId>
    <KeyTime>2021-09-22T11:15:00</KeyTime>
    <ActivityId>6257564</ActivityId>
    <ActivityDesc>[PFL-013 Time]</ActivityDesc>
    <APriority>1</APriority>
    <AStatus>2</AStatus>
    <StartTime>2021-09-22T10:47:54</StartTime>
    <TDuration>0</TDuration>
    <UserId>2690</UserId>
    <EntryOn>2021-09-22T10:47:54.153</EntryOn>
    <TransType>2</TransType>
    <PercentComplete>1.000000000000000e+001</PercentComplete>
    <ExecutionStartTime>2021-09-22T11:15:00</ExecutionStartTime>
    <AutoComplete>0</AutoComplete>
    <TestsToComplete>27</TestsToComplete>
    <Locked>1</Locked>
    <SheetId>3198</SheetId>
    <TransNum>3</TransNum>
    <LockActivity>1</LockActivity>
    <NeedOverdueComment>0</NeedOverdueComment>
  </row>
</rows>'

INSERT @Nodes
(
ParentNodeName,
NodeName
)
SELECT e.value('local-name(..)[1]', 'VARCHAR(MAX)') AS ParentNodeName,
e.value('local-name(.)[1]', 'VARCHAR(MAX)') AS NodeName
FROM @data.nodes('//*[local-name(.) > ""]') AS n(e)

;WITH Yak(NodeLevel, RootName, ElementName, NodeID, NodePath, ElementPath)
AS (
SELECT 0,
ParentNodeName,
NodeName,
NodeID,
CAST(NodeID AS VARCHAR(MAX)),
CAST(NodeName AS VARCHAR(MAX))
FROM @Nodes
WHERE ParentNodeName = ''

UNION ALL

SELECT y.NodeLevel + 1,
n.ParentNodeName,
n.NodeName,
n.NodeID,
y.NodePath + ';' + CAST(n.NodeID AS VARCHAR(MAX)),
y.ElementPath + '\' + CAST(n.NodeName AS VARCHAR(MAX))
FROM @Nodes AS n
INNER JOIN Yak AS y ON y.ElementName = n.ParentNodeName
)

SELECT RootName,
REPLICATE(' ', NodeLevel) + ElementName AS ElementName,
ROW_NUMBER() OVER (PARTITION BY RootName ORDER BY ElementName) AS SortedByElementName,
ROW_NUMBER() OVER (PARTITION BY RootName ORDER BY NodeID) AS SortedByPresence,
ElementPath
FROM Yak
ORDER BY NodePath 
 
 --select * from TempPending_ResultSets
--Where Rs_Value.exist('(/rows/row/ActivityId[contains(,"6257564")])')=1
 
  


-- select Rs_Value.query('data(/rows[1]/row[1]/ActivityId)') from TempPending_ResultSets


--Begin tran

--Declare @ActivityIds table (ActivityId int)
--insert into @ActivityIds select 6257564
--Delete from TempPending_ResultSets
--Where Rs_Value.exist(N'(/rows/row/ActivityId[text()in (6257564)])')=1
--Rollback Tran
--go
--Begin Tran

--Declare @ActivityIds table (ActivityId int)
--insert into @ActivityIds select 6257564
--;WITH TmpPendingResultSet AS 
--	(
--		Select 
--			CAST(ISNULL(LTRIM(RTRIM(REPLACE(CAST(RS_Value.query('data(/rows[1]/row[1]/TransType)') as nVarChar(max)),' ',''))),0) as  Int) TransType
--			,CAST(ISNULL(LTRIM(RTRIM(REPLACE(CAST(RS_Value.query('data(/rows[1]/row[1]/ActivityId)') as nVarChar(max)),' ',''))),0) as  Int)  ActivityId
--			,RS_Id
--		from 
--			Pending_Resultsets
--	)
--	Delete Pr 
--	from 
--		TempPending_ResultSets Pr
--		Join TmpPendingResultSet T on T.RS_Id = Pr.RS_Id And T.TransType = 2
--		JOIN @ActivityIds A ON  T.ActivityId = A.ActivityId 
 

--Rollback Tran
 
Begin Tran
Declare @id nvarchar(10) =N'2'
Declare @ActivityIds table (ActivityId int)
insert into @ActivityIds select 6257564
--Delete a from TempPending_ResultSets a join @ActivityIds b on
--a.Rs_Value.exist(N'(/rows/row/ActivityId[text() = sql:column("b.ActivityId")])')=1
--and a.Rs_Value.exist(N'(/rows/row/TransType[text() =sql:variable("@id")])')=1

Delete a from TempPending_ResultSets a join @ActivityIds b on
a.Rs_Value.exist(N'(/rows/row[ActivityId[text() = sql:column("b.ActivityId")]][TransType[text() =sql:variable("@id")]])')=1
Select @@ROWCOUNT
ROllback Tran

 





--XMLData.exist('/DataObject/Objects[Object[@Name="State" and @Value=sql:variable("@State")] 
--    and Object[@Name="Department" and @Value=sql:variable("@Dept")]]') = 1;





SELECT Top 1 CONVERT(XML, event_data) XMLData
             FROM   sys.fn_xe_file_target_read_file('system_health*.xel', NULL, NULL, NULL) 
Where object_name ='xml_deadlock_report'
and File_Offset =83456