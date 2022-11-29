
SELECT distinct 
Object_name (a.object_id),
DATEDIFF(DAY,ISNULL(STATS_DATE(a.OBJECT_ID, a.index_id),'1990-01-01'),GETDATE())
FROM sys.indexes a join sys.tables b on b.object_id = a.object_id  Order by 2

GO
SELECT 
       OBJECT_NAME(ips.object_id) AS object_name,
       i.name AS index_name,
       i.type_desc AS index_type,
       ips.avg_fragmentation_in_percent,
       ips.avg_page_space_used_in_percent,
       ips.page_count,
       Case when ips.avg_fragmentation_in_percent >=31 Then 'Rebuild' Else 'Reorganize' end [ActionNeeded]
FROM sys.dm_db_index_physical_stats(DB_ID(), default, default, default, 'SAMPLED') AS ips
INNER JOIN sys.indexes AS i 
ON ips.object_id = i.object_id
   AND
   ips.index_id = i.index_id
Where i.name is not null 
And ips.avg_fragmentation_in_percent >=31
ORDER BY page_count DESC;