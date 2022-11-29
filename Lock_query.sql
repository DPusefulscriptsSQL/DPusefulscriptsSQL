If not exists (Select 1 from master.sys.tables where name ='blockedQuery')
Begin
CREATE TABLE master.[dbo].[blockedQuery](
               [command] [nvarchar](max) NULL,
               [spid] [int] NULL,
               [cmd] [nchar](32) NULL,
               [blocked] [int] NULL,
               [login_time] [datetime] NULL,
               [last_batch] [datetime] NULL,
               [SrNo] [int] IDENTITY(1,1) NOT NULL,
               [blockedCommand] [nvarchar](max) NULL
) ON [PRIMARY] 
end
truncate table master..BlockedQuery 
While 1=1
Begin

Insert Into master..BlockedQuery ( command,spid,cmd,blocked,login_time,last_batch,blockedCommand)

Select (Select text from sys.dm_exec_sql_text(sql_handle)),spid,cmd, blocked,login_time,last_batch,

(Select (Select text from sys.dm_exec_sql_text(sql_handle)) from sys.sysprocesses where spid = a.blocked )

from sys.sysprocesses a where blocked <> 0 
End
