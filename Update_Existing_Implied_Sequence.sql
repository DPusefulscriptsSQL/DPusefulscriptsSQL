IF NOT EXISTS (Select 1 From sys.syscolumns where name = 'Implied_Sequence_Offset' and object_name(id) = 'Production_Plan')
Begin
Alter Table Production_Plan Add Implied_Sequence_Offset Int
End

GO
 
Declare @Cnt int, @TotalCnt int,@Path_Id int
Select Distinct Path_Id into #Temp from Production_Plan
SET @TotalCnt = @@ROWCOUNT
ALter table #Temp Add Id int Identity(1,1)
SET @cnt  = 1

While @Cnt  <= @TotalCnt
Begin

Select @Path_Id = Path_Id from #Temp where Id = @Cnt 

;WITH S AS (Select PP_Id,Forecast_Start_Date,Implied_Sequence,Implied_Sequence_Offset,Path_Id,(Datediff(s,'1990-01-01',Forecast_Start_Date)%1000000000) Julian_Implied_Sequence, row_number() over (Partition by path_Id,Forecast_Start_Date order by Forecast_Start_Date) Julian_Implied_Sequence_Offset from Production_Plan Where Path_Id = @Path_Id)
UPDATE S 
SET Implied_Sequence = Julian_Implied_Sequence,Implied_Sequence_Offset =Julian_Implied_Sequence_Offset
Where Path_Id = @Path_Id

SET @Cnt = @Cnt+1
End
 