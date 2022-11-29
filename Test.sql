

--EXEC spBF_DowntimeGetAll '2018-09-01 09:15:43','2018-09-11 09:15:43',N'4,1,7,33',NULL,NULL,0,0,NULL,NULL

--EXEC spBF_DowntimeGetAll '2018-08-01 09:15:43','2018-09-11 09:15:43',N'4,1,7,33',NULL,NULL,0,0,NULL,NULL
 

--SELECT  StartTime ,EndTime,ProdId FROM dbo.fnBF_GetPSFromEvents(1,'2018-08-01 14:45:43.000' ,'2018-09-11 14:45:43.000' ,16) 
--SELECT  StartTime ,EndTime,ProdId FROM dbo.fnBF_GetPSFromEvents(4,'2018-08-01 14:45:43.000' ,'2018-09-11 14:45:43.000' ,16) 
--SELECT  StartTime ,EndTime,ProdId FROM dbo.fnBF_GetPSFromEvents(7,'2018-08-01 14:45:43.000' ,'2018-09-11 14:45:43.000' ,16) 
--SELECT  StartTime ,EndTime,ProdId FROM dbo.fnBF_GetPSFromEvents(33,'2018-08-01 14:45:43.000' ,'2018-09-11 14:45:43.000' ,16) 



--Select count(0) from Events  Where pu_Id = 1
--Select count(0) from Events  Where pu_Id = 4
--Select count(0) from Events  Where pu_Id = 7
--Select count(0) from Events  Where pu_Id = 33
SELECT  StartTime ,EndTime,ProdId FROM dbo.fnBF_GetPSFromEvents(1,'2018-08-01 14:45:43.000' ,'2018-09-11 14:45:43.000' ,16) 
SELECT  StartTime ,EndTime,ProdId FROM dbo.fnCMN_GetPSFromEvents(1,'2018-08-01 14:45:43.000' ,'2018-09-11 14:45:43.000' ) 
 