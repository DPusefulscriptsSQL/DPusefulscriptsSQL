 

 --Select * from dbo.fnBF_wrQuickOEESlices(14,'2021-04-22 00:37.993','2021-04-22 16:29:37.993','UTC',0,1,0)
 Select Non_Productive_Category,* from Prod_Units_base  where pu_id = 14
 Select Datediff(minute,start_time,end_time),* from NonProductive_DEtail where Pu_id = 14 and NPDet_Id = 9
 Select * from Event_Reason_Tree_Data where Event_Reason_Tree_Data_Id = 14
 --Select * from sys.tables where name like '%event%reason%'

 Select * from Event_Reason_Category_Data where Event_Reason_Tree_Data_Id = 14
 select * from Event_Reason_Catagories where erc_Id  in (2,7)
  --------
     ------------

	 ------
--------

-------------------
     ------

	 -------
--------------------


05:05 --05:30 -npt
05:15- 05:20 dt



  Select Datediff(minute,start_time,end_time)  ,
   CASE WHEN EC.erc_Id  = PU.Non_Productive_Category THEN 1 ELSE 0 END [IsNPTConfigurationCOrrect]
  from NonProductive_DEtail  NPT
  JOIN Prod_Units_base PU ON PU.Pu_Id = NPT.PU_Id
  JOIN Event_Reason_Category_Data ECD on ECD.Event_Reason_Tree_Data_Id = NPT.Event_Reason_Tree_Data_Id 
  JOIN Event_Reason_Catagories EC ON EC.erc_Id = ECD.ERC_ID
  where PU.Pu_id = 14 --and NPT.NPDet_Id = 9
