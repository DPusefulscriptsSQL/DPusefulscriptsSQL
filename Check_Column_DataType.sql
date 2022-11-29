
DECLARE @VlotIdentifier varchar(200),@xtype int
SET @VlotIdentifier= @lotIdentifier
Select @xtype = Case when Data_type = 'varchar' then 0 Else 1 end from information_schema.columns where table_Name ='events' and column_name ='event_num'