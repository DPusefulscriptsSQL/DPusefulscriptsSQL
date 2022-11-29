
Declare @cnt int , @total int,@Puid int,@endtime Datetime,@starttime Datetime,@interval int
Declare 
	@Actualstarttime datetime ='2019-03-27 00:00:00.000', --Min StartTime
	@Finalendtime datetime = '2019-03-28 00:00:00.000'-- Max Endtime
select distinct pu_id into #temp from Prod_Units 
where Pu_id   in (1) --change this condition as per requirement
order by 1
Set @total =@@ROWCOUNT

Alter Table #temp Add rowID int Identity(1,1)
select @interval = value from Site_parameters where parm_id = 602

Set @cnt = 1
While @cnt <= @total
Begin
       select @Puid = Pu_id from #temp where @cnt = rowID
	   Select  @starttime=null,@endtime = NULL
       Set @starttime = @Actualstarttime
       Set @endtime = Dateadd(Minute,@interval,@starttime)

       While @endtime < @Finalendtime
       Begin
       
              EXEC spBF_OEEAggPopulateAllSlices @Puid, @Starttime, @Endtime
              Set @starttime = Dateadd(MINUTE,@interval,@starttime)
              Set @endtime = Dateadd(MINUTE,@interval,@endtime)

       End

	   Set @cnt = @cnt+1

End

drop table #temp



