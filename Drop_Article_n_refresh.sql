declare @PublicationTable Table(Id int identity(1,1),Pubname varchar(100))
Declare @total int, @cnt int,@PublicationName nvarchar(256)
SELECT @cnt =1
insert into @PublicationTable(Pubname)
Select name from syspublications
Select @total = count(0) from @PublicationTable
while @cnt < = @total
Begin


Select @PublicationName=Pubname from  @PublicationTable where Id = @cnt 




EXEC sp_dropsubscription @publication = @PublicationName, @article = 'PrdExec_Input_Source_Data' ,@subscriber = 'all'  
EXEC sp_droparticle @publication = @PublicationName, @article = 'PrdExec_Input_Source_Data',@force_invalidate_snapshot = 1;

EXEC sp_dropsubscription @publication = @PublicationName, @article = 'production_Status' ,@subscriber = 'all'  
EXEC sp_droparticle @publication = @PublicationName, @article = 'production_Status',@force_invalidate_snapshot = 1;    
EXEC sp_changepublication @publication = @PublicationName, @property = N'allow_anonymous',@value = 'FALSE'    
EXEC sp_changepublication @publication = @PublicationName,@property = N'immediate_sync',@value = 'FALSE'  


Set @cnt = @cnt+1

End
 