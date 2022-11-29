create table tblident(Sno int identity,col1 char(1))
GO
create table tblidentity(Sno int identity,col1 char(1))
GO
insert into tblidentity values('A'),('B')
GO
CREATE TRIGGER dbo.trgr_tblidentity
on dbo.tblidentity after insert
as
begin
	insert into tblident values ('D')
end
GO
Create procedure usp_identities 
AS
BEGIN

insert into tblidentity values ('C')
SELECT @@IDENTITY AS '@@IDENTITY_INPROC'
SELECT SCOPE_IDENTITY() AS 'SCOPEIDENTITY_INPROC'
SELECT IDENT_CURRENT('tblidentity') AS 'IDENTCURRENT_INPROC'END

GO
Exec usp_identities
GO
drop proc usp_identities
GO
Drop table tblidentity
GO
Drop table tblident