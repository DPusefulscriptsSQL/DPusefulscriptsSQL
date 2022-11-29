
 Select pcd.*,C.Char_Desc,pp.Prop_Desc,S.Spec_Id,Specs.Target,V.Var_Desc from Product_Characteristic_Defaults Pcd 
 join Characteristics C on C.Char_Id = Pcd.Char_Id
 join products p on P.Prod_Id = Pcd.Prod_Id
  join Product_Properties pp on pp.Prop_Id = Pcd.Prop_Id
   join Specifications S on S.Prop_Id = C.Prop_Id
    Join Active_Specs Specs on Specs.Spec_Id =S.Spec_Id and Specs.Char_Id = C.Char_Id
	join PU_Groups pg on pg.PUG_Desc =Specs.Target
	join Variables_Base v on pg.PUG_Id = V.PUG_Id
 where C.Char_Id =8 and S.spec_Id =5 AND Pg.Pu_Id = 86

  