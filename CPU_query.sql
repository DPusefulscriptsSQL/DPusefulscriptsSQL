select scheduler_id, cpu_id, status, is_online,* 
from sys.dm_os_schedulers 
where status = 'VISIBLE ONLINE'

select cpu_count from sys.dm_os_sys_info

SELECT @@SERVERNAME AS SQLServerName, 
      -- @ProductVersion AS ProductVersion,
       SERVERPROPERTY('Edition') AS Edition,
       SERVERPROPERTY('ProductLevel') AS ProductLevel,
       SERVERPROPERTY('ProductUpdateLevel') AS ProductUpdateLevel,
       SERVERPROPERTY('ProductVersion') AS Version,
       cpu_count/hyperthread_ratio AS [Sockets], 
       hyperthread_ratio AS [CoresPerSocket], 
       cpu_count AS [Cores] 
FROM sys.dm_os_sys_info

SELECT cpu_count AS [Logical CPU Count], hyperthread_ratio AS Hyperthread_Ratio,
cpu_count/hyperthread_ratio AS Physical_CPU_Count,physical_memory_kb,
--physical_memory_in_bytes/1048576 AS Physical_Memory_in_MB,
sqlserver_start_time, affinity_type_desc -- (affinity_type_desc is only in 2008 R2)
FROM sys.dm_os_sys_info