-- Unit tests for testing kms database
-- Testing dbo.doc

set nocount on
set noexec off
use kms
go 

-- Unit test for dbo.doc the beginning
declare @c_doc tinyint = 14
declare @s_doc varchar(9) = '45 01'
declare @n_doc varchar(8) = '591777'
declare @d_doc date = '20020129'
declare @e_doc date = '20190620'
declare @u_doc varchar(max) = '��� �-�� "������������"'
declare @x_doc tinyint = 1

declare @docrecid int = dbo.seekdoc(@s_doc, @n_doc)
if @docrecid>0  begin print '�������� 45 01 591777 ��� ���������� � dbo.doc' return end 

-- ����������/���������/�������� ������ �������� � dbo.doc
insert into dbo.doc (c_doc,s_doc,n_doc,d_doc,e_doc,u_doc,x_doc) values (@c_doc,@s_doc,@n_doc,@d_doc,@e_doc,@u_doc,@x_doc)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekdoc(@s_doc, @n_doc) = @newrecid print '�������� 45 01 591777 ������� �������� � dbo.doc!'

update dbo.doc set s_doc='45 02' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.doc')
print @newrecid
if dbo.seekdoc('45 02', @n_doc) = @newrecid print '�������� 45 01 591777 -> 45 02 591777!'

update dbo.doc set n_doc='591778' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.doc')
print @newrecid
if dbo.seekdoc('45 02', '591778') = @newrecid print '�������� 45 02 591777 -> 45 02 591778!'

delete from dbo.doc where recid=@newrecid
-- ����������/���������/�������� ������ �������� � dbo.doc

-- ����������/���������/�������� ������ � dbo.doc ����� �������������
declare @recid int = (select top(1) recid from kmsview where docid is null)
update kmsview set c_doc=@c_doc, s_doc=@s_doc, n_doc=@n_doc, d_doc=@d_doc, e_doc=@e_doc where recid=@recid

declare @nc_doc tinyint = (select c_doc from kmsview where recid = @recid)
declare @ns_doc varchar(9) = (select s_doc from kmsview where recid = @recid)
declare @nn_doc varchar(8) = (select n_doc from kmsview where recid = @recid)
declare @nd_doc date = (select d_doc from kmsview where recid = @recid)
declare @ne_doc date = (select e_doc from kmsview where recid = @recid)

if @c_doc = @nc_doc and @s_doc = @ns_doc and @n_doc = @nn_doc and @d_doc = @nd_doc and @e_doc = @ne_doc
	print '�������� �������� 45 01 591777 �������� �������!'

set @c_doc = 3
set @s_doc = 'II ��'
set @n_doc = '813134'
set @d_doc = '20050212'
set @e_doc = '20230212'

update kmsview set c_doc=@c_doc, s_doc=@s_doc, n_doc=@n_doc, d_doc=@d_doc, e_doc=@e_doc where recid=@recid

set @nc_doc = (select c_doc from kmsview where recid = @recid)
set @ns_doc = (select s_doc from kmsview where recid = @recid)
set @nn_doc = (select n_doc from kmsview where recid = @recid)
set @nd_doc = (select d_doc from kmsview where recid = @recid)
set @ne_doc = (select e_doc from kmsview where recid = @recid)

if @c_doc = @nc_doc and @s_doc = @ns_doc and @n_doc = @nn_doc and @d_doc = @nd_doc and @e_doc = @ne_doc
	print '�������� �������� 45 01 591777 ������� ������� �� II �� 813134!'

print '�������� ��������� ��������� II �� 813134...'
update kmsview set c_doc=null, s_doc=null, n_doc=null, d_doc=null, e_doc=null where recid=@recid
print '�������� �������� II �� 813134 �����...'
go 
-- ����������/���������/�������� ������ � dbo.doc ����� �������������
-- Unit test for dbo.doc the end

-- Unit test for dbo.odoc the beginning
declare @c_doc tinyint = 14
declare @s_doc varchar(9) = '45 01'
declare @n_doc varchar(8) = '591777'
declare @d_doc date = '20020129'
declare @e_doc date = '20190620'
declare @u_doc varchar(max) = '��� �-�� "������������"'
declare @x_doc tinyint = 1

declare @docrecid int = dbo.seekodoc(@s_doc, @n_doc)
if @docrecid>0  begin print '������ �������� 45 01 591777 ��� ���������� � dbo.odoc' return end 

-- ����������/���������/�������� ������ �������� � dbo.odoc
insert into dbo.odoc (c_doc,s_doc,n_doc,d_doc,e_doc,u_doc,x_doc) values (@c_doc,@s_doc,@n_doc,@d_doc,@e_doc,@u_doc,@x_doc)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekodoc(@s_doc, @n_doc) = @newrecid print '������ �������� 45 01 591777 ������� �������� � dbo.doc!'

update dbo.odoc set s_doc='45 02' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.odoc')
print @newrecid
if dbo.seekodoc('45 02', @n_doc) = @newrecid print '������ �������� 45 01 591777 -> 45 02 591777!'

update dbo.odoc set n_doc='591778' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.odoc')
print @newrecid
if dbo.seekodoc('45 02', '591778') = @newrecid print '������ �������� 45 02 591777 -> 45 02 591778!'

delete from dbo.odoc where recid=@newrecid
-- ����������/���������/�������� ������ �������� � dbo.doc

-- ����������/���������/�������� ������ � dbo.doc ����� �������������
declare @recid int = (select top(1) recid from kmsview where odocid is null)
update kmsview set oc_doc=@c_doc, os_doc=@s_doc, on_doc=@n_doc, od_doc=@d_doc, oe_doc=@e_doc where recid=@recid

declare @nc_doc tinyint = (select oc_doc from kmsview where recid = @recid)
declare @ns_doc varchar(9) = (select os_doc from kmsview where recid = @recid)
declare @nn_doc varchar(8) = (select on_doc from kmsview where recid = @recid)
declare @nd_doc date = (select od_doc from kmsview where recid = @recid)
declare @ne_doc date = (select oe_doc from kmsview where recid = @recid)

if @c_doc = @nc_doc and @s_doc = @ns_doc and @n_doc = @nn_doc and @d_doc = @nd_doc and @e_doc = @ne_doc
	print '������ �������� 45 01 591777 �������� �������!'

set @c_doc = 3
set @s_doc = 'II ��'
set @n_doc = '813134'
set @d_doc = '20050212'
set @e_doc = '20230212'

update kmsview set oc_doc=@c_doc, os_doc=@s_doc, on_doc=@n_doc, od_doc=@d_doc, oe_doc=@e_doc where recid=@recid

set @nc_doc = (select oc_doc from kmsview where recid = @recid)
set @ns_doc = (select os_doc from kmsview where recid = @recid)
set @nn_doc = (select on_doc from kmsview where recid = @recid)
set @nd_doc = (select od_doc from kmsview where recid = @recid)
set @ne_doc = (select oe_doc from kmsview where recid = @recid)

if @c_doc = @nc_doc and @s_doc = @ns_doc and @n_doc = @nn_doc and @d_doc = @nd_doc and @e_doc = @ne_doc
	print '������ �������� 45 01 591777 ������� ������� �� II �� 813134!'

print '�������� ������� ��������� II �� 813134...'
update kmsview set oc_doc=null, os_doc=null, on_doc=null, od_doc=null, oe_doc=null where recid=@recid
go
-- Unit test for dbo.odoc

-- Unit test for dbo.enp the beginning
declare @enp char(16)     = '1350110823000204'
declare @ogrn varchar(13) = '1027806865481'
declare @okato varchar(5)  = '87000'
declare @dp date = '20000101'
declare @dt date = '20010101'
declare @dr date = '20020202'

declare @enprecid int = dbo.seekenp(@enp)
if @enprecid>0  begin print '��� 1350110823000204 ��� ���������� � dbo.enp' return end 

-- ����������/���������/�������� ������ �������� � dbo.enp
insert into dbo.enp (enp,ogrn,okato,dp,dt,dr) values (@enp,@ogrn,@okato,@dp,@dt,@dr)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekenp(@enp) = @newrecid print '��� 1350110823000204 ������� �������� � dbo.enp!'

update dbo.enp set enp='1350110823000205' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp')
print @newrecid
if dbo.seekenp('1350110823000205') = @newrecid print '��� 1350110823000204 -> 1350110823000205!'

update dbo.enp set ogrn='1027806865482' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp')
print @newrecid
if dbo.seekenp('1350110823000205') = @newrecid print '��� ���� 1027806865481 -> 1027806865482!'

delete from dbo.enp where recid=@newrecid
-- ����������/���������/�������� ������ �������� � dbo.enp

go
-- Unit test for dbo.enp the end

-- Unit test for dbo.enp2 the beginning
declare @enp char(16)     = '1350110823000204'
declare @ogrn varchar(13) = '1027806865481'
declare @okato varchar(5)  = '87000'
declare @dp date = '20000101'
declare @dt date = '20010101'
declare @dr date = '20020202'

declare @enprecid int = dbo.seekenp2(@enp)
if @enprecid>0  begin print '���2 1350110823000204 ��� ���������� � dbo.enp' return end 

-- ����������/���������/�������� ������ �������� � dbo.enp
insert into dbo.enp2 (enp,ogrn,okato,dp,dt,dr) values (@enp,@ogrn,@okato,@dp,@dt,@dr)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekenp2(@enp) = @newrecid print '���2 1350110823000204 ������� �������� � dbo.enp!'

update dbo.enp2 set enp='1350110823000205' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp2')
print @newrecid
if dbo.seekenp2('1350110823000205') = @newrecid print '���2 1350110823000204 -> 1350110823000205!'

update dbo.enp2 set ogrn='1027806865482' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp2')
print @newrecid
if dbo.seekenp2('1350110823000205') = @newrecid print '���2 ���� 1027806865481 -> 1027806865482!'

delete from dbo.enp2 where recid=@newrecid
-- ����������/���������/�������� ������ �������� � dbo.enp2

go
-- Unit test for dbo.enp2 the end

-- Unit test for dbo.vs the beginning
declare @pv char(5) = 'P2101'
declare @vs char(9) = '010101001'
declare @dp date = '20000101'
declare @dt date = '20010101'
declare @dr date = '20020202'

declare @vsrecid int = dbo.seekvs(@vs)
if @vsrecid>0  begin print '�� P2101 010101001 ��� ���������� � dbo.vs' return end 

-- ����������/���������/�������� ������ �������� � dbo.vs
insert into dbo.vs (pv,vs,dp,dt,dr) values (@pv,@vs,@dp,@dt,@dr)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekvs(@vs) = @newrecid print '�� P2101 010101001 ������� ��������� � dbo.vs!'

update dbo.vs set vs='010101002' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.vs')
print @newrecid
if dbo.seekvs('010101002') = @newrecid print '�� P2101 010101001 -> 010101002!'

update dbo.vs set pv='P2102' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.vs')
print @newrecid
if dbo.seekvs('010101002') = @newrecid print '�� P2101 010101002 -> P2102 010101002!'

delete from dbo.vs where recid=@newrecid
-- ����������/���������/�������� ������ �������� � dbo.enp2
go
-- Unit test for dbo.vs the end

print 'The whole Unit test has been completed!'
-- ����������/���������/�������� ������ � dbo.doc ����� �������������
/*
print '������� ����...'
--�������� ��������� 45 01 591777 � ������, ���� ������� ����
--�������� ��������� II �� 813134 � ������, ���� ������� ����
declare @docrecid01 int = dbo.seekdoc('45 01', '591777')
declare @docrecid02 int = dbo.seekdoc('II ��', '813134')
declare @docrecid03 int = dbo.seekdoc('III ��', '813134')
declare @docrecid04 int = dbo.seekdoc('III ��', '813135')
--if @docrecid01<=0 and @docrecid02<=0 begin print '���������� �� ���������� � dbo.doc!' return end 
go 
disable TRIGGER dbo.uDelDoc ON dbo.doc
go 
update kms  set docid=null where docid in (select recid from doc where s_doc='45 01' and n_doc='591777')
update kms  set docid=null where docid in (select recid from doc where s_doc='II ��' and n_doc='813134')
update kms  set docid=null where docid in (select recid from doc where s_doc='III ��' and n_doc='813134')
update kms  set docid=null where docid in (select recid from doc where s_doc='III ��' and n_doc='813135')
go 
delete from doc where s_doc='45 01' and n_doc='591777'
delete from doc where s_doc='45 02' and n_doc='591777'
delete from doc where s_doc='45 02' and n_doc='591778'
delete from doc where s_doc='II ��' and n_doc='813134'
delete from doc where s_doc='III ��' and n_doc='813134'
delete from doc where s_doc='III ��' and n_doc='813135'
go
enable TRIGGER dbo.uDelDoc ON dbo.doc
go 
print '������� ���� ������� ���������'
*/
