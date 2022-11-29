Declare @PU_Id int,@TimeStamp datetime,@SheetId int,@DoAll int,@NumEventsIntoRun int,@Prod_Id int,@SYear int,@SMonth int,@SDay int,@SHour int,@SMinute int,@SSecond int,@EventType int,@EventSubtype int
,@total Int, @cnt int
SELECT @cnt =1
  
SELECT @DoAll = NULL,@NumEventsIntoRun=NULL
SELECT @PU_Id=2068,@TimeStamp='2021-06-21 15:16:19.000',@EventType=14,@EventSubtype=5  
EXEC spServer_StbChkEventStub @PU_Id = @PU_Id,@TimeStamp = @TimeStamp,@SheetId = @SheetId,@DoAll = @DoAll OUTPUT,@NumEventsIntoRun = @NumEventsIntoRun OUTPUT,@Prod_Id = @Prod_Id OUTPUT,@SYear = @SYear OUTPUT,@SMonth = @SMonth OUTPUT,
@SDay = @SDay OUTPUT,@SHour = @SHour OUTPUT,@SMinute = @SMinute OUTPUT,@SSecond = @SSecond OUTPUT,@EventType = @EventType,@EventSubtype = @EventSubtype
Declare @Variables TABLE(Var_Id int,Test_Freq int)
INSERT INTO @Variables
exec spServer_StbGetEventTestFreqValues @PU_Id,@Prod_Id,@TimeStamp,@EventType,@EventSubtype

Select case when Test_Freq > 0 AND (@DoAll = 1 or ((@NumEventsIntoRun -1)%Test_Freq)=0 ) THEN 1 ELSE 0 END,a.*,b.Var_Desc,DT.Data_Type_Desc,dt.Data_Type_Id ,T.*
from @Variables a join variables_base b on b.var_id = a.var_id join Data_Type DT on DT.Data_Type_Id = b.Data_Type_Id
join tests t on t.Var_Id = a.Var_Id and t.Result_On = @TimeStamp
 

--if (TestFreq && (DoAll || (((NumEvtsSoFar - 1) % TestFreq) == 0)))

--UPDATE #DataTable SET TotalMandatoryVariablesCount = (Select SUM(case when Test_Freq > 0 AND (@DoAll = 1 or ((@NumEventsIntoRun -1)%Test_Freq)=0 ) THEN 1 ELSE 0 END) from @Variables)
--Where SrNo = @cnt
 
 --select keyid1,* from activities where activity_id =  149236
 --select Event_Subtype_Id,* from User_Defined_Events where ude_id =74332