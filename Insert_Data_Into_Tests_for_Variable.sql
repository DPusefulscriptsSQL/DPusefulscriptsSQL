--Select top 10 * from events Order by 1 desc

Declare @NewResult varchar(25)
Select Top 1 @NewResult = PercentOEE from OEEAggregation where pu_id = 1 Order by OEEAggregation_Id Desc	
Select @NewResult = 1	

declare @TestId int,@Date datetime =getdate()
EXECUTE spServer_DBMgrUpdTest2 1103,1,NULL,@NewResult,@Date,NULL,NULL,NULL,NULL,NULL,@TestId Output,NULL,NULL,NULL,NULL,NULL

Select @TestId





 
