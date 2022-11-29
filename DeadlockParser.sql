-- REFERENCES:
-- see //msdn.microsoft.com/en-us/library/ms188246.aspx
-- (MS BOL Analyzing Deadlocks with SQL Server Profiler)
-- see //msdn.microsoft.com/en-us/library/ms175519.aspx
-- (MS BOL Lock Modes)
-- //blogs.msdn.com/bartd/archive/2006/09/09/Deadlock-Troubleshooting_2C00_-Part-1.aspx
-- //blogs.msdn.com/b/bartd/archive/2008/09/24/today-s-annoyingly-unwieldy-term-intra-query-parallel-thread-deadlocks.aspx
-- Shred XML Deadlock Graphs, showing in tabular format as much information as possible.
-- Insert the XML Deadlock Graph into the @deadlock table.
-- Author: Wayne Sheffield
-- Modification History:
-- Version - Date       - Description
-- 2         2010-10-10 - Added individual items in the Execution Stack node.
--                      - Converted from using an XML variable to a table variable with an XML variable
--                      -   to allow seeing multiple deadlocks simultaneously.
-- 3         2010-10-11 - Added KPID to Process CTE and final results.
--                      - Expanded LockMode to varchar(10).
-- 4         2011-05-11 - Added Waits.
-- 5         2011-05-15 - Revamped to minimize calls to the root of the deadlock xml nodes.
--                        Modified InputBuffer to be XML.
--                        Modified Execution Stack to return XML (vs. one row for each item, which
--                          was causing duplication of other data).
-- 6         2012-02-01 - Add loading deadlock info from fn_trace_gettable.
--                      - Get the InputBuffer from .query vs. trying to build XML.
--                      - Add number of processes involved in the deadlock.
--                      - Add the Query Statement being run.
-- 7         2012-09-01 - Corrected typo in ObjNode in both the Locks and Waits CTEs.
--                      - Added DENSE_RANK for each process.
--                      - Added support for exchangeEvent, threadpool, resourceWait events.
--                      -   (threadpool and resourceWait events are not tested - need to find a deadlock with them to test)
--                      - Simplified xpath queries
-- 8         2012-09-04 - Greatly simplified locks and waits CTEs based on feedback from Mark Cowne.
--                      - Added database_id and AssociatedObjectId per feedback from Gianluca Sartori.
--                      - Combined the Locks and Waits CTEs into one.
-- 9         2012-10-26 - Handle deadlock graphs from the system_health xe (has a victim-list node for multi-victim deadlocks).
-- 10        2013-07-29 - Added ability to load in a deadlock file (.xdl).
--                      - Added QueryStatement to output.
--                      - Switched from clause order from "Locks JOIN Process" to "Process LEFT JOIN Locks"
-- 11        2013-12-26 - Read in deadlocks from the system_health XE file target
-- 12        2014-05-06 - Read in deadlocks from the system_health XE ring buffer
-- 13        2014-07-01 - Read in deadlocks from SQL Sentry

DECLARE @deadlock TABLE (
        DeadlockID INT IDENTITY PRIMARY KEY CLUSTERED,
        DeadlockGraph XML
        );
-- use below to load a deadlock trace file
/*
DECLARE @file VARCHAR(500);
SELECT  @file = REVERSE(SUBSTRING(REVERSE([PATH]), CHARINDEX('\', REVERSE([path])), 260)) + N'LOG.trc'
FROM    sys.traces 
WHERE   is_default = 1; -- get the system default trace, use different # for other active traces.

-- or just SET @file = 'your trace file to load';

INSERT  INTO @deadlock (DeadlockGraph)
SELECT  TextData
FROM    ::FN_TRACE_GETTABLE(@file, DEFAULT)
WHERE   TextData LIKE '%';
*/

-- or read in a deadlock file - doesn't have to have a "xdl" extension.
/*
INSERT INTO @deadlock (DeadlockGraph)
SELECT *
FROM OPENROWSET(BULK 'Deadlock.xdl', SINGLE_BLOB) UselessAlias;
*/


-- or read in the deadlock from the system_health XE file target
/*
WITH cte1 AS
(
SELECT	target_data = convert(XML, target_data)
FROM	sys.dm_xe_session_targets t
		JOIN sys.dm_xe_sessions s 
		  ON t.event_session_address = s.address
WHERE	t.target_name = 'event_file'
AND		s.name = 'system_health'
), cte2 AS
(
SELECT	[FileName] = FileEvent.FileTarget.value('@name', 'varchar(1000)')
FROM	cte1
		CROSS APPLY cte1.target_data.nodes('//EventFileTarget/File') FileEvent(FileTarget)
), cte3 AS
(
SELECT	event_data = CONVERT(XML, t2.event_data)
FROM    cte2
		CROSS APPLY sys.fn_xe_file_target_read_file(cte2.[FileName], NULL, NULL, NULL) t2
WHERE	t2.object_name = 'xml_deadlock_report'
)
INSERT INTO @deadlock(DeadlockGraph)
SELECT  Deadlock = Deadlock.Report.query('.')
FROM	cte3	
		CROSS APPLY cte3.event_data.nodes('//event/data/value/deadlock') Deadlock(Report);
*/

-- or read in the deadlock from the system_health XE ring buffer
/*
INSERT INTO @deadlock(DeadlockGraph)
SELECT  --XEventData.XEvent.value('@timestamp', 'datetime') AS DeadlockDateTime,
        CONVERT(XML, XEventData.XEvent.value('(data/value)[1]', 'varchar(max)')) AS DeadlockGraph
FROM    (SELECT CAST(target_data AS XML) AS TargetData
         FROM   sys.dm_xe_session_targets st WITH (NOLOCK)
                JOIN sys.dm_xe_sessions s WITH (NOLOCK)
                  ON s.address = st.event_session_address
         WHERE  name = 'system_health'
        ) AS Data
        CROSS APPLY TargetData.nodes('//RingBufferTarget/event') AS XEventData (XEvent)
WHERE   XEventData.XEvent.value('@name', 'varchar(4000)') = 'xml_deadlock_report';
*/

/*
-- or read in the deadlock from SQL Sentry deadlock collection
INSERT INTO @deadlock(DeadlockGraph)
SELECT  deadlockxml
FROM    dbo.PerformanceAnalysisTraceDeadlock
*/

-- use below to load individual deadlocks.
-- INSERT INTO @deadlock VALUES ('Put your deadlock here');
-- Insert the deadlock XML in the above line!
-- Duplicate as necessary for additional graphs.



Insert into @deadlock(DeadlockGraph)
select cast('<deadlock>
  <victim-list>
    <victimProcess id="process274956a5848" />
  </victim-list>
  <process-list>
    <process id="process274956a5848" taskpriority="0" logused="0" waitresource="PAGE: 5:1:197691 " waittime="4817" ownerId="12918218470" transactionname="SELECT" lasttranstarted="2022-05-10T11:57:43.677" XDES="0x2744005c180" lockMode="S" schedulerid="10" kpid="8896" status="suspended" spid="922" sbid="0" ecid="0" priority="0" trancount="0" lastbatchstarted="2022-05-10T11:57:43.677" lastbatchcompleted="2022-05-10T11:57:43.677" lastattention="1900-01-01T00:00:00.677" clientapp="Core Microsoft SqlClient Data Provider" hostname="4250211fcfac" hostpid="990" loginname="proficyuser" isolationlevel="serializable (4)" xactid="12918218470" currentdb="5" currentdbname="SOADB" lockTimeout="4294967295" clientoption1="671088672" clientoption2="128056">
      <executionStack>
        <frame procname="adhoc" line="1" stmtstart="104" stmtend="2106" sqlhandle="0x020000003d67c00f383725489dfd119b7d9c618389beb3280000000000000000000000000000000000000000">
unknown    </frame>
        <frame procname="unknown" line="1" sqlhandle="0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000">
unknown    </frame>
      </executionStack>
      <inputbuf>
(@__operationsResourceParameters_OnHold_Value_2 bit)SELECT COUNT(*)
FROM (
    SELECT DISTINCT [v].[CompletedBy], [v].[CompletedOn], [v].[CompletedQuantity], [v].[LotIdentifier], [v].[LotInitialPlannedQuantity], [v].[LotPlannedQuantity], [v].[MaterialLotActualId], [v].[OnHold], [v].[OperationDescription], [v].[OperationName], [v].[ProducedMaterialId], [v].[ProductionLineId], [v].[ReadyOn], [v].[SegmentActualId], [v].[SegmentId], [v].[SegmentsDefinitionId], [v].[StartedBy], [v].[StartedOn], [v].[StartedOnUnitId], [v].[Status], [v].[WorkOrderId], [v].[WorkOrderName], [v].[WorkOrderPriority], [v].[WorkOrderPriorityInitialized]
    FROM [WorkOrder].[View_Operations] AS [v]
    LEFT JOIN [WorkOrder].[SegmentValidUnits] AS [s] ON ([v].[SegmentsDefinitionId] = [s].[SegmentsDefinitionId]) AND ([v].[SegmentId] = [s].[SegmentId])
    WHERE ((COALESCE([v].[StartedOnUnitId], [s].[ValidOnUnitId]) IN (CAST(251 AS bigint)) AND ([v].[Status] &lt;&gt; 10)) AND [v].[Status] IN (20, 30)) AND ([v].[OnHold] = @__operationsResourcePara   </inputbuf>
    </process>
    <process id="process275d301d088" taskpriority="0" logused="114000" waitresource="KEY: 5:72057594558218240 (faaae7eb87d8)" waittime="2456" ownerId="12918213534" transactionname="user_transaction" lasttranstarted="2022-05-10T11:57:43.417" XDES="0x275c4ce4420" lockMode="X" schedulerid="1" kpid="7184" status="suspended" spid="607" sbid="0" ecid="0" priority="0" trancount="2" lastbatchstarted="2022-05-10T11:57:43.440" lastbatchcompleted="2022-05-10T11:57:43.430" lastattention="1900-01-01T00:00:00.430" clientapp="Core Microsoft SqlClient Data Provider" hostname="4250211fcfac" hostpid="990" loginname="proficyuser" isolationlevel="serializable (4)" xactid="12918213534" currentdb="5" currentdbname="SOADB" lockTimeout="4294967295" clientoption1="673185824" clientoption2="128056">
      <executionStack>
        <frame procname="adhoc" line="278" stmtstart="36446" stmtend="36728" sqlhandle="0x020000003db7b5086d5f57176295d162e5428b0f5096646c0000000000000000000000000000000000000000">
unknown    </frame>
        <frame procname="unknown" line="1" sqlhandle="0x0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000">
unknown    </frame>
      </executionStack>
      <inputbuf>
(@p2 nvarchar(1000),@p3 bigint,@p4 nvarchar(100),@p5 bigint,@p6 nvarchar(1000),@p7 bigint,@p8 nvarchar(100),@p9 bigint,@p10 nvarchar(1000),@p11 bigint,@p12 nvarchar(100),@p13 bigint,@p14 nvarchar(1000),@p15 bigint,@p16 nvarchar(100),@p17 bigint,@p18 nvarchar(1000),@p19 bigint,@p20 nvarchar(100),@p21 bigint,@p22 nvarchar(1000),@p23 bigint,@p24 nvarchar(100),@p25 bigint,@p26 nvarchar(1000),@p27 bigint,@p28 nvarchar(100),@p29 bigint,@p30 nvarchar(1000),@p31 bigint,@p32 nvarchar(100),@p33 bigint,@p34 nvarchar(1000),@p35 bigint,@p36 nvarchar(100),@p37 bigint,@p38 nvarchar(1000),@p39 bigint,@p40 nvarchar(100),@p41 bigint,@p42 nvarchar(1000),@p43 bigint,@p44 nvarchar(100),@p45 bigint,@p46 nvarchar(1000),@p47 bigint,@p48 nvarchar(100),@p49 bigint,@p50 nvarchar(1000),@p51 bigint,@p52 nvarchar(100),@p53 bigint,@p54 nvarchar(1000),@p55 bigint,@p56 nvarchar(100),@p57 bigint,@p58 bigint,@p59 bigint,@p60 bigint,@p61 bigint,@p62 bigint,@p63 bigint,@p64 bigint,@p65 bigint,@p66 bigint,@p67 bigint,@p68 bigint,@p69 bigint,@p70   </inputbuf>
    </process>
  </process-list>
  <resource-list>
    <pagelock fileid="1" pageid="197691" dbid="5" subresource="FULL" objectname="SOADB.WorkOrder.SegmentValidUnits" id="lock2717f5e3380" mode="IX" associatedObjectId="72057594537443328">
      <owner-list>
        <owner id="process275d301d088" mode="IX" />
      </owner-list>
      <waiter-list>
        <waiter id="process274956a5848" mode="S" requestType="wait" />
      </waiter-list>
    </pagelock>
    <keylock hobtid="72057594558218240" dbid="5" objectname="SOADB.WorkOrder.View_OperationWithoutOperationName" indexname="IX_WorkOrderPriorityInitialized_WorkOrderPriority_ReadyOn_SegmentActualId" id="lock26f91ba9c80" mode="RangeS-U" associatedObjectId="72057594558218240">
      <owner-list>
        <owner id="process274956a5848" mode="RangeS-S" />
      </owner-list>
      <waiter-list>
        <waiter id="process275d301d088" mode="X" requestType="convert" />
      </waiter-list>
    </keylock>
  </resource-list>
</deadlock>' as xml)
;
WITH CTE AS 
(
SELECT  DeadlockID,
        DeadlockGraph
FROM    @deadlock
), Victims AS 
(
SELECT    ID = Victims.List.value('@id', 'varchar(50)')
FROM      CTE
          CROSS APPLY CTE.DeadlockGraph.nodes('//deadlock/victim-list/victimProcess') AS Victims (List)
), Locks AS 
(
-- Merge all of the lock information together.
SELECT  CTE.DeadlockID,
        MainLock.Process.value('@id', 'varchar(100)') AS LockID,
        OwnerList.Owner.value('@id', 'varchar(200)') AS LockProcessId,
        REPLACE(MainLock.Process.value('local-name(.)', 'varchar(100)'), 'lock', '') AS LockEvent,
        MainLock.Process.value('@objectname', 'sysname') AS ObjectName,
        OwnerList.Owner.value('@mode', 'varchar(10)') AS LockMode,
        MainLock.Process.value('@dbid', 'INTEGER') AS Database_id,
        MainLock.Process.value('@associatedObjectId', 'BIGINT') AS AssociatedObjectId,
        MainLock.Process.value('@WaitType', 'varchar(100)') AS WaitType,
        WaiterList.Owner.value('@id', 'varchar(200)') AS WaitProcessId,
        WaiterList.Owner.value('@mode', 'varchar(10)') AS WaitMode
FROM    CTE
        CROSS APPLY CTE.DeadlockGraph.nodes('//deadlock/resource-list') AS Lock (list)
        CROSS APPLY Lock.list.nodes('*') AS MainLock (Process)
        OUTER APPLY MainLock.Process.nodes('owner-list/owner') AS OwnerList (Owner)
        CROSS APPLY MainLock.Process.nodes('waiter-list/waiter') AS WaiterList (Owner)
), Process AS 
(
-- get the data from the process node
SELECT  CTE.DeadlockID,
        [Victim] = CONVERT(BIT, CASE WHEN Deadlock.Process.value('@id', 'varchar(50)') = ISNULL(Deadlock.Process.value('../../@victim', 'varchar(50)'), v.ID) 
                                     THEN 1
                                     ELSE 0
                                END),
        [LockMode] = Deadlock.Process.value('@lockMode', 'varchar(10)'), -- how is this different from in the resource-list section?
        [ProcessID] = Process.ID, --Deadlock.Process.value('@id', 'varchar(50)'),
        [KPID] = Deadlock.Process.value('@kpid', 'int'), -- kernel-process id / thread ID number
        [SPID] = Deadlock.Process.value('@spid', 'int'), -- system process id (connection to sql)
        [SBID] = Deadlock.Process.value('@sbid', 'int'), -- system batch id / request_id (a query that a SPID is running)
        [ECID] = Deadlock.Process.value('@ecid', 'int'), -- execution context ID (a worker thread running part of a query)
        [IsolationLevel] = Deadlock.Process.value('@isolationlevel', 'varchar(200)'),
        [WaitResource] = Deadlock.Process.value('@waitresource', 'varchar(200)'),
        [LogUsed] = Deadlock.Process.value('@logused', 'int'),
        [ClientApp] = Deadlock.Process.value('@clientapp', 'varchar(100)'),
        [HostName] = Deadlock.Process.value('@hostname', 'varchar(20)'),
        [LoginName] = Deadlock.Process.value('@loginname', 'varchar(20)'),
        [TransactionTime] = Deadlock.Process.value('@lasttranstarted', 'datetime'),
        [BatchStarted] = Deadlock.Process.value('@lastbatchstarted', 'datetime'),
        [BatchCompleted] = Deadlock.Process.value('@lastbatchcompleted', 'datetime'),
        [InputBuffer] = Input.Buffer.query('.'),
        CTE.[DeadlockGraph],
        es.ExecutionStack,
        [SQLHandle] = ExecStack.Stack.value('@sqlhandle', 'varchar(64)'),
        [QueryStatement] = NULLIF(ExecStack.Stack.value('.', 'varchar(max)'), ''),
        --[QueryStatement] = Execution.Frame.value('.', 'varchar(max)'),
        [ProcessQty] = SUM(1) OVER (PARTITION BY CTE.DeadlockID),
        [TranCount] = Deadlock.Process.value('@trancount', 'int')
FROM    CTE
        CROSS APPLY CTE.DeadlockGraph.nodes('//deadlock/process-list/process') AS Deadlock (Process)
        CROSS APPLY (SELECT Deadlock.Process.value('@id', 'varchar(50)') ) AS Process (ID)
        LEFT JOIN Victims v ON Process.ID = v.ID
        CROSS APPLY Deadlock.Process.nodes('inputbuf') AS Input (Buffer)
        CROSS APPLY Deadlock.Process.nodes('executionStack') AS Execution (Frame)
-- get the data from the executionStack node as XML
        CROSS APPLY (SELECT ExecutionStack = (SELECT   ProcNumber = ROW_NUMBER() 
                                                                    OVER (PARTITION BY CTE.DeadlockID,
                                                                                       Deadlock.Process.value('@id', 'varchar(50)'),
                                                                                       Execution.Stack.value('@procname', 'sysname'),
                                                                                       Execution.Stack.value('@code', 'varchar(MAX)') 
                                                                              ORDER BY (SELECT 1)),
                                                        ProcName = Execution.Stack.value('@procname', 'sysname'),
                                                        Line = Execution.Stack.value('@line', 'int'),
                                                        SQLHandle = Execution.Stack.value('@sqlhandle', 'varchar(64)'),
                                                        Code = LTRIM(RTRIM(Execution.Stack.value('.', 'varchar(MAX)')))
                                                FROM Execution.Frame.nodes('frame') AS Execution (Stack)
                                                ORDER BY ProcNumber
                                                FOR XML PATH('frame'), ROOT('executionStack'), TYPE )
                    ) es
        CROSS APPLY Execution.Frame.nodes('frame') AS ExecStack (Stack)
)
     -- get the columns in the desired order
--SELECT * FROM Locks

SELECT  p.DeadlockID,
        p.Victim,
        p.ProcessQty,
        ProcessNbr = DENSE_RANK() 
                     OVER (PARTITION BY p.DeadlockId 
                               ORDER BY p.ProcessID),
        p.LockMode,
        LockedObject = NULLIF(l.ObjectName, ''),
        l.database_id,
        l.AssociatedObjectId,
        LockProcess = p.ProcessID,
        p.KPID,
        p.SPID,
        p.SBID,
        p.ECID,
        p.TranCount,
        l.LockEvent,
        LockedMode = l.LockMode,
        l.WaitProcessID,
        l.WaitMode,
        p.WaitResource,
        l.WaitType,
        p.IsolationLevel,
        p.LogUsed,
        p.ClientApp,
        p.HostName,
        p.LoginName,
        p.TransactionTime,
        p.BatchStarted,
        p.BatchCompleted,
        p.QueryStatement,
        p.SQLHandle,
        p.InputBuffer,
        p.DeadlockGraph,
        p.ExecutionStack
FROM    Process p
        LEFT JOIN Locks l
        --JOIN Process p
            ON p.DeadlockID = l.DeadlockID
               AND p.ProcessID = l.LockProcessID
ORDER BY p.DeadlockId,
        p.Victim DESC,
        p.ProcessId;