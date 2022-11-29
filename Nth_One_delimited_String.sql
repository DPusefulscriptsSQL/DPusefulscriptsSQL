

Declare @str varchar(100) = 'YO-LLD-HC-PO0019-20220429013000',@delimiter varchar(10) = '-',@n int = 4
SELECT VALUE FROM STRING_SPLIT(@str, @delimiter) ORDER BY (SELECT NULL) OFFSET (@n-1) ROWS FETCH NEXT 1 ROW ONLY