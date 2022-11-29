Declare @cnt int,@RoleNm varchar(4),@p3 int,@p6 Int,@P5 int
SET @cnt =56

While @cnt < 57
Begin
	SET @RoleNm = 'R'+cast(@cnt as  varchar)
	exec spEM_CreateSecurityRole @RoleNm,1,@p3 output


	exec spEM_CreateSecurityRoleMember @p3,NULL,'CHL_GROUP001',1,'CH01:DC=CH01,DC=PLANTAPPS,DC=com',@p6 output
	exec spEM_CreateUserSecurity 1,@p3,2,1,@p5 output
	SET @cnt = @cnt + 1
End 