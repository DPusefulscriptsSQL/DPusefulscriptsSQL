Create table User_Mymachines (Dept_Id Int , Dept_desc Varchar(50),
Pl_Id Int , Pl_desc Varchar(50),
Pu_Id Int , Pu_desc Varchar(50),
ET_Id Int , ET_desc Varchar(50),
Is_Slave Bit,User_Id int)
GO
Create clustered index icx_user_mymachines on User_Mymachines(User_Id)
GO
--select * from users where username like '%bm_opera%'
Create table #Temp (Dept_Id Int , Dept_desc Varchar(50),
Pl_Id Int , Pl_desc Varchar(50),
Pu_Id Int , Pu_desc Varchar(50),
ET_Id Int , ET_desc Varchar(50),
Is_Slave Bit,User_Id int)

declare @cnt int, @total int,@username varchar(20),@UserId int

SET @total = 300
SET @cnt =1

while @cnt <= @total

BEgin
		Select @UserId=User_id from users_base where username = 'bm_operator_'+cast(@cnt as varchar)
		Insert into #Temp(Dept_id, Dept_desc,Pl_id,Pl_desc,Pu_id,Pu_desc,ET_Id,ET_desc,IS_Slave)
		EXEC	spBF_APIMyMachines_APIGetMyMachines
				@UserId;
		UPDATE #Temp SET User_Id = @UserId
		UPDATE T
		SET T.Is_Slave = Case when pu.Master_Unit IS NOT NULL THEN 1 ELSE 0 END
		FRoM #Temp T join Prod_Units_Base Pu on Pu.Pu_id = T.Pu_id 
		Insert into User_Mymachines
		Select * from #temp 
		Delete from #Temp


		Set @cnt = @cnt +1
End



