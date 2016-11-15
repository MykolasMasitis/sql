create nonclustered index idx_doc on dbo.kms (s_doc, n_doc) where s_doc<>''

if exists(select * from sys.indexes where object_id=object_id('dbo.kms.idx_doc')) drop index dbo.kms.idx_doc

if exists ( select * from sys.indexes where object_id=object_id('kms') and name='idx_doc') drop index idx_doc on kms

select object_id('dbo.idx_doc')

select * from sys.objects where OBJECT_ID=1605580758

select * from sys.dm_db_index_physical_stats (db_id('kms'), OBJECT_ID('kms'), null, null, 'detailed')

alter index idx_doc on kms disable

alter index idx_doc on kms rebuild

alter index idx_doc on kms reorganize

insert into tempdb.NSI.nompmmyy select * from kms.nsi.nompmmyy
GO 

CREATE SCHEMA nsi
GO
DECLARE @table sysname;
SET @table = 'nsi.nompmmyy';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.nompmmyy;
CREATE TABLE nsi.nompmmyy (s_card char(6), n_card numeric(10), q char(2), enp char(16), vsn char(9), lpu_id numeric(6), date_in date, spos numeric(1));
GO

declare @curdate date
declare @ArcFileName char(
set @curdate = GETDATE()
print  @curdate

backup database kms to disk='d:\kms\arc\arckms001.bak'

begin transaction
update kms set c_doc = 74 where c_doc=14

rollback

select @@ERROR

 set implicit_transactions off	

 create unique index idx_nz on dbo.kms (nz) where nz is not null

 update dbo.kms set nz=null where nz=''

 select w, count(*) from kms group by w

 if exists (select * from sys.types where name='sex') drop type sex

 select * from sys.schemas

 select * from dbo.kms where adr_id=dbo.fseekadr77(ul=2350,'','','','')

 drop function dbo.fseekadr77
 go 

CREATE FUNCTION dbo.seekdoc (@s_doc varchar(9)='', @n_doc varchar(8)='') RETURNS int
BEGIN
 DECLARE @recid int;
 SELECT recid FROM dbo.doc WHERE s_doc=@s_doc AND n_doc=@n_doc;
 SET @recid=CASE WHEN @recid IS NULL THEN 0 ELSE @recid END ;
 RETURN @recid;
END
GO 

declare @id int
exec dbo.adddoc 14, '45 01', '001002','29-01-2002',null,null,null, @recid=@id output
select @id

select * from dbo.doc where recid=dbo.seekdoc('45 01', '001001')

select SCOPE_IDENTITY()

select @@TRANCOUNT

commit

update doc set s_doc='45 99' where recid=2

select * from doc where istop=true

select OBJECT_ID('dbo.doc')

select * from sys.databases

use msdb
select * from sys.objects

select * from doc where istop=0

select * from sys.messages

select * from nsi.scenario where ismsk>0 and isown>0

select * from nsi.scenario order by cnt desc 

set IMPLICIT_TRANSACTIONS on 

declare @id int;
exec dbo.adddoc @id output, 14,'12 12', 123456
select @id

set IMPLICIT_TRANSACTIONS off

DECLARE @IMPLICIT_TRANSACTIONS VARCHAR(3) = 'OFF';  
IF ( (2 & @@OPTIONS) = 2 ) SET @IMPLICIT_TRANSACTIONS = 'ON';  
SELECT @IMPLICIT_TRANSACTIONS AS IMPLICIT_TRANSACTIONS;

update doc set s_doc='45 05', n_doc='428670' where recid=3


declare @e_doc date = null
update odoc set e_doc=isnull(@e_doc, e_doc) where recid=10


update odoc set e_doc=null where recid=10

declare @c_doc tinyint=null, @s_doc varchar(9)=null, @n_doc varchar(8)=null, @d_doc date=null,
  @e_doc date=null, @x_doc tinyint=null, @u_doc varchar(max)=null
IF COALESCE(@s_doc, @n_doc, @d_doc, @e_doc, @u_doc)=NULL BEGIN PRINT 'No parameters!' RETURN END

if isnull(null)=true print '!'

create proc dbo.AddTwoNumbers
	@numberOne int,
	@numberTwo int = 2
as
	set nocount on
	select @numberOne+@numberTwo as Result
	return 0
go 

exec dbo.AddTwoNumbers @numberOne=1

use kms

exec dbo.editdoc

declare @id int
set @id = (select recid from doc where c_doc=14)
select @id

declare @id int
select @id=1

declare @id int
select @id = recid from doc where c_doc=14
select @id

select * from doc where recid=47586

create table ##tmptbl (var01 tinyint,var02 smallint,var03 int)

insert into ##tmptbl default values

select * from ##tmptbl

exec dbo.editdoc 47588,14,'45 01','591777'

select * from doc where recid=47587

DECLARE @recid int
SET @recid = dbo.seekdoc('45 01', '591777')
select @recid

select * from doc where s_doc='45 01' and n_doc='591777'

declare @sst varchar(3)=null
select isnull(nullif(@sst,''),'missing')

select nullif(1,1)

update doc set c_doc=3 where recid=2

ALTER TABLE dbo.doc add docid int

declare @recid int
exec adddoc default,default,default,default,default,default,default,@recid output
select @id


exec editdoc 1, 14, '45 01', '591778', '20020228'

drop index doc.pk_doc

alter table doc drop constraint pk_doc

update doc set docid=recid

create clustered index uniq on dbo.doc (docid, childid)

CREATE TABLE dbo.doc (recid int IDENTITY(1,1), docid int, 
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
c_doc tinyint REFERENCES nsi.viddocs (code), s_doc varchar(9) NOT NULL, n_doc varchar(8) NOT NULL, d_doc date NOT NULL, e_doc date,
x_doc tinyint NOT NULL DEFAULT 0, u_doc varchar(max))

alter table dbo.doc add CONSTRAINT PK_doc PRIMARY KEY (recid ASC)

enable trigger dbo.moddoc on doc

insert into dbo.doc values(default,default,default,default,default,default,default,default,'45 02','591777','2002-02-20',default,default,default)

update dbo.doc set c_doc=3 where recid=1

select * from kms where enp2id is not null

UPDATE permiss set n_perm='0927816' where recid=1

insert into permiss values (default,default,default,default,default,default,default,11,'45 01','591777','20021212','20121212')

select @@VERSION OPTION(IGNORE_NONCLUSTERED_COLUMNSTORE_INDEX)
go

if OBJECT_ID('nsi.tr_sex_mod','TR') is not null drop trigger nsi.tr_sex_mod
go
create trigger tr_sex_mod on nsi.sex 
instead of update
as
--declare @ocode tinyint = (select code from deleted)
--declare @ncode tinyint = (select code from inserted)

--print @ocode 
--print @ncode 

print @@rowcount

declare @RecsInInserted int = (select count(*) from inserted)
declare @RecsInDeleted int = (select count(*) from deleted)

print 'RecsInInserted='+cast(@RecsInInserted as char)
print 'RecsInDeleted='+cast(@RecsInDeleted  as char)

if update(code)
begin
 set nocount on 
 print 'Code updated!'
end 
if update(name)
begin
 set nocount on
 print 'Name updated!'
end 
go 

update nsi.sex set name='qwert'

declare @qwert int 
exec @qwert=dbo.moddoc null,null,null,null,null,null,null,null
select @qwert

declare @docid int = null
if @docid is null print '!' else print '?'

declare @tr_name varchar(100)='nsi.tr_sex_add'
if OBJECT_ID(@tr_name,'TR') is not null drop trigger nsi.tr_sex_add
go
create trigger nsi.tr_sex_add on nsi.sex 
after insert
as
begin
 set nocount on 
 rollback
 --raiserror('stop!',1,1)
end 

insert into nsi.sex values (3,'gender')



declare @rowcount int
select @rowcount = count(*) from (select * from nsi.SEX union select * from nsi.sex) temptable
select @rowcount

select * from nsi.sex intersect select * from nsi.sex

SELECT  a.*
    FROM    nsi.sex a
    INNER JOIN nsi.d_gzk b ON a.[code] = b.[code]
    WHERE   NOT EXISTS( SELECT a.* INTERSECT SELECT b.* )


select * from kmsview where fam='Иванов'

SELECT a.recid,a.pv,a.nz,a.status,a.p_doc,a.p_doc2,a.vs,a.vs_data,a.sn_card,a.enp,a.gz_data,a.q,a.dp,a.dt,a.fam,a.d_fam,
a.im,a.d_im,a.ot,a.d_ot,a.w,a.dr,a.true_dr,a.adr_id,a.adr50_id,a.jt,a.scn,a.kl,a.cont,
a.snils,a.gr,a.mr,a.d_reg,a.form,a.predst,a.spos,a.d_gzk,a.coment,a.ktg,a.s_card2,a.n_card2,a.ofioid,
a.odocid,a.lpuid,a.oper,a.operpv,a.osmoid,a.permid,a.enp2id,a.predstid,a.wrkid,a.dpok,a.blanc,a.photo,a.sign,
b.ul, b.dom, b.kor, b.str, b.kv, 
c.c_okato as c_okato, c.ra_name as ra_name, c.np_c as np_c, c.np_name as np_name, c.ul_c as ul_c, c.ul_name as ul_name, 
c.dom as dom2, c.kor as kor2, c.str as str2, c.kv as kv2
FROM dbo.kms a 
INNER JOIN dbo.adr77 b ON a.adr_id=b.recid INNER JOIN dbo.adr50 c ON a.adr50_id=c.recid 

select a.* from kms a

select a.*, b.* from kms a left outer join adr77 b on a.adr_id=b.recid

SELECT * FROM KMSVIEW

declare @addresult int, @outid int
exec @addresult = dbo.adddoc null, null, '591777','20020131', default, default, @recid=@outid out
print @addresult
print @outid


declare @s_doc varchar(9)
set @s_doc = ''
if @s_doc!=0 print '@s_doc is null'


declare @date date = ''
--set @date = '2002-12-12'
select @date
if @date is null print  '@date is null'

select * from kmsview where recid=1

update kmsview set oc_doc=14, os_doc='45 04', on_doc='123123', od_doc='20020228' where recid=1

declare @recid int
SELECT @recid=recid FROM dbo.odoc WHERE s_doc='45 03' AND n_doc='123123' AND IsTop=1;

select * from kms where odocid=318

update kms set odocid=null where odocid=318



IF OBJECT_ID('nsi.uAddSex','TR') IS NOT NULL DROP TRIGGER nsi.uAddSex
GO
CREATE TRIGGER nsi.uAddSex ON nsi.sex
INSTEAD OF insert
AS
BEGIN
	PRINT SCOPE_IDENTITY()
	print 'SCOPE_IDENTITY()'
END
GO

insert into nsi.sex values (5,'sex')

select suser_name()

select odocid from 

select * from kmsview where recid=1

update kmsview set oc_doc=14, os_doc='45 08', on_doc='123123', od_doc='20020228' where recid=1

select * from kms where docid is null order by recid asc

select * from dbo.odoc where recid = 310
select * from kms where recid=1

EXEC sp_dropmessage 50000, @lang='russian'
EXEC sp_dropmessage 60001, @lang='us_english'

select odocid from kms where odocid=329

select * from kmsview where docid is null

select * from kmsview where recid=2512
update kmsview set c_doc=14, s_doc='45 01', n_doc='592777', d_doc='20020228' where recid=2512

select * from doc where s_doc='45 01' and n_doc='591777'

disable trigger dbo.udeldoc on dbo.doc


select recid from kms where docid=47570

select * from kmsview where docid=47595

select * from doc where recid=47594

declare @recid int = dbo.seekdoc('45 01', '591777')
print @recid

select * from dbo.doc where recid=47596

select * from kmsview where recid=2767

select * from doc where recid=47597

exec('print 'Hello!'')

select * from dbo.enp where enp='1350110823000204'

select a.vs,b.vs from dbo.kms a inner join dbo.vs b on a.vsid=b.recid where a.vs<>b.vs

select a.scn,b.svn from dbo.pers a inner join dbo.moves b on a.movesid=b.recid

select * from nsi.scenario where isown=1 and ismsk=1

select a.fam,b.fam from dbo.pers a inner join dbo.fio b on a.fioid=b.recid

create index idx_pers_enp on dbo.pers(enp)

drop index pers.idx_pers_enp

select * from sys.objects

drop trigger udelkms2

go 
CREATE TRIGGER dbo.uDelKms ON dbo.kms2
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON
	print 'uDelkms2 trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50003, 16, 1) RETURN END /*Попытка удалить неактуальную запись!*/

	DECLARE @recid int= (SELECT recid FROM deleted)
	UPDATE dbo.kms2 SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid

END
GO

select * from pers as a2 where datepart(year, pers.dr)=datepart(year, a2.dr)

select * from kmsview 

select * from pers where permid is not null

select * from docs order by recid 

SELECT * FROM dbo.docs WHERE s_doc='45 10' AND n_doc='424461'

select * from vs where vs='031079227'

select * from fio where fam='Лайшевцева'

select * from pers where docid=4

select * from pers where oenpid is not null

select * from dbo.enp where id in (select id from dbo.kms group by id having count(*)>1) order by id

dbo.pseekenp '1353120819000396', '1027806865481', '89000'

select * from enp where recid=155

select count(*) from pers where okmsid is not null

select hashbytes('sha1', enp) from dbo.enp 

select * from kmsview

declare @out_id int
exec dbo.AddPerson '123-534-833 39', '19740620', 1, 1, null, null, null, null, 'P2104', '001002003', '20161103', '20161203', @out_id out
select @out_id

exec dbo.ModPerson 2, 2, null, null, null, null,null,null,null,null,'', '001002003','20160101', '20160201'

exec dbo.ModPerson 2, 3, '123-534-833 39', null, null, null,null,null,null,null,null,null,null,null

go
create trigger dbo.uAddVs on dbo.kms after update
as
begin
 print 'After update trigger fired!'
end
go 

update dbo.kms set n_card='P2104' where recid = 3

exec dbo.ModPerson 2, 2, null, null, null, null,null,null,null,null,null,'002003006',null,null

select * from dbo.pers where vsid is not null

enable trigger dbo.udelkms on dbo.kms

disable trigger dbo.udelkms on dbo.kms

select dbo.kmsconv('7700004049700674')

exec dbo.ModPerson 1

select iif(null>0,0,1)

update dbo.pers set vsid=COALESCE(null,vsid) where recid=1

select IDENT_CURRENT('dbo.pers')

select SCOPE_IDENTITY()

select @@identity

INSERT INTO dbo.kms (id, tip, s_card, n_card, ogrn, okato, dp, dt, dr) VALUES (1, 2, '770001', '1200684', coalesce(null, default), @kmsokato, @kms_dp, @kms_dt, @kms_dr)

declare @definition char(13) = ( SELECT object_definition(default_object_id) AS definition
FROM   sys.columns
WHERE  name      ='ogrn'
AND    object_id = object_id('dbo.kms'))
select @definition

declare @vsid int = null
declare @n_vs varchar(20)='001002003'
select (@vsid is null OR @vsid=0) AND (@n_vs is not null)



CREATE UNIQUE INDEX idx_snils_unik ON dbo.pers (snils) INCLUDE (recid) WHERE snils is not null and IsDeleted=0


insert into dbo.pers (status,snils,dr,w) values (1,null,'19740620',1)

DROP INDEX [idx_snils_unik] ON [dbo].[pers]


select * from dbo.kmsview
