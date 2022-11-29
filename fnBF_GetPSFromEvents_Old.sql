/****** Object:  UserDefinedFunction [dbo].[fnBF_GetPSFromEvents]    Script Date: 2/8/2018 6:11:23 PM ******/



DROP FUNCTION [dbo].[fnBF_GetPSFromEvents]
GO

/****** Object:  UserDefinedFunction [dbo].[fnBF_GetPSFromEvents]    Script Date: 2/8/2018 6:11:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[fnBF_GetPSFromEvents](@UnitId int, @StartTime datetime, @EndTime datetime,@MoveInProgressTimeStatus Int = 0) 

	returns  @RunTimes Table(ProdId Int, StartTime datetime, EndTime datetime)
AS 
/* ##### fnBF_GetPSFromEvents #####
Description	: returns all the events for a product in particular timeperiod
Creation Date	: if any
Created By	: if any
#### Update History ####
DATE				Modified By		UserStory/Defect No		Comments		
----				-----------			-------------------				--------
2018-02-20	Prasad													

*/

BEGIN

Declare @Events TABLE(Start_Time DateTime, TimeStamp Datetime, Applied_Product Int,Event_Id Int,Event_Status TinyInt,Pu_Id int)
 	DECLARE   @AllEvents  TABLE(Id int Identity(1,1), Start_Time DateTime, End_Time DateTime,Prod_Id Int,EventId Int,EventStatus Int)
 	DECLARE   @AllEventsOrdered  TABLE(Id int Identity(1,1), Start_Time DateTime, End_Time DateTime,Prod_Id Int)
	DECLARE   @AllEventsOrdered2  TABLE(Id int Identity(1,1), Start_Time DateTime, End_Time DateTime,Prod_Id Int,ShiftDesc varchar(10))
	DECLARE   @Prod_Starts TABLE(Pu_Id Int, prod_id Int, Start_Time DateTime, End_Time DateTime NULL)
	DECLARE @CurrentEndTime DateTime,@NextEnd DateTime,@CurrentStartTime DateTime,@CurrentProdId Int,@LastProdId Int
	DECLARE @Start Int, @PrevEnd DateTime, @End Int,@Start2 Int
 	DECLARE @EventStatus Int,@EventId Int,@NextEvent Int
 	IF @MoveInProgressTimeStatus Is NULL
 		SET @MoveInProgressTimeStatus = 0	 
	
	INSERT INTO @Prod_Starts(Pu_Id,prod_id,Start_Time,End_Time)
		SELECT ps.PU_Id, ps.prod_id, ps.Start_Time, ps.End_Time
		FROM production_starts ps
		WHERE (ps.PU_Id = @UnitId AND  ps.PU_Id <> 0)
				AND (    Start_Time BETWEEN @StartTime AND @EndTime 
				OR End_Time BETWEEN @StartTime AND @EndTime 
				OR (Start_Time <= @StartTime AND (End_Time > @EndTime OR End_Time is null)))
INSERT INTO @Events 
	SELECT Start_Time,TimeStamp,Applied_Product,Event_Id,Event_Status,Pu_Id FROM EVENTS (nolock) WHERE pu_id = @UnitId

	
	UPDATE @Prod_Starts SET Start_Time = @StartTime WHERE Start_Time < @StartTime
	UPDATE @Prod_Starts SET End_Time = @EndTime WHERE End_Time > @EndTime OR End_Time IS NULL
	DELETE FROM @Prod_Starts WHERE Start_Time = End_Time
/*
	INSERT INTO @AllEvents ( Start_Time, End_Time,Prod_Id,EventId ,EventStatus )
		SELECT  e.Start_Time, e.TimeStamp, coalesce(e.Applied_Product,ps.prod_Id),e.Event_Id,e.Event_Status
			FROM @Prod_Starts ps 
			JOIN Events e ON ps.Start_Time <= e.TimeStamp AND ( ps.End_Time >= e.Start_Time ) AND ps.Pu_Id = e.Pu_Id 
			Order By e.Pu_Id,e.TimeStamp
*/
	INSERT INTO @AllEvents ( Start_Time, End_Time,Prod_Id,EventId ,EventStatus )
		SELECT  e.Start_Time, e.TimeStamp, e.Applied_Product,e.Event_Id,e.Event_Status
			FROM @Events e 
			WHERE   PU_Id = @Unitid and  e.Timestamp BETWEEN @StartTime and @EndTime --  ps.Start_Time <= e.TimeStamp AND ( ps.End_Time >= e.Start_Time ) AND ps.Pu_Id = e.Pu_Id 
			Order By e.TimeStamp
   	IF Not Exists(select 1 from @AllEvents)
	BEGIN
		--SELECT @NextEvent = Min(Event_Id) 
		--	From @Events 
		--	WHERE   PU_Id = @Unitid and  Timestamp > @StartTime
		Select Top 1 @NextEvent =  Event_Id From @Events Where PU_Id = @Unitid and  Timestamp > @StartTime Order by Event_Id
		IF @NextEvent Is Not Null
		BEGIN
			INSERT INTO @AllEvents ( Start_Time, End_Time,Prod_Id,EventId ,EventStatus )
				SELECT  e.Start_Time, e.TimeStamp, e.Applied_Product,e.Event_Id,e.Event_Status
					FROM @Events e 
					WHERE   Event_Id = @NextEvent
		END
	END
	UPDATE @AllEvents SET Prod_Id = b.Prod_id
			FROM @AllEvents a
			Join  production_starts b ON b.PU_Id = @UnitId  and b.Start_Time  < a.End_Time and (b.End_Time >= a.End_Time or b.End_Time Is Null)
			Where a.Prod_Id is null
	UPDATE @AllEvents SET Start_Time = @StartTime WHERE Start_Time < @StartTime
	UPDATE @AllEvents SET End_Time = @EndTime WHERE End_Time > @EndTime
 	DELETE FROM @AllEvents WHERE Start_Time = End_Time

	 	 SET @End = @@ROWCOUNT
 	 IF @MoveInProgressTimeStatus != 0
 	 BEGIN
 		IF @End = 0
 		BEGIN
 			SELECT @PrevEnd = Max(TimeStamp) FROM @Events WHERE TimeStamp < @StartTime and PU_Id = @UnitId
 			IF @PrevEnd Is Not Null
 			BEGIN
 				SELECT @EventStatus = Event_Status,@EventId = Event_id FROM @Events WHERE TimeStamp = @PrevEnd and PU_Id = @UnitId
 				IF @EventStatus = @MoveInProgressTimeStatus
 				BEGIN
 					 INSERT INTO @AllEvents ( Start_Time, End_Time,Prod_Id,EventId,EventStatus)
 	  					 SELECT  e.Start_Time, @EndTime, coalesce(e.Applied_Product,ps.prod_Id),e.Event_Id,e.Event_Status
 	  						 FROM @Events e
 	  	  					 Join @Prod_Starts ps  ON ps.Start_Time <= @EndTime AND ( ps.End_Time >= @EndTime )
 	  	  					 WHERE Event_Id  = @EventId 
 				END
 			END
 		END
 		ELSE
 		BEGIN -- Check last Event
 				SELECT @EventStatus = EventStatus,@EventId = Eventid FROM @AllEvents WHERE Id = @End
 				IF @EventStatus = @MoveInProgressTimeStatus
 				BEGIN
 					 Update @AllEvents SET  End_Time = @EndTime WHERE Id = @End
 				END
		END
 	 END 	  	 
	IF Not Exists(select 1 from @AllEvents)
	BEGIN
		INSERT INTO @RunTimes (ProdId , StartTime , EndTime )  
			SELECT prod_id,Start_Time,End_Time From @Prod_Starts 
		RETURN   
	END
	/*  Last event starting Before endtime  */
	Select @CurrentEndTime = MAX(End_Time) FROM @AllEvents
	IF @CurrentEndTime IS Not Null
	BEGIN
		IF @CurrentEndTime < @EndTime 
		BEGIN
			SET @NextEnd = Null
			SELECT @NextEnd = Min(Timestamp)
				FROM @Events  
				WHERE TimeStamp > @CurrentEndTime and PU_Id = @UnitId  and (Start_Time < @EndTime or Start_Time Is Null)
			IF @NextEnd Is Not Null
			BEGIN
				INSERT INTO @AllEvents( Start_Time, End_Time,Prod_Id)
  	  	  	  	  	 SELECT e.Start_Time,@NextEnd, coalesce(e.Applied_Product,ps.prod_Id)
						FROM @Events e 
						Join Production_Starts ps on ps.PU_Id = e.PU_Id and  
								ps.Start_Time < e.TimeStamp AND ( ps.End_Time >= e.TimeStamp  or  ps.End_Time Is Null)
						WHERE e.TimeStamp = @NextEnd and e.PU_Id = @UnitId
			END
			ELSE
			BEGIN
				INSERT INTO @AllEvents( Start_Time, End_Time,Prod_Id)
	  	  	  	  	 SELECT 
						case WHEN ps.Start_Time <= @CurrentEndTime then @CurrentEndTime ELSE  ps.Start_Time END,
						CASE WHEN ps.End_Time IS NULL  OR  ps.End_Time > @EndTime THEN   @EndTime ELSE ps.End_Time END,
						ps.prod_Id
					FROM  Production_Starts ps 
					WHERE  ps.PU_Id = @UnitId  and
							ps.Start_Time < @EndTime AND ( ps.End_Time >= @CurrentEndTime  or  ps.End_Time Is Null)
			
			END
		END
	END
	Select @CurrentEndTime = Null
	/*  First event ending Before starting  */
	Select @CurrentEndTime = min(Start_Time) FROM @AllEvents
	IF @CurrentEndTime IS Not Null
	BEGIN
		IF @CurrentEndTime > @StartTime 
		BEGIN
			INSERT INTO @AllEvents( Start_Time, End_Time,Prod_Id)
	  	  	 SELECT @StartTime,@CurrentEndTime, ps.prod_Id
				FROM  Production_Starts ps 
				WHERE  ps.PU_Id = @UnitId  and
						ps.Start_Time < @CurrentEndTime AND ( ps.End_Time >= @StartTime  or  ps.End_Time Is Null)
		END
	END
	
	Insert into @AllEventsOrdered(Start_Time, End_Time,Prod_Id)
		SELECT Start_Time, End_Time,Prod_Id
			FROM @AllEvents
			Order by Start_Time
	
    SET @Start = 1
 
    SET @PrevEnd = Null
    SELECT @End = COUNT(*) FROM @AllEventsOrdered
    WHILE @Start <= @End
    BEGIN
		SELECT @CurrentStartTime = Start_Time,@CurrentEndTime = End_Time  FROM @AllEventsOrdered WHERE Id = @Start
		IF @CurrentStartTime IS Null
		BEGIN
			Select @CurrentStartTime = Null
			Select @CurrentStartTime = MAX(Timestamp) 
				FROM @Events  
				WHERE TimeStamp < @CurrentEndTime and PU_Id = @UnitId
			IF @CurrentStartTime Is Null SET @CurrentStartTime = DATEADD(MINUTE,-1,@CurrentEndTime)
			Update @AllEventsOrdered Set Start_Time = @CurrentStartTime Where Id = @Start
		END
		ELSE
		BEGIN
			IF @PrevEnd Is Not Null 
			BEGIN
				IF @CurrentStartTime < @PrevEnd
					Update @AllEventsOrdered Set Start_Time = @PrevEnd Where Id = @Start
				IF @CurrentStartTime != @PrevEnd -- plug holes
				BEGIN
					INSERT INTO @AllEventsOrdered( Start_Time, End_Time,Prod_Id)
	  	  	  	  		 SELECT 
							case WHEN ps.Start_Time <= @PrevEnd then @PrevEnd ELSE  ps.Start_Time END,
							CASE WHEN ps.End_Time IS NULL  OR  ps.End_Time > @CurrentStartTime THEN   @CurrentStartTime ELSE ps.End_Time END,
							ps.prod_Id
						FROM  Production_Starts ps 
						WHERE  ps.PU_Id = @UnitId  and
								ps.Start_Time < @PrevEnd AND ( ps.End_Time >= @CurrentStartTime  or  ps.End_Time Is Null)
				END
			END
			SET @PrevEnd = @CurrentEndTime
		END
		IF @CurrentStartTime is Not Null and @CurrentEndTime Is Not Null
		BEGIN
			DELETE FROM @AllEventsOrdered WHERE Start_Time > @CurrentStartTime and End_Time < @CurrentEndTime
		END
		SET @Start2 = Null
		SELECT @Start2 = MIN(ID) FROM @AllEventsOrdered WHERE id > @Start
		IF @Start2 Is Null
			SET @Start = @End + 1
		ELSE
			SET @Start = @Start2
    END
    
	UPDATE @AllEventsOrdered SET Start_Time = @StartTime Where Start_Time < @StartTime
	UPDATE @AllEventsOrdered SET end_Time = @EndTime Where end_Time > @EndTime


  	INSERT INTO @AllEventsOrdered2(Start_Time, End_Time,Prod_Id)
		SELECT Start_Time, End_Time,Prod_Id
			FROM @AllEventsOrdered
			Order by Start_Time

    SELECT  @Start =1
    SELECT @End = Max(Id) FROM @AllEventsOrdered2
    SET @CurrentStartTime = Null
    SET @CurrentEndTime = Null
    SET @LastProdId = Null
    WHILE @Start <= @End
	BEGIN
		IF @CurrentStartTime Is Null
		BEGIN
			SELECT @CurrentStartTime = Start_Time,@CurrentEndTime = End_Time,@LastProdId = Prod_Id FROM @AllEventsOrdered2 Where Id = @Start
		END
		ELSE
		BEGIN
			SELECT @CurrentProdId = Prod_Id FROM @AllEventsOrdered2 Where Id = @Start
			IF @CurrentProdId = @LastProdId
			BEGIN
				SELECT @CurrentEndTime = End_Time FROM @AllEventsOrdered2 Where Id = @Start
			END
			ELSE
			BEGIN
				INSERT INTO @RunTimes (ProdId , StartTime , EndTime ) Values (@LastProdId,@CurrentStartTime,@CurrentEndTime)
				SELECT @CurrentStartTime = @CurrentEndTime,@CurrentEndTime = End_Time,@LastProdId = Prod_Id FROM @AllEventsOrdered2 Where Id = @Start 
			END
			IF @Start = @End
			BEGIN
				INSERT INTO @RunTimes (ProdId , StartTime , EndTime ) Values (@LastProdId,@CurrentStartTime,@CurrentEndTime)
			END
			SET @Start = @Start + 1
		END 
	END	
	----<Change - Prasad 2018-01-05>
	--Delete from @RunTimes
	--INSERT INTO @RunTimes (ProdId , StartTime , EndTime ) 
	--Select Prod_Id,Min(Start_Time),Max(End_Time) from @AllEventsOrdered2 Group By Prod_Id, ShiftDesc, Cast(Start_Time as DATE)
	----</Change - Prasad 2018-01-05>

	RETURN
END



GO


