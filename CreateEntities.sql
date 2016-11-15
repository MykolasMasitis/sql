-- The fourth step of creating Database KMS
-- The next (5th tep) is performing out of VFP module that populates the created here tables
--
SET NOCOUNT ON
GO
USE kms
GO

-- Creating dbo.adr50
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.adr50')) DROP TABLE dbo.adr50
CREATE TABLE dbo.adr50 (recid int IDENTITY(1,1), id int, 
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
c_okato varchar(5), ra_name varchar(60), np_c tinyint NULL REFERENCES nsi.np_c(code),
np_name varchar(60), ul_c tinyint NULL REFERENCES nsi.ul_c(code), ul_name varchar(60), dom varchar(7), kor varchar(5),
[str] varchar(5), kv varchar(5), d_reg date)
GO
CREATE CLUSTERED INDEX idx_adr50_uniq ON dbo.adr50 (id, parentid)
GO 
ALTER TABLE dbo.adr50 ADD CONSTRAINT PK_adr50 PRIMARY KEY (recid ASC)
GO
CREATE UNIQUE INDEX idx_adr50_unik ON dbo.adr50 (c_okato, ra_name, np_name, ul_name, dom, kor, [str], kv) INCLUDE (recid) WHERE IsTop=1 AND IsDeleted=0
GO

IF OBJECT_ID('seekadr50','P') IS NOT NULL DROP PROCEDURE seekadr50
GO
CREATE PROCEDURE dbo.seekadr50(@c_okato varchar(5)='', @ra_name varchar(60)='', @np_name varchar(60)='',
	 @ul_name varchar(60)='',@dom varchar(7)='', @kor varchar(5)='', @str varchar(5)='', @kv varchar(5)='',
	 @recid int=NULL out)
AS
BEGIN
SET NOCOUNT ON;
SELECT recid FROM adr50 WHERE c_okato=@c_okato AND ra_name=@ra_name AND np_name=@np_name AND ul_name=@ul_name
	AND dom=@dom AND kor=@kor AND [str]=@str AND kv=@kv;
END
GO

IF OBJECT_ID('uModAdr50','TR') IS NOT NULL DROP TRIGGER uModAdr50
GO
CREATE TRIGGER dbo.uModAdr50 ON dbo.adr50
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModAdr50 trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50001, 16, 1) RETURN END

	DECLARE @id int, @parentid int, @version_start datetime, @version_stop datetime ,@isdeleted bit

	DECLARE @c_okato varchar(5), @ra_name varchar(60), @np_c tinyint, @np_name varchar(60), @ul_c tinyint, @ul_name varchar(60),
		@dom50 varchar(7), @kor50 varchar(5), @str50 varchar(5), @kv50 varchar(5), @d_reg50 date
	DECLARE @oc_okato varchar(5), @ora_name varchar(60), @onp_c tinyint, @onp_name varchar(60), @oul_c tinyint, @oul_name varchar(60),
		@odom50 varchar(7), @okor50 varchar(5), @ostr50 varchar(5), @okv50 varchar(5), @od_reg50 date

	SET @oc_okato = (select c_okato from deleted)
	SET @ora_name = (select ra_name from deleted)
	SET @onp_c    = (select np_c    from deleted)
	SET @onp_name = (select np_name from deleted)
	SET @oul_c    = (select ul_c    from deleted)
	SET @oul_name = (select ul_name from deleted)
	SET @odom50   = (select dom     from deleted)
	SET @okor50   = (select kor     from deleted)
	SET @ostr50   = (select str     from deleted)
	SET @okv50    = (select kv      from deleted)
	SET @od_reg50 = (select d_reg   from deleted)

	DECLARE newcur CURSOR FOR SELECT
		id, recid AS parentid, sysdatetime() as version_start, null as version_stop, 1 as istop, 0 as isdeleted,
		c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, [str], kv, d_reg FROM inserted	

	OPEN newcur

	FETCH NEXT FROM newcur INTO @id, @parentid, @version_start, @version_stop ,@istop, @isdeleted,
		@c_okato, @ra_name, @np_c, @np_name, @ul_c, @ul_name, @dom50, @kor50, @str50, @kv50, @d_reg50

	CLOSE newcur
	DEALLOCATE newcur

	IF coalesce(@c_okato,'')!=coalesce(@oc_okato,'') or coalesce(@ra_name,'')!=coalesce(@ora_name,'') or 
	   @np_c!=@onp_c or coalesce(@np_name,'')!=coalesce(@onp_name,'') or 
	   @ul_c!=@oul_c or coalesce(@ul_name,'')!=coalesce(@oul_name,'') or 
	   coalesce(@dom50,'')!=coalesce(@odom50,'') or coalesce(@kor50,'')!=coalesce(@okor50,'') or 
	   coalesce(@str50,'')!=coalesce(@ostr50,'') or coalesce(@kv50,'')!=coalesce(@okv50,'') or (@d_reg50=@od_reg50)
	BEGIN 

	 DECLARE @recid int = (select recid from deleted)
	 UPDATE dbo.adr50 SET istop=0, version_stop=sysdatetime() WHERE adr50.recid=@recid

	 INSERT INTO dbo.adr50
	 (id, parentid, version_start, version_stop, istop, isdeleted, c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, [str], kv, d_reg) VALUES
	  (@id, @parentid, @version_start, @version_stop, @istop, @isdeleted,
	   coalesce(@c_okato, @oc_okato), coalesce(@ra_name, @ora_name),coalesce(@np_c, @onp_c),coalesce(@np_name, @onp_name),coalesce(@ul_c, @oul_c),coalesce(@ul_name, @oul_name),
	   coalesce(@dom50, @odom50), coalesce(@kor50, @okor50), coalesce(@str50, @ostr50), coalesce(@kv50, @okv50), coalesce(@d_reg50, @od_reg50))

	 UPDATE dbo.adr50 SET childid=SCOPE_IDENTITY() WHERE adr50.recid=@recid
	END 
END
GO
DISABLE TRIGGER dbo.uModAdr50 ON dbo.adr50
GO

IF OBJECT_ID('uDelAdr50','TR') IS NOT NULL DROP TRIGGER uDelAdr50
GO
CREATE TRIGGER dbo.uDelAdr50 ON dbo.adr50
INSTEAD OF DELETE
AS
BEGIN
	print 'uDelAdr50 trigger fired!'
	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.adr50 SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid

    UPDATE dbo.pers SET adr50_id=NULL WHERE adr50_id=@recid
END
GO
DISABLE TRIGGER dbo.uDelAdr50 ON dbo.adr50
GO
-- Creating dbo.adr50

-- Creating dbo.adr77
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.adr77')) DROP TABLE dbo.adr77
CREATE TABLE dbo.adr77 (recid int IDENTITY(1,1), id int, 
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
ul int NOT NULL, dom varchar(7) NOT NULL, kor varchar(5), [str] varchar(5), kv varchar(5) NOT NULL, d_reg date)
GO
CREATE CLUSTERED INDEX idx_adr77_uniq ON dbo.adr77 (id, parentid)
GO 
ALTER TABLE dbo.adr77 ADD CONSTRAINT PK_adr77 PRIMARY KEY (recid ASC)
GO
CREATE UNIQUE INDEX idx_adr77_unik ON dbo.adr77 (ul,dom,kor,[str],kv) INCLUDE (recid) WHERE IsTop=1 AND IsDeleted=0
GO

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekadr77')) DROP FUNCTION dbo.seekadr77
GO
CREATE FUNCTION dbo.seekadr77 (@ul int, @dom varchar(7), @kor varchar(5), @str varchar(5), @kv varchar(5)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.adr77 WHERE ul=@ul AND dom=@dom	 AND kor=@kor AND str=@str AND kv=@kv AND IsTop=1
 SET @recid=CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
 RETURN @recid
END
GO 

--- The proc is ONLY created for VFP Module kms2sql and could be deleted immediately after conversion VFP -> MS SQL
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.pseekadr77')) DROP PROCEDURE dbo.pseekadr77
GO
CREATE PROCEDURE dbo.pseekadr77(@ul int, @dom varchar(7), @kor varchar(5), @str varchar(5), @kv varchar(5), @recid int=NULL out)
AS
BEGIN
SET NOCOUNT ON;
SELECT recid FROM dbo.adr77 WHERE ul=@ul AND dom=@dom AND kor=@kor AND str=@str AND kv=@kv
END
GO
--- The proc is ONLY created for VFP Module kms2sql and could be deleted immediately after conversion VFP -> MS SQL

IF OBJECT_ID('uModAdr77','TR') IS NOT NULL DROP TRIGGER uModAdr77
GO
CREATE TRIGGER dbo.uModAdr77 ON dbo.adr77
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModAdr77 trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50001, 16, 1) RETURN END

	DECLARE @id int, @parentid int, @version_start datetime, @version_stop datetime ,@isdeleted bit

	DECLARE @ul int, @dom varchar(7), @kor varchar(5), @str varchar(5), @kv varchar(5), @d_reg date
	DECLARE @oul int, @odom varchar(7), @okor varchar(5), @ostr varchar(5), @okv varchar(5), @od_reg date

	SET @oul    = (select ul    from deleted)
	SET @odom   = (select dom   from deleted)
	SET @okor   = (select kor   from deleted)
	SET @ostr   = (select str   from deleted)
	SET @okv    = (select kv    from deleted)
	SET @od_reg = (select d_reg from deleted)

	DECLARE newcur CURSOR FOR SELECT
		id, recid AS parentid, sysdatetime() as version_start, null as version_stop, 1 as istop, 0 as isdeleted,
		ul, dom, kor, str, kv, d_reg FROM inserted	

	OPEN newcur

	FETCH NEXT FROM newcur INTO @id, @parentid, @version_start, @version_stop ,@istop, @isdeleted,
		@ul, @dom, @kor, @str, @kv, @d_reg

	CLOSE newcur
	DEALLOCATE newcur

	IF @ul!=@oul or coalesce(@dom,'')!=coalesce(@odom,'') or coalesce(@kor,'')!=coalesce(@okor,'') or 
	   coalesce(@str,'')!=coalesce(@ostr,'') or coalesce(@kv,'')!=coalesce(@okv,'') or (@d_reg=@od_reg)
	BEGIN 

	 DECLARE @recid int = (select recid from deleted)
	 UPDATE dbo.adr77 SET istop=0, version_stop=sysdatetime() WHERE adr77.recid=@recid

	 INSERT INTO dbo.adr77
	 (id, parentid, version_start, version_stop, istop, isdeleted, ul, dom, kor, str, kv, d_reg) VALUES
	  (@id, @parentid, @version_start, @version_stop, @istop, @isdeleted,
	   coalesce(@ul, @oul), coalesce(@dom, @odom), coalesce(@kor, @okor), coalesce(@str, @ostr), coalesce(@kv, @okv), coalesce(@d_reg, @od_reg))

	 UPDATE dbo.adr77 SET childid=SCOPE_IDENTITY() WHERE adr77.recid=@recid
	END 
END
GO
DISABLE TRIGGER dbo.uModAdr77 ON dbo.adr77
GO

IF OBJECT_ID('uDelAdr77','TR') IS NOT NULL DROP TRIGGER uDelAdr77
GO
CREATE TRIGGER dbo.uDelAdr77 ON dbo.adr77
INSTEAD OF DELETE
AS
BEGIN
	print 'uDelAdr77 trigger fired!'
	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.adr77 SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid

    UPDATE dbo.pers SET adr_id=NULL WHERE adr_id=@recid
END
GO
DISABLE TRIGGER dbo.uDelAdr77 ON dbo.adr77
GO
-- Creating dbo.adr77

-- Creating dbo.auxinfo table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.auxinfo')) DROP TABLE dbo.auxinfo
CREATE TABLE dbo.auxinfo (recid int IDENTITY(1,1), id int, 
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
pv char(3), nz varchar(5), kl tinyint NOT NULL DEFAULT 0, cont varchar(40),
gr char(3) check(gr = upper(gr)) references nsi.countries(code),
mr varchar(max), comment varchar(max), ktg varchar(1), lpuid dec(4))
GO
CREATE CLUSTERED INDEX idx_aux_uniq ON dbo.auxinfo (id, parentid)
GO 
ALTER TABLE dbo.auxinfo ADD CONSTRAINT PK_aux PRIMARY KEY (recid asc)
GO


IF OBJECT_ID('uModAux','TR') IS NOT NULL DROP TRIGGER uModAux
GO
CREATE TRIGGER dbo.uModAux ON dbo.auxinfo
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModAux trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50001, 16, 1) RETURN END

	DECLARE @id int, @parentid int, @version_start datetime, @version_stop datetime ,@isdeleted bit

	DECLARE @pv char(3), @nz varchar(5), @kl tinyint, @cont varchar(40), @gr char(3), @mr varchar(max), @comment varchar(max), @ktg varchar(1), @lpuid dec(4)
	DECLARE @opv char(3), @onz varchar(5), @okl tinyint, @ocont varchar(40), @ogr char(3), @omr varchar(max), @ocomment varchar(max), @oktg varchar(1), @olpuid dec(4)

	SET @opv      = (select pv      from deleted)
	SET @onz      = (select nz      from deleted)
	SET @okl      = (select kl      from deleted)
	SET @ocont    = (select cont    from deleted)
	SET @ogr      = (select gr      from deleted)
	SET @omr      = (select mr      from deleted)
	SET @ocomment = (select comment from deleted)
	SET @oktg     = (select ktg     from deleted)
	SET @olpuid   = (select lpuid   from deleted)

	DECLARE newcur CURSOR FOR SELECT
		id, recid AS parentid, sysdatetime() as version_start, null as version_stop, 1 as istop, 0 as isdeleted,
		pv, nz, kl, cont, gr, mr, comment, ktg, lpuid FROM inserted	

	OPEN newcur

	FETCH NEXT FROM newcur INTO @id, @parentid, @version_start, @version_stop ,@istop, @isdeleted,
		@pv, @nz, @kl, @cont, @gr, @mr, @comment, @ktg, @lpuid

	CLOSE newcur
	DEALLOCATE newcur

	IF coalesce(@pv,'')!=coalesce(@opv,'') or coalesce(@nz,'')!=coalesce(@onz,'') or (coalesce(@kl,0)!=coalesce(@okl,0)) or 
	   coalesce(@cont,'')!=coalesce(@ocont,'') or coalesce(@gr,'')!=coalesce(@ogr,'') or coalesce(@mr,'')!=coalesce(@omr,'') or
	   coalesce(@comment,'')!=coalesce(@ocomment,'') or coalesce(@ktg,'')!=coalesce(@oktg,'') or (@lpuid=@olpuid)
	BEGIN 

	 DECLARE @recid int = (select recid from deleted)
	 UPDATE dbo.auxinfo SET istop=0, version_stop=sysdatetime() WHERE auxinfo.recid=@recid

	 INSERT INTO dbo.auxinfo
	 (id, parentid, version_start, version_stop, istop, isdeleted, pv, nz, kl, cont, gr, mr, comment, ktg, lpuid) VALUES
	  (@id, @parentid, @version_start, @version_stop, @istop, @isdeleted,
	   coalesce(@pv, @opv), coalesce(@nz, @onz), coalesce(@kl, @okl), coalesce(@cont, @ocont), coalesce(@gr, @ogr), coalesce(@mr, @omr),
	   coalesce(@comment, @ocomment), coalesce(@ktg, @oktg), coalesce(@lpuid, @olpuid))

	 UPDATE dbo.auxinfo SET childid=SCOPE_IDENTITY() WHERE auxinfo.recid=@recid
	END 

END
GO
DISABLE TRIGGER dbo.uModAux ON dbo.auxinfo
GO

IF OBJECT_ID('uDelAux','TR') IS NOT NULL DROP TRIGGER uDelAux
GO
CREATE TRIGGER dbo.uDelAux ON dbo.auxinfo
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'uDelAux trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50003, 16, 1) RETURN END /*Попытка удалить неактуальную запись!*/

	DECLARE @recid int= (SELECT recid FROM deleted)
	UPDATE dbo.auxinfo SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid

END
GO
DISABLE TRIGGER dbo.uDelAux ON dbo.auxinfo
GO
-- Creating dbo.auxinfo table

-- Creating dbo.docs table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.docs')) DROP TABLE dbo.docs
CREATE TABLE dbo.docs (recid int IDENTITY(1,1), id int, 
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
tip tinyint/*1-осн. документ, 2-доп. документ, 3-старый документ*/, 
c_doc tinyint REFERENCES nsi.viddocs (code), s_doc varchar(9) NOT NULL, n_doc varchar(8) NOT NULL, d_doc date NOT NULL, e_doc date,
u_doc varchar(max), x_doc tinyint NOT NULL DEFAULT 0)
GO
CREATE CLUSTERED INDEX idx_docs_uniq ON dbo.docs (id, tip, parentid)
GO 
ALTER TABLE dbo.docs ADD CONSTRAINT PK_docs PRIMARY KEY (recid ASC)
GO
CREATE UNIQUE INDEX idx_docs_unik ON dbo.docs (s_doc, n_doc) INCLUDE (recid) WHERE IsTop=1 AND IsDeleted=0
GO

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekdocs')) DROP FUNCTION dbo.seekdocs
GO
CREATE FUNCTION dbo.seekdocs (@s_doc varchar(9), @n_doc varchar(8)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.docs WHERE s_doc=@s_doc AND n_doc=@n_doc AND IsTop=1 AND IsDeleted=0
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 

--- The proc is ONLY created for VFP Module kms2sql and could be deleted immediately after conversion VFP -> MS SQL
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.pseekdocs')) DROP PROCEDURE dbo.pseekdocs
GO
CREATE PROCEDURE dbo.pseekdocs(@s_doc varchar(9)='', @n_doc varchar(8)='', @recid int=NULL out)
AS
BEGIN
SET NOCOUNT ON;
SELECT recid FROM docs WHERE s_doc=@s_doc AND n_doc=@n_doc AND IsTop=1 AND IsDeleted=0
END
GO
--- The proc is ONLY created for VFP Module kms2sql and could be deleted immediately after conversion VFP -> MS SQL

IF OBJECT_ID('uModDocs','TR') IS NOT NULL DROP TRIGGER uModDos
GO
CREATE TRIGGER dbo.uModDocs ON dbo.docs
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModDocs trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50001, 16, 1) RETURN END

	DECLARE @id int, @parentid int, @version_start datetime, @version_stop datetime, @isdeleted bit

	DECLARE @tip tinyint, @c_doc tinyint, @s_doc varchar(9), @n_doc varchar(8), @d_doc date, @e_doc date, @u_doc varchar(max), @x_doc tinyint
	DECLARE @otip tinyint, @oc_doc tinyint, @os_doc varchar(9), @on_doc varchar(8), @od_doc date, @oe_doc date, @ou_doc varchar(max), @ox_doc tinyint

	SET @otip   = (select tip   from deleted)
	SET @oc_doc = (select c_doc from deleted)
	SET @os_doc = (select s_doc from deleted)
	SET @on_doc = (select n_doc from deleted)
	SET @od_doc = (select d_doc from deleted)
	SET @oe_doc = (select e_doc from deleted)
	SET @ou_doc = (select u_doc from deleted)
	SET @ox_doc = (select x_doc from deleted)

	DECLARE newcur CURSOR FOR SELECT
		id, recid AS parentid, sysdatetime() as version_start, null as version_stop, 1 as istop, 0 as isdeleted,
		tip, c_doc, s_doc, n_doc, d_doc, e_doc, u_doc, x_doc FROM inserted	

	OPEN newcur

	FETCH NEXT FROM newcur INTO @id, @parentid, @version_start, @version_stop, @istop, @isdeleted,
		@tip, @c_doc, @s_doc, @n_doc, @d_doc, @e_doc, @u_doc, @x_doc

	CLOSE newcur
	DEALLOCATE newcur

	IF coalesce(@tip,'')!=coalesce(@otip,'') or coalesce(@c_doc,0)!=coalesce(@oc_doc,0) or coalesce(@s_doc,'')!=coalesce(@os_doc,'') or 
	   coalesce(@n_doc,'')!=coalesce(@on_doc,'') or coalesce(@d_doc,'')!=coalesce(@od_doc,'') or coalesce(@e_doc,'')!=coalesce(@oe_doc,'') or 
	   coalesce(@u_doc,'')!=coalesce(@ou_doc,'') or coalesce(@x_doc,0)!=coalesce(@ox_doc,0)
	BEGIN 

	DECLARE @recid int = (select recid from deleted)
	UPDATE dbo.docs SET istop=0, version_stop=sysdatetime() WHERE docs.recid=@recid

	INSERT INTO dbo.docs
	(id, parentid, version_start, version_stop, istop, isdeleted, tip, c_doc, s_doc, n_doc, d_doc, e_doc, u_doc, x_doc) VALUES
	 (@id, @parentid, @version_start, @version_stop, @istop, @isdeleted,
	  coalesce(@tip, @otip), coalesce(@c_doc, @oc_doc), coalesce(@s_doc, @os_doc), coalesce(@n_doc, @on_doc), coalesce(@d_doc, @od_doc),
	  coalesce(@e_doc, @oe_doc), coalesce(@u_doc, @ou_doc), coalesce(@x_doc, @ox_doc))

	UPDATE dbo.docs SET childid=SCOPE_IDENTITY() WHERE docs.recid=@recid

	END

END
GO
DISABLE TRIGGER dbo.uModDocs ON dbo.docs
GO

IF OBJECT_ID('uDelDocs','TR') IS NOT NULL DROP TRIGGER uDelDocs
GO
CREATE TRIGGER dbo.uDelDocs ON dbo.docs
INSTEAD OF DELETE
AS
BEGIN
	print 'uDelDocs trigger fired!'
	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	DECLARE @Tip tinyint = (SELECT tip FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.docs SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid

	IF @Tip=1
	 UPDATE dbo.pers SET docid=NULL WHERE vsid=@recid
	ELSE IF @Tip=2
	 UPDATE dbo.pers SET permid=NULL WHERE permid=@recid
	ELSE IF @Tip=3
	 UPDATE dbo.pers SET odocid=NULL WHERE odocid=@recid
END
GO
DISABLE TRIGGER dbo.uDelDocs ON dbo.docs
GO
-- Creating dbo.docs table

-- Creating dbo.enp table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.enp')) DROP TABLE dbo.enp
CREATE TABLE dbo.enp (recid int IDENTITY(1,1), id int, 
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
tip tinyint, enp char(16) null, blanc varchar(11) null, ogrn varchar(13) NOT NULL DEFAULT '1025004642519', 
okato varchar(5) NOT NULL DEFAULT '45000', dp date null, dt date null, dr date null)
GO
CREATE CLUSTERED INDEX idx_enp_uniq ON dbo.enp (id, tip, parentid)
GO 
ALTER TABLE dbo.enp ADD CONSTRAINT PK_enp PRIMARY KEY (recid asc)
GO
CREATE UNIQUE INDEX idx_enp_unik ON dbo.enp (enp,blanc,ogrn,okato) INCLUDE (recid) WHERE IsTop=1 AND IsDeleted=0
GO

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekenp')) DROP FUNCTION dbo.seekenp
GO
CREATE FUNCTION dbo.seekenp (@enp char(16), @ogrn varchar(13)='1025004642519', @okato varchar(5)='45000') RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.enp WHERE enp=@enp AND ogrn=@ogrn AND okato=@okato AND IsTop=1 AND IsDeleted=0
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 

--- The proc is ONLY created for VFP Module oldkmssql and could be deleted immediately after conversion VFP -> MS SQL
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.pseekenp')) DROP PROCEDURE dbo.pseekenp
GO
CREATE PROCEDURE dbo.pseekenp(@enp char(16), @ogrn varchar(13)='1025004642519', @okato varchar(5)='45000', @recid int=NULL out)
AS
BEGIN
SET NOCOUNT ON;
SELECT recid FROM dbo.enp WHERE enp=@enp AND ogrn=@ogrn AND okato=@okato AND IsTop=1 AND IsDeleted=0
END
GO
--- The proc is ONLY created for VFP Module oldkmssql and could be deleted immediately after conversion VFP -> MS SQL

IF OBJECT_ID('uModEnp','TR') IS NOT NULL DROP TRIGGER uModEnp
GO
CREATE TRIGGER dbo.uModEnp ON dbo.enp
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModEnp trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50001, 16, 1) RETURN END

	DECLARE @id int, @parentid int, @version_start datetime, @version_stop datetime ,@isdeleted bit
	DECLARE	@tip tinyint, @enp char(16), @blanc varchar(11), @ogrn varchar(13), @okato varchar(5), @dp date, @dt date, @dr date
	DECLARE	@otip tinyint, @oenp char(16), @oblanc varchar(11), @oogrn varchar(13), @ookato varchar(5), @odp date, @odt date, @odr date

	SET @otip    = (select tip   from deleted)
	SET @oenp    = (select enp   from deleted)
	SET @oblanc  = (select blanc from deleted)
	SET @oogrn   = (select ogrn  from deleted)
	SET @ookato  = (select okato from deleted)
	SET @odp     = (select dp    from deleted)
	SET @odt     = (select dt    from deleted)
	SET @odr     = (select dr    from deleted)

	DECLARE newcur CURSOR FOR SELECT
		id, recid AS parentid, sysdatetime() as version_start, null as version_stop, 1 as istop, 0 as isdeleted,
		tip, enp, blanc, ogrn, okato, dp, dt, dr FROM inserted

	OPEN newcur

	FETCH NEXT FROM newcur INTO @id, @parentid, @version_start, @version_stop ,@istop, @isdeleted,
		@tip, @enp, @blanc, @ogrn, @okato, @dp, @dt, @dr

	CLOSE newcur
	DEALLOCATE newcur

	IF coalesce(@tip,'')!=coalesce(@otip,'') or coalesce(@enp,'')!=coalesce(@oenp,'') or coalesce(@blanc,'')!=coalesce(@oblanc,'') or 
	   coalesce(@ogrn,'')!=coalesce(@oogrn,'') or coalesce(@okato,'')!=coalesce(@ookato,'') or coalesce(@dp,'')!=coalesce(@odp,'') or 
	   coalesce(@dt,'')!=coalesce(@odt,'') or coalesce(@dr,'')!=coalesce(@odr,'')
	BEGIN 

	 DECLARE @recid int = (select recid from deleted)
	 UPDATE dbo.enp SET istop=0, version_stop=sysdatetime() WHERE enp.recid=@recid

	 INSERT INTO dbo.enp
	 (id, parentid, version_start, version_stop, istop, isdeleted, tip, enp, blanc, ogrn, okato, dp, dt, dr) VALUES
	  (@id, @parentid, @version_start, @version_stop, @istop, @isdeleted,
	   coalesce(@tip, @otip), coalesce(@enp, @oenp), coalesce(@blanc, @oblanc), coalesce(@ogrn, @oogrn), coalesce(@okato, @ookato),
	   coalesce(@dp, @odp), coalesce(@dt, @odt), coalesce(@dr, @odr))

	 UPDATE dbo.enp SET childid=SCOPE_IDENTITY() WHERE enp.recid=@recid

	END

END
GO
DISABLE TRIGGER dbo.uModEnp ON dbo.enp
GO

IF OBJECT_ID('uDelEnp','TR') IS NOT NULL DROP TRIGGER uDelEnp
GO
CREATE TRIGGER dbo.uDelEnp ON dbo.enp
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	DECLARE @Tip tinyint = (SELECT tip FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.enp SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid

	IF @Tip=1
	 UPDATE dbo.pers SET enpid=NULL WHERE enpid=@recid
	ELSE IF @Tip=2
	 UPDATE dbo.pers SET oenpid=NULL WHERE oenpid=@recid
	ELSE IF @Tip=3
	 UPDATE dbo.pers SET enp2id=NULL WHERE enp2id=@recid
END
GO
DISABLE TRIGGER dbo.uDelEnp ON dbo.enp
GO
-- Creating dbo.enp table

-- Creating dbo.fio table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.fio')) DROP TABLE dbo.fio
CREATE TABLE dbo.fio (recid int IDENTITY(1,1), id int, 
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
fam varchar(40) NOT NULL, d_fam char(1) NOT NULL DEFAULT SPACE(1) REFERENCES nsi.codfio (code), im varchar(40) NOT NULL, 
d_im char(1) NOT NULL DEFAULT SPACE(1) REFERENCES nsi.codfio (code), ot varchar(40),
d_ot char(1) NOT NULL DEFAULT SPACE(1) REFERENCES nsi.codfio (code))
GO
CREATE CLUSTERED INDEX idx_fio_uniq ON dbo.fio (id, parentid)
GO 
ALTER TABLE dbo.fio ADD CONSTRAINT PK_fio PRIMARY KEY (recid asc)
GO

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekfio')) DROP FUNCTION dbo.seekfio
GO
CREATE FUNCTION dbo.seekfio (@fam varchar(40), @im varchar(40), @ot varchar(40)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.fio WHERE fam=@fam AND im=@im AND ot=@ot AND IsTop=1
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 

IF OBJECT_ID('uModFio','TR') IS NOT NULL DROP TRIGGER uModFio
GO
CREATE TRIGGER dbo.uModFio ON dbo.fio
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON

	PRINT 'uModFio trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50001, 16, 1) RETURN END /*попытка редактировать неактуальныю запись!*/

	DECLARE @id int, @parentid int, @version_start datetime, @version_stop datetime, @isdeleted bit
	DECLARE	@fam varchar(40), @d_fam char(1), @im varchar(40), @d_im char(1), @ot varchar(40), @d_ot char(1)
	DECLARE	@ofam varchar(40), @od_fam char(1), @oim varchar(40), @od_im char(1), @oot varchar(40), @od_ot char(1)

	SET @ofam   = (select fam   from deleted)
	SET @od_fam = (select d_fam from deleted)
	SET @oim    = (select im    from deleted)
	SET @od_im  = (select d_im  from deleted)
	SET @oot    = (select ot    from deleted)
	SET @od_ot  = (select d_ot  from deleted)

	DECLARE newcur CURSOR FOR SELECT
		id, recid AS parentid, sysdatetime() as version_start, null as version_stop, 1 as istop, 0 as isdeleted,
		fam, d_fam, im, d_im, ot, d_ot FROM inserted

	OPEN newcur

	FETCH NEXT FROM newcur INTO @id, @parentid, @version_start, @version_stop ,@istop, @isdeleted,
		@fam, @d_fam, @im, @d_im, @ot, @d_ot

	CLOSE newcur
	DEALLOCATE newcur

	IF coalesce(@fam,'')!=coalesce(@ofam,'') or coalesce(@d_fam,'')!=coalesce(@od_fam,'') or coalesce(@im,'')!=coalesce(@oim,'') or 
	   coalesce(@ot,'')!=coalesce(@oot,'') or coalesce(@d_ot,'')!=coalesce(@od_ot,'')
	BEGIN 

	UPDATE dbo.fio SET istop=0, version_stop=sysdatetime() FROM deleted WHERE fio.recid=deleted.recid

	INSERT INTO dbo.fio
	(id, parentid, version_start, version_stop, istop, isdeleted, fam, d_fam, im, d_im, ot, d_ot) VALUES
	 (@id, @parentid, @version_start, @version_stop, @istop, @isdeleted, 
		coalesce(@fam,@ofam), coalesce(@d_fam,@od_fam), coalesce(@im,@oim), coalesce(@d_im,@od_im), coalesce(@ot,@oot), coalesce(@d_ot,@od_ot))

	DECLARE @recid int= (select recid from deleted)

	UPDATE dbo.fio SET childid=SCOPE_IDENTITY() FROM deleted WHERE fio.recid=deleted.recid

	END

END
GO
DISABLE TRIGGER dbo.uModFio ON dbo.fio
GO

IF OBJECT_ID('uDelFio','TR') IS NOT NULL DROP TRIGGER uDelFio
GO
CREATE TRIGGER dbo.uDelFio ON dbo.fio
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'uDelFio trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50003, 16, 1) RETURN END /*Попытка удалить неактуальную запись!*/

	DECLARE @recid int= (SELECT recid FROM deleted)
	UPDATE dbo.fio SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid

END
GO
DISABLE TRIGGER dbo.uDelFio ON dbo.fio
GO
-- Creating dbo.fio table

-- Creating dbo.kms table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.kms')) DROP TABLE dbo.kms
CREATE TABLE dbo.kms (recid int IDENTITY(1,1), id int, 
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
tip tinyint /*1-ВС,2-КМС,3-старый КМС*/, s_card varchar(12) null, n_card varchar(32) not null, ogrn varchar(13) NOT NULL DEFAULT '1025004642519', okato varchar(5) NOT NULL DEFAULT '45000',
dp date null, dt date null, dr date null)
GO
CREATE CLUSTERED INDEX idx_kms_uniq ON dbo.kms (id, tip, parentid)
GO 
ALTER TABLE dbo.kms ADD CONSTRAINT PK_kms PRIMARY KEY (recid asc)
GO
CREATE UNIQUE INDEX idx_kms_unik ON dbo.kms (s_card,n_card) INCLUDE (recid) WHERE IsTop=1 AND IsDeleted=0
GO

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekkms')) DROP FUNCTION dbo.seekkms
GO
CREATE FUNCTION dbo.seekkms (@s_card varchar(12), @n_card varchar(32)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.kms WHERE s_card=@s_card AND n_card=@n_card AND IsTop=1 AND IsDeleted=0
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 

--- The proc is ONLY created for VFP Module oldkmssql and could be deleted immediately after conversion VFP -> MS SQL
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.pseekkms')) DROP PROCEDURE dbo.pseekkms
GO
CREATE PROCEDURE dbo.pseekkms(@s_card varchar(12)=null, @n_card varchar(32)=null, @recid int=NULL out)
AS
BEGIN
 SET NOCOUNT ON;
 SELECT recid FROM dbo.kms WHERE s_card=@s_card AND n_card=@n_card AND IsTop=1 AND IsDeleted=0
END
GO
--- The proc is ONLY created for VFP Module oldkmssql and could be deleted immediately after conversion VFP -> MS SQL

IF OBJECT_ID('uModkms','TR') IS NOT NULL DROP TRIGGER uModkms
GO
CREATE TRIGGER dbo.uModkms ON dbo.kms
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON
	print 'uModkms trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50001, 16, 1) RETURN END

	DECLARE @id int, @parentid int, @version_start datetime, @version_stop datetime ,@isdeleted bit

	DECLARE @tip tinyint, @s_card varchar(12), @n_card varchar(32), @ogrn varchar(13), @okato varchar(5), @dp date, @dt date, @dr date
	DECLARE @otip tinyint, @os_card varchar(12), @on_card varchar(32), @oogrn varchar(13), @ookato varchar(5), @odp date, @odt date, @odr date

	SET @otip    = (select tip    from deleted)
	SET @os_card = (select s_card from deleted)
	SET @on_card = (select n_card from deleted)
	SET @oogrn   = (select ogrn   from deleted)
	SET @ookato  = (select okato  from deleted)
	SET @odp     = (select dp     from deleted)
	SET @odt     = (select dt     from deleted)
	SET @odr     = (select dr     from deleted)

	DECLARE newcur CURSOR FOR SELECT
		id, recid AS parentid, sysdatetime() as version_start, null as version_stop, 1 as istop, 0 as isdeleted,
		tip, s_card, n_card, ogrn, okato, dp, dt, dr FROM inserted	

	OPEN newcur

	FETCH NEXT FROM newcur INTO @id, @parentid, @version_start, @version_stop ,@istop, @isdeleted,
		@tip, @s_card, @n_card, @ogrn, @okato, @dp, @dt, @dr

	CLOSE newcur
	DEALLOCATE newcur

	IF coalesce(@tip,'')!=coalesce(@otip,'') or coalesce(@s_card,'')!=coalesce(@os_card,'') or coalesce(@n_card,'')!=coalesce(@on_card,'') or 
	   coalesce(@ogrn,'')!=coalesce(@oogrn,'') or coalesce(@okato,'')!=coalesce(@ookato,'') or coalesce(@dp,'')!=coalesce(@odp,'') or 
	   coalesce(@dt,'')!=coalesce(@odt,'') or coalesce(@dr,'')!=coalesce(@odr,'')
	BEGIN 

	 DECLARE @recid int = (select recid from deleted)
	 UPDATE dbo.kms SET istop=0, version_stop=sysdatetime() WHERE kms.recid=@recid

	 INSERT INTO dbo.kms
	 (id, parentid, version_start, version_stop, istop, isdeleted, tip, s_card, n_card, ogrn, okato, dp, dt, dr) VALUES
	  (@id, @parentid, @version_start, @version_stop, @istop, @isdeleted,
	   coalesce(@tip, @otip), coalesce(@s_card, @os_card), coalesce(@n_card, @on_card), coalesce(@ogrn, @oogrn), coalesce(@okato, @ookato),
	   coalesce(@dp, @odp), coalesce(@dt, @odt), coalesce(@dr, @odr))

	 UPDATE dbo.kms SET childid=SCOPE_IDENTITY() WHERE kms.recid=@recid
	END 
END
GO
DISABLE TRIGGER dbo.uModkms ON dbo.kms
GO

IF OBJECT_ID('uDelKms','TR') IS NOT NULL DROP TRIGGER uDelKms
GO
CREATE TRIGGER dbo.uDelKms ON dbo.kms
INSTEAD OF DELETE
AS
BEGIN
	print 'uDelKms trigger fired!'
	SET NOCOUNT ON

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	DECLARE @Tip tinyint = (SELECT tip FROM deleted)
	IF @istop=0	BEGIN RAISERROR(50603, 16, 1) RETURN END

	DECLARE @recid int= (select recid from deleted)
	UPDATE dbo.kms SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid

	IF @Tip=1
	 UPDATE dbo.pers SET vs=NULL, vsid=NULL WHERE vsid=@recid
	ELSE IF @Tip=2
	 UPDATE dbo.pers SET kms=NULL, kmsid=NULL WHERE kmsid=@recid
	ELSE IF @Tip=3
	 UPDATE dbo.pers SET okms=NULL, okmsid=NULL WHERE okmsid=@recid
END
GO
DISABLE TRIGGER dbo.uDelKms ON dbo.kms
GO

-- Creating dbo.kms table

-- Creating dbo.moves table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.moves')) DROP TABLE dbo.moves
CREATE TABLE dbo.moves (recid int IDENTITY(1,1) PRIMARY KEY CLUSTERED, id int, isdeleted bit NOT NULL DEFAULT 0,
scn char(3), jt char(1), dp date, form tinyint, spos tinyint, d_gzk tinyint, predst tinyint, predstid int)
GO
-- Creating dbo.moves table

-- Creating dbo.ofio table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.ofio')) DROP TABLE dbo.ofio
CREATE TABLE dbo.ofio (recid int IDENTITY(1,1), id int, 
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
fam varchar(40), im varchar(40), ot varchar(40))
GO
CREATE CLUSTERED INDEX idx_fio_uniq ON dbo.ofio (id, parentid)
GO 
ALTER TABLE dbo.ofio ADD CONSTRAINT PK_ofio PRIMARY KEY (recid asc)
GO

IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.seekofio')) DROP FUNCTION dbo.seekofio
GO
CREATE FUNCTION dbo.seekofio (@fam varchar(40), @im varchar(40), @ot varchar(40)) RETURNS int WITH SCHEMABINDING
BEGIN
 DECLARE @recid int
 SELECT @recid=recid FROM dbo.ofio WHERE fam=@fam AND im=@im AND ot=@ot AND IsTop=1
 RETURN CASE WHEN @recid IS NULL THEN 0 ELSE @recid END
END
GO 

IF OBJECT_ID('uModOFio','TR') IS NOT NULL DROP TRIGGER uModOFio
GO
CREATE TRIGGER dbo.uModOFio ON dbo.ofio
INSTEAD OF UPDATE
AS
BEGIN
	SET NOCOUNT ON

	PRINT 'uModOFio trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50001, 16, 1) RETURN END /*попытка редактировать неактуальныю запись!*/

	DECLARE @id int, @parentid int, @version_start datetime, @version_stop datetime, @isdeleted bit
	DECLARE	@fam varchar(40), @im varchar(40), @ot varchar(40)
	DECLARE	@ofam varchar(40), @oim varchar(40), @oot varchar(40)

	SET @ofam   = (select fam   from deleted)
	SET @oim    = (select im    from deleted)
	SET @oot    = (select ot    from deleted)

	DECLARE newcur CURSOR FOR SELECT
		id, recid AS parentid, sysdatetime() as version_start, null as version_stop, 1 as istop, 0 as isdeleted,
		fam, im, ot FROM inserted

	OPEN newcur

	FETCH NEXT FROM newcur INTO @id, @parentid, @version_start, @version_stop ,@istop, @isdeleted,
		@fam, @im, @ot

	CLOSE newcur
	DEALLOCATE newcur

	IF coalesce(@fam,'')!=coalesce(@ofam,'') or coalesce(@im,'')!=coalesce(@oim,'') or coalesce(@ot,'')!=coalesce(@oot,'')
	BEGIN 

	UPDATE dbo.ofio SET istop=0, version_stop=sysdatetime() FROM deleted WHERE ofio.recid=deleted.recid

	INSERT INTO dbo.ofio
	(id, parentid, version_start, version_stop, istop, isdeleted, fam, im, ot) VALUES
	 (@id, @parentid, @version_start, @version_stop, @istop, @isdeleted, coalesce(@fam,@ofam), coalesce(@im,@oim), coalesce(@ot,@oot))

	DECLARE @recid int= (select recid from deleted)

	UPDATE dbo.ofio SET childid=SCOPE_IDENTITY() FROM deleted WHERE ofio.recid=deleted.recid

	END

END
GO
DISABLE TRIGGER dbo.uModOFio ON dbo.ofio
GO

IF OBJECT_ID('uDelOFio','TR') IS NOT NULL DROP TRIGGER uDelOFio
GO
CREATE TRIGGER dbo.uDelOFio ON dbo.ofio
INSTEAD OF DELETE
AS
BEGIN
	SET NOCOUNT ON
	PRINT 'uDelOFio trigger fired!'

	DECLARE @IsTop bit = (SELECT istop FROM deleted)
	IF @IsTop=0	BEGIN RAISERROR(50003, 16, 1) RETURN END /*Попытка удалить неактуальную запись!*/

	DECLARE @recid int= (SELECT recid FROM deleted)
	UPDATE dbo.ofio SET version_stop=sysdatetime(), istop=0, isdeleted=1 WHERE recid=@recid

END
GO
DISABLE TRIGGER dbo.uDelOFio ON dbo.ofio
GO
-- Creating dbo.ofio table

-- Creating dbo.predst table
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.predst')) DROP TABLE dbo.predst
CREATE TABLE dbo.predst (recid int IDENTITY(1,1), id int,
parentid int NULL, childid int NULL, version_start datetime default sysdatetime(), version_stop datetime NULL,
istop bit NOT NULL DEFAULT 1, isdeleted bit NOT NULL DEFAULT 0,
fam varchar(40), im varchar(40), ot varchar(40), c_doc tinyint, s_doc varchar(9), n_doc varchar(8), d_doc date,
u_doc varchar(max), tel1 varchar(10), tel2 varchar(10), inf varchar(100))
GO
CREATE CLUSTERED INDEX idx_predst_uniq ON dbo.predst (id, parentid)
GO 
ALTER TABLE dbo.predst ADD CONSTRAINT PK_predst PRIMARY KEY (recid asc)
GO
-- Creating dbo.predst table

-- Creating dbo.users table
CREATE TABLE [dbo].[users](
[recid] int IDENTITY(1,1),
[pv] varchar(3), [ucod] int, [id] varchar(8), [fam] varchar(25), [im] varchar(20), [ot] varchar(20), [kadr] dec(1),
[created] datetime default sysdatetime(),
CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED ([recid] ASC))
GO
CREATE INDEX ucod ON users (ucod)
GO
-- Creating dbo.users table

-- Creating dbo.wrkpl table
CREATE TABLE [dbo].[wrkpl](
[recid] int IDENTITY(1,1),
[code] varchar(3), [name] varchar(100),
[created] datetime default sysdatetime(),
CONSTRAINT [PK_wrkpl] PRIMARY KEY CLUSTERED ([recid] ASC))
GO
--INSERT INTO wrkpl (code,name) values ('','')
--GO
CREATE INDEX name ON wrkpl (name)
GO
-- Creating dbo.wrkpl table

-- Creating pers
IF EXISTS (SELECT * FROM sys.objects WHERE OBJECT_ID=OBJECT_ID('dbo.pers')) DROP TABLE dbo.pers
CREATE TABLE dbo.pers (recid int IDENTITY(1,1) NOT NULL, isdeleted bit NOT NULL DEFAULT 0,
	status tinyint NOT NULL DEFAULT 0 REFERENCES nsi.status (code), snils varchar(14),
	vs varchar(9), vsid int NULL REFERENCES dbo.kms,
	sn_card varchar(17) , kmsid int NULL REFERENCES dbo.kms,
	enp char(16), enpid int NULL REFERENCES dbo.enp(recid), 
	fioid int NULL REFERENCES dbo.fio(recid),
	dr date NOT NULL, true_dr tinyint NOT NULL DEFAULT 1 REFERENCES nsi.true_dr (code),
	w tinyint NOT NULL REFERENCES nsi.sex (code), auxid int REFERENCES dbo.auxinfo (recid),
	adr_id int NULL REFERENCES dbo.adr77(recid), adr50_id int NULL REFERENCES dbo.adr50(recid),
	docid int NULL REFERENCES dbo.docs(recid), movesid int null REFERENCES dbo.moves (recid),
	ofioid int REFERENCES dbo.ofio(recid), odocid int NULL REFERENCES dbo.docs(recid), 
	okmsid int NULL REFERENCES dbo.kms,
	oenpid int NULL REFERENCES dbo.enp(recid), permid int NULL REFERENCES dbo.docs(recid),
	enp2id int NULL REFERENCES dbo.enp(recid), photo varbinary(max), [sign] varbinary(max),
	oper tinyint, operpv tinyint, CONSTRAINT PK_pers PRIMARY KEY CLUSTERED (recid ASC))
GO
CREATE UNIQUE INDEX idx_pers_snils ON dbo.pers (snils) WHERE snils IS NOT NULL
GO
CREATE UNIQUE INDEX idx_pers_vs ON dbo.pers (vs) WHERE vs IS NOT NULL
GO
CREATE UNIQUE INDEX idx_pers_sn_card ON dbo.pers (sn_card) WHERE sn_card IS NOT NULL
GO 
CREATE UNIQUE INDEX idx_pers_enp ON dbo.pers (enp) WHERE enp IS NOT NULL
GO
-- Creating pers

print 'CreateInterface.sql next or run VFP modules and CreateInterface.sql then !'
