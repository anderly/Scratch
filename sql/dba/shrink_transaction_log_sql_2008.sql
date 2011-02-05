alter database [DBNAME] set recovery simple
go

checkpoint
go

alter database [DBNAME] set recovery full
go

dbcc shrinkfile (N'DBNAME_Log' , 1)
go