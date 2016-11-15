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
declare @u_doc varchar(max) = 'ОВД р-на "ТЕКСТИЛЬЩИКИ"'
declare @x_doc tinyint = 1

declare @docrecid int = dbo.seekdoc(@s_doc, @n_doc)
if @docrecid>0  begin print 'Документ 45 01 591777 уже существует в dbo.doc' return end 

-- Добавление/изменение/удаления записи напрямую в dbo.doc
insert into dbo.doc (c_doc,s_doc,n_doc,d_doc,e_doc,u_doc,x_doc) values (@c_doc,@s_doc,@n_doc,@d_doc,@e_doc,@u_doc,@x_doc)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekdoc(@s_doc, @n_doc) = @newrecid print 'Документ 45 01 591777 успешно добавлен в dbo.doc!'

update dbo.doc set s_doc='45 02' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.doc')
print @newrecid
if dbo.seekdoc('45 02', @n_doc) = @newrecid print 'Документ 45 01 591777 -> 45 02 591777!'

update dbo.doc set n_doc='591778' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.doc')
print @newrecid
if dbo.seekdoc('45 02', '591778') = @newrecid print 'Документ 45 02 591777 -> 45 02 591778!'

delete from dbo.doc where recid=@newrecid
-- Добавление/изменение/удаления записи напрямую в dbo.doc

-- Добавление/изменение/удаления записи в dbo.doc через представление
declare @recid int = (select top(1) recid from kmsview where docid is null)
update kmsview set c_doc=@c_doc, s_doc=@s_doc, n_doc=@n_doc, d_doc=@d_doc, e_doc=@e_doc where recid=@recid

declare @nc_doc tinyint = (select c_doc from kmsview where recid = @recid)
declare @ns_doc varchar(9) = (select s_doc from kmsview where recid = @recid)
declare @nn_doc varchar(8) = (select n_doc from kmsview where recid = @recid)
declare @nd_doc date = (select d_doc from kmsview where recid = @recid)
declare @ne_doc date = (select e_doc from kmsview where recid = @recid)

if @c_doc = @nc_doc and @s_doc = @ns_doc and @n_doc = @nn_doc and @d_doc = @nd_doc and @e_doc = @ne_doc
	print 'Основной документ 45 01 591777 добавлен успешно!'

set @c_doc = 3
set @s_doc = 'II МЮ'
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
	print 'Основной документ 45 01 591777 успешно заменен на II МЮ 813134!'

print 'Удаление основного документа II МЮ 813134...'
update kmsview set c_doc=null, s_doc=null, n_doc=null, d_doc=null, e_doc=null where recid=@recid
print 'Основной документ II МЮ 813134 удалён...'
go 
-- Добавление/изменение/удаления записи в dbo.doc через представление
-- Unit test for dbo.doc the end

-- Unit test for dbo.odoc the beginning
declare @c_doc tinyint = 14
declare @s_doc varchar(9) = '45 01'
declare @n_doc varchar(8) = '591777'
declare @d_doc date = '20020129'
declare @e_doc date = '20190620'
declare @u_doc varchar(max) = 'ОВД р-на "ТЕКСТИЛЬЩИКИ"'
declare @x_doc tinyint = 1

declare @docrecid int = dbo.seekodoc(@s_doc, @n_doc)
if @docrecid>0  begin print 'Старый документ 45 01 591777 уже существует в dbo.odoc' return end 

-- Добавление/изменение/удаления записи напрямую в dbo.odoc
insert into dbo.odoc (c_doc,s_doc,n_doc,d_doc,e_doc,u_doc,x_doc) values (@c_doc,@s_doc,@n_doc,@d_doc,@e_doc,@u_doc,@x_doc)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekodoc(@s_doc, @n_doc) = @newrecid print 'Старый документ 45 01 591777 успешно добавлен в dbo.doc!'

update dbo.odoc set s_doc='45 02' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.odoc')
print @newrecid
if dbo.seekodoc('45 02', @n_doc) = @newrecid print 'Старый документ 45 01 591777 -> 45 02 591777!'

update dbo.odoc set n_doc='591778' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.odoc')
print @newrecid
if dbo.seekodoc('45 02', '591778') = @newrecid print 'Старый документ 45 02 591777 -> 45 02 591778!'

delete from dbo.odoc where recid=@newrecid
-- Добавление/изменение/удаления записи напрямую в dbo.doc

-- Добавление/изменение/удаления записи в dbo.doc через представление
declare @recid int = (select top(1) recid from kmsview where odocid is null)
update kmsview set oc_doc=@c_doc, os_doc=@s_doc, on_doc=@n_doc, od_doc=@d_doc, oe_doc=@e_doc where recid=@recid

declare @nc_doc tinyint = (select oc_doc from kmsview where recid = @recid)
declare @ns_doc varchar(9) = (select os_doc from kmsview where recid = @recid)
declare @nn_doc varchar(8) = (select on_doc from kmsview where recid = @recid)
declare @nd_doc date = (select od_doc from kmsview where recid = @recid)
declare @ne_doc date = (select oe_doc from kmsview where recid = @recid)

if @c_doc = @nc_doc and @s_doc = @ns_doc and @n_doc = @nn_doc and @d_doc = @nd_doc and @e_doc = @ne_doc
	print 'Старый документ 45 01 591777 добавлен успешно!'

set @c_doc = 3
set @s_doc = 'II МЮ'
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
	print 'Старый документ 45 01 591777 успешно заменен на II МЮ 813134!'

print 'Удаление старого документа II МЮ 813134...'
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
if @enprecid>0  begin print 'ЕНП 1350110823000204 уже существует в dbo.enp' return end 

-- Добавление/изменение/удаления записи напрямую в dbo.enp
insert into dbo.enp (enp,ogrn,okato,dp,dt,dr) values (@enp,@ogrn,@okato,@dp,@dt,@dr)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekenp(@enp) = @newrecid print 'ЕНП 1350110823000204 успешно добавлен в dbo.enp!'

update dbo.enp set enp='1350110823000205' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp')
print @newrecid
if dbo.seekenp('1350110823000205') = @newrecid print 'ЕНП 1350110823000204 -> 1350110823000205!'

update dbo.enp set ogrn='1027806865482' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp')
print @newrecid
if dbo.seekenp('1350110823000205') = @newrecid print 'ЕНП ОГРН 1027806865481 -> 1027806865482!'

delete from dbo.enp where recid=@newrecid
-- Добавление/изменение/удаления записи напрямую в dbo.enp

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
if @enprecid>0  begin print 'ЕНП2 1350110823000204 уже существует в dbo.enp' return end 

-- Добавление/изменение/удаления записи напрямую в dbo.enp
insert into dbo.enp2 (enp,ogrn,okato,dp,dt,dr) values (@enp,@ogrn,@okato,@dp,@dt,@dr)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekenp2(@enp) = @newrecid print 'ЕНП2 1350110823000204 успешно добавлен в dbo.enp!'

update dbo.enp2 set enp='1350110823000205' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp2')
print @newrecid
if dbo.seekenp2('1350110823000205') = @newrecid print 'ЕНП2 1350110823000204 -> 1350110823000205!'

update dbo.enp2 set ogrn='1027806865482' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp2')
print @newrecid
if dbo.seekenp2('1350110823000205') = @newrecid print 'ЕНП2 ОГРН 1027806865481 -> 1027806865482!'

delete from dbo.enp2 where recid=@newrecid
-- Добавление/изменение/удаления записи напрямую в dbo.enp2

go
-- Unit test for dbo.enp2 the end

-- Unit test for dbo.vs the beginning
declare @pv char(5) = 'P2101'
declare @vs char(9) = '010101001'
declare @dp date = '20000101'
declare @dt date = '20010101'
declare @dr date = '20020202'

declare @vsrecid int = dbo.seekvs(@vs)
if @vsrecid>0  begin print 'ВС P2101 010101001 уже существует в dbo.vs' return end 

-- Добавление/изменение/удаления записи напрямую в dbo.vs
insert into dbo.vs (pv,vs,dp,dt,dr) values (@pv,@vs,@dp,@dt,@dr)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekvs(@vs) = @newrecid print 'ВС P2101 010101001 успешно добавлена в dbo.vs!'

update dbo.vs set vs='010101002' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.vs')
print @newrecid
if dbo.seekvs('010101002') = @newrecid print 'ВС P2101 010101001 -> 010101002!'

update dbo.vs set pv='P2102' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.vs')
print @newrecid
if dbo.seekvs('010101002') = @newrecid print 'ВС P2101 010101002 -> P2102 010101002!'

delete from dbo.vs where recid=@newrecid
-- Добавление/изменение/удаления записи напрямую в dbo.enp2
go
-- Unit test for dbo.vs the end

print 'The whole Unit test has been completed!'
-- Добавление/изменение/удаления записи в dbo.doc через представление
/*
print 'Очистка базы...'
--Удаление документа 45 01 591777 в случае, если таковой есть
--Удаление документа II МЮ 813134 в случае, если таковой есть
declare @docrecid01 int = dbo.seekdoc('45 01', '591777')
declare @docrecid02 int = dbo.seekdoc('II МЮ', '813134')
declare @docrecid03 int = dbo.seekdoc('III МЮ', '813134')
declare @docrecid04 int = dbo.seekdoc('III МЮ', '813135')
--if @docrecid01<=0 and @docrecid02<=0 begin print 'Документов не существует в dbo.doc!' return end 
go 
disable TRIGGER dbo.uDelDoc ON dbo.doc
go 
update kms  set docid=null where docid in (select recid from doc where s_doc='45 01' and n_doc='591777')
update kms  set docid=null where docid in (select recid from doc where s_doc='II МЮ' and n_doc='813134')
update kms  set docid=null where docid in (select recid from doc where s_doc='III МЮ' and n_doc='813134')
update kms  set docid=null where docid in (select recid from doc where s_doc='III МЮ' and n_doc='813135')
go 
delete from doc where s_doc='45 01' and n_doc='591777'
delete from doc where s_doc='45 02' and n_doc='591777'
delete from doc where s_doc='45 02' and n_doc='591778'
delete from doc where s_doc='II МЮ' and n_doc='813134'
delete from doc where s_doc='III МЮ' and n_doc='813134'
delete from doc where s_doc='III МЮ' and n_doc='813135'
go
enable TRIGGER dbo.uDelDoc ON dbo.doc
go 
print 'Очистка базы успешно закончена'
*/
