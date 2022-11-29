--PRE CONFIGURATION FOR BCP
--sp_configure 'show advanced options', 1;
--GO
--RECONFIGURE;
--GO
--sp_configure 'Ole Automation Procedures', 1;
--GO
--RECONFIGURE;
--GO
--find path where to create
Declare @Path varchar(200),@TableName Varchar(100) = 'Tests',@bcpSQL varchar(max),@createSQL varchar(max),@DBName varchar(50)
select @Path = physical_name from master.sys.database_files
Select @Path = REPLACE(@Path,REVERSE(LEFT(REVERSE(@Path),PATINDEX('%\%',REVERSE(@Path))-1)),'')+@TableName+'.txt'
SELECT @DBName ='SOADBUNI'

--create file
DECLARE @OLE INT
DECLARE @FileID INT
EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT
EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @Path, 8, 1
--EXECUTE sp_OAMethod @FileID, 'WriteLine', Null, 'Today is wonderful day'
EXECUTE sp_OADestroy @FileID
EXECUTE sp_OADestroy @OLE

select @bcpSQL= 'EXEC xp_cmdshell ''bcp "select Test_Id,Canceled,Result_On,Entry_On,Entry_By,Comment_Id,Array_Id,Event_Id,Var_Id,Locked,Result,Second_User_Id,Signature_Id,IsVarMandatory from '+@DBName+'.dbo.tests" queryout "'+@Path+'" -E -T -c -t^|'''
EXEC(@bcpSQL)

Select @createSQL ='
 CREATE TABLE [dbo].[Tests_1](
	[Test_Id] [int] IDENTITY(1,1) NOT NULL,
	[Canceled] [bit] NOT NULL,
	[Result_On] [datetime] NOT NULL,
	[Entry_On] [datetime] NOT NULL,
	[Entry_By] [int] NULL,
	[Comment_Id] [int] NULL,
	[Array_Id] [int] NULL,
	[Event_Id] [int] NULL,
	[Var_Id] [int] NOT NULL,
	[Locked] [tinyint] NULL,
	[Result] nvarchar(50) NULL,
	[Second_User_Id] [int] NULL,
	[Signature_Id] [int] NULL,
	[IsVarMandatory] [bit] NULL,
 CONSTRAINT [Tests_PK_TestId_1] PRIMARY KEY NONCLUSTERED 
(
	[Test_Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Test_By_Variable_And_Result_On_1] UNIQUE CLUSTERED 
(
	[Var_Id] ASC,
	[Result_On] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
'
EXEC (@createSQL)
select @bcpSQL = 'EXEC xp_cmdshell ''bcp '+@DBName+'.dbo.Tests_1 in "'+@Path+'" -E -T -c -t^| '''
EXEC (@bcpSQL)
  