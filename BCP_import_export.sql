 EXEC master.dbo.sp_configure 'show advanced options', 1
RECONFIGURE
EXEC master.dbo.sp_configure 'xp_cmdshell', 1
RECONFIGURE

select cmd,(select text from sys.dm_exec_sql_text(sql_handle)),* from sys.sysprocesses where dbid =db_id('gbdb') and cmd <> 'awaiting command'
 

EXEC xp_cmdshell 'bcp "select Test_Id,Canceled,Result_On,Entry_On,Entry_By,Comment_Id,Array_Id,Event_Id,Var_Id,Locked,Result,Second_User_Id,Signature_Id,IsVarMandatory from GBDB.dbo.tests" queryout "E:\DATA\bcptest.txt" -E -T -c -t^|'
--01:40:00

EXEC xp_cmdshell 'bcp GBDB.dbo.Tests_1 in "E:\DATA\bcptest.txt" -E -T -c -t^| -e "E:\DATA\error.txt" ' 
  


EXEC xp_cmdshell 'bcp "select Test_Id,Canceled,Result_On,Entry_On,Entry_By,Comment_Id,Array_Id,Event_Id,Var_Id,Locked,Result,Second_User_Id,Signature_Id,IsVarMandatory from GBDB.dbo.tests where Test_Id = 634066858" queryout "E:\DATA\bcptest1.txt" -E -T -c -t^|' 
--01:40:00

EXEC xp_cmdshell 'bcp GBDB.dbo.Tests_1 in "E:\DATA\bcptest1.txt" -E -T -c -t^| -e "E:\DATA\error.txt" ' 
  