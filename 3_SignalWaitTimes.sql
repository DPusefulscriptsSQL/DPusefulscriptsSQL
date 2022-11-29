
--Signal Wait Time and percentage
 SELECT (SUM(signal_wait_time_ms)/1000)/60 "TotalSignalWaitTime(Min)",
 ( SUM(CAST(signal_wait_time_ms AS NUMERIC(20, 2)))
 / SUM(CAST(wait_time_ms AS NUMERIC(20, 2))) * 100 )
 AS PercentageSignalWaitsOfTotalTime
FROM sys.dm_os_wait_stats
Select * from  sys.dm_os_wait_stats
Order by 4 desc


