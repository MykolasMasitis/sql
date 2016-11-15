-- Unit tests for testing kms database, ver.01

-- Turning all the triggers on
USE kms
GO
ENABLE TRIGGER dbo.uModFio ON dbo.fio
GO 
ENABLE TRIGGER dbo.uDelFio ON dbo.fio
GO
ENABLE TRIGGER dbo.uModOFio ON dbo.ofio
GO 
ENABLE TRIGGER dbo.uDelOFio ON dbo.ofio
GO
ENABLE TRIGGER dbo.uModAux ON dbo.auxinfo
GO
ENABLE TRIGGER dbo.uDelAux ON dbo.auxinfo
GO
ENABLE TRIGGER dbo.uModkms ON dbo.kms
GO
ENABLE TRIGGER dbo.uDelKms ON dbo.kms
GO
ENABLE TRIGGER dbo.uModDocs ON dbo.docs
GO
ENABLE TRIGGER dbo.uDelDocs ON dbo.docs
GO
ENABLE TRIGGER dbo.uModEnp ON dbo.enp
GO
ENABLE TRIGGER dbo.uDelEnp ON dbo.enp
GO
ENABLE TRIGGER dbo.uModAdr77 ON dbo.adr77
GO
ENABLE TRIGGER dbo.uDelAdr77 ON dbo.adr77
GO
ENABLE TRIGGER dbo.uModAdr50 ON dbo.adr50
GO
ENABLE TRIGGER dbo.uDelAdr50 ON dbo.adr50
GO
-- Turning all the triggers on


set nocount on
set noexec off
use kms
go 
-- Debugging AddPerson proedure
declare @recid int
exec dbo.AddPerson 1, '001-438-525-01', '19740620', default, 1,
	'104', '100', 0, 'Контактная информация', 'RUS', 'Москва', 'Комментарий','X', 9999,
	'Рябов',' ','Михаил',' ','Станиславович',' ',
	'Масевич','Миколас','Казимирас',
	null,null,null,null,
	'P2104','001002003','19991201','19991231',
	'770000','4049700674',default,default,'20000101','20991231','20000115',
	'46-12','003004',default,default,'19950101','20991231','19950115',
	'775352082900219',null,default,default,'20100101',null,null,
	'775252082900219',null,default,default,'20100202',null,
	14,'4501','591777','20020129','20190620','ОВД р-на Текстильщики',default,
	23,'AA','001002','20110101','20140101',
	9,'','506348520','20160624','20290624','Госдударственный Департамент США',default,
	745,'20','2',null,'40','19900911',
	'46000','Сергиево-Посадский район',1,'Хотьково',7,'Первомайская','15',default,default,default,'19740622',
	@out_id=@recid
--set @recid = @@IDENTITY
-- Debugging AddPerson proedure
/*
--Testing dbo.pers ЕНП
declare @out_id int, @recid int
insert into dbo.pers (status,snils,dr,w) values (1,'001-438-525-01','19740620',1)
set @recid = @@IDENTITY

exec dbo.ModPerson @recid, @fam='Рябов', @im='Михаил'
exec dbo.ModPerson @recid, @ot='Вячеславович'
exec dbo.ModPerson @recid, @ot='Ростиславович'
exec dbo.ModPerson @recid, @ot='Станиславович'

exec dbo.ModPerson @recid, @ofam='Масевич'
exec dbo.ModPerson @recid, @oim='Миндаугас'
exec dbo.ModPerson @recid, @oot='Казимирас'

exec dbo.ModPerson @recid, @s_vs='P2104', @n_vs='001002003'
exec dbo.ModPerson @recid, @vs_dp= '20000101'
exec dbo.ModPerson @recid, @vs_dt= '20000201'

exec dbo.ModPerson @recid, @s_kms='770000', @n_kms='4049700674'
exec dbo.ModPerson @recid, @kms_dp= '20010101'
exec dbo.ModPerson @recid, @kms_dt= '20991231'
exec dbo.ModPerson @recid, @kms_dr= '20010102'

exec dbo.ModPerson @recid, @s_okms='46-12', @n_okms='116287'
exec dbo.ModPerson @recid, @okms_dp= '19950101'
exec dbo.ModPerson @recid, @okms_dt= '19980101'
exec dbo.ModPerson @recid, @okms_dr= '19950115'

exec dbo.ModPerson @recid, @c_doc=14, @s_doc='45 01', @n_doc='591777', @d_doc= '20020129'
exec dbo.ModPerson @recid, @e_doc= '20190620'
exec dbo.ModPerson @recid, @u_doc= 'ОВД р-на Текстильщики'

exec dbo.ModPerson @recid, @c_perm=23, @s_perm='AA', @n_perm='001002', @d_perm= '20150101'
exec dbo.ModPerson @recid, @e_perm= '20180101'

exec dbo.ModPerson @recid, @oc_doc=9, @os_doc='', @on_doc='506348520', @od_doc= '20160624'
exec dbo.ModPerson @recid, @oe_doc= '20290624'
exec dbo.ModPerson @recid, @ou_doc= 'Госдударственный Департамент США'

exec dbo.ModPerson @recid, @enp='7753520829002196'
exec dbo.ModPerson @recid, @enp_dp='20160615'
exec dbo.ModPerson @recid, @enp_dt='20991231'
exec dbo.ModPerson @recid, @enp_dr='20160620'

exec dbo.ModPerson @recid, @enp2='7754520829002196'
exec dbo.ModPerson @recid, @enp2_dp='20140615'
exec dbo.ModPerson @recid, @enp2_dt='20991231'

exec dbo.ModPerson @recid, @ul=745 /*Артюхиной*/, @dom='20', @kv='40'
exec dbo.ModPerson @recid, @kor='2'
exec dbo.ModPerson @recid, @ul=2928 /*Васильцовский Стан*/, @dom='3/1', @kv='224'

exec dbo.ModPerson @recid, @c_okato='46000'
exec dbo.ModPerson @recid, @ra_name='Сергиево-Посадский район'
exec dbo.ModPerson @recid, @np_c=1, @np_name='Хотьково'
exec dbo.ModPerson @recid, @ul_c=17, @ul_name='Первомайская'
exec dbo.ModPerson @recid, @dom50='15'

exec dbo.ModPerson @recid, @pv='104'
exec dbo.ModPerson @recid, @nz='001'
exec dbo.ModPerson @recid, @kl=77
exec dbo.ModPerson @recid, @cont='Мобильный телефон +79637820825'
exec dbo.ModPerson @recid, @gr='RUS'
exec dbo.ModPerson @recid, @mr='Союз Советских Социалистических Республик'
exec dbo.ModPerson @recid, @comment='Это просто комментарий'
--Testing dbo.pers
*/
/*
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
*/
print 'The whole Unit tests have been completed!'
