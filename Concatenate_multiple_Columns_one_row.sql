;WITH S as 
(
	 Select 
		DISTINCT 
		Event_Reason_Tree_Data_Id,
		Erc.ERC_Id,
		Erc.ERC_DESC 
	FROM  
		Event_Reason_Category_Data Ercd
		JOIN Event_Reason_Catagories Erc On Erc.ERC_Id = Ercd.ERC_Id
	Where 
		Event_Reason_Tree_Data_Id In 
	 (Select   Event_Reason_Tree_Data_Id  FROM  Event_Reason_Category_Data Group by Event_Reason_Tree_Data_Id Having count(0) >1)
)
,Reason_Category As 
(
SELECT Event_Reason_Tree_Data_Id, ReasonCategory = STUFF((
    SELECT ', ' +'CategoryId:'+ CAST(ERC_Id as Varchar)+';CategoryDesc:' +ERC_DESC FROM S
    WHERE Event_Reason_Tree_Data_Id = x.Event_Reason_Tree_Data_Id
    FOR XML PATH(''), TYPE).value('.[1]', 'nvarchar(max)'), 1, 2, '')
FROM  S AS x
GROUP BY Event_Reason_Tree_Data_Id
)
