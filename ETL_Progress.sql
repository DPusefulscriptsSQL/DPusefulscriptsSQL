select top 500 server_name, status, package_name,p.Start_Time, datediff(minute, p.start_time, isnull(p.end_time,getutcdate())) time, read_count, source_table,
insert_count, update_count, delete_count, destination_table, last_source_timestamp
from audit.packagerunlog p
left join audit.dataflowlog d on d.run_id = p.run_id
left join audit.datasourcerunlog s on s.run_id = dbo.fndw_gettoplevelrunid(p.run_id)
left join admin.data_sources ds on ds.source_id = s.source_id
--where Server_Name = 'lynchburg2'
order by p.run_id desc
--order by isnull(p.End_Time, getutcdate())  desc