;WITH task_space_usage AS (
    -- SUM alloc/delloc pages
    SELECT session_id,
           request_id,
           SUM(internal_objects_alloc_page_count) AS alloc_pages,
           SUM(internal_objects_dealloc_page_count) AS dealloc_pages
    FROM sys.dm_db_task_space_usage WITH (NOLOCK)
    WHERE session_id <> @@SPID
    GROUP BY session_id, request_id
)
SELECT TSU.session_id,
       TSU.alloc_pages * 1.0 / 128 AS [internal object MB space],
       TSU.dealloc_pages * 1.0 / 128 AS [internal object dealloc MB space],
       EST.text,
       -- Extract statement from sql text
       ISNULL(
           NULLIF(
               SUBSTRING(
                   EST.text, 
                   ERQ.statement_start_offset / 2, 
                   CASE WHEN ERQ.statement_end_offset < ERQ.statement_start_offset THEN 0 ELSE( ERQ.statement_end_offset - ERQ.statement_start_offset ) / 2 END
               ), ''
           ), EST.text
       ) AS [statement text],
       EQP.query_plan
FROM task_space_usage AS TSU
INNER JOIN sys.dm_exec_requests ERQ WITH (NOLOCK)
    ON  TSU.session_id = ERQ.session_id
    AND TSU.request_id = ERQ.request_id
OUTER APPLY sys.dm_exec_sql_text(ERQ.sql_handle) AS EST
OUTER APPLY sys.dm_exec_query_plan(ERQ.plan_handle) AS EQP
WHERE EST.text IS NOT NULL OR EQP.query_plan IS NOT NULL
ORDER BY 3 DESC, 5 DESC

--queries using tempDB space
SELECT  SS.session_id ,        SS.database_id ,
        CAST(SS.user_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation User Objects MB] ,
        CAST(( SS.user_objects_alloc_page_count
               - SS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15, 2)) [Net Allocation User Objects MB] ,
        CAST(SS.internal_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation Internal Objects MB] ,
        CAST(( SS.internal_objects_alloc_page_count
               - SS.internal_objects_dealloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Net Allocation Internal Objects MB] ,
        CAST(( SS.user_objects_alloc_page_count
               + internal_objects_alloc_page_count ) / 128 AS DECIMAL(15, 2)) [Total Allocation MB] ,
        CAST(( SS.user_objects_alloc_page_count
               + SS.internal_objects_alloc_page_count
               - SS.internal_objects_dealloc_page_count
               - SS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15, 2)) [Net Allocation MB] ,
        T.text [Query Text]
FROM    sys.dm_db_session_space_usage SS
        LEFT JOIN sys.dm_exec_connections CN ON CN.session_id = SS.session_id
        OUTER APPLY sys.dm_exec_sql_text(CN.most_recent_sql_handle) T


SELECT  TS.session_id ,
        TS.request_id ,
        TS.database_id ,
        CAST(TS.user_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation User Objects MB] ,
        CAST(( TS.user_objects_alloc_page_count
               - TS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15, 2)) [Net Allocation User Objects MB] ,
        CAST(TS.internal_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation Internal Objects MB] ,
        CAST(( TS.internal_objects_alloc_page_count
               - TS.internal_objects_dealloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Net Allocation Internal Objects MB] ,
        CAST(( TS.user_objects_alloc_page_count
               + internal_objects_alloc_page_count ) / 128 AS DECIMAL(15, 2)) [Total Allocation MB] ,
        CAST(( TS.user_objects_alloc_page_count
               + TS.internal_objects_alloc_page_count
               - TS.internal_objects_dealloc_page_count
               - TS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15, 2)) [Net Allocation MB] ,
        T.text [Query Text]
FROM    sys.dm_db_task_space_usage TS
        INNER JOIN sys.dm_exec_requests ER ON ER.request_id = TS.request_id
                                              AND ER.session_id = TS.session_id
        OUTER APPLY sys.dm_exec_sql_text(ER.sql_handle) T



SELECT  COALESCE(T1.session_id, T2.session_id) [session_id] ,        T1.request_id ,
        COALESCE(T1.database_id, T2.database_id) [database_id],
        COALESCE(T1.[Total Allocation User Objects], 0)
        + T2.[Total Allocation User Objects] [Total Allocation User Objects] ,
        COALESCE(T1.[Net Allocation User Objects], 0)
        + T2.[Net Allocation User Objects] [Net Allocation User Objects] ,
        COALESCE(T1.[Total Allocation Internal Objects], 0)
        + T2.[Total Allocation Internal Objects] [Total Allocation Internal Objects] ,
        COALESCE(T1.[Net Allocation Internal Objects], 0)
        + T2.[Net Allocation Internal Objects] [Net Allocation Internal Objects] ,
        COALESCE(T1.[Total Allocation], 0) + T2.[Total Allocation] [Total Allocation] ,
        COALESCE(T1.[Net Allocation], 0) + T2.[Net Allocation] [Net Allocation] ,
        COALESCE(T1.[Query Text], T2.[Query Text]) [Query Text]
FROM    ( SELECT    TS.session_id ,
                    TS.request_id ,
                    TS.database_id ,
                    CAST(TS.user_objects_alloc_page_count / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation User Objects] ,
                    CAST(( TS.user_objects_alloc_page_count
                           - TS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Net Allocation User Objects] ,
                    CAST(TS.internal_objects_alloc_page_count / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation Internal Objects] ,
                    CAST(( TS.internal_objects_alloc_page_count
                           - TS.internal_objects_dealloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Net Allocation Internal Objects] ,
                    CAST(( TS.user_objects_alloc_page_count
                           + internal_objects_alloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation] ,
                    CAST(( TS.user_objects_alloc_page_count
                           + TS.internal_objects_alloc_page_count
                           - TS.internal_objects_dealloc_page_count
                           - TS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Net Allocation] ,
                    T.text [Query Text]
          FROM      sys.dm_db_task_space_usage TS
                    INNER JOIN sys.dm_exec_requests ER ON ER.request_id = TS.request_id
                                                          AND ER.session_id = TS.session_id
                    OUTER APPLY sys.dm_exec_sql_text(ER.sql_handle) T
        ) T1
        RIGHT JOIN ( SELECT SS.session_id ,
                            SS.database_id ,
                            CAST(SS.user_objects_alloc_page_count / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation User Objects] ,
                            CAST(( SS.user_objects_alloc_page_count
                                   - SS.user_objects_dealloc_page_count )
                            / 128 AS DECIMAL(15, 2)) [Net Allocation User Objects] ,
                            CAST(SS.internal_objects_alloc_page_count / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation Internal Objects] ,
                            CAST(( SS.internal_objects_alloc_page_count
                                   - SS.internal_objects_dealloc_page_count )
                            / 128 AS DECIMAL(15, 2)) [Net Allocation Internal Objects] ,
                            CAST(( SS.user_objects_alloc_page_count
                                   + internal_objects_alloc_page_count ) / 128 AS DECIMAL(15,
                                                              2)) [Total Allocation] ,
                            CAST(( SS.user_objects_alloc_page_count
                                   + SS.internal_objects_alloc_page_count
                                   - SS.internal_objects_dealloc_page_count
                                   - SS.user_objects_dealloc_page_count )
                            / 128 AS DECIMAL(15, 2)) [Net Allocation] ,
                            T.text [Query Text]
                     FROM   sys.dm_db_session_space_usage SS
                            LEFT JOIN sys.dm_exec_connections CN ON CN.session_id = SS.session_id
                            OUTER APPLY sys.dm_exec_sql_text(CN.most_recent_sql_handle) T
                   ) T2 ON T1.session_id = T2.session_id


;WITH task_space_usage AS (
    -- SUM alloc/delloc pages
    SELECT session_id,
           request_id,
           SUM(internal_objects_alloc_page_count) AS alloc_pages,
           SUM(internal_objects_dealloc_page_count) AS dealloc_pages
    FROM sys.dm_db_task_space_usage WITH (NOLOCK)
    WHERE session_id <> @@SPID
    GROUP BY session_id, request_id
)
SELECT TSU.session_id,
       TSU.alloc_pages * 1.0 / 128 AS [internal object MB space],
       TSU.dealloc_pages * 1.0 / 128 AS [internal object dealloc MB space],
       EST.text,
       -- Extract statement from sql text
       ISNULL(
           NULLIF(
               SUBSTRING(
                 EST.text,
                 ERQ.statement_start_offset / 2,
                 CASE WHEN ERQ.statement_end_offset < ERQ.statement_start_offset
                  THEN 0
                 ELSE( ERQ.statement_end_offset - ERQ.statement_start_offset ) / 2 END
               ), ''
           ), EST.text
       ) AS [statement text],
       EQP.query_plan
FROM task_space_usage AS TSU
INNER JOIN sys.dm_exec_requests ERQ WITH (NOLOCK)
    ON  TSU.session_id = ERQ.session_id
    AND TSU.request_id = ERQ.request_id
OUTER APPLY sys.dm_exec_sql_text(ERQ.sql_handle) AS EST
OUTER APPLY sys.dm_exec_query_plan(ERQ.plan_handle) AS EQP
WHERE EST.text IS NOT NULL OR EQP.query_plan IS NOT NULL
ORDER BY 3 DESC;

SELECT es.host_name , es.login_name , es.program_name,
st.dbid as QueryExecContextDBID, DB_NAME(st.dbid) as QueryExecContextDBNAME, st.objectid as ModuleObjectId,
SUBSTRING(st.text, er.statement_start_offset/2 + 1,(CASE WHEN er.statement_end_offset = -1 THEN LEN(CONVERT(nvarchar(max),st.text)) * 2 ELSE er.statement_end_offset 
END - er.statement_start_offset)/2) as Query_Text,
tsu.session_id ,tsu.request_id, tsu.exec_context_id, 
(tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count) as OutStanding_user_objects_page_counts,
(tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) as OutStanding_internal_objects_page_counts,
er.start_time, er.command, er.open_transaction_count, er.percent_complete, er.estimated_completion_time, er.cpu_time, er.total_elapsed_time, er.reads,er.writes, 
er.logical_reads, er.granted_query_memory
FROM sys.dm_db_task_space_usage tsu inner join sys.dm_exec_requests er 
 ON ( tsu.session_id = er.session_id and tsu.request_id = er.request_id) 
inner join sys.dm_exec_sessions es ON ( tsu.session_id = es.session_id ) 
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) st
WHERE (tsu.internal_objects_alloc_page_count+tsu.user_objects_alloc_page_count) > 0
ORDER BY (tsu.user_objects_alloc_page_count - tsu.user_objects_dealloc_page_count)+(tsu.internal_objects_alloc_page_count - tsu.internal_objects_dealloc_page_count) 
DESC



SELECT top 5 a.session_id, a.transaction_id, a.transaction_sequence_num, a.elapsed_time_seconds,
b.program_name, b.open_tran, b.status
FROM sys.dm_tran_active_snapshot_database_transactions a
join sys.sysprocesses b
on a.session_id = b.spid
ORDER BY elapsed_time_seconds DESC