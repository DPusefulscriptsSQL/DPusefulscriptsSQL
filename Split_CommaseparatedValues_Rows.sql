--Split comma seperated string
--@VarIds --Comma separated string
DECLARE @xml XML
SET @xml = cast(('<X>'+replace(@VarIds,',','</X><X>')+'</X>') as xml)

SELECT N.value('.', 'int') FROM @xml.nodes('X') AS T(N)