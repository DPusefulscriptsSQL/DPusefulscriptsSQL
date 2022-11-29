declare @PublicationTable Table(Id int identity(1,1),Pubname varchar(100))
Declare @total int, @cnt int,@PublicationName nvarchar(256)
SELECT @cnt =1
insert into @PublicationTable(Pubname)
Select name from syspublications
Select @total = count(0) from @PublicationTable
while @cnt < = @total
Begin


Select @PublicationName=Pubname from  @PublicationTable where Id = @cnt 
IF NOT EXISTS (select 1 from dbo.sysarticles where name ='PrdExec_Input_Source_Data')
Begin
EXEC sp_addarticle @publication =@PublicationName, @article = 'PrdExec_Input_Source_Data' ,@source_object =N'PrdExec_Input_Source_Data', @source_owner = N'dbo', @destination_owner = N'PrdExec_Input_Source_Data',@destination_table = N'dbo',@force_invalidate_snapshot=1      
 END
IF NOT EXISTS (select 1 from dbo.sysarticles where name ='production_Status')
Begin
EXEC sp_addarticle @publication =@PublicationName, @article = 'production_Status' ,@source_object =N'production_Status', @source_owner = N'dbo', @destination_owner = N'production_Status',@destination_table = N'dbo',@force_invalidate_snapshot=1      
End

IF NOT EXISTS (select 1 from dbo.sysarticles where name ='PrdExec_Input_Source_Data') OR NOT EXISTS (select 1 from dbo.sysarticles where name ='production_Status')
Begin
	EXEC sp_refreshsubscriptions @publication = @PublicationName   
End
IF NOT EXISTS(Select 1 from   dbo.syspublications Where immediate_sync = 1)
Begin
EXEC sp_changepublication @publication = @PublicationName,@property = N'immediate_sync',@value = 'TRUE'   
End
IF NOT EXISTS(Select 1 from   dbo.syspublications Where allow_anonymous = 1)
Begin
EXEC sp_changepublication @publication = @PublicationName,@property = N'allow_anonymous',@value = 'TRUE'  
End

Set @cnt = @cnt+1

End

 