--Create table testTrigger (col1 int)

DROP TRIGGER [dbo].[Trigg_TestTrigger]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[Trigg_TestTrigger]
ON [dbo].[testTrigger]
 
  FOR INSERT
  AS
   DECLARE @TEMP TABLE 
   (EventType NVARCHAR(30), Parameters INT, EventInfo NVARCHAR(4000)) 
   INSERT INTO @TEMP EXEC('DBCC INPUTBUFFER(@@SPID)') 
  Insert into Message_Log_Detail (Message_Log_Id,Message) Select 9999,EventInfo from @TEMP
GO

