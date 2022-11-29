select size/128.0 SIZE,CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 SPACEUSED,size/128.0 - CAST(FILEPROPERTY(name, 'SpaceUsed') AS int)/128.0 EMPTYSPACE,* from sys.database_files


