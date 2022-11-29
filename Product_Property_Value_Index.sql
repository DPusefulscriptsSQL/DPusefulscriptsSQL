

Select id,product_id,Property_definition_id,[value] from Product.product_property_value where product_id = 31839


DROP INDEX IX_PropertyValue_idProdIdDefIdVal
ON Product.Product_Property_Value 
GO
CREATE NONCLUSTERED INDEX IX_PropertyValue_idProdIdDefIdVal
ON Product.Product_Property_Value (product_id)INCLUDE(Id, Property_definition_Id)


 

 