
--          Alter Table ecs.pa_customcalls_configuration Alter Column config_data nvarchar(max) NULL ;        Alter Table ecs.pa_customcalls_configuration Alter Column created_by Nvarchar(50) NULL ;        Alter Table ecs.pa_customcalls_configuration Alter Column last_modified_by Nvarchar(50) NULL ;      
If exists(Select 1 from sys.tables where name='AlterTableList')
Begin
	Drop table AlterTableList
End
GO
If Not exists(Select 1 from sys.tables where name='AlterTableList')
Begin
CREATE TABLE AlterTableList([Table] varchar(256), [Column] varchar(256) ,[Schema] varchar(256),[Datatype] varchar(256),[Length] smallint,isnullable int,iscomputed int,[IsAltered] int,
SerialNo Int Identity(1,1),
TableSerialNo Int
)

	;With s as 
	(
		Select 
			b.name [Table],a.name [Column],c.name [Datatype],a.length,a.isnullable,a.iscomputed,d.name [Schema]
		from 
			sys.syscolumns a 
			join sys.tables b on a.id = b.object_id
			join sys.types c on c.user_type_id = a.xtype 
			join sys.schemas d on d.schema_Id = b.schema_id
		where 
			(c.name in ('varchar','char','text') Or c.name like 'varchar%')
	)
	Insert into AlterTableList([Table], [Column],[Datatype],[Length],isnullable,iscomputed, [IsAltered],[Schema])
	Select DISTINCT [Table], [Column],[Datatype],[Length],isnullable,iscomputed,0 [IsAltered],[Schema]  from S 
	Where [Table] in ('Event_configuration_Values','Access_Level',	'Active_Specs',	'Activities',	'Activity_Configuration_Types',	'Activity_History',	'Activity_Statuses',	'Activity_Types',	'AlarmAttributeValues',	'AlarmAttributeValue_History',	'Alarms',	'Alarm_History',	'Alarm_Priorities',	'Alarm_SPC_Rules',	'Alarm_SPC_Rule_Properties',	'Alarm_Templates',	'Alarm_Template_SPC_Rule_Property_Data',	'Alarm_Template_Var_Data',	'Alarm_Types',	'Alarm_Variable_Rules',	'AppVersions',	'AppVersion_History',	'AttributeValuesHistory',	'Audit_Trail',	'Batch_Parameter_Selections',	'Batch_Procedure_Selections',	'Batch_Unit_Parameter_Selections',	'BF_Service',	'Bill_Of_Material',	'Bill_Of_Material_Family',	'Bill_Of_Material_Formulation',	'Bill_Of_Material_Formulation_Item',	'Binaries',	'Bus_Subscriptions',	'Calculations',	'Calculation_Dependencies',	'Calculation_Dependency_Scopes',	'Calculation_History',	'Calculation_Inputs','Calculation_Input_Attributes',	'Calculation_Input_Data',	'Calculation_Input_Data_History',	'Calculation_Input_Entities',	'Calculation_Input_History',	'Calculation_Instance_Dependencies_History',	'Calculation_Trigger_Types',	'Calculation_Types',	'Characteristics',	'Characteristic_Groups',	'Characteristic_History','Client_Connections',	'Client_Connection_App_Data',	'Client_Connection_Statuses',	'Client_Connection_User_History',	'Client_SP_CursorTypes',	'Client_SP_LockTypes',	'Client_SP_Prototypes',	'COA',	'COA_Items',	'Colors',	'Color_Scheme',	'Color_Scheme_Categories',	'Color_Scheme_Fields',	'Comments',	'comment_attachments',	'Comment_Source',	'Comparison_Operators',	'Containers',	'Container_Classes',	'Container_Location_History',	'Container_Statuses',	'Control_Type',	'CreateStoredProcedures.bat',	'Crews',	'Crew_Schedule',	'Crew_Schedule_History',	'Customer',	'Customer_COA',	'Customer_Orders',	'Customer_Order_Line_Items',	'Customer_Order_Line_Specs',	'Customer_Types',	'CXS_Route',	'CXS_Route_Data',	'CXS_Route_Group',	'CXS_Service',	'Dashboard_Cache_Options',	'Dashboard_Dashboard_Styles','Dashboard_DataTable_Headers',	'Dashboard_Default_XSL',	'Dashboard_Dialogues',	'Dashboard_Event_Scopes',	'Dashboard_Event_Types',	'Dashboard_Frequency_Types',	'Dashboard_Gallery_Generator_Servers',	'Dashboard_Icons',	'Dashboard_Parameter_Data_Types',	'Dashboard_Parameter_Default_Values',	'Dashboard_Parameter_Types',	'Dashboard_Parameter_Values',	'Dashboard_Reports',	'Dashboard_Report_Data',	'Dashboard_Statistics',	'Dashboard_Templates',	'Dashboard_Template_Launch_Type',	'Dashboard_Template_Parameters',	'Dashboard_Template_Size_Units',	'Dashboard_Users',	'Dashboard_Value_Types',	'DataSource',	'Data_Source',	'Data_Source_XRef',	'Data_Type',	'DB_Maintenance_Commands',	'DB_Maintenance_Command_Groups',	'DB_Maintenance_Command_Severity',	'DB_Maintenance_Command_Types',	'DB_Trans_Types',	'Defect_Details_History',	'Defect_Types',	'Departments_Base',	'Department_History',	'Dependency_History',	'Dept_Parameters',	'dir.bat',	'Display_Options',	'Display_Option_Access',	'Display_Option_Categories',	'ED_Attributes',	'ED_Fields',	'ED_FieldTypes',	'ED_FieldType_ValidValues',	'ED_Field_Properties',	'ED_Models',	'Ed_Script',	'Email_Groups',	'Email_Messages',	'Email_Message_Data',	'Email_Recipients',	'Engineering_Unit',	'Engineering_Unit_Conversion',	'Errors',	'ESignature',	'Events',	'Events_Xref_Lot_History',	'Event_Components',	'Event_Component_History',	'Event_Configuration',	'Event_Configuration_Data',	'Event_Configuration_Data_History',	'Event_Configuration_History',	'Event_Configuration_Properties',	'Event_Container_Data_History',	'Event_Details',	'Event_Detail_History',	'Event_Dimensions',	'Event_History',	'Event_Reasons',	'Event_Reason_Catagories',	'Event_Reason_Level_Headers',	'Event_Reason_Tree',	'Event_Subtypes',	'Event_Transactions',	'Event_Types',	'Execute_Table_Script.bat',	'Extended_Test_Freqs',	'External_Interfaces',	'Extra',	'FTP_Actions',	'FTP_Config',	'FTP_Post_Actions',	'FTP_Transfer_Types',	'Functions',	'GB_DSet',	'GB_Dset_Data',	'GB_RSum_Data',	'Golden_Batches',	'GWay_Permanent_Clients',	'Historians',	'Historian_Options',	'Historian_Option_Data',	'Historian_Quality',	'Historian_Types',	'Historian_Type_Options',	'Icons',	'Import_Export_Fields',	'Import_Export_Types',	'In_Process_Bins',	'Languages',	'Language_Substitutions',	'Licenses',	'License_Mgr_Info',	'License_Mgr_Stats',	'Linkable_Remote_Servers',	'Message_Log_Detail',	'Message_Log_Header',	'Message_Properties',	'Message_Result_Mappings',	'Message_Types',	'Modules',	'NonProductive_Detail_History',	'NPT_Detail_Grouping',	'OEEAggregation',	'OEEAggregationGranularityLevel',	'OEEAggregationSliceTypes',	'OPC_Class',	'OPC_Property',	'OPC_Type',	'Operating_Systems',	'out.txt',	'Parameters',	'Parameter_Categories',	'Parameter_Types',	'PDF_Process_Segment_History',	'PendingTasks',	'Performance_Counters',	'Performance_Objects',	'Performance_Statistics',	'Performance_Statistics_Keys',	'Phrase',	'PrdExec_Inputs',	'PrdExec_Input_History',	'PrdExec_Input_Positions',	'Prdexec_Paths',	'PrdExec_Path_Alarm_Types',	'PrdExec_Path_History',	'PrdExec_Path_Unit_History',	'PrdExec_Path_Unit_Starts_History',	'PreEvents',	'PrintServer_Files',	'Process_Segment_Component_History',	'Process_Segment_Dependency_History',	'Process_Segment_Equipment_History',	'Process_Segment_Family_History',	'Process_Segment_History',	'Process_Segment_Parameter_History',	'Production_Event_Association',	'Production_Plan',	'Production_Plan_History',	'Production_Plan_Starts_History',	'Production_Plan_Statuses',	'Production_Plan_Types',	'Production_Setup',	'Production_Setup_Detail',	'Production_Setup_Detail_History',	'Production_Setup_History',	'Production_Starts_History',	'Production_Status',	'Production_Status_XRef',	'Products_Base',	'Product_Definition_History',	'Product_Definition_Property_History',	'Product_Definition_Property_Value_History',	'Product_Dependency_History',	'Product_Dependency_Version_History',	'Product_Family',	'Product_Family_History',	'Product_Groups',	'Product_History',	'Product_Location_History',	'Product_Properties',	'Product_Properties_History',	'Product_Segment_History',	'Product_Segment_Parameter_History',	'Prod_Lines_Base',	'Prod_Line_History',	'Prod_Units_Base',	'Prod_Unit_History',	'Prod_XRef',	'Property_Types',	'PurgeConfig',	'PurgeConfig_Detail',	'PurgeResult',	'PU_Groups',	'PU_Group_History',	'Reason_Shortcuts',	'Report_Definitions',	'Report_Definition_Parameters',	'Report_Dependency_Types',	'Report_Engines',	'Report_Engine_Activity',	'Report_Engine_Responses',	'Report_Parameters',	'Report_Parameter_Groups',	'Report_Parameter_Types',	'Report_Printers',	'Report_Print_Styles',	'Report_Relative_Dates',	'Report_Relative_Date_Types',	'Report_Runs',	'Report_Schedule',	'Report_Server_Links',	'Report_Server_Link_Types',	'Report_Shell_Commands',	'Report_Shortcuts',	'Report_Tree_Model',	'Report_Tree_Nodes',	'Report_Tree_Node_Types',	'Report_Tree_Templates',	'Report_Tree_Users',	'Report_Types',	'Report_Type_Dependencies',	'Report_Type_Parameters',	'Report_WebPages',	'Report_WebPage_Dependencies',	'Research_Status',	'ResultSetConfig',	'ResultSetTypes',	'Return_Error_Codes',	'Return_Error_Groups',	'S95_Event_History',	'sample',	'Sampling_Interval',	'Sampling_Type',	'Sampling_Window_Types',	'Saved_Queries',	'Scripts.exe',	'Security_Groups',	'Security_Items',	'Security_Operations',	'Segment_Parameter_History',	'Server_Log_Records',	'ServiceProvider_Stored_Procedure',	'ServiceProvider_Stored_Procedure_Field',	'Service_ThreadPools',	'Sheets',	'Sheet_Column_History',	'Sheet_Display_Options',	'Sheet_Groups',	'Sheet_Shortcuts',	'Sheet_Type',	'Sheet_Type_Display_Options',	'Sheet_Unit',	'Sheet_Variables',	'Shifts',	'Shipment',	'Shipment_Line_Items',	'Site_Parameters',	'Site_Parameter_History',	'Source',	'SPC_Calculation_Types',	'SPC_Group_Variable_Types',	'SPC_Trend_Types',	'Specifications',	'Specification_History',	'Specification_Types',	'Spec_Activations',	'Spool_Weights',	'Staged_Sheet_Variables',	'Stored_Procs',	'Stored_Proc_Dependancies',	'Stored_Proc_Parms',	'Stored_Proc_Parm_Types',	'Stored_Proc_spCalc_Parms',	'Subscription',	'Subscription_Group',	'Subscription_Trigger',	'Tables',	'Table_Fields',	'Table_Fields_Values',	'Table_Fields_Values_History',	'Table_Lists',	'Tasks',	'Templates',	'Template_Properties',	'Template_Property_Data',	'Tests',	'Test_History',	'Test_Status',	'Timed_Event_Details',	'Timed_Event_Detail_History',	'Timed_Event_Fault',	'Timed_Event_Fault_History',	'Timed_Event_Status',	'TimeZoneTranslations',	'Topics',	'Transactions',	'Transaction_Filter_Values',	'Transaction_Groups',	'Transaction_Types',	'Trans_Metric_Properties',	'Trans_Properties',	'Trans_Variables',	'Tree_Statistics',	'UDEAttributeValues',	'Unit_Locations',	'Unit_Types',	'UserGroup',	'User_Defined_Events',	'User_Defined_Event_History',	'User_history',	'User_Parameters',	'User_Parameter_History',	'User_Role_Security',	'Variables_Base',	'Variable_History',	'Variable_Interface_Info',	'Var_Lookup',	'Var_Specs',	'VendorAttributes',	'Views',	'View_Groups',	'Waste_Event_Details',	'Waste_Event_Detail_History',	'Waste_Event_Fault',	'Waste_Event_Fault_History',	'Waste_Event_Meas',	'Waste_Event_Type',	'Web_App_Criteria',	'Web_App_Reject_Codes',	'Web_App_Status',	'Web_App_Types',	'Web_Report_Definitions',	'Web_Report_Instances',	'Web_Report_Instance_History',	'Web_Report_Triggers'	,'Users_Base')
	AND [Table] not in ('UserGroup','Characteristic_Groups')
	AND [Schema] = 'dbo'
	UNION 
	Select DISTINCT [Table], [Column],[Datatype],[Length],isnullable,iscomputed,0 [IsAltered],[Schema]  from S 
	Where [schema] in ('Assignment','ncr','apc','Assignment','comment','erp','ecs','product','pds','route','security','usersettings','historyservice')
	---removed workorder schema
	AND 
	NOT 
	(
		([table] = 'property_category' and [Schema] = 'pds' and [Column] = 'Id')
		OR 
		([table] = 'property_definition' and [Schema] = 'pds' and [Column] in ( 'Id','property_group_id','initial_id'))
		OR
		([table] = 'property_group' and [Schema] = 'pds' and [Column] in ( 'id','initial_id','property_category_id'))
		OR
		([table] = 'SegmentPropertyHistory' and [Schema] = 'pds' and [Column] in ( 'PropertyDefinitionId'))		 	 
	)

	--AND [TABLE] ='CXS_Route_Data'
	--and [TABLE] not in ('PreEvents','CXS_Route_Data','Functions','GWay_Permanent_Clients','License_Mgr_Stats','PreEvents','Site_Parameters','User_Parameters')
	
	Order by [Table],[Schema],[iscomputed] desc
End
GO
 SET NOCOUNT ON
 Declare @Cnt int,@totalCnt int,@PublicationName varchar(100),@IsReplicationPresent Int,@CntPublication Int
 DECLARE @AddArticleSQL varchar(max), @DropArticleSQL varchar(max),@GrantTotal varchar(max)
 ,@IsDBO Int
 SELECT @IsDBO =1
 CREATE TABLE #tmpPublications(publication_name varchar(100),SerialNo Int Identity(1,1))
 SELECT @IsReplicationPresent = CASE WHEN EXISTS(Select 1 from master.sys.sysdatabases where name='distribution') THEN 1 ELSE 0 END 
 SELECT @CntPublication =0
 Create Table #ArticleList(
publication	nvarchar(256) /*/*COLLATE Latin1_General_CI_AI*/*/,
article	nvarchar(256) /*COLLATE Latin1_General_CI_AI*/,
source_owner	nvarchar(256) /*COLLATE Latin1_General_CI_AI*/,
source_object	nvarchar(256) /*COLLATE Latin1_General_CI_AI*/
)


IF EXISTS(Select 1 from master.sys.sysdatabases where name='distribution')
BEGIN
	Insert into #tmpPublications(publication_name)
	SELECT DISTINCT  
	p.publication publication_name 
	FROM distribution..MSArticles a  
	JOIN distribution..MSpublications p ON a.publication_id = p.publication_id 

	Insert into #ArticleList
	select 
		p.name, A.name,A.dest_owner,A.dest_table
	from 
		dbo.sysarticles  A 
		join dbo.syspublications P on P.pubid= A.pubid

END
SELECT @CntPublication = count(0) from #tmpPublications
IF EXISTS (Select 1 from sys.views where name ='View_History_Events' and schema_id in (Select schema_id from sys.schemas where name='historyservice'))
Begin
	Drop view historyservice.View_History_Events
End


 


Create Table #Temp(TableName Varchar(400),ColumnName varchar(1000),TypeOfColumn varchar(200),SubTypeOfColumn Varchar(500) ,NameofObject varchar(500),AlterScript Varchar(max))
Create table #tmp (TableName varchar(400), columnname varchar(1000))
Declare @TotalTableCnt int,@TotalColumnCnt int, @cntColumn Int,@cntTable int,@Start datetime, @End Datetime
DECLARE @TotalSql Varchar(max)
Declare @TableName Varchar(400),@ColumnName varchar(1000),@SchemaName varchar(1000)
Declare @DropSql varchar(max),@CreateSql varchar(max),@AlterSql varchar(max),@name varchar(200),@ComputedColumnAlterSql varchar(max)

SELECT @DropSql='',@CreateSql='',@AlterSql='',@TotalSql='',@ComputedColumnAlterSql='',@AddArticleSQL='',@DropArticleSQL=''

IF @IsReplicationPresent = 1 and @CntPublication >0
BEGIN
SELECT @DropArticleSQL = 
COALESCE(@DropArticleSQL+'','')+
'EXEC sp_dropsubscription @publication = @PublicationName, @article = '''+[Article]+''' ,@subscriber = ''all''
EXEC sp_droparticle @publication = @PublicationName, @article = '''+[Article]+''',@force_invalidate_snapshot = 1;
'From (select distinct [Table],[Schema],[Article],publication from AlterTableList A join #ArticleList S on S.source_object= A.[Table] and S.source_owner = A.[Schema] )T Where
[Table] in ('CXS_Route_Data','PreEvents','Functions','GWay_Permanent_Clients','License_Mgr_Stats','Site_Parameters','User_Parameters','Events')
OR [schema] in ('Assignment','ncr','apc','Assignment','comment','erp','ecs','product','pds','route','security','usersettings','historyservice','workorder')
Select @DropArticleSQL = 
'Declare @Cnt int,@PublicationName varchar(200)
SELECT @Cnt =1,@PublicationName=''''
While @Cnt <='+Cast(@CntPublication as varchar)+'
Begin
		Select @PublicationName=  publication_name from #tmpPublications where SerialNo = @Cnt
'+		
@DropArticleSQL+'
EXEC sp_changepublication @publication = @PublicationName, @property = N''allow_anonymous'',@value = ''FALSE''
		EXEC sp_changepublication @publication = @PublicationName,@property = N''immediate_sync'',@value = ''FALSE''
	SET @Cnt = @Cnt+1
End
'


SELECT @AddArticleSQL = 
COALESCE(@AddArticleSQL+'','')+
'EXEC sp_addarticle @publication =@PublicationName, @article = '''+[Article]+''' ,@source_object =N'''+[Table]+''',@source_owner = N'''+[Schema]+''', @destination_owner = N'''+[Schema]+''',@destination_table = N'''+[Table]+''',@force_invalidate_snapshot=1
'From (select distinct [Table],[Schema],[Article],publication from AlterTableList A join #ArticleList S on S.source_object= A.[Table] and S.source_owner = A.[Schema])T Where [Table] in ('CXS_Route_Data','PreEvents','Functions','GWay_Permanent_Clients','License_Mgr_Stats','Site_Parameters','User_Parameters','Events')
OR [schema] in ('Assignment','ncr','apc','Assignment','comment','erp','ecs','product','pds','route','security','usersettings','historyservice','workorder')
SELECT @AddArticleSQL=
'Declare @Cnt int,@PublicationName varchar(200)
SELECT @Cnt =1,@PublicationName=''''
While @Cnt <='+Cast(@CntPublication as varchar)+'
Begin
		Select @PublicationName=  publication_name from #tmpPublications where SerialNo = @Cnt
'+@AddArticleSQL+'
		EXEC sp_refreshsubscriptions @publication = @PublicationName
		EXEC sp_changepublication @publication = @PublicationName,@property = N''immediate_sync'',@value = ''TRUE''
		EXEC sp_changepublication @publication = @PublicationName,@property = N''allow_anonymous'',@value = ''TRUE''
	SET @Cnt = @Cnt+1
End'
END
IF  (SELECT COUNT(0) FROM AlterTableList) > 0
BEGIN
IF @IsReplicationPresent = 1 and @CntPublication >0
Begin 
EXEC (@DropArticleSQL)
--SELECT @DropArticleSQL
END
/*Excluding these tables as as These are filled with product related object name.*/

Delete from AlterTableList Where [Table] in ('Client_SP_CursorTypes','Client_SP_LockTypes','Client_SP_Prototypes','AlterTableList')
--Delete from AlterTableList Where  [Table]  in ('Dashboard_Templates') AND [Column]  IN ('Dashboard_Template_XSL')
 DELETE FROM AlterTableList where [Table] not in ( 'tests');
;WITH S AS (Select Distinct [Table],[Schema] from AlterTableList),S1 As ( Select *,Row_Number() over (Order by [Table],[Schema])rownum from S)
UPDATE A
SET TableSerialNo = S1.rownum
From 
	S1
	Join AlterTableList A on A.[Table] = S1.[Table] and A.[Schema] = S1.[Schema]


Select @TotalColumnCnt=Max(SerialNo),@TotalTableCnt=Max(TableSerialNo) from AlterTableList 
SELECT @cntTable = 1, @cntColumn=1

 
While @cntTable <=@TotalTableCnt
Begin 
	Select top 1 @TableName = [Table], @SchemaName = [Schema] from AlterTableList where TableSerialNo = @cntTable 
	Select @TotalColumnCnt = MAx(SerialNo),@cntColumn=Min(SerialNo) from AlterTableList where TableSerialNo = @cntTable 
	SELECT @DropSql='',@CreateSql ='',@AlterSql ='',@ComputedColumnAlterSql='',@AddArticleSQL='',@DropArticleSQL='',@TotalSql=''
 SELECT @Start =GETDATE()
	While @cntColumn <=@TotalColumnCnt
	Begin
		Select Top 1 @ColumnName = [Column] from AlterTableList where TableSerialNo = @cntTable And SerialNo= @cntColumn
		
		Insert into #tmp
		SELECT @cntTable,@cntColumn
		SET @cntColumn = @cntColumn+1

		--<Code>
		--Get Unique and primary keys of the table
		Insert Into #Temp(TableName ,ColumnName ,TypeOfColumn ,SubTypeOfColumn  ,NameofObject )
		Select TheTable,COlumns,'Constraint',[Type]+' '+Isclustered,TheKey from (
		SELECT 
		  keys.Parent_Object_ID,
		  OBJECT_NAME(keys.Parent_Object_ID) AS TheTable,
		  keys.name AS TheKey, --the name of the key
		  COALESCE(STUFF(
			(SELECT
			   ', ' + COL_NAME(Ic.Object_Id, Ic.Column_Id)
			   + CASE WHEN Is_Descending_Key <> 0 THEN ' DESC' ELSE '' END
			 FROM Sys.Index_Columns Ic
			 WHERE Ic.Index_Id = keys.unique_Index_Id 
			   AND Ic.Object_Id = keys.parent_Object_Id
			   AND is_included_column=0
			ORDER BY Key_Ordinal
			FOR XML PATH (''), TYPE).value('.', 'varchar(max)'),1,2,''), '?') AS COLUMNS,
			(SELECT 
				Distinct i.type_desc
			 FROM Sys.Index_Columns Ic
			 join sys.indexes i on i.index_id = ic.index_id
			 join sys.data_spaces ds on i.data_space_id = ds.data_space_id 
			 WHERE Ic.Index_Id = keys.unique_Index_Id 
			   AND Ic.Object_Id = keys.parent_Object_Id
			   AND is_included_column=0
			) Isclustered,
		  REPLACE(REPLACE(LOWER(type_desc),'_',' '),'constraint','') AS [Type],
		  is_system_named
		FROM sys.Key_Constraints [keys]
		WHERE OBJECTPROPERTYEX(keys.Parent_Object_ID,'IsUserTable')=1
			AND 
			EXISTS (Select 1 FROM Sys.Index_Columns Ic WHERE Ic.Index_Id = keys.unique_Index_Id AND Ic.Object_Id = keys.parent_Object_Id AND is_included_column=0 AND  COL_NAME(Ic.Object_Id, Ic.Column_Id) =@ColumnName)
		 ) T
		 Where 
			Parent_Object_ID = (select A.Object_Id from sys.tables A join sys.schemas s on s.schema_id=A.schema_id Where A.name =@TableName and s.name =@SchemaName)		    
		
		--Get foreign Keys of other table referencing the primary key of current table.
		;WITH FK_Others as (SELECT
			fk.is_disabled,
			fk.is_not_trusted,
			OBJECT_SCHEMA_NAME(o1.object_id) AS FK_schema,
			o1.name AS FK_table,
			--Generate list of columns in referring side of foreign key
			STUFF(
				(
					SELECT ', ' + c1.name AS [text()]
					FROM sys.columns c1 INNER
						JOIN sys.foreign_key_columns fkc
							ON c1.object_id = fkc.parent_object_id
							AND c1.column_id = fkc.parent_column_id
					WHERE fkc.constraint_object_id = fk.object_id
					FOR XML PATH('')
				), 1, 2, '') AS FK_columns,
			--Look for any indexes that will fully satisfy the foreign key columns
			STUFF(
				(
					SELECT ', ' + i.name AS [text()]
					FROM sys.indexes i
					WHERE i.object_id = o1.object_id
						AND NOT EXISTS ( --Find foreign key columns that don't match the index key columns
							SELECT fkc.constraint_column_id, fkc.parent_column_id
							FROM sys.foreign_key_columns fkc
							WHERE fkc.constraint_object_id = fk.object_id
							EXCEPT
							SELECT ic.key_ordinal, ic.column_id
							FROM sys.index_columns ic
							WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id
						)
					FOR XML PATH('')
				), 1, 2, '') AS FK_indexes,
			fk.name AS FK_name,
			OBJECT_SCHEMA_NAME(o2.object_id) AS PK_schema,
			o2.name AS PK_table,
			--Generate list of columns in referenced (i.e. PK) side of foreign key
			STUFF(
				(
					SELECT ', ' + c2.name AS [text()]
					FROM sys.columns c2
						INNER JOIN sys.foreign_key_columns fkc
							ON c2.object_id = fkc.referenced_object_id
							AND c2.column_id = fkc.referenced_column_id
					WHERE fkc.constraint_object_id = fk.object_id
					FOR XML PATH('')
				), 1, 2, '') AS PK_columns,
			pk.name AS PK_name,
			fk.delete_referential_action_desc AS Delete_Action,
			fk.update_referential_action_desc AS Update_Action
		FROM sys.objects o1
			INNER JOIN sys.foreign_keys fk
				ON o1.object_id = fk.parent_object_id
			INNER JOIN sys.objects o2
				ON fk.referenced_object_id = o2.object_id
			INNER JOIN sys.key_constraints pk
				ON fk.referenced_object_id = pk.parent_object_id
				AND fk.key_index_id = pk.unique_index_id
		--WHERE o2.name = 'property_group' and OBJECT_SCHEMA_NAME(o2.object_id) = 'pds'
		)
		Insert Into #Temp(TableName ,ColumnName ,TypeOfColumn ,SubTypeOfColumn  ,NameofObject,AlterScript )
		Select distinct FK_schema+'.'+FK_table,FK_columns,'Constraint','F',FK_name,' WITH CHECK ADD FOREIGN KEY ('+FK_columns+') References '+Pk_schema+'.'+PK_table+'('+PK_columns+')' from FK_Others FkTbl
		where FkTbl.PK_table='property_group' and FkTbl.PK_schema ='pds' and @SchemaName = 'pds' and @TableName ='property_group' and @columnName =Pk_columns
		AND NOT EXISTS (Select 1 From #Temp where TableName /*collate SQL_Latin1_General_CP1_CI_AS*/ =@TableName and TypeOfColumn /*collate SQL_Latin1_General_CP1_CI_AS*/= 'Constraint' and SubTypeOfColumn /*collate SQL_Latin1_General_CP1_CI_AS*/ = 'F' and NameofObject /*collate SQL_Latin1_General_CP1_CI_AS*/= FkTbl.FK_name)  ;


		--Get Foreign Keys of the table
		Insert Into #Temp(TableName ,ColumnName ,TypeOfColumn ,SubTypeOfColumn  ,NameofObject,AlterScript )
		Select TableName,ColumnName,'Constraint','F',foreign_key_name,[AlterScript] From 
		(SELECT f.parent_object_id,

		' WITH CHECK ADD FOREIGN KEY ('+COL_NAME(fc.parent_object_id, fc.parent_column_id)+') References  '+OBJECT_NAME(f.referenced_object_id) +'('+COL_NAME(fc.referenced_object_id, fc.referenced_column_id)+')'
		[AlterScript],
		COL_NAME(fc.parent_object_id, fc.parent_column_id) ColumnName,OBJECT_NAME(f.parent_object_id) TableName
		,CONVERT(CHAR(200), f.name) AS foreign_key_name,
		  OBJECT_SCHEMA_NAME(f.parent_object_id) + '.'
		  + OBJECT_NAME(f.parent_object_id) + '.'
		  + COL_NAME(fc.parent_object_id, fc.parent_column_id) AS constraint_column,
		  OBJECT_SCHEMA_NAME(f.referenced_object_id) + '.'
		  + OBJECT_NAME(f.referenced_object_id) + '.'
		  + COL_NAME(fc.referenced_object_id, fc.referenced_column_id) AS referenced_column,
		  CASE WHEN is_disabled <> 0 THEN 'Disabled' ELSE ''
		  END AS is_disabled,
		  delete_referential_action_desc,
		  update_referential_action_desc
		  FROM sys.foreign_keys AS f
		  INNER JOIN sys.foreign_key_columns AS fc
			ON f.object_id = fc.constraint_object_id 
			)T Where 
			parent_object_id= (select A.Object_Id from sys.tables A join sys.schemas s on s.schema_id=A.schema_id Where A.name =@TableName and s.name =@SchemaName)		    
			And ColumnName = @ColumnName
		
		
		--Get Indexes 
		Insert Into #Temp(TableName ,ColumnName ,TypeOfColumn ,SubTypeOfColumn  ,NameofObject ,AlterScript)
		Select TableName,NULL,'Index','Index',index_name,index_create_statement from (
		SELECT t.name TableName,sc.name [SchemaName],
			DB_NAME() AS database_name,Key_Definition,include_definition,filter_definition,
			sc.name + N'.' + t.name AS table_name,
			(SELECT MAX(user_reads) 
				FROM (VALUES (last_user_seek), (last_user_scan), (last_user_lookup)) AS value(user_reads)) AS last_user_read,
			last_user_update,
			CASE si.index_id WHEN 0 THEN N'/* No create statement (Heap) */'
			ELSE 
				CASE is_primary_key WHEN 1 THEN
					N'ALTER TABLE ' + QUOTENAME(sc.name) + N'.' + QUOTENAME(t.name) + N' ADD CONSTRAINT ' + QUOTENAME(si.name) + N' PRIMARY KEY ' +
						CASE WHEN si.index_id > 1 THEN N'NON' ELSE N'' END + N'CLUSTERED '
					ELSE N'CREATE ' + 
						CASE WHEN si.is_unique = 1 then N'UNIQUE ' ELSE N'' END +
						CASE WHEN si.index_id > 1 THEN N'NON' ELSE N'' END + N'CLUSTERED ' +
						N'INDEX ' + QUOTENAME(si.name) + N' ON ' + QUOTENAME(sc.name) + N'.' + QUOTENAME(t.name) + N' '
				END +
				/* key def */ N'(' + key_definition + N')' +
				/* includes */ CASE WHEN include_definition IS NOT NULL THEN 
					N' INCLUDE (' + include_definition + N')'
					ELSE N''
				END +
				/* filters */ CASE WHEN filter_definition IS NOT NULL THEN 
					N' WHERE ' + filter_definition ELSE N''
				END +
				/* with clause - compression goes here */
				CASE WHEN row_compression_partition_list IS NOT NULL OR page_compression_partition_list IS NOT NULL 
					THEN N' WITH (' +
						CASE WHEN row_compression_partition_list IS NOT NULL THEN
							N'DATA_COMPRESSION = ROW ' + CASE WHEN psc.name IS NULL THEN N'' ELSE + N' ON PARTITIONS (' + row_compression_partition_list + N')' END
						ELSE N'' END +
						CASE WHEN row_compression_partition_list IS NOT NULL AND page_compression_partition_list IS NOT NULL THEN N', ' ELSE N'' END +
						CASE WHEN page_compression_partition_list IS NOT NULL THEN
							N'DATA_COMPRESSION = PAGE ' + CASE WHEN psc.name IS NULL THEN N'' ELSE + N' ON PARTITIONS (' + page_compression_partition_list + N')' END
						ELSE N'' END
					+ N')'
					ELSE N''
				END +
				/* ON where? filegroup? partition scheme? */
				' ON ' + CASE WHEN psc.name is null 
					THEN ISNULL(QUOTENAME(fg.name),N'')
					ELSE psc.name + N' (' + partitioning_column.column_name + N')' 
					END
				+ N';'
			END AS index_create_statement,
			si.index_id,
			si.name AS index_name,
			partition_sums.reserved_in_row_GB,
			partition_sums.reserved_LOB_GB,
			partition_sums.row_count,
			stat.user_seeks,
			stat.user_scans,
			stat.user_lookups,
			user_updates AS queries_that_modified,
			partition_sums.partition_count,
			si.allow_page_locks,
			si.allow_row_locks,
			si.is_hypothetical,
			si.has_filter,
			si.fill_factor,
			si.is_unique,
			ISNULL(pf.name, '/* Not partitioned */') AS partition_function,
			ISNULL(psc.name, fg.name) AS partition_scheme_or_filegroup,
			t.create_date AS table_created_date,
			t.modify_date AS table_modify_date
		FROM sys.indexes AS si
		JOIN sys.tables AS t ON si.object_id=t.object_id
		JOIN sys.schemas AS sc ON t.schema_id=sc.schema_id
		LEFT JOIN sys.dm_db_index_usage_stats AS stat ON 
			stat.database_id = DB_ID() 
			and si.object_id=stat.object_id 
			and si.index_id=stat.index_id
		LEFT JOIN sys.partition_schemes AS psc ON si.data_space_id=psc.data_space_id
		LEFT JOIN sys.partition_functions AS pf ON psc.function_id=pf.function_id
		LEFT JOIN sys.filegroups AS fg ON si.data_space_id=fg.data_space_id
		/* Key list */ OUTER APPLY ( SELECT STUFF (
			(SELECT N', ' + QUOTENAME(c.name) +
				CASE ic.is_descending_key WHEN 1 then N' DESC' ELSE N'' END
			FROM sys.index_columns AS ic 
			JOIN sys.columns AS c ON 
				ic.column_id=c.column_id  
				and ic.object_id=c.object_id
			WHERE ic.object_id = si.object_id
				and ic.index_id=si.index_id
				and ic.key_ordinal > 0
			ORDER BY ic.key_ordinal FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'')) AS keys ( key_definition )
		/* Partitioning Ordinal */ OUTER APPLY (
			SELECT MAX(QUOTENAME(c.name)) AS column_name
			FROM sys.index_columns AS ic 
			JOIN sys.columns AS c ON 
				ic.column_id=c.column_id 
				and ic.object_id=c.object_id
			WHERE ic.object_id = si.object_id
				and ic.index_id=si.index_id
				and ic.partition_ordinal = 1) AS partitioning_column
		/* Include list */ OUTER APPLY ( SELECT STUFF (
			(SELECT N', ' + QUOTENAME(c.name)
			FROM sys.index_columns AS ic 
			JOIN sys.columns AS c ON 
				ic.column_id=c.column_id  
				and ic.object_id=c.object_id
			WHERE ic.object_id = si.object_id
				and ic.index_id=si.index_id
				and ic.is_included_column = 1
			ORDER BY c.name FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'')) AS includes ( include_definition )
		/* Partitions */ OUTER APPLY ( 
			SELECT 
				COUNT(*) AS partition_count,
				CAST(SUM(ps.in_row_reserved_page_count)*8./1024./1024. AS NUMERIC(32,1)) AS reserved_in_row_GB,
				CAST(SUM(ps.lob_reserved_page_count)*8./1024./1024. AS NUMERIC(32,1)) AS reserved_LOB_GB,
				SUM(ps.row_count) AS row_count
			FROM sys.partitions AS p
			JOIN sys.dm_db_partition_stats AS ps ON
				p.partition_id=ps.partition_id
			WHERE p.object_id = si.object_id
				and p.index_id=si.index_id
			) AS partition_sums
		/* row compression list by partition */ OUTER APPLY ( SELECT STUFF (
			(SELECT N', ' + CAST(p.partition_number AS VARCHAR(32))
			FROM sys.partitions AS p
			WHERE p.object_id = si.object_id
				and p.index_id=si.index_id
				and p.data_compression = 1
			ORDER BY p.partition_number FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'')) AS row_compression_clause ( row_compression_partition_list )
		/* data compression list by partition */ OUTER APPLY ( SELECT STUFF (
			(SELECT N', ' + CAST(p.partition_number AS VARCHAR(32))
			FROM sys.partitions AS p
			WHERE p.object_id = si.object_id
				and p.index_id=si.index_id
				and p.data_compression = 2
			ORDER BY p.partition_number FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'),1,2,'')) AS page_compression_clause ( page_compression_partition_list )
		WHERE 
			--partitioning_column.column_name = @ColumnName and
			si.type IN (0,1,2) /* heap, clustered, nonclustered */
			AND 
			(
				EXISTS (Select 1 from (SELECT QUOTENAME(c.name) ColName FROM sys.index_columns AS ic JOIN sys.columns AS c ON ic.column_id=c.column_id  and ic.object_id=c.object_id WHERE ic.object_id = si.object_id and ic.index_id=si.index_id and ic.key_ordinal > 0) T Where T.ColName = '['+@ColumnName+']')
				OR
				EXISTS (SELECT 1 From (SELECT QUOTENAME(c.name) ColName FROM sys.index_columns AS ic  JOIN sys.columns AS c ON ic.column_id=c.column_id  and ic.object_id=c.object_id WHERE ic.object_id = si.object_id and ic.index_id=si.index_id and ic.is_included_column = 1)T Where T.ColName = '['+@ColumnName+']')
			)
			 ) T
			 Where TableName  = @TableName And [SchemaName] = @SchemaName
			 
			And Not exists(select 1 from #Temp Where NameofObject = T.index_name /*collate SQL_Latin1_General_CP1_CI_AS*/)
		ORDER BY table_name, index_id
			OPTION (RECOMPILE);
 
  

		--Get Default constraints
		Insert Into #Temp(TableName ,ColumnName ,TypeOfColumn ,SubTypeOfColumn  ,NameofObject ,AlterScript)
		select 
			t.[name],col.[name],'Constraint','Default',con.name,'ALTER TABLE ['+t.name+'] ADD  CONSTRAINT ['+con.name+']  DEFAULT '+con.[definition]+' FOR ['+col.name+']'
		
		from 
			sys.default_constraints con
			left outer join sys.objects t on con.parent_object_id = t.object_id
			left outer join sys.all_columns col on con.parent_column_id = col.column_id and con.parent_object_id = col.object_id
			left outer join sys.schemas s on s.schema_id =t.schema_id
		Where   
			t.[name] = @TableName And col.name = @ColumnName and s.name=@SchemaName
		
		--Get Check constraints
		Insert Into #Temp(TableName ,ColumnName ,TypeOfColumn ,SubTypeOfColumn  ,NameofObject ,AlterScript)
		select 
			t.[name],col.[name],'Constraint','Check',con.name,'ALTER TABLE  ['+t.name+']  WITH '+Case when con.is_disabled = 1 Then 'NOCHECK' ElSE 'CHECK' END+' ADD  CONSTRAINT ['+con.name+'] CHECK  ('+con.[definition]+')'
		from 
			sys.check_constraints con
			left outer join sys.objects t on con.parent_object_id = t.object_id
			left outer join sys.all_columns col on con.parent_column_id = col.column_id and con.parent_object_id = col.object_id
			left outer join sys.schemas s on s.schema_id = t.schema_id
		Where   
			(t.[name] = @TableName And col.name = @ColumnName and s.name= @SchemaName)
			OR ('SheetVars_CC_VarIdTitle' = con.name and t.[name] = 'Sheet_Variables' and @TableName = 'Sheet_Variables')
			OR ('variables_CC_Tags' = con.name and t.[name] = 'Variables_Base' and @TableName = 'Variables_Base')


		



		 	

	
	 
		--</Code>


		
	End
		    

			
			UPDATE T
			SET
				T.TableName = A.[Schema] /*COLLATE SQL_Latin1_General_CP1_CI_AS*/ +'.'+T.TableName 
			from 
				AlterTableList A
				join #Temp T on A.[Table]  /*COLLATE SQL_Latin1_General_CP1_CI_AS*/ = T.[TableName]
			Where 
				A.[Table] = @TableName
				AND A.[Schema] = @SchemaName
				--and [schema] <> 'dbo' and ISNULL([schema],'') <>''
		--SELECT @IsDBO = case when [schema] <> 'dbo' and ISNULL([schema],'') <>'' Then 0 Else 1 end from AlterTableList where [Table] = @TableName
		SELECT @IsDBO = 0

		
		Select @DropSql = Coalesce(@DropSql+'
		','')+'IF EXISTS(Select 1 from sys.sysobjects where name  ='''+NameofObject+''' and parent_obj ='+
		Case when @IsDBO = 1 Then ''''+TableName+'''' Else '(Select object_id from sys.tables a join sys.schemas s on s.schema_id =a.schema_id and s.name+''.''+a.name = '''+TableName+''')' End
		
		+' AND xtype in  (''F''))
		Begin 
			Alter table '+TableName+' Drop Constraint '+NameofObject+'
		END;

		' from #temp where TypeOfColumn = 'Constraint'

			Select @DropSql = Coalesce(@DropSql+'
		','')+'IF EXISTS(Select 1 from sys.sysobjects where name  ='''+NameofObject+''' and parent_obj ='+
		Case when @IsDBO = 1 Then ''''+TableName+'''' Else '(Select object_id from sys.tables a join sys.schemas s on s.schema_id =a.schema_id and s.name+''.''+a.name = '''+TableName+''')' End
		
		+' AND xtype in  (''UQ'',''PK'',''D'',''C''))
		Begin 
			Alter table '+TableName+' Drop Constraint '+NameofObject+'
		END;

		' from #temp where TypeOfColumn = 'Constraint' 


		Select @CreateSql = Coalesce(@CreateSql+'
		','')+'IF NOT EXISTS(Select 1 from sys.sysobjects where name  ='''+NameofObject+''' and parent_obj ='+
		Case when @IsDBO = 1 Then ''''+TableName+'''' Else '(Select object_id from sys.tables a join sys.schemas s on s.schema_id =a.schema_id and s.name+''.''+a.name = '''+TableName+''')' End
		+' AND xtype in  (''UQ'',''PK'',''F''))
		Begin 
			Alter table '+TableName+' Add Constraint '+NameofObject+' '+ SubTypeOfColumn+' ('+ColumnName+')
		END;

		' from #temp  where TypeOfColumn = 'Constraint' AND (SubTypeOfColumn Like '%unique%' OR SubTypeOfColumn Like '%Primary%')
		
		
		Select @CreateSql = Coalesce(@CreateSql+'
		','')+'IF NOT EXISTS(Select 1 from sys.sysobjects where name  ='''+NameofObject+''' and parent_obj ='+Case when @IsDBO = 1 Then ''''+TableName+'''' Else '(Select object_id from sys.tables a join sys.schemas s on s.schema_id =a.schema_id and s.name+''.''+a.name = '''+TableName+''')' End+' AND xtype in  (''UQ'',''PK'',''F''))
		Begin 
			Alter table '+TableName+' '+[AlterScript]+'
		END;

		' from #temp  where TypeOfColumn = 'Constraint' AND SubTypeOfColumn = 'F'


		Select @CreateSql = Coalesce(@CreateSql+'
		','')+'
		IF NOT EXISTS(Select 1 from sys.default_constraints where name ='''+NameofObject+''' and parent_object_id ='+Case when @IsDBO = 1 Then ''''+TableName+'''' Else '(Select object_id from sys.tables a join sys.schemas s on s.schema_id =a.schema_id and s.name+''.''+a.name = '''+TableName+''')' End+')
		Begin 
			'+AlterScript+'
		END;

		' from #temp  where TypeOfColumn = 'Constraint' AND SubTypeOfColumn in ('Default')

		Select @CreateSql = Coalesce(@CreateSql+'
		','')+'
		IF NOT EXISTS(Select 1 from sys.check_constraints where name ='''+NameofObject+''' and parent_object_id ='+Case when @IsDBO = 1 Then ''''+TableName+'''' Else '(Select object_id from sys.tables a join sys.schemas s on s.schema_id =a.schema_id and s.name+''.''+a.name = '''+TableName+''')' End+')
		Begin 
			'+AlterScript+'
		END;

		' from #temp  where TypeOfColumn = 'Constraint' AND SubTypeOfColumn in ('Check')


		Select @DropSql = Coalesce(@DropSql+'
		','')+'IF Exists (Select 1 from sys.sysindexes where name ='''+NameOfObject+''' and id='+Case when @IsDBO = 1 Then ''''+TableName+'''' Else '(Select object_id from sys.tables a join sys.schemas s on s.schema_id =a.schema_id and s.name+''.''+a.name = '''+TableName+''')' End+')
		Begin
			Drop Index '+TableName+'.'+NameOfObject+'
		End;'
		From #Temp Where TypeOfColumn ='Index'

		Select @CreateSql = Coalesce(@CreateSql+'
		','')+'IF Exists (Select 1 from sys.sysindexes where name ='''+NameOfObject+''' and id='+Case when @IsDBO = 1 Then ''''+TableName+'''' Else '(Select object_id from sys.tables a join sys.schemas s on s.schema_id =a.schema_id and s.name+''.''+a.name = '''+TableName+''')' End+')
		Begin
			'+AlterScript+'
		End;'
		From #Temp
		Where TypeOfColumn ='Index'

		  
		Select @AlterSql = Coalesce(@AlterSql+'
		','')+'
		Alter Table '+case when isnull([schema],'') <> '' and [schema] <> 'dbo' Then [Schema]+'.' else '' end+[Table]+' Drop Column ['+[Column]+']'
		 from AlterTableList Where [Table]=@TableName   And iscomputed = 1 And [Schema] =@SchemaName
		 		
			 
		  

		Select @AlterSql = Coalesce(@AlterSql+'
		','')+'
		Alter Table '+case when isnull([schema],'') <> '' and [schema] <> 'dbo' Then [Schema]+'.' else '' end+[Table]+' Alter Column ['+[Column]+']'+
		
		Case 
			when Datatype = 'varchar' Then ' Nvarchar('+Case when ([Length] > 4000 and [Table] in 
			('SDK_Clause_Data','BF_MessageQueue','Activity_History','User_Parameters','pa_customcalls_configuration',
			'User_Parameter_History','Table_Fields_Values_History','Table_Fields_Values',
			'Sheet_Unit',
			'Sheet_Type_Display_Options','Sheet_Display_Options','Server_Log_Records',
			'Saved_Queries','Report_Type_Parameters','Report_Tree_Nodes','Activities',
			'Errors','Functions','Message_Log_Detail','Report_Definition_Parameters',
			'Report_Parameters','Report_Server_Links')) or ([length] = -1 and [Table]='comment_attachments') Then 
			'4000' 
			When (([length] >4000 or [length] =-1) AND [Schema] <> 'dbo') THen 'max'
			when [Length] > 4000 and [Table] in ('Site_Parameters','Site_Parameter_History') Then '4000' 
			else cast([Length] as varchar) End +')'
			when Datatype='char' Then ' Nchar('+Case when ([Length] > 4000 and [Table] in ('Activities','Errors','Functions','Message_Log_Detail')) 
			or ([length] = -1 and [Table]='comment_attachments') Then '4000' 
			when [Length] =-1 then '4000'
			else cast([length] as varchar) End +')'
			
		End		
		+ 
		case when isnullable = 1 then ' NULL ' ELSE ' NOT NULL ' END+';'
		 from AlterTableList Where [Table]=@TableName  And iscomputed <> 1 and Datatype <> 'text' And [Schema] =@SchemaName
		  Select @AlterSql = Replace(@AlterSql,'nvarchar(-1)','nvarchar(max)')

Select @AlterSql = Coalesce(@AlterSql+'
		','')+'
		Alter Table '+case when isnull([schema],'') <> '' and [schema] <> 'dbo' Then [Schema]+'.' else '' end+[Table]+' Alter Column ['+[Column]+'] Nvarchar(max)'+ case when isnullable = 1 then ' NULL ' ELSE ' NOT NULL ' END+';
		Alter Table '+case when isnull([schema],'') <> '' and [schema] <> 'dbo' Then [Schema]+'.' else '' end+[Table]+' Alter Column ['+[Column]+'] ntext'+ case when isnullable = 1 then ' NULL ' ELSE ' NOT NULL ' END+';'
		 from AlterTableList Where [Table]=@TableName   And iscomputed <> 1 and Datatype = 'text' And [Schema] =@SchemaName


		Select @ComputedColumnAlterSql = Coalesce(@ComputedColumnAlterSql+'
		','')+'
		Alter Table '+case when isnull([schema],'') <> '' and [schema] <> 'dbo' Then [Schema]+'.' else '' end+[Table]+' Add ['+[Column]+'] AS '+Cast(Cc.[definition] as varchar(max))
		 from AlterTableList A join sys.computed_columns Cc on Object_name(Cc.object_id) =A.[Table] And Cc.[Name] = A.[Column] 
		 Where [Table]=@TableName   And A.iscomputed = 1 And [Schema] =@SchemaName
	

		
		 
		truncate table #Temp
	 

 
		SELECT @TotalSql = 
 
ISNULL(@DropSql,'')+'
'+
ISNULL(@AlterSql,'')+'
'+
ISNULL(@CreateSql,'')+'
'+'
'+isnull(@ComputedColumnAlterSql,'') 
Select @TableName 
IF @TableName not in ( 'Tests','Test_History')
Begin
	EXEC ( @TotalSql)
	PRINT 2
END

ELSE

BEGIN
PRINT 1
	Declare @Path varchar(200),@bcpSQL varchar(max),@createNewSQL varchar(max),@DBName varchar(50)
	select @Path = physical_name from master.sys.database_files
	Select @Path = REPLACE(@Path,REVERSE(LEFT(REVERSE(@Path),PATINDEX('%\%',REVERSE(@Path))-1)),'')+@TableName+'.txt'
	SELECT @DBName ='SOADBUNI'

	--create file
	DECLARE @OLE INT
	DECLARE @FileID INT
	EXECUTE sp_OACreate 'Scripting.FileSystemObject', @OLE OUT
	EXECUTE sp_OAMethod @OLE, 'OpenTextFile', @FileID OUT, @Path, 8, 1
	--EXECUTE sp_OAMethod @FileID, 'WriteLine', Null, 'Today is wonderful day'
	EXECUTE sp_OADestroy @FileID
	EXECUTE sp_OADestroy @OLE

	select @bcpSQL= 'EXEC xp_cmdshell ''bcp "select Test_Id,Canceled,Result_On,Entry_On,Entry_By,Comment_Id,Array_Id,Event_Id,Var_Id,Locked,Result,Second_User_Id,Signature_Id,IsVarMandatory from '+@DBName+'.dbo.tests" queryout "'+@Path+'" -E -T -c -t^|'''
	EXEC(@bcpSQL)
	SELECT @bcpSQL
	Select @createNewSQL ='
	 CREATE TABLE ['+@DBName+'].[dbo].[Tests_1](
		[Test_Id] [int] IDENTITY(1,1) NOT NULL,
		[Canceled] [bit] NOT NULL,
		[Result_On] [datetime] NOT NULL,
		[Entry_On] [datetime] NOT NULL,
		[Entry_By] [int] NULL,
		[Comment_Id] [int] NULL,
		[Array_Id] [int] NULL,
		[Event_Id] [int] NULL,
		[Var_Id] [int] NOT NULL,
		[Locked] [tinyint] NULL,
		[Result] nvarchar(50) NULL,
		[Second_User_Id] [int] NULL,
		[Signature_Id] [int] NULL,
		[IsVarMandatory] [bit] NULL,
	 CONSTRAINT [Tests_PK_TestId_1] PRIMARY KEY NONCLUSTERED 
	(
		[Test_Id] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
	 CONSTRAINT [Test_By_Variable_And_Result_On_1] UNIQUE CLUSTERED 
	(
		[Var_Id] ASC,
		[Result_On] ASC
	)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]
	'
	EXEC (@createNewSQL)
	SELEct @createNewSQL
	select @bcpSQL = 'EXEC xp_cmdshell ''bcp '+@DBName+'.dbo.Tests_1 in "'+@Path+'" -E -T -c -t^| '''
	EXEC (@bcpSQL)
	SELECT @bcpSQL
	select @bcpSQL = 	'EXEC xp_cmdshell ''del '+@Path+''''
	EXEC (@bcpSQL)
	SELECT @bcpSQL
END



  

 SET @cntTable = @cntTable+1
  
 SELECT @DropSql='',@CreateSql='',@AlterSql='',@ComputedColumnAlterSql='',@AddArticleSQL='',@DropArticleSQL='',@TotalSql=''
 SELECT @End = Getdate()
 SELECT @TableName
 --Insert Into ##TESTTIMECAPTURE
 --select @TableName ,@Start,@End
End

IF @IsReplicationPresent = 1 and @CntPublication >0
Begin 
EXEC (@AddArticleSQL)

END
END 
drop table #tmp
Drop table #Temp

Drop table #tmpPublications
Drop table #ArticleList
SET NOCOUNT OFF 
 
  