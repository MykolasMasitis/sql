-- Unit tests for testing kms database, ver.01

set nocount on
set noexec off
use kms
go 

-- Testing dbo.vs
declare @pv char(5) = 'P2101'
declare @vs char(9) = '010101001'
declare @dp date = '20000101'
declare @dt date = '20010101'

declare @vsrecid int = dbo.seekvs(@vs)
if @vsrecid>0  begin print 'ВС P2101 010101001 уже существует в dbo.vs' return end 

-- Добавление/изменение/удаления записи напрямую в dbo.vs
insert into dbo.vs (pv,vs,dp,dt) values (@pv,@vs,@dp,@dt)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekvs(@vs) = @newrecid print 'ВС P2101 010101001 успешно добавлена в dbo.vs!'

update dbo.vs set vs='010101002' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.vs')
print @newrecid
if dbo.seekvs('010101002') = @newrecid print 'ВС P2101 010101001 -> 010101002!'
print @newrecid
update dbo.vs set pv='P2102' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.vs')
print @newrecid
if dbo.seekvs('010101002') = @newrecid print 'ВС P2101 010101002 -> P2102 010101002!'

delete from dbo.vs where recid=@newrecid
-- Добавление/изменение/удаления записи напрямую в dbo.enp2
go
-- Testing dbo.vs

-- Testing dbo.kms
declare @s_card char(12) = '770000'
declare @n_card char(32) = '1200684'
declare @dp date         = '20000101'

declare @kmsrecid int = dbo.seekkms(@s_card, @n_card)
if @kmsrecid>0  begin print 'КМС 770000 1200684 уже существует в dbo.kms' return end 

-- Добавление/изменение/удаления записи напрямую в dbo.kms
insert into dbo.kms(s_card,n_card,dp) values (@s_card,@n_card,@dp)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekkms(@s_card, @n_card) = @newrecid print 'КМС 770000 1200684 успешно добавлена в dbo.kms!'

update dbo.kms set s_card='770001' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.kms')
print @newrecid
if dbo.seekkms('770001','1200684') = @newrecid print 'КМС 770000 1200684 -> 770001 1200684!'
print @newrecid
update dbo.kms set n_card='001200684' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.kms')
print @newrecid
if dbo.seekkms('770000','001200684') = @newrecid print 'КМС 770001 1200684 -> 770001 001200684!'

delete from dbo.kms where recid=@newrecid
-- Добавление/изменение/удаления записи напрямую в dbo.kms
go
-- Testing dbo.kms

-- Testing dbo.enp
declare @enp char(16) = '7748740872000586'
declare @ogrn varchar(13) = '1025004642519'
declare @okato char(5) = '45000'
declare @dp date = '20000101'
declare @dt date = '20100101'
declare @dr date = '20000131'

declare @enprecid int = dbo.seekenp(@enp)
if @enprecid>0  begin print 'ЕНП 7748740872000586 уже существует в dbo.enp' return end 

-- Добавление/изменение/удаления записи напрямую в dbo.enp
insert into dbo.enp(enp,ogrn,okato,dp,dt,dr) values (@enp,default,default,@dp,@dt,@dr)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekenp(@enp) = @newrecid print 'ЕНП 7748740872000586 успешно добавлена в dbo.enp!'

update dbo.enp set enp='7848740872000586' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp')
print @newrecid
if dbo.seekenp('7848740872000586') = @newrecid print 'ЕНП 7748740872000586 -> 7848740872000586!'
print @newrecid
update dbo.enp set dr='20110620' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp')
print @newrecid
if dbo.seekenp('7848740872000586') = @newrecid print 'ЕНП 7848740872000586: DR 20000131->20110620!'

delete from dbo.enp where recid=@newrecid
-- Добавление/изменение/удаления записи напрямую в dbo.enp
go
-- Testing dbo.enp

-- Testing dbo.oldkms
declare @s_card char(12)  = '46-27'
declare @n_card char(32)  = '752440'
declare @ogrn varchar(13) = '1027739099772'
declare @okato char(5)    = '46000'
declare @dp date          = '20000101'
declare @dt date          = '20010101'
declare @dr date          = '20020101'

declare @kmsrecid int = dbo.seekoldkms(@s_card, @n_card)
if @kmsrecid>0  begin print 'КМС2 46-27 752440 уже существует в dbo.oldkms' return end 

-- Добавление/изменение/удаления записи напрямую в dbo.kms
insert into dbo.oldkms(s_card, n_card, ogrn, okato, dp, dt, dr) values (@s_card, @n_card, @ogrn, @okato, @dp, @dt, @dr)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekoldkms(@s_card, @n_card) = @newrecid print 'КМС2 46-27 752440 успешно добавлена в dbo.oldkms!'

update dbo.oldkms set s_card='46-28' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.oldkms')
print @newrecid
if dbo.seekoldkms('46-28','752440') = @newrecid print 'КМС2 46-27 752440 -> КМС2 46-28 752440!'
print @newrecid
update dbo.oldkms set n_card='752441' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.oldkms')
print @newrecid
if dbo.seekoldkms('46-28','752441') = @newrecid print 'КМС2 46-27 752440 -> КМС2 46-28 752441!'

delete from dbo.oldkms where recid=@newrecid
-- Добавление/изменение/удаления записи напрямую в dbo.oldkms
go
-- Testing dbo.oldkms

-- Testing dbo.oldenp
declare @enp char(16) = '7748740872000586'
declare @ogrn varchar(13) = '1025004642519'
declare @okato char(5) = '45000'
declare @dp date = '20000101'
declare @dt date = '20100101'
declare @dr date = '20000131'

declare @enprecid int = dbo.seekoldenp(@enp)
if @enprecid>0  begin print 'ЕНП 7748740872000586 уже существует в dbo.oldenp' return end 

-- Добавление/изменение/удаления записи напрямую в dbo.oldenp
insert into dbo.oldenp(enp,ogrn,okato,dp,dt,dr) values (@enp,@ogrn,@okato,@dp,@dt,@dr)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekoldenp(@enp) = @newrecid print 'ЕНП 7748740872000586 успешно добавлена в dbo.oldenp!'

update dbo.oldenp set enp='7848740872000586' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.oldenp')
print @newrecid
if dbo.seekoldenp('7848740872000586') = @newrecid print 'ЕНП 7748740872000586 -> 7848740872000586!'
print @newrecid
update dbo.oldenp set dr='20110620' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.oldenp')
print @newrecid
if dbo.seekenp('7848740872000586') = @newrecid print 'ЕНП 7848740872000586: DR 20000131->20110620!'

delete from dbo.oldenp where recid=@newrecid
-- Добавление/изменение/удаления записи напрямую в dbo.enp
go
-- Testing dbo.oldenp

-- Testing dbo.enp
declare @enp char(16) = '7748740872000586'
declare @ogrn varchar(13) = '1025004642519'
declare @okato char(5) = '45000'
declare @dp date = '20000101'
declare @dt date = '20100101'
declare @dr date = '20000131'

declare @enprecid int = dbo.seekenp2(@enp)
if @enprecid>0  begin print 'ЕНП2 7748740872000586 уже существует в dbo.enp2' return end 

-- Добавление/изменение/удаления записи напрямую в dbo.enp2
insert into dbo.enp2 (enp,ogrn,okato,dp,dt,dr) values (@enp,default,default,@dp,@dt,@dr)
declare @newrecid int = SCOPE_IDENTITY()
print @newrecid
if dbo.seekenp2(@enp) = @newrecid print 'ЕНП2 7748740872000586 успешно добавлена в dbo.enp!'

update dbo.enp2 set enp='7848740872000586' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp2')
print @newrecid
if dbo.seekenp2('7848740872000586') = @newrecid print 'ЕНП2 7748740872000586 -> 7848740872000586!'
print @newrecid
update dbo.enp2 set dr='20110620' where recid=@newrecid
set @newrecid = IDENT_CURRENT('dbo.enp2')
print @newrecid
if dbo.seekenp2('7848740872000586') = @newrecid print 'ЕНП2 7848740872000586: DR 20000131->20110620!'

delete from dbo.enp2 where recid=@newrecid
-- Добавление/изменение/удаления записи напрямую в dbo.enp
go
-- Testing dbo.enp

-- Testing dbo.doc
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
-- Testing dbo.doc

print 'The whole Unit tests have been completed!'
