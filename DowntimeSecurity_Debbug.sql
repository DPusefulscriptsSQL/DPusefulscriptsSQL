Declare 
 	  	  @PUIds 	 VarChar(7000) = '81'
 	  	 ,@LineIds 	 VarChar(7000) = Null
 	  	 ,@UserId 	 Int=1

declare @DisplayOptions TABLE (Id Int Identity (1,1),PU_Id Int,MasterUnit Int,AddSecurity Int,DeleteSecurity Int,
 	  	  	  	  	  	  	  	 CloseSecurity Int,OpenSecurity Int,EditStartTimeSecurity Int,
 	  	  	  	  	  	  	  	 AddComments Int,AssignReasons Int,ChangeComments Int,
 	  	  	  	  	  	  	  	 ChangeFault Int,ChangeLocation int,OverlapRecords Int,
 	  	  	  	  	  	  	  	 SplitRecords Int, [CopyPasteReasons&Fault] Int , CopyFault Int , CopyReasons Int)

 
 	 DECLARE @AllUnits Table (PU_Id Int,MasterUnit Int)
 	 DECLARE @AllLines Table (PL_Id Int,MasterUnit Int)
 	 DECLARE @SecurityUnits Table (PU_Id Int)
 	 DECLARE @UnitsToProcess Table (Id Int Identity (1,1),MasterId Int)
 	 DECLARE @End Int, @Start Int,@PUId Int,@ActualSecurity Int
 	 DECLARE @UsersSecurity Int


 	 If @LineIds Is Not NUll
 	 BEGIN
 	  	 INSERT INTO @AllLines(PL_Id) 
 	  	  	 SELECT Id FROM dbo.fnCMN_IdListToTable('xxx',@LineIds,',')
 	  	 INSERT INTO @AllUnits(PU_Id,MasterUnit)
 	  	  	 SELECT a.PU_Id,Coalesce(a.Master_Unit, a.PU_Id)
 	  	  	 FROM Prod_Units_Base a
 	  	  	 JOIN @AllLines c on c.PL_Id = a.PL_Id 
 	  	  	 Join Event_Configuration  b on b.ET_Id = 2 and b.PU_Id = a.PU_Id
 	  	 INSERT INTO @AllUnits(PU_Id,MasterUnit)
 	  	  	 SELECT a.PU_Id,a.Master_Unit 
 	  	  	 FROM Prod_Units_Base a
 	  	  	 JOIN @AllUnits b On b.PU_Id = a.Master_Unit  
 	  	 IF NOT EXISTS(SELECT 1 FROM @AllUnits)
 	  	 BEGIN
 	  	  	 RETURN
 	  	 END 	 
 	 END
    ELSE If @PUIds Is Not NUll
 	 BEGIN
 	  	 INSERT INTO @AllUnits(PU_Id) 
 	  	  	 SELECT DiSTINCT Id 
 	  	  	  	 FROM dbo.fnCMN_IdListToTable('xxx',@PUIds,',')
 	  	 UPDATE @AllUnits Set MasterUnit = Coalesce(b.Master_Unit, b.PU_Id)
 	  	  	 FROM @AllUnits a
 	  	  	 JOIN Prod_Units_Base b on b.PU_Id = a.PU_Id 
 	  	  	 JOIN Event_Configuration  c on c.ET_Id = 2 and c.PU_Id =  Coalesce(b.Master_Unit, b.PU_Id)
 	  	 IF NOT EXISTS(SELECT 1 FROM @AllUnits)
 	  	 BEGIN
 	  	  	 RETURN
 	  	 END 	 
 	 END
 

 	 INSERT INTO @SecurityUnits(PU_Id)
 	  	 SELECT DISTINCT PU_Id FROM dbo.fnMES_GetDowntimeAvailableUnits(@UserId)

 	 IF EXISTS(SELECT 1 FROM @AllUnits)
 	  	 DELETE FROM @AllUnits WHERE ISNULL(MasterUnit,0) NOT IN (SELECT PU_ID FROM @SecurityUnits)
 	 ELSE
 	 BEGIN
 	  	 INSERT INTO @AllUnits(PU_Id,MasterUnit)  SELECT DISTINCT PU_Id,PU_Id FROM @SecurityUnits
 	  	 INSERT INTO @AllUnits(PU_Id,MasterUnit)  
 	  	  	 SELECT a.PU_Id,a.Master_Unit 
 	  	  	 FROM Prod_Units_Base a
 	  	  	 JOIN @AllUnits b On b.PU_Id = a.Master_Unit  
 	 END

 	 IF NOT EXISTS(SELECT 1 FROM @AllUnits)
 	 BEGIN
 	  	 RETURN
 	 END
 	 
 	 declare @DisplayOptionsTuned dbo.DisplayOptions
 	 Insert Into @DisplayOptionsTuned(PU_Id,MasterUnit,AddSecurity,DeleteSecurity,CloseSecurity,OpenSecurity,
 	  	  	  	  	  	  	  	 EditStartTimeSecurity,AddComments,AssignReasons,ChangeComments,ChangeFault
 	  	  	  	  	  	  	  	  	 ,ChangeLocation,OverlapRecords, 	 SplitRecords, [CopyPasteReasons&Fault],CopyFault,CopyReasons,UsersSecurity)
 	 SELECT Distinct PU_Id,MasterUnit,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,dbo.fnBF_CmnGetUserAccessLevel(ISNULL(MasterUnit,PU_Id),@UserId,1) FROM @AllUnits


 	 Declare @SheetSecurityOptions dbo.SheetSecurityOptions
 	 Insert Into @SheetSecurityOptions(SecurityType,DtOption,DtpOption,Defaultlevel,Pu_id)
 	 Select DISTINCT 'AddSecurity',8,393,3,ISNULL(MasterUnit,PU_Id) from @AllUnits union all /* 8 - "AddSecurity" Display Option for Classic DT :: 393 - "Insert Records" Display Option for DT+ */
 	 Select DISTINCT 'DeleteSecurity',7,392,3,ISNULL(MasterUnit,PU_Id) from @AllUnits union all/* 7 - "DeleteSecurity" Display Option for Classic DT :: 392 - "Delete Records" Display Option for DT+ */
 	 Select DISTINCT 'CloseSecurity',130,397,3,ISNULL(MasterUnit,PU_Id) from @AllUnits union all/* 130 - "CloseSecurity" Display Option for Classic DT :: 397 - "Change Time" Display Option for DT+ */
 	 Select DISTINCT 'OpenSecurity',129,397,3,ISNULL(MasterUnit,PU_Id) from @AllUnits union all/* 129 - "OpenSecurity" Display Option for Classic DT :: 397 - "Change Time" Display Option for DT+ */
 	 Select DISTINCT 'EditStartTimeSecurity',273,397,3,ISNULL(MasterUnit,PU_Id) from @AllUnits union all/* 273 - "EditStartTimeSecurity" Display Option for Classic DT :: 397 - "Change Time" Display Option for DT+ */
 	 Select DISTINCT 'AddComments',null,388,1,ISNULL(MasterUnit,PU_Id) from @AllUnits union all/* 388 - "Add Comments" Display Option for DT+ */
 	 Select DISTINCT 'ChangeComments',null,390,3,ISNULL(MasterUnit,PU_Id) from @AllUnits union all/* 390 - "Change Comments" Display Option for DT+ */
 	 Select DISTINCT 'AssignReasons',null,389,2,ISNULL(MasterUnit,PU_Id) from @AllUnits union all/* 389 - "Assign Reasons" Display Option for DT+ */
 	 Select DISTINCT 'ChangeFault',null,400,2,ISNULL(MasterUnit,PU_Id) from @AllUnits union all/* 400 - "Change Fault" Display Option for DT+ */
 	 Select DISTINCT 'ChangeLocation',null,401,2,ISNULL(MasterUnit,PU_Id) from @AllUnits union all/*  401 - "Change Location" Display Option for DT+ */
 	 Select DISTINCT 'OverlapRecords',null,394,3,ISNULL(MasterUnit,PU_Id) from @AllUnits union all/* 394 - "Overlap Records" Display Option for DT+ */
 	 Select DISTINCT 'SplitRecords',null,395,3,ISNULL(MasterUnit,PU_Id) from @AllUnits union all/* 395 - "Split Records" Display Option for DT+ */
 	 Select DISTINCT 'CopyPasteReasons&Fault',null,391,3,ISNULL(MasterUnit,PU_Id) from @AllUnits/* 391 - "CopyPaste Reasons" Display Option for DT+ */
 	 union all SELECT DISTINCT 'CopyReasons',null,467,3,ISNULL(MasterUnit,PU_Id) from @AllUnits

 DECLARE 	 
  	 --@SecurityOptions dbo.SheetSecurityOptions ,
 	 @UnitId int, 
 	 @DtOption 	 Int, 
 	 @DtpOption 	 Int,
 	 @DefaultLevel 	 Int

DECLARE  
@TmpDisplayOptions TABLE
(
  	  [PU_Id] [int] NULL,
  	  [MasterUnit] [int] NULL,
  	  [AddSecurity] [int] NULL,
  	  [DeleteSecurity] [int] NULL,
  	  [CloseSecurity] [int] NULL,
  	  [OpenSecurity] [int] NULL,
  	  [EditStartTimeSecurity] [int] NULL,
  	  [AddComments] [int] NULL,
  	  [AssignReasons] [int] NULL,
  	  [ChangeComments] [int] NULL,
  	  [ChangeFault] [int] NULL,
  	  [ChangeLocation] [int] NULL,
  	  [OverlapRecords] [int] NULL,
  	  [SplitRecords] [int] NULL,
  	  [CopyPasteReasons&Fault] [int] NULL,
 	  [CopyFault] [int] NULL,
 	  [CopyReasons] [int] NULL,
  	  [UsersSecurity] [int] NULL
)

  	  
  	  
  	  Insert into @TmpDisplayOptions
  	  Select * from @DisplayOptionsTuned

	  
	    
  	  Declare @DisplayOptionsValue Table(Display_Option_Id Int, Sheet_Type_Id Int, Sheet_Id Int,Master_Unit Int,PU_Id Int,aValue varchar(7000),SecurityType nvarchar(50),rownum int)
  	  ;WITH ActiveSheets As 
  	  (
 	  	  	   Select distinct s.Sheet_Type,SU.PU_Id,s.Master_Unit,s.Sheet_Id from Sheet_Unit su join Sheets s on s.Sheet_Id = su.Sheet_Id 
 	  	  	   Where su.PU_Id in (select ISNULL(MasterUnit,pu_id) from @TmpDisplayOptions) AND s.Sheet_Type in (5,15,28) AND s.Is_Active = 1
 	  	  	   UNION
 	  	  	   Select distinct s.Sheet_Type,NULL,s.Master_Unit,s.Sheet_Id from Sheets s 
   	      	   where  S.Master_Unit in (select ISNULL(MasterUnit,pu_id) from @TmpDisplayOptions)
   	      	   AND s.Sheet_Type in (5,15,28)
  	    	  AND s.Is_Active = 1
  	  )
  	  ,DefaultSecurityValues As 
  	  (
  	    	  Select 
  	    	    	  Display_Option_Id,Sheet_Type_Id,Display_option_default,Sheet_Id,PU_Id ,Master_Unit
  	    	  from 
  	    	    	  Sheet_Type_Display_Options A
  	    	    	  Join ActiveSheets Ac On Ac.Sheet_Type = A.Sheet_Type_Id
   	  )
  	  ,ActualSecurityValues As 
  	  (
  	    	  Select 
  	    	    	  a.Display_Option_Id,Sheet_Type_Id,s.Sheet_Id,Master_Unit,PU_Id,a.Value
  	    	  from 
  	    	    	  Sheet_Display_options a  WITH (nolock) 
   	    	    	  Join display_Options b  WITH (nolock)  on b.Display_Option_Id = a.Display_Option_Id
   	    	    	  Join Sheet_Type_Display_Options c   WITH (nolock)  on c.Display_Option_Id = b.Display_Option_Id 
   	    	    	  Join Sheets s  WITH (nolock)  on s.Sheet_Id = a.Sheet_Id And s.Is_Active = 1
   	    	    	  Left Join Sheet_Unit su  WITH (nolock)  on su.sheet_Id = s.sheet_Id
  	    	  Where su.PU_Id in (select ISNULL(MasterUnit,pu_id) from @TmpDisplayOptions) Or s.Master_Unit in (select ISNULL(MasterUnit,pu_id) from @TmpDisplayOptions)
  	  )
  	  ,DisplayOption_SecurityType as 
  	  (
  	    	  Select 8 Display_option_id, 'AddSecurity' SecurityType UNION Select 393 Display_option_id, 'AddSecurity' SecurityType
  	    	  UNION
  	    	  Select 7 Display_option_id, 'DeleteSecurity' SecurityType UNION Select 392 Display_option_id, 'DeleteSecurity' SecurityType 
  	    	  UNION
  	    	  Select 130 Display_option_id, 'CloseSecurity' SecurityType UNION Select 397 Display_option_id, 'CloseSecurity' SecurityType
  	    	  UNION
  	    	  Select 129 Display_option_id, 'OpenSecurity' SecurityType UNION Select 397 Display_option_id, 'OpenSecurity' SecurityType
  	    	  UNION
  	    	  Select 273 Display_option_id, 'EditStartTimeSecurity' SecurityType UNION Select 397 Display_option_id, 'EditStartTimeSecurity' SecurityType
  	    	  UNION
  	    	  Select 388 Display_option_id, 'AddComments' SecurityType UNION Select 390 Display_option_id, 'ChangeComments' SecurityType
  	    	  union
  	    	  Select 389 Display_option_id, 'AssignReasons' SecurityType UNION Select 400 Display_option_id, 'ChangeFault' SecurityType
  	    	  union
  	    	  Select 401 Display_option_id, 'ChangeLocation' SecurityType UNION Select 394 Display_option_id, 'OverlapRecords' SecurityType
  	    	  union
  	    	  Select 395 Display_option_id, 'SplitRecords' SecurityType UNION Select 391 Display_option_id, 'CopyPasteReasons&Fault' SecurityType
 	  	  Union
 	  	    select 467, 'CopyReasons'
 	  	  
  	  )
  	  Insert Into @DisplayOptionsValue
  	  Select 
  	    	  S.Display_Option_Id,S.Sheet_Type_Id,s.Sheet_Id,S.Master_Unit,S.PU_Id,ISNULL(S1.Value,S.Display_Option_Default) Value,Dstype.SecurityType
  	    	  ,Case 
			  when 
			  S.Display_Option_Id <> 467 then 
			  row_number() Over (partition by ISNULL(S.Master_Unit,S.PU_Id),Dstype.SecurityType order by Case When s.Sheet_Type_Id =28 THEN 1 When s.Sheet_Type_Id =5 THEN 2 When s.Sheet_Type_Id =15 THEN 3 END) 
			  Else row_number() over (partition by ISNULL(S.Master_Unit,S.PU_Id),Dstype.SecurityType Order by Value Asc) End
  	  from 
  	    	  DefaultSecurityValues S 
  	    	  join DisplayOption_SecurityType Dstype on Dstype.Display_Option_Id =s.Display_Option_Id
  	    	  LEFT OUTER JOIN ActualSecurityValues S1 oN S.Display_Option_Id = S1.Display_option_Id and S.Sheet_Type_Id = S1.Sheet_Type_Id 
  	    	  AND ISNULL(S.Master_Unit,S.Pu_Id) = ISNULL(S1.Master_Unit,S1.Pu_Id) 
  	    	  AND S.Sheet_Id = S1.Sheet_Id
  	  
  	  
  	  ;WITH ActiveSheets As 
   	   (
    	        	   Select distinct s.Sheet_Type,SU.PU_Id,s.Master_Unit,s.Sheet_Id from Sheet_Unit su join Sheets s on s.Sheet_Id = su.Sheet_Id 
 	  	  	   Where su.PU_Id in (select ISNULL(MasterUnit,pu_id) from @TmpDisplayOptions) AND s.Sheet_Type in (5,15,28) AND s.Is_Active = 1
 	  	  	   UNION
 	  	  	   Select distinct s.Sheet_Type,NULL,s.Master_Unit,s.Sheet_Id from Sheets s 
   	      	   where  S.Master_Unit in (select ISNULL(MasterUnit,pu_id) from @TmpDisplayOptions)
   	      	   AND s.Sheet_Type in (5,15,28)
   	      	   AND s.Is_Active = 1
   	   ), FinalRslt AS 
   	   (
   	      	   Select
   	      	      	   s.SecurityType,S.Pu_Id, 
  	    	    	   CASE WHEN v.Display_Option_Id = 467 then Min(v.aValue) else CASE WHEN u.UsersSecurity >= ISNULL(Min(v.aValue),s.DefaultLevel) Then 1 Else 0 End end Value
   	      	   from
   	      	      	   @SheetSecurityOptions s
   	      	      	   Join @TmpDisplayOptions U on ISNULL(U.MasterUnit,U.PU_Id) = Isnull(s.masterUnit,s.PU_Id)
   	      	      	   Left join @DisplayOptionsValue v on v.SecurityType = s.SecurityType and ISNULL(v.Master_Unit,v.PU_Id) = Isnull(s.masterUnit,s.PU_Id) and v.rownum =1
   	      	   Where Exists (Select 1 from ActiveSheets)
 	  	  	   Group By s.SecurityType,s.PU_Id,s.DefaultLevel,u.UsersSecurity,v.Display_Option_Id
   	   )
  	  ,FinalRslt_Pivot As 
  	  (
  	    	  Select 
  	    	    	  Pu_Id,[AddComments],[AddSecurity],[AssignReasons],[ChangeComments],[EditStartTimeSecurity],
  	    	    	  [OpenSecurity],[ChangeFault],[ChangeLocation],[CloseSecurity],[CopyPasteReasons&Fault],[DeleteSecurity],[OverlapRecords],[SplitRecords],[CopyReasons]
  	    	  from 
  	    	    	  FinalRslt
  	    	    	  PIVOT 
  	    	    	  (
  	    	    	    	    	  AVG(Value) FOR SecurityType in 
  	    	    	    	    	  (
  	    	    	    	    	    	  [AddComments],[AddSecurity],[AssignReasons],[ChangeComments],[OpenSecurity],[ChangeFault],[ChangeLocation],
  	    	    	    	    	    	  [CloseSecurity],[CopyPasteReasons&Fault],[DeleteSecurity],[OverlapRecords],[SplitRecords],[EditStartTimeSecurity],[CopyReasons]
  	    	    	    	    	  )
  	    	    	  )pvt
  	  )
  	  UPDATE A 
  	  SET
  	    	  A.[AddComments] = ISNULL(B.AddComments,0),
  	    	  A.[AddSecurity] = ISNULL(B.AddSecurity,0),
  	    	  A.[AssignReasons] = ISNULL(B.AssignReasons,0),
  	    	  A.[ChangeComments] = ISNULL(B.ChangeComments,0),
  	    	  A.[ChangeFault] = ISNULL(B.ChangeFault,0),
  	    	  A.[ChangeLocation] = ISNULL(B.ChangeLocation,0),
  	    	  A.[CloseSecurity] = ISNULL(B.CloseSecurity,0),
  	    	  A.[CopyPasteReasons&Fault] = ISNULL(B.[CopyPasteReasons&Fault],0),
  	    	  A.[DeleteSecurity] = ISNULL(B.DeleteSecurity,0),
  	    	  A.[OverlapRecords] = ISNULL(B.OverlapRecords,0),
  	    	  A.[SplitRecords] = ISNULL(B.SplitRecords,0),
  	    	  A.openSecurity = ISNULL(B.Opensecurity,0),
  	    	  A.editStartTimeSecurity = ISNULL(B.EditStartTimeSecurity,0),
 	  	  A.CopyFault = CASE WHEN ISNULL(B.CopyReasons,3) IN (1,3) THEN 1 ELSE 0 END,
 	  	  A.CopyReasons = CASE WHEN ISNULL(B.CopyReasons,3) IN (1,2) THEN 1 ELSE 0 END
  	  from 
  	    	  @TmpDisplayOptions A 
  	    	  join FinalRslt_Pivot B on B.PU_Id = A.MasterUnit

			  Select * from @TmpDisplayOptions
			  
			  --Select * from Sheet_Type_Display_Options where Display_Option_Id = 467 And Sheet_Type_Id in (28,29)

			  --UPDATE Sheet_Type_Display_Options set Display_Option_Default =3 Where Display_Option_Id = 467 And Sheet_Type_Id in (28,29)
			   select * from ED_FieldType_ValidValues where ED_Field_Type_Id = 83
			   
/*
UPDATE ED_FieldType_ValidValues SET Field_Id=9  where ED_Field_Type_Id = 83 AND Field_desc = 'Copy Fault & Reason both'
UPDATE ED_FieldType_ValidValues SET Field_Id=10  where ED_Field_Type_Id = 83 AND Field_desc = 'Copy Fault only'
UPDATE ED_FieldType_ValidValues SET Field_Id=11 where ED_Field_Type_Id = 83 AND Field_desc = 'Copy Reason only'
UPDATE ED_FieldType_ValidValues SET Field_Id=1  where ED_Field_Type_Id = 83 AND Field_desc = 'Copy Fault & Reason both'
UPDATE ED_FieldType_ValidValues SET Field_Id=2  where ED_Field_Type_Id = 83 AND Field_desc = 'Copy Fault only'
UPDATE ED_FieldType_ValidValues SET Field_Id=3  where ED_Field_Type_Id = 83 AND Field_desc = 'Copy Reason only'

			   
UPDATE ED_FieldType_ValidValues SET Field_Id=11  where ED_Field_Type_Id = 84 AND Field_desc = 'Do Not System Complete'
UPDATE ED_FieldType_ValidValues SET Field_Id=22  where ED_Field_Type_Id = 84 AND Field_desc = 'System Complete Honor Mandatory'
UPDATE ED_FieldType_ValidValues SET Field_Id=33  where ED_Field_Type_Id = 84 AND Field_desc = 'System Complete Ignore Mandatory' 
UPDATE ED_FieldType_ValidValues SET Field_Id=0  where ED_Field_Type_Id = 84 AND Field_desc = 'Do Not System Complete'
UPDATE ED_FieldType_ValidValues SET Field_Id=2  where ED_Field_Type_Id = 84 AND Field_desc = 'System Complete Honor Mandatory'
UPDATE ED_FieldType_ValidValues SET Field_Id=1  where ED_Field_Type_Id = 84 AND Field_desc = 'System Complete Ignore Mandatory' 
*/