select sp.Parm_id,p.parm_name,sp.Value from site_parameters sp
join parameters p on p.parm_id = sp.parm_id
where sp.parm_id
in (10,27,158,160,161,162,163,165,166,167,168,169,170,172,174,182,183) 
Order by sp.Parm_id
/*
WIN-SO42COFNVO0

Update site_parameters set value ='WIN-SO42COFNVO0/ReportServer' where parm_Id =10
Update site_parameters set value ='WIN-SO42COFNVO0' where parm_Id =27
--Update site_parameters set value ='C:\Inetpub\wwwroot\ProficyWebParts' where parm_Id =158
--Update site_parameters set value ='/ProficyDashBoard/' where parm_Id =160
--Update site_parameters set value ='12297' where parm_Id =161
--Update site_parameters set value ='1' where parm_Id =162
--Update site_parameters set value ='/ProficyWebParts/' where parm_Id =163
Update site_parameters set value ='WIN-SO42COFNVO0' where parm_Id =165
Update site_parameters set value ='WIN-SO42COFNVO0' where parm_Id =166
Update site_parameters set value ='WIN-SO42COFNVO0' where parm_Id =167
--Update site_parameters set value ='7' where parm_Id =168
--Update site_parameters set value ='3' where parm_Id =169
--Update site_parameters set value ='0' where parm_Id =170
--Update site_parameters set value ='C:\Inetpub\wwwroot\ProficyDashboard' where parm_Id =172
--Update site_parameters set value ='DAVCatalog' where parm_Id =174
--Update site_parameters set value ='1' where parm_Id =182
--Update site_parameters set value ='0' where parm_Id =183

*/


