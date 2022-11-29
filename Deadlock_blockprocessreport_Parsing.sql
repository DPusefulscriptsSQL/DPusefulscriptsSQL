--CREATE TABLE #ReportsXML
--(
--	monitorloop nvarchar(100) NOT NULL,
--	endTime datetime NULL,
--	blocking_spid INT NOT NULL,
--	blocking_ecid INT NOT NULL,
--	blocked_spid INT NOT NULL,
--	blocked_ecid INT NOT NULL,
--	blocked_hierarchy_string as CAST(blocked_spid as varchar(20)) + '.' + CAST(blocked_ecid as varchar(20)) + '/',
--	blocking_hierarchy_string as CAST(blocking_spid as varchar(20)) + '.' + CAST(blocking_ecid as varchar(20)) + '/',
--	bpReportXml xml not null,
--	primary key clustered (monitorloop, blocked_spid, blocked_ecid),
--	unique nonclustered (monitorloop, blocking_spid, blocking_ecid, blocked_spid, blocked_ecid)
--)
DECLARE @deadlock TABLE (
        DeadlockID INT IDENTITY PRIMARY KEY CLUSTERED,
        DeadlockGraph XML
        );
;WITH events_cte AS (
  SELECT
    xevents.event_data,
    DATEADD(mi,
    DATEDIFF(mi, GETUTCDATE(), CURRENT_TIMESTAMP),
    xevents.event_data.value(
      '(event/@timestamp)[1]', 'datetime2')) AS [event time] ,
    xevents.event_data.value(
      '(event/action[@name="client_app_name"]/value)[1]', 'nvarchar(128)')
      AS [client app name],
    xevents.event_data.value(
      '(event/action[@name="client_hostname"]/value)[1]', 'nvarchar(max)')
      AS [client host name],
    xevents.event_data.value(
      '(event[@name="blocked_process_report"]/data[@name="database_name"]/value)[1]', 'nvarchar(max)')
      AS [database name],
    xevents.event_data.value(
      '(event[@name="blocked_process_report"]/data[@name="database_id"]/value)[1]', 'int')
      AS [database_id],
    xevents.event_data.value(
      '(event[@name="blocked_process_report"]/data[@name="object_id"]/value)[1]', 'int')
      AS [object_id],
    xevents.event_data.value(
      '(event[@name="blocked_process_report"]/data[@name="index_id"]/value)[1]', 'int')
      AS [index_id],
    xevents.event_data.value(
      '(event[@name="blocked_process_report"]/data[@name="duration"]/value)[1]', 'bigint') / 1000
      AS [duration (ms)],
    xevents.event_data.value(
      '(event[@name="blocked_process_report"]/data[@name="lock_mode"]/text)[1]', 'varchar')
      AS [lock_mode],
    xevents.event_data.value(
      '(event[@name="blocked_process_report"]/data[@name="login_sid"]/value)[1]', 'int')
      AS [login_sid],
    xevents.event_data.query(
      '(event[@name="blocked_process_report"]/data[@name="blocked_process"]/value/blocked-process-report)[1]')
      AS blocked_process_report,
    xevents.event_data.query(
      '(event/data[@name="xml_report"]/value/deadlock)[1]')
      AS deadlock_graph
  FROM    sys.fn_xe_file_target_read_file
    ('C:\Program Files\Microsoft SQL Server\MSSQL15.SQL2019\MSSQL\Log\Deadlock_Blocked_Process_report_0_133009090217790000.xel',
     null,
     null, null)
    CROSS APPLY (SELECT CAST(event_data AS XML) AS event_data) as xevents
)
/*
SELECT
  CASE WHEN blocked_process_report.value('(blocked-process-report[@monitorLoop])[1]', 'nvarchar(max)') IS NULL
       THEN 'Deadlock'
       ELSE 'Blocked Process'
       END AS ReportType,
  [event time],
  CASE [client app name] WHEN '' THEN ' -- N/A -- '
                         ELSE [client app name]
                         END AS [client app _name],
  CASE [client host name] WHEN '' THEN ' -- N/A -- '
                          ELSE [client host name]
                          END AS [client host name],
  [database name],
  COALESCE(OBJECT_SCHEMA_NAME(object_id, database_id), ' -- N/A -- ') AS [schema],
  COALESCE(OBJECT_NAME(object_id, database_id), ' -- N/A -- ') AS [table],
  index_id,
  [duration (ms)],
  lock_mode,
  COALESCE(SUSER_NAME(login_sid), ' -- N/A -- ') AS username,
  CASE WHEN blocked_process_report.value('(blocked-process-report[@monitorLoop])[1]', 'nvarchar(max)') IS NULL
       THEN deadlock_graph
       ELSE blocked_process_report
       END AS Report
FROM events_cte
ORDER BY [event time] DESC ;
*/
Insert Into @deadlock(DeadlockGraph)
Select CASE WHEN blocked_process_report.value('(blocked-process-report[@monitorLoop])[1]', 'nvarchar(max)') IS NULL
       THEN deadlock_graph
       ELSE blocked_process_report
       END FROM events_cte
	  
--;WITH CTE AS 
--(
--SELECT  DeadlockID,
--        DeadlockGraph
--FROM    @deadlock
--), Victims AS 
--(
--SELECT    ID = Victims.List.value('@id', 'varchar(50)')
--FROM      CTE
--          CROSS APPLY CTE.DeadlockGraph.nodes('//deadlock/victim-list/victimProcess') AS Victims (List)
--), Locks AS 
--(
---- Merge all of the lock information together.
--SELECT  CTE.DeadlockID,
--        MainLock.Process.value('@id', 'varchar(100)') AS LockID,
--        OwnerList.Owner.value('@id', 'varchar(200)') AS LockProcessId,
--        REPLACE(MainLock.Process.value('local-name(.)', 'varchar(100)'), 'lock', '') AS LockEvent,
--        MainLock.Process.value('@objectname', 'sysname') AS ObjectName,
--        OwnerList.Owner.value('@mode', 'varchar(10)') AS LockMode,
--        MainLock.Process.value('@dbid', 'INTEGER') AS Database_id,
--        MainLock.Process.value('@associatedObjectId', 'BIGINT') AS AssociatedObjectId,
--        MainLock.Process.value('@WaitType', 'varchar(100)') AS WaitType,
--        WaiterList.Owner.value('@id', 'varchar(200)') AS WaitProcessId,
--        WaiterList.Owner.value('@mode', 'varchar(10)') AS WaitMode
--FROM    CTE
--        CROSS APPLY CTE.DeadlockGraph.nodes('//deadlock/resource-list') AS Lock (list)
--        CROSS APPLY Lock.list.nodes('*') AS MainLock (Process)
--        OUTER APPLY MainLock.Process.nodes('owner-list/owner') AS OwnerList (Owner)
--        CROSS APPLY MainLock.Process.nodes('waiter-list/waiter') AS WaiterList (Owner)
--), Process AS 
--(
---- get the data from the process node
--SELECT  CTE.DeadlockID,
--        [Victim] = CONVERT(BIT, CASE WHEN Deadlock.Process.value('@id', 'varchar(50)') = ISNULL(Deadlock.Process.value('../../@victim', 'varchar(50)'), v.ID) 
--                                     THEN 1
--                                     ELSE 0
--                                END),
--        [LockMode] = Deadlock.Process.value('@lockMode', 'varchar(10)'), -- how is this different from in the resource-list section?
--        [ProcessID] = Process.ID, --Deadlock.Process.value('@id', 'varchar(50)'),
--        [KPID] = Deadlock.Process.value('@kpid', 'int'), -- kernel-process id / thread ID number
--        [SPID] = Deadlock.Process.value('@spid', 'int'), -- system process id (connection to sql)
--        [SBID] = Deadlock.Process.value('@sbid', 'int'), -- system batch id / request_id (a query that a SPID is running)
--        [ECID] = Deadlock.Process.value('@ecid', 'int'), -- execution context ID (a worker thread running part of a query)
--        [IsolationLevel] = Deadlock.Process.value('@isolationlevel', 'varchar(200)'),
--        [WaitResource] = Deadlock.Process.value('@waitresource', 'varchar(200)'),
--        [LogUsed] = Deadlock.Process.value('@logused', 'int'),
--        [ClientApp] = Deadlock.Process.value('@clientapp', 'varchar(100)'),
--        [HostName] = Deadlock.Process.value('@hostname', 'varchar(20)'),
--        [LoginName] = Deadlock.Process.value('@loginname', 'varchar(20)'),
--        [TransactionTime] = Deadlock.Process.value('@lasttranstarted', 'datetime'),
--        [BatchStarted] = Deadlock.Process.value('@lastbatchstarted', 'datetime'),
--        [BatchCompleted] = Deadlock.Process.value('@lastbatchcompleted', 'datetime'),
--        [InputBuffer] = Input.Buffer.query('.'),
--        CTE.[DeadlockGraph],
--        es.ExecutionStack,
--        [SQLHandle] = ExecStack.Stack.value('@sqlhandle', 'varchar(64)'),
--        [QueryStatement] = NULLIF(ExecStack.Stack.value('.', 'varchar(max)'), ''),
--        --[QueryStatement] = Execution.Frame.value('.', 'varchar(max)'),
--        [ProcessQty] = SUM(1) OVER (PARTITION BY CTE.DeadlockID),
--        [TranCount] = Deadlock.Process.value('@trancount', 'int')
--FROM    CTE
--        CROSS APPLY CTE.DeadlockGraph.nodes('//deadlock/process-list/process') AS Deadlock (Process)
--        CROSS APPLY (SELECT Deadlock.Process.value('@id', 'varchar(50)') ) AS Process (ID)
--        LEFT JOIN Victims v ON Process.ID = v.ID
--        CROSS APPLY Deadlock.Process.nodes('inputbuf') AS Input (Buffer)
--        CROSS APPLY Deadlock.Process.nodes('executionStack') AS Execution (Frame)
---- get the data from the executionStack node as XML
--        CROSS APPLY (SELECT ExecutionStack = (SELECT   ProcNumber = ROW_NUMBER() 
--                                                                    OVER (PARTITION BY CTE.DeadlockID,
--                                                                                       Deadlock.Process.value('@id', 'varchar(50)'),
--                                                                                       Execution.Stack.value('@procname', 'sysname'),
--                                                                                       Execution.Stack.value('@code', 'varchar(MAX)') 
--                                                                              ORDER BY (SELECT 1)),
--                                                        ProcName = Execution.Stack.value('@procname', 'sysname'),
--                                                        Line = Execution.Stack.value('@line', 'int'),
--                                                        SQLHandle = Execution.Stack.value('@sqlhandle', 'varchar(64)'),
--                                                        Code = LTRIM(RTRIM(Execution.Stack.value('.', 'varchar(MAX)')))
--                                                FROM Execution.Frame.nodes('frame') AS Execution (Stack)
--                                                ORDER BY ProcNumber
--                                                FOR XML PATH('frame'), ROOT('executionStack'), TYPE )
--                    ) es
--        CROSS APPLY Execution.Frame.nodes('frame') AS ExecStack (Stack)
--)
--     -- get the columns in the desired order
----SELECT * FROM Locks
 
--SELECT  p.DeadlockID,
--        p.Victim,
--        p.ProcessQty,
--        ProcessNbr = DENSE_RANK() 
--                     OVER (PARTITION BY p.DeadlockId 
--                               ORDER BY p.ProcessID),
--        p.LockMode,
--        LockedObject = NULLIF(l.ObjectName, ''),
--        l.database_id,
--        l.AssociatedObjectId,
--        LockProcess = p.ProcessID,
--        p.KPID,
--        p.SPID,
--        p.SBID,
--        p.ECID,
--        p.TranCount,
--        l.LockEvent,
--        LockedMode = l.LockMode,
--        l.WaitProcessID,
--        l.WaitMode,
--        p.WaitResource,
--        l.WaitType,
--        p.IsolationLevel,
--        p.LogUsed,
--        p.ClientApp,
--        p.HostName,
--        p.LoginName,
--        p.TransactionTime,
--        p.BatchStarted,
--        p.BatchCompleted,
--        p.QueryStatement,
--        p.SQLHandle,
--        p.InputBuffer,
--        p.DeadlockGraph,
--        p.ExecutionStack
--FROM    Process p
--        LEFT JOIN Locks l
--        --JOIN Process p
--            ON p.DeadlockID = l.DeadlockID
--               AND p.ProcessID = l.LockProcessID
--ORDER BY p.DeadlockId,
--        p.Victim DESC,
--        p.ProcessId;
--CREATE TABLE #TraceXML (
--		id int identity primary key,
--		ReportXML xml NOT NULL	
--	)
--INSERT INTO #TraceXML (ReportXML)
--Select DeadlockGraph from @deadlock Where DeadlockGraph is not null;
--CREATE PRIMARY XML INDEX PXML_TraceXML ON #TraceXML(ReportXML);
--WITH XMLNAMESPACES 
--	(
--		'http://tempuri.org/TracePersistence.xsd' AS MY
--	),
--	ShreddedWheat AS 
--	(
--		SELECT
--			bpShredded.blocked_ecid,
--			bpShredded.blocked_spid,
--			bpShredded.blocking_ecid,
--			bpShredded.blocking_spid,
--			bpShredded.monitorloop,
--			bpReports.bpReportXml,
--			bpReports.bpReportEndTime
--		FROM #TraceXML
--		CROSS APPLY 
--			ReportXML.nodes('/MY:TraceData/MY:Events/MY:Event[@name="Blocked process report"]')
--			AS eventNodes(eventNode)
--		CROSS APPLY 
--			eventNode.nodes('./MY:Column[@name="EndTime"]')
--			AS endTimeNodes(endTimeNode)
--		CROSS APPLY
--			eventNode.nodes('./MY:Column[@name="TextData"]')
--			AS bpNodes(bpNode)
--		CROSS APPLY (
--			SELECT CAST(bpNode.value('(./text())[1]', 'nvarchar(max)') as xml),
--				CAST(LEFT(endTimeNode.value('(./text())[1]', 'varchar(max)'), 19) as datetime)
--		) AS bpReports(bpReportXml, bpReportEndTime)
--		CROSS APPLY (
--			SELECT 
--				monitorloop = bpReportXml.value('(//@monitorLoop)[1]', 'nvarchar(100)'),
--				blocked_spid = bpReportXml.value('(/blocked-process-report/blocked-process/process/@spid)[1]', 'int'),
--				blocked_ecid = bpReportXml.value('(/blocked-process-report/blocked-process/process/@ecid)[1]', 'int'),
--				blocking_spid = bpReportXml.value('(/blocked-process-report/blocking-process/process/@spid)[1]', 'int'),
--				blocking_ecid = bpReportXml.value('(/blocked-process-report/blocking-process/process/@ecid)[1]', 'int')
--		) AS bpShredded
--	)
--	INSERT #ReportsXML(blocked_ecid,blocked_spid,blocking_ecid,blocking_spid,
--		monitorloop,bpReportXml,endTime)
--	SELECT blocked_ecid,blocked_spid,blocking_ecid,blocking_spid,
--		COALESCE(monitorloop, CONVERT(nvarchar(100), bpReportEndTime, 120), 'unknown'),
--		bpReportXml,bpReportEndTime
--	FROM ShreddedWheat;
	
--	DROP TABLE #TraceXML
--	;WITH Blockheads AS
--(
--	SELECT blocking_spid, blocking_ecid, monitorloop, blocking_hierarchy_string
--	FROM #ReportsXML
--	EXCEPT
--	SELECT blocked_spid, blocked_ecid, monitorloop, blocked_hierarchy_string
--	FROM #ReportsXML
--), 
--Hierarchy AS
--(
--	SELECT monitorloop, blocking_spid as spid, blocking_ecid as ecid, 
--		cast('/' + blocking_hierarchy_string as varchar(max)) as chain,
--		0 as level
--	FROM Blockheads
	
--	UNION ALL
	
--	SELECT irx.monitorloop, irx.blocked_spid, irx.blocked_ecid,
--		cast(h.chain + irx.blocked_hierarchy_string as varchar(max)),
--		h.level+1
--	FROM #ReportsXML irx
--	JOIN Hierarchy h
--		ON irx.monitorloop = h.monitorloop
--		AND irx.blocking_spid = h.spid
--		AND irx.blocking_ecid = h.ecid
--)
--SELECT 
--	ISNULL(CONVERT(nvarchar(30), irx.endTime, 120), 
--		'Lead') as traceTime,
--	SPACE(4 * h.level) 
--		+ CAST(h.spid as varchar(20)) 
--		+ CASE h.ecid 
--			WHEN 0 THEN ''
--			ELSE '(' + CAST(h.ecid as varchar(20)) + ')' 
--		END AS blockingTree,
--	irx.bpReportXml
--from Hierarchy h
--left join #ReportsXML irx
--	on irx.monitorloop = h.monitorloop
--	and irx.blocked_spid = h.spid
--	and irx.blocked_ecid = h.ecid
--order by h.monitorloop, h.chain

--DROP TABLE #ReportsXML
;WITH S AS (
Select  


DeadlockID,
DeadlockGraph.value('(/blocked-process-report/blocked-process/process/inputbuf)[1]', 'nvarchar(100)') [Victim],
DeadlockGraph.value('(/blocked-process-report/blocking-process/process/inputbuf)[1]', 'nvarchar(100)') [BlockingSession],
DeadlockGraph.value('(/blocked-process-report/blocked-process/process/@clientapp)[1]', 'nvarchar(100)') [Victim Client],
DeadlockGraph.value('(/blocked-process-report/blocking-process/process/@clientapp)[1]', 'nvarchar(100)') [BlockingSession Client],
DeadlockGraph.value('(/blocked-process-report/blocked-process/process/@status)[1]', 'nvarchar(100)') [Victim Status],
DeadlockGraph.value('(/blocked-process-report/blocking-process/process/@status)[1]', 'nvarchar(100)') [BlockingSession Status],
DeadlockGraph.value('(/blocked-process-report/blocked-process/process/@waittime)[1]', 'nvarchar(100)') [Victim Waittime],
DeadlockGraph.value('(/blocked-process-report/blocking-process/process/@waittime)[1]', 'nvarchar(100)') [BlockingSession Waitime],
DeadlockGraph.value('(/blocked-process-report/blocked-process/process/@lockMode)[1]', 'nvarchar(100)') [Victim lockmode],
DeadlockGraph.value('(/blocked-process-report/blocking-process/process/@lockMode)[1]', 'nvarchar(100)') [BlockingSession lockmode],
DeadlockGraph.value('(/blocked-process-report/blocked-process/process/@hostname)[1]', 'nvarchar(100)') [Victim hostname],
DeadlockGraph.value('(/blocked-process-report/blocking-process/process/@hostname)[1]', 'nvarchar(100)') [BlockingSession hostname],
DeadlockGraph.value('(/blocked-process-report/blocked-process/process/@loginname)[1]', 'nvarchar(100)') [Victim loginname],
DeadlockGraph.value('(/blocked-process-report/blocking-process/process/@loginname)[1]', 'nvarchar(100)') [BlockingSession loginname],
DeadlockGraph.value('(/blocked-process-report/blocked-process/process/@lockTimeout)[1]', 'nvarchar(100)') [Victim lockTimeOut],
DeadlockGraph.value('(/blocked-process-report/blocking-process/process/@lockTimeout)[1]', 'nvarchar(100)') [BlockingSession LockTimeout],
DeadlockGraph.value('(/blocked-process-report/blocked-process/process/@trancount)[1]', 'nvarchar(100)') [Victim TransactionCount],
DeadlockGraph.value('(/blocked-process-report/blocking-process/process/@trancount)[1]', 'nvarchar(100)') [BlockingSession TransactionCount],
DeadlockGraph.value('(/blocked-process-report/blocked-process/process/@currentdbname)[1]', 'nvarchar(100)') [Victim DB],
DeadlockGraph.value('(/blocked-process-report/blocking-process/process/@currentdbname)[1]', 'nvarchar(100)') [BlockingSession DB]
,DeadlockGraph.value('(/blocked-process-report/blocked-process/process/@spid)[1]', 'nvarchar(100)') [Victim SPid],
DeadlockGraph.value('(/blocked-process-report/blocking-process/process/@spid)[1]', 'nvarchar(100)') [BlockingSession SPid]










from @deadlock)
Select  
--CASE WHEN PATINDEX('%'+'Object Id = '+'%',victim) >0 
--THEN 
--REPLACE(RIGHT(Victim,PATINDEX('%'+'Object Id = '+'%',victim)-LEN('Object Id = ')+1),']','') ELSE '' END [Victim Object Id],
--CASE WHEN PATINDEX('%'+'Object Id = '+'%',BlockingSession)>0
--THEN 
--REPLACE(RIGHT(BlockingSession,PATINDEX('%'+'Object Id = '+'%',BlockingSession)-LEN('Object Id = ')+1),']','')  ELSE '' END [BlockingSession Object Id]
--,*
Distinct [BlockingSession SPid],BlockingSession,[BlockingSession Client],[BlockingSession DB],[BlockingSession hostname],[BlockingSession lockmode],[BlockingSession loginname],[BlockingSession Status]
from S 