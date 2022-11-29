DECLARE @TotalCount DECIMAL(10, 2)
    ,@SQL NVARCHAR(MAX) =''
	,@schemaName Varchar(200)='dbo'
	,@TableName varchar(200) = 'Timed_Event_Details'
SET @SQL = 'SELECT @TotalCount = COUNT(0) FROM '+@schemaName+'.'+@TableName
EXECUTE SP_EXECUTESQL @SQL,N'@TotalCount DECIMAL(10, 2) OUT',@TotalCount ouT
SELECT @SQL = STUFF((
SELECT ', CAST(SUM(CASE WHEN ' + Quotename(C.COLUMN_NAME) + ' IS NOT NULL THEN 1 ELSE 0 END) * 100.00/@TotalCount AS decimal(10,2)) AS [' + C.COLUMN_NAME + ']'
            FROM INFORMATION_SCHEMA.COLUMNS C
            WHERE TABLE_NAME = @TableName
                AND TABLE_SCHEMA = @schemaName
            FOR XML PATH('')
                ,type
            ).value('.', 'nvarchar(max)'), 1, 2, '')
			 
SET @SQL = '
SELECT ' + @SQL + '
FROM '+@schemaName+'.'+@TableName
EXECUTE SP_EXECUTESQL @SQL
    ,N'@TotalCount decimal(10,2)'
    ,@TotalCount




