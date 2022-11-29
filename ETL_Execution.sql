select datediff(mi, start_time, end_time),start_time, end_time,status,package_name from audit.packagerunlog order by start_time desc
select d.run_Id, ds.server_name [Data Source], p.package_name, convert(float,datediff(second, p.start_time, p.end_time))/60.0 timeTaken, 
d.source_table, d.Read_count, 
case when datediff(second, p.start_time, p.end_time) = 0 then 0 else d.read_count*60.0/convert(float,datediff(second, p.start_time, p.end_time)) end as [Read Per Minute],
d.destination_table, d.insert_count,  
case when datediff(second, p.start_time, p.end_time) = 0 then 0 else d.insert_count*60.0/convert(float,datediff(second, p.start_time, p.end_time)) end as [Insert Per Minute]
from audit.packagerunlog p
left outer join audit.packagerunlog pp on p.parent_run_id = pp.run_id
left outer join audit.dataflowlog d on d.run_id = p.run_id 
left outer join audit.datasourcerunlog s on s.run_id = 
            case when p.parent_run_id = 0 or p.parent_run_id is null then p.run_id else 
                  case when pp.parent_run_id = 0 or pp.parent_run_id is null then pp.run_id else pp.parent_run_Id 
                  end
            end
left outer join admin.data_sources ds on ds.source_id = s.source_id
where d.read_count <> 0 and d.insert_count <> 0
order by d.run_id desc

sp_spaceused FactProductionEvent
sp_spaceused FactTestResult
sp_spaceused FactTimedEventDetail
sp_spaceused FactWasteEventDetail
sp_spaceused FactUnitProduction
sp_spaceused FactUnitEfficiency
sp_spaceused FactProductionEventTimeSlice
sp_spaceused 'etl.StageFactProductionEvent'
sp_spaceused 'etl.StageFactTimedEventDetail'
sp_spaceused 'etl.StageFactTestResult'

select start_time,end_time,Product_Key,Process_Order_Key,* from FactUnitEfficiency where Unit_Key in (select Unit_Key from DimProductionUnit where Src_Key = '1')
 and Production_Time_Key = '20110421'
select * from admin.cube_production_subtype
select * from dimsite
select Event_Subtype_Desc,Src_Key,* from dimeventtype where ET_Desc = 'Production Event'

DELETE FROM admin.Cube_Production_Subtype WHERE Site_Key = 2
INSERT INTO admin.Cube_Production_Subtype (site_Key, et_src_key) VALUES(2, '0')


DELETE FROM admin.Cube_Production_Subtype WHERE Site_Key = 2
INSERT INTO admin.Cube_Production_Subtype (site_Key, et_src_key)
SELECT site_key, src_key
FROM DimEventType d
WHERE site_key = 2 And ET_Desc = 'Production Event' And Event_Subtype_Desc In ('Batch','Reel')
And Not Exists(SELECT * FROM admin.Cube_Production_Subtype WHERE ET_Src_Key = d.Src_Key)

select start_time,end_time,Product_Key,Process_Order_Key,* from FactUnitEfficiency where Unit_Key in (select Unit_Key from DimProductionUnit where Src_Key = '1')
 and site_Key = 3
 select * from DimProductionUnit where Site_Key = 3
 select * from DimProductionMetrics
 
 select * from factproductioneventtimeslice where Site_Key = 3
 select  start_time,end_time,* from factunitproduction where Site_Key = 3
 select   start_time,end_time,* from factalarmtimeslice where Site_Key = 3
  select * from factuserdefinedeventtimeslice where Site_Key = 3
 
