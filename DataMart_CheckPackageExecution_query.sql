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