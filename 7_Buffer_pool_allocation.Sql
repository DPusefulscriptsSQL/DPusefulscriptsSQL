SELECT 
    name ,
    index_id, indexname,
    CAST(COUNT(*) * 8./1024. AS NUMERIC(10,1)) AS buffer_pool_mb  
FROM sys.dm_os_buffer_descriptors AS bd   
    INNER JOIN   
    (  
        SELECT object_name(object_id) AS name   
            ,index_id ,allocation_unit_id ,i.name [indexname] 
        FROM sys.allocation_units AS au  
            INNER JOIN sys.partitions AS p   
                ON au.container_id = p.hobt_id   
                    AND (au.type = 1 OR au.type = 3)  
					JOIN sys.sysindexes i on i.indid = index_id and i.id = object_id
        UNION ALL  
        SELECT object_name(object_id) AS name     
            ,index_id, allocation_unit_id  ,i.name
        FROM sys.allocation_units AS au  
            INNER JOIN sys.partitions AS p   
                ON au.container_id = p.partition_id   
                    AND au.type = 2  
					JOIN sys.sysindexes i on i.indid = index_id and i.id = object_id
    ) AS obj   
        ON bd.allocation_unit_id = obj.allocation_unit_id  
WHERE database_id = DB_ID()  
GROUP BY name, index_id ,indexname
HAVING COUNT(*) > 10
ORDER BY buffer_pool_mb DESC;


--SELECT object_name(object_id) AS name   
--            ,index_id ,allocation_unit_id  ,i.name
--        FROM sys.allocation_units AS au  
--            INNER JOIN sys.partitions AS p   
--                ON au.container_id = p.hobt_id   
--                    AND (au.type = 1 OR au.type = 3) 
--					JOIN sys.sysindexes i on i.indid = index_id and i.id = object_id