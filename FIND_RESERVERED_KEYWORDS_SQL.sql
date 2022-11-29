
;WITH RESERVED_KEYWORDS AS (
SELECT 'ADD' Key_word UNION SELECT  'ALL'  UNION SELECT  'ALTER'  UNION SELECT  'AND'  UNION SELECT  'ANY'  UNION SELECT  'AS'  UNION SELECT  'ASC'  UNION SELECT  'AUTHORIZATION'  UNION SELECT  'BACKUP'  UNION SELECT  'BEGIN'  UNION SELECT  'BETWEEN'  UNION SELECT  'BREAK'  UNION SELECT  'BROWSE'  UNION SELECT  'BULK'  UNION SELECT  'BY'  UNION SELECT  
'CASCADE'  UNION SELECT  'CASE'  UNION SELECT  'CHECK'  UNION SELECT  'CHECKPOINT'  UNION SELECT  'CLOSE'  UNION SELECT  'CLUSTERED'  UNION SELECT  'COALESCE'  UNION SELECT  'COLLATE'  UNION SELECT  'COLUMN'  UNION SELECT  'COMMIT'  UNION SELECT  'COMPUTE'  UNION SELECT  'CONSTRAINT'  UNION SELECT  
'CONTAINS'  UNION SELECT  'CONTAINSTABLE'  UNION SELECT  'CONTINUE'  UNION SELECT  'CONVERT'  UNION SELECT  'CREATE'  UNION SELECT  'CROSS'  UNION SELECT  'CURRENT'  UNION SELECT  'CURRENT_DATE'  UNION SELECT  'CURRENT_TIME'  UNION SELECT  'CURRENT_TIMESTAMP'  UNION SELECT  
'CURRENT_USER'  UNION SELECT  'CURSOR'  UNION SELECT  'DATABASE'  UNION SELECT  'DBCC'  UNION SELECT  'DEALLOCATE'  UNION SELECT  'DECLARE'  UNION SELECT  'DEFAULT'  UNION SELECT  'DELETE'  UNION SELECT  'DENY'  UNION SELECT  'DESC'  UNION SELECT  'DISK'  UNION SELECT  'DISTINCT'  UNION SELECT  
'DISTRIBUTED'  UNION SELECT  'DOUBLE'  UNION SELECT  'DROP'  UNION SELECT  'DUMP'  UNION SELECT  'ELSE'  UNION SELECT  'END'  UNION SELECT  'ERRLVL'  UNION SELECT  'ESCAPE'  UNION SELECT  'EXCEPT'  UNION SELECT  'EXEC'  UNION SELECT  'EXECUTE'  UNION SELECT  'EXISTS'  UNION SELECT  'EXIT'  UNION SELECT  'EXTERNAL'  UNION SELECT  
'FETCH'  UNION SELECT  'FILE'  UNION SELECT  'FILLFACTOR'  UNION SELECT  'FOR'  UNION SELECT  'FOREIGN'  UNION SELECT  'FREETEXT'  UNION SELECT  'FREETEXTTABLE'  UNION SELECT  'FROM'  UNION SELECT  'FULL'  UNION SELECT  'FUNCTION'  UNION SELECT  'GOTO'  UNION SELECT  'GRANT'  UNION SELECT  'GROUP'  UNION SELECT  
'HAVING'  UNION SELECT  'HOLDLOCK'  UNION SELECT  'IDENTITY'  UNION SELECT  'IDENTITY_INSERT'  UNION SELECT  'IDENTITYCOL'  UNION SELECT  'IF'  UNION SELECT  'IN'  UNION SELECT  'INDEX'  UNION SELECT  'INNER'  UNION SELECT  'INSERT'  UNION SELECT  'INTERSECT'  UNION SELECT  'INTO'  UNION SELECT  'IS'  UNION SELECT  
'JOIN'  UNION SELECT  'KEY'  UNION SELECT  'KILL'  UNION SELECT  'LEFT'  UNION SELECT  'LIKE'  UNION SELECT  'LINENO'  UNION SELECT  'LOAD'  UNION SELECT  'MERGE'  UNION SELECT  'NATIONAL'  UNION SELECT  'NOCHECK'  UNION SELECT  'NONCLUSTERED'  UNION SELECT  'NOT'  UNION SELECT  'NULL'  UNION SELECT  'NULLIF'  UNION SELECT  
'OF'  UNION SELECT  'OFF'  UNION SELECT  'OFFSETS'  UNION SELECT  'ON'  UNION SELECT  'OPEN'  UNION SELECT  'OPENDATASOURCE'  UNION SELECT  'OPENQUERY'  UNION SELECT  'OPENROWSET'  UNION SELECT  'OPENXML'  UNION SELECT  'OPTION'  UNION SELECT  'OR'  UNION SELECT  'ORDER'  UNION SELECT  'OUTER'  UNION SELECT  'OVER'  UNION SELECT  
'PERCENT'  UNION SELECT  'PIVOT'  UNION SELECT  'PLAN'  UNION SELECT  'PRECISION'  UNION SELECT  'PRIMARY'  UNION SELECT  'PRINT'  UNION SELECT  'PROC'  UNION SELECT  'PROCEDURE'  UNION SELECT  'PUBLIC'  UNION SELECT  'RAISERROR'  UNION SELECT  'READ'  UNION SELECT  'READTEXT'  UNION SELECT  'RECONFIGURE'  UNION SELECT  
'REFERENCES'  UNION SELECT  'REPLICATION'  UNION SELECT  'RESTORE'  UNION SELECT  'RESTRICT'  UNION SELECT  'RETURN'  UNION SELECT  'REVERT'  UNION SELECT  'REVOKE'  UNION SELECT  'RIGHT'  UNION SELECT  'ROLLBACK'  UNION SELECT  'ROWCOUNT'  UNION SELECT  'ROWGUIDCOL'  UNION SELECT  'RULE'  UNION SELECT  
'SAVE'  UNION SELECT  'SCHEMA'  UNION SELECT  'SECURITYAUDIT'  UNION SELECT  'SELECT'  UNION SELECT  'SEMANTICKEYPHRASETABLE'  UNION SELECT  'SEMANTICSIMILARITYDETAILSTABLE'  UNION SELECT  'SEMANTICSIMILARITYTABLE'  UNION SELECT  'SESSION_USER'  UNION SELECT  
'SET'  UNION SELECT  'SETUSER'  UNION SELECT  'SHUTDOWN'  UNION SELECT  'SOME'  UNION SELECT  'STATISTICS'  UNION SELECT  'SYSTEM_USER'  UNION SELECT  'TABLE'  UNION SELECT  'TABLESAMPLE'  UNION SELECT  'TEXTSIZE'  UNION SELECT  'THEN'  UNION SELECT  'TO'  UNION SELECT  'TOP'  UNION SELECT  'TRAN'  UNION SELECT  'TRANSACTION'  UNION SELECT  
'TRIGGER'  UNION SELECT  'TRUNCATE'  UNION SELECT  'TRY_CONVERT'  UNION SELECT  'TSEQUAL'  UNION SELECT  'UNION'  UNION SELECT  'UNIQUE'  UNION SELECT  'UNPIVOT'  UNION SELECT  'UPDATE'  UNION SELECT  'UPDATETEXT'  UNION SELECT  'USE'  UNION SELECT  'USER'  UNION SELECT  'VALUES'  UNION SELECT  'VARYING'  UNION SELECT  
'VIEW'  UNION SELECT  'WAITFOR'  UNION SELECT  'WHEN'  UNION SELECT  'WHERE'  UNION SELECT  'WHILE'  UNION SELECT  'WITH'  UNION SELECT  'WITHIN GROUP'  UNION SELECT  'WRITETEXT'

),
S1 As (SELECT @ProductGroupIds ActualWord UNION
SELECT @ProductFamilyIds UNION
SELECT @ProdDescription UNION
SELECT @ProductCode	 )
Select @IsReservedKeywordUsed = Count(0) from RESERVED_KEYWORDS Join S1 ON 
--WHERE ---'%'+Key_word+'%' like N'lot1''));WAITFOR DELAY ''00:01''--'
PATINDEX ('%;'+Key_Word+';%',S1.ActualWord) >0 OR
PATINDEX ('%;'+Key_Word+' %',S1.ActualWord) >0 OR
PATINDEX ('% '+Key_Word+';%',S1.ActualWord) >0 OR
PATINDEX ('% '+Key_Word+' %',S1.ActualWord) >0 

IF @IsReservedKeywordUsed = 1
BEGIN
	SELECT  Error = 'ERROR: SQL reserved Keywords Used'
	RETURN
END