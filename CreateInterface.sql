-- Creating a view with procs
--
USE kms
GO

IF OBJECT_ID('dbo.kmsview','V') IS NOT NULL DROP VIEW dbo.kmsview
GO
CREATE VIEW dbo.kmsview AS SELECT a.recid,a.status,a.snils,a.dr,a.true_dr,a.w,a.photo,a.sign,a.oper,a.operpv,
	b.c_okato,b.ra_name,b.np_c,b.np_name,b.ul_c,b.ul_name,b.dom as dom50,b.kor as kor50,b.str as str50,b.kv as kv50, b.d_reg as d_reg50,
	c.ul,c.dom,c.kor,c.str,c.kv,c.d_reg,
	d.pv,d.nz,d.kl,d.cont,d.gr,d.mr,d.comment,d.ktg,d.lpuid,
	e.c_doc,e.s_doc,e.n_doc,e.d_doc,e.e_doc,e.u_doc,e.x_doc,
	f.c_doc as c_perm,f.s_doc as s_perm,f.n_doc as n_perm,f.d_doc as d_perm,f.e_doc as e_perm,
	g.c_doc as oc_doc,g.s_doc as os_doc,g.n_doc as on_doc,g.d_doc as od_doc,g.e_doc as oe_doc,g.u_doc as ou_doc,
	h.enp,h.blanc,h.ogrn as enpogrn,h.okato as enpokato,h.dp as enpdp,h.dt as enpdt,h.dr as enpdr,
	i.enp as enp2,i.ogrn as enp2ogrn,i.okato as enp2okato,i.dp as enp2dp,i.dt as enp2dt,
	j.fam,j.d_fam,j.im,j.d_im,j.ot,j.d_ot,
	k.s_card as s_vs,k.n_card as n_vs,k.ogrn as vsogrn,k.okato as vsokato,k.dp as vsdp,k.dt as vsdt,
	l.s_card as s_kms,l.n_card as n_kms,l.ogrn as kmsogrn,l.okato as kmsokato,l.dp as kmsdp,l.dt as kmsdt,
	m.s_card as s_okms,m.n_card as n_okms,m.ogrn as okmsogrn,m.okato as okmsokato,m.dp as okmsdp,m.dt as okmsdt,
	n.fam as ofam,n.im as oim,n.ot as oot FROM dbo.pers a
LEFT OUTER JOIN dbo.adr50 b ON a.adr_id=b.recid
LEFT OUTER JOIN dbo.adr77 c ON a.adr50_id=c.recid
LEFT OUTER JOIN dbo.auxinfo d ON a.auxid=d.recid
LEFT OUTER JOIN dbo.docs e ON a.docid=e.recid
LEFT OUTER JOIN dbo.docs f ON a.permid=f.recid
LEFT OUTER JOIN dbo.docs g ON a.odocid=g.recid
LEFT OUTER JOIN dbo.enp h ON a.enpid=h.recid
LEFT OUTER JOIN dbo.enp i ON a.enp2id=i.recid
LEFT OUTER JOIN dbo.fio j ON a.fioid=j.recid
LEFT OUTER JOIN dbo.kms k ON a.vsid=k.recid
LEFT OUTER JOIN dbo.kms l ON a.kmsid=l.recid
LEFT OUTER JOIN dbo.kms m ON a.okmsid=m.recid
LEFT OUTER JOIN dbo.ofio n ON a.ofioid=n.recid
WHERE a.IsDeleted=0
GO

IF OBJECT_ID('dbo.GetPersons','P') IS NOT NULL DROP FUNCTION dbo.GetPersons
GO
CREATE PROCEDURE dbo.GetPersons
AS
BEGIN
SET NOCOUNT ON;
SELECT * FROM kmsview;
END
GO

/*
CREATE VIEW dbo.kmsview AS SELECT a.recid,v.pv,v.nz,a.status,a.vs,x.dp as vs_data,a.sn_card,a.enp,z.dp as gz_data,z.dp,z.dt,y.fam,y.d_fam,
y.im,y.d_im,y.ot,y.d_ot,a.w,a.dr,a.true_dr,a.adr_id,a.adr50_id,v.kl,v.cont,
a.snils,v.gr,v.mr,/*a.d_reg,a.jt,a.scn,a.form,a.predst,a.predstid,a.spos,a.d_gzk,*/v.comment,v.ktg,/*a.s_card2,a.n_card2*/a.ofioid,
a.docid, a.odocid,v.lpuid,a.oper,a.operpv,a.osmoid,a.permid,a.enp2id,/*a.wrkid,a.dpok*/a.photo,a.sign,
b.ul, b.dom, b.kor, b.str, b.kv, 
c.c_okato as c_okato, c.ra_name as ra_name, c.np_c as np_c, c.np_name as np_name, c.ul_c as ul_c, c.ul_name as ul_name, 
c.dom as dom2, c.kor as kor2, c.str as str2, c.kv as kv2, 
d.fam as prfam, d.im as prim, d.ot as prot, d.c_doc as prc_doc, d.s_doc as prs_doc, d.n_doc as prn_doc, d.d_doc as prd_doc, 
d.u_doc as prpodr, d.tel1 as prtel1, d.tel2 as prtel2, d.inf as prpinf,
e.enp as enp2, e.ogrn as ogrn_old2, e.okato as okato_old2, e.dp as dp_old2, 
f.c_doc as oc_doc, f.s_doc as os_doc, f.n_doc as on_doc, f.d_doc as od_doc, f.e_doc as oe_doc, f.u_doc as ou_doc,
g.fam as ofam, g.im as oim, g.ot as oot, g.w as ow, g.dr as odr, 
h.ogrn as ogrn_old, h.okato as okato_old, h.dp as dp_old, 
i.c_doc as c_perm, i.s_doc as s_perm, i.n_doc as n_perm, i.d_doc as d_perm, i.e_doc as e_perm, 
/*k.code as wrkcode, k.name as wrkname,*/
l.c_doc as c_doc, l.s_doc as s_doc, l.n_doc as n_doc, l.d_doc as d_doc, l.e_doc as e_doc, l.x_doc as x_doc, l.u_doc as u_doc,
m.scn, m.jt, m.form, m.spos, m.predst, m.predstid, m.d_gzk, 
z.blanc
FROM dbo.pers a 
LEFT OUTER JOIN dbo.kms x ON a.vsid=x.recid 
LEFT OUTER JOIN dbo.adr77 b ON a.adr_id=b.recid LEFT OUTER JOIN dbo.adr50 c ON a.adr50_id=c.recid
LEFT OUTER JOIN dbo.enp e ON a.enp2id=e.recid
LEFT OUTER JOIN dbo.docs f ON a.odocid=f.recid LEFT OUTER JOIN dbo.ofio g ON a.ofioid=g.recid 
LEFT OUTER JOIN dbo.osmo h ON a.osmoid=h.recid LEFT OUTER JOIN dbo.docs i ON a.permid=i.recid
LEFT OUTER JOIN dbo.docs l ON a.docid=l.recid 
LEFT OUTER JOIN dbo.moves m ON a.movesid=m.recid LEFT OUTER JOIN dbo.predst d ON m.predstid=d.recid 
LEFT OUTER JOIN dbo.auxinfo v ON a.auxid=v.recid LEFT OUTER JOIN dbo.moves w ON a.movesid=w.recid 
LEFT OUTER JOIN dbo.fio y ON a.fioid=y.recid 
LEFT OUTER JOIN dbo.enp z ON a.enpid=z.recid  
*/

-- Proc dbo.AddPerson
IF OBJECT_ID('dbo.AddPerson','P') IS NOT NULL DROP PROCEDURE dbo.AddPerson
GO
CREATE PROCEDURE dbo.AddPerson (@status tinyint=0, @snils varchar(14)=null, @dr date=null, @true_dr tinyint=1, @w tinyint=0,
	@pv char(3)=null, @nz varchar(5)=null, @kl tinyint=null, @cont varchar(40)=null, @gr char(3)=null, @mr varchar(max)=null, @comment varchar(max)=null, @ktg varchar(1)=null, @lpuid dec(4)=null,
	@fam varchar(40)=null, @d_fam char(1)=null, @im varchar(40)=null, @d_im char(1)=null, @ot varchar(40)=null, @d_ot char(1)=null, 
	@ofam varchar(40)=null, @oim varchar(40)=null, @oot varchar(40)=null,
	@photo varbinary(max)=null, @sign varbinary(max)=null, @oper tinyint=0, @operpv tinyint=0,
	@s_vs varchar(12)=null, @n_vs varchar(32)=null, @vs_dp date=null, @vs_dt date=null, 
	@s_kms varchar(12)=null, @n_kms varchar(32)=null, @kmsogrn varchar(13)='1025004642519', @kmsokato varchar(5)='45000', @kms_dp date=null, @kms_dt date=null, @kms_dr date=null,
	@s_okms varchar(12)=null, @n_okms varchar(32)=null, @okmsogrn varchar(13)='1025004642519', @okmsokato varchar(5)='45000', @okms_dp date=null, @okms_dt date=null, @okms_dr date=null,
	@enp varchar(16)=null, @blanc varchar(11)=null, @enpogrn varchar(13)=null, @enpokato varchar(5)=null, @enp_dp date=null, @enp_dt date=null, @enp_dr date=null,
	@enp2 varchar(16)=null, @blanc2 varchar(11)=null, @enp2ogrn varchar(13)=null, @enp2okato varchar(5)=null, @enp2_dp date=null, @enp2_dt date=null,
	@c_doc tinyint=null, @s_doc varchar(9)=null, @n_doc varchar(8)=null, @d_doc date=null, @e_doc date=null, @u_doc varchar(max)=null, @x_doc tinyint=0,
	@c_perm tinyint=null, @s_perm varchar(9)=null, @n_perm varchar(8)=null, @d_perm date=null, @e_perm date=null,
	@oc_doc tinyint=null, @os_doc varchar(9)=null, @on_doc varchar(8)=null, @od_doc date=null, @oe_doc date=null, @ou_doc varchar(max)=null, @ox_doc tinyint=0,
	@ul int=null, @dom varchar(7)=null, @kor varchar(5)=null, @str varchar(5)=null, @kv varchar(5)=null, @d_reg77 date=null,
	@c_okato varchar(5)=null, @ra_name varchar(60)=null, @np_c tinyint=null, @np_name varchar(60)=null, @ul_c tinyint=null, @ul_name varchar(60)=null,
	@dom50 varchar(7)=null, @kor50 varchar(5)=null, @str50 varchar(5)=null, @kv50 varchar(5)=null, @d_reg50 date=null,
	@out_id int OUTPUT)
AS
BEGIN TRY
	BEGIN TRANSACTION

	DECLARE @recid int, @vsid int, @kmsid  int, @okmsid int, @enpid int, @oenpid int, @enp2id int, @docid int, 
		@odocid int, @permid int, @fioid int, @ofioid int, @adr_id int, @adr50_id int, @auxid int

    INSERT INTO dbo.pers (status,snils,dr,true_dr,w) VALUES 
		(COALESCE(@status,0), @snils, @dr,COALESCE(@true_dr, 1),@w)
	SET @recid=@@IDENTITY

	--ФИО
	IF (@fioid is null OR @fioid=0) AND (@fam is not null and @fam!='')
	 BEGIN
      INSERT INTO dbo.fio (id,fam,d_fam,im,d_im,ot,d_ot) VALUES (@recid,@fam,coalesce(@d_fam,' '),@im,coalesce(@d_im,' '),@ot,coalesce(@d_ot,' '))
      SET @fioid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET fioid=@fioid WHERE recid=@recid
	 END 
	--ФИО
	--Старые ФИО
	IF (@ofioid is null OR @ofioid=0) AND ((@ofam is not null and @ofam!='') or (@oim is not null and @oim!='') or (@oot is not null and @oot!=''))
	 BEGIN
      INSERT INTO dbo.ofio (id,fam,im,ot) VALUES (@recid,@ofam,@oim,@oot)
      SET @ofioid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET ofioid=@ofioid WHERE recid=@recid
	 END 
	--Старые ФИО
	--ВС
	IF (@vsid is null OR @vsid=0) AND (@n_vs is not null)
	 BEGIN
      INSERT INTO dbo.kms (id, tip, s_card, n_card, dp, dt) VALUES (@recid, 1, @s_vs, @n_vs, @vs_dp, @vs_dt)
      SET @vsid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET vs=@n_vs, vsid=@vsid WHERE recid=@recid
	 END 
	--ВС
	--КМС
	IF (@kmsid is null OR @kmsid=0) AND (@n_kms is not null)
	 BEGIN
     INSERT INTO dbo.kms (id, tip, s_card, n_card, ogrn, okato, dp, dt, dr) VALUES (@recid, 2, @s_kms, @n_kms, @kmsogrn, @kmsokato, @kms_dp, @kms_dt, @kms_dr)
      SET @kmsid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET sn_card=@s_kms+@n_kms, kmsid=@kmsid WHERE recid=@recid
	 END 
	--КМС
	--Старый КМС
	IF (@okmsid is null OR @okmsid=0) AND (@n_okms is not null)
	 BEGIN
      INSERT INTO dbo.kms (id, tip, s_card, n_card, dp, dt, dr) VALUES (@recid, 3, @s_okms, @n_okms, @okms_dp, @okms_dt, @okms_dr)
      SET @okmsid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET okmsid=@okmsid WHERE recid=@recid
	 END 
	--Старый КМС
	--Основной документ
	IF (@docid is null OR @docid=0) AND (@n_doc is not null)
	 BEGIN
      INSERT INTO dbo.docs (id, tip, c_doc, s_doc, n_doc, d_doc, e_doc, u_doc, x_doc) VALUES 
		(@recid, 1, @c_doc, @s_doc, @n_doc, @d_doc, @e_doc, @u_doc, @x_doc)
      SET @docid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET docid=@docid WHERE recid=@recid
	 END 
	--Основной документ
	--Разрешение на проживание
	IF (@permid is null OR @permid=0) AND (@n_perm is not null)
	 BEGIN
      INSERT INTO dbo.docs (id, tip, c_doc, s_doc, n_doc, d_doc, e_doc) VALUES 
		(@recid, 2, @c_perm, @s_perm, @n_perm, @d_perm, @e_perm)
      SET @permid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET permid=@permid WHERE recid=@recid
	 END 
	--Разрешение на проживание
	--Старый документ
	IF (@odocid is null OR @odocid=0) AND (@on_doc is not null)
	 BEGIN
      INSERT INTO dbo.docs (id, tip, c_doc, s_doc, n_doc, d_doc, e_doc, u_doc, x_doc) VALUES 
		(@recid, 3, @oc_doc, @os_doc, @on_doc, @od_doc, @oe_doc, @ou_doc, @ox_doc)
      SET @odocid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET odocid=@odocid WHERE recid=@recid
	 END 
	--Старый документ
	--ЕНП
	IF (@enpid is null OR @enpid=0) AND (@enp is not null)
	 BEGIN
	  IF @enpogrn is null and @enpokato is null
       INSERT INTO dbo.enp (id, tip, enp, blanc, dp, dt) VALUES (@recid, 1, @enp, @blanc, @enp_dp, @enp_dt)
	  ELSE IF @enpogrn is null and @enpokato is not null
       INSERT INTO dbo.enp (id, tip, enp, blanc, okato, dp, dt) VALUES (@recid, 1, @enp, @blanc, @enpokato, @enp_dp, @enp_dt)
	  ELSE IF @enpogrn is not null and @enpokato is null
       INSERT INTO dbo.enp (id, tip, enp, blanc, ogrn, dp, dt) VALUES (@recid, 1, @enp, @blanc, @enpogrn, @enp_dp, @enp_dt)
	  ELSE IF @enpogrn is not null and @enpokato is not null
       INSERT INTO dbo.enp (id, tip, enp, blanc, okato, ogrn, dp, dt) VALUES (@recid, 1, @enp, @blanc, @enpokato, @enpogrn, @enp_dp, @enp_dt)

      SET @enpid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET enp=@enp, enpid=@enpid WHERE recid=@recid
	 END 
	--ЕНП
	--Второй ЕНП
	IF (@enp2id is null OR @enp2id=0) AND (@enp2 is not null)
	 BEGIN
	  IF @enp2ogrn is null and @enp2okato is null
       INSERT INTO dbo.enp (id, tip, enp, blanc, dp, dt) VALUES (@recid, 2, @enp2, @blanc2, @enp2_dp, @enp2_dt)
	  ELSE IF @enp2ogrn is null and @enp2okato is not null
       INSERT INTO dbo.enp (id, tip, enp, blanc, okato, dp, dt) VALUES (@recid, 2, @enp2, @blanc2,@enp2okato, @enp2_dp, @enp2_dt)
	  ELSE IF @enp2ogrn is not null and @enp2okato is null
       INSERT INTO dbo.enp (id, tip, enp, blanc, ogrn, dp, dt) VALUES (@recid, 2, @enp2, @blanc2, @enp2ogrn, @enp2_dp, @enp2_dt)
	  ELSE IF @enp2ogrn is not null and @enp2okato is not null
       INSERT INTO dbo.enp (id, tip, enp, blanc, okato, ogrn, dp, dt) VALUES (@recid, 2, @enp2, @blanc2, @enp2okato, @enp2ogrn, @enp2_dp, @enp2_dt)

      SET @enp2id = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET enp2id=@enp2id WHERE recid=@recid
	 END 
	--Второй ЕНП
	--Московский адрес
	IF (@adr_id is null OR @adr_id=0) AND (@ul is not null)
	 BEGIN
      INSERT INTO dbo.adr77 (id, ul, dom, kor, [str], kv, d_reg) VALUES (@recid, @ul, @dom, @kor, @str, @kv, @d_reg77)
      SET @adr_id = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET adr_id=@adr_id WHERE recid=@recid
	 END 
	--Московский адрес
	--Иногородний адрес
	IF (@adr50_id is null OR @adr50_id=0) AND (@c_okato!='' and @c_okato is not null)
	 BEGIN
      INSERT INTO dbo.adr50 (id, c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, [str], kv, d_reg) VALUES 
		(@recid, @c_okato, @ra_name, @np_c, @np_name, @ul_c, @ul_name, @dom50, @kor50, @str50, @kv50, @d_reg50)
      SET @adr50_id = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET adr50_id=@adr50_id WHERE recid=@recid
	 END 
	--Иногородний адрес
	-- auxinfo
	IF (@auxid is null OR @auxid=0) AND ((@pv!='' and @pv is not null) or (@nz!='' and @nz is not null) or (@kl is not null) or
		(@cont!='' and @cont is not null) or (@gr!='' and @gr is not null) or (@mr!='' and @mr is not null) or 
		(@comment!='' and @comment is not null) or (@ktg!='' and @ktg is not null) or (@lpuid is not null))
	 BEGIN
      INSERT INTO dbo.auxinfo(id, pv, nz, kl, cont, gr, mr, comment, ktg, lpuid) VALUES 
		(@recid, @pv, @nz, coalesce(@kl,0), @cont, @gr, @mr, @comment, @ktg, @lpuid)
--      SET @auxid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET auxid=SCOPE_IDENTITY() WHERE recid=@recid
	 END 
	-- auxinfo

    COMMIT TRANSACTION
    SET @out_id = SCOPE_IDENTITY()
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
           @ErrSeverity = ERROR_SEVERITY()
	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
GO
-- Proc dbo.AddPerson

-- Proc dbo.ModPerson
IF OBJECT_ID('dbo.ModPerson','P') IS NOT NULL DROP PROCEDURE dbo.ModPerson
GO
CREATE PROCEDURE dbo.ModPerson (@recid int=0, @status tinyint=0, @snils varchar(14)=null, @dr date=null, @true_dr tinyint=1, @w tinyint=0,
	@pv char(3)=null, @nz varchar(5)=null, @kl tinyint=null, @cont varchar(40)=null, @gr char(3)=null, @mr varchar(max)=null, @comment varchar(max)=null, @ktg varchar(1)=null, @lpuid dec(4)=null,
	@fam varchar(40)=null, @d_fam char(1)=null, @im varchar(40)=null, @d_im char(1)=null, @ot varchar(40)=null, @d_ot char(1)=null, 
	@ofam varchar(40)=null, @oim varchar(40)=null, @oot varchar(40)=null,
	@photo varbinary(max)=null, @sign varbinary(max)=null, @oper tinyint=0, @operpv tinyint=0,
	@s_vs varchar(12)=null, @n_vs varchar(32)=null, @vs_dp date=null, @vs_dt date=null, 
	@s_kms varchar(12)=null, @n_kms varchar(32)=null, @kmsogrn varchar(13)='1025004642519', @kmsokato varchar(5)='45000', @kms_dp date=null, @kms_dt date=null, @kms_dr date=null,
	@s_okms varchar(12)=null, @n_okms varchar(32)=null, @okmsogrn varchar(13)='1025004642519', @okmsokato varchar(5)='45000', @okms_dp date=null, @okms_dt date=null, @okms_dr date=null,
	@enp varchar(16)=null, @blanc varchar(11)=null, @enpogrn varchar(13)=null, @enpokato varchar(5)=null, @enp_dp date=null, @enp_dt date=null, @enp_dr date=null,
	@enp2 varchar(16)=null, @blanc2 varchar(11)=null, @enp2ogrn varchar(13)=null, @enp2okato varchar(5)=null, @enp2_dp date=null, @enp2_dt date=null,
	@c_doc tinyint=null, @s_doc varchar(9)=null, @n_doc varchar(8)=null, @d_doc date=null, @e_doc date=null, @u_doc varchar(max)=null, @x_doc tinyint=0,
	@c_perm tinyint=null, @s_perm varchar(9)=null, @n_perm varchar(8)=null, @d_perm date=null, @e_perm date=null,
	@oc_doc tinyint=null, @os_doc varchar(9)=null, @on_doc varchar(8)=null, @od_doc date=null, @oe_doc date=null, @ou_doc varchar(max)=null, @ox_doc tinyint=0,
	@ul int=null, @dom varchar(7)=null, @kor varchar(5)=null, @str varchar(5)=null, @kv varchar(5)=null, @d_reg77 date=null,
	@c_okato varchar(5)=null, @ra_name varchar(60)=null, @np_c tinyint=null, @np_name varchar(60)=null, @ul_c tinyint=null, @ul_name varchar(60)=null,
	@dom50 varchar(7)=null, @kor50 varchar(5)=null, @str50 varchar(5)=null, @kv50 varchar(5)=null, @d_reg50 date=null)
AS
BEGIN TRY
	BEGIN TRANSACTION
	IF (@recid IS NULL OR @recid=0) BEGIN RAISERROR(90001, 16, 1) RETURN END 

	DECLARE @vsid   int = (SELECT vsid   FROM dbo.pers WHERE recid=@recid)
	DECLARE @kmsid  int = (SELECT kmsid  FROM dbo.pers WHERE recid=@recid)
	DECLARE @okmsid int = (SELECT okmsid FROM dbo.pers WHERE recid=@recid)

	DECLARE @enpid  int = (SELECT enpid FROM dbo.pers WHERE recid=@recid)
	DECLARE @oenpid int = (SELECT oenpid FROM dbo.pers WHERE recid=@recid)
	DECLARE @enp2id int = (SELECT enp2id FROM dbo.pers WHERE recid=@recid)

	DECLARE @docid  int = (SELECT docid  FROM dbo.pers WHERE recid=@recid)
	DECLARE @odocid int = (SELECT odocid FROM dbo.pers WHERE recid=@recid)
	DECLARE @permid int = (SELECT permid FROM dbo.pers WHERE recid=@recid)

	DECLARE @fioid int  = (SELECT fioid FROM dbo.pers WHERE recid=@recid)
	DECLARE @ofioid int = (SELECT ofioid FROM dbo.pers WHERE recid=@recid)

	DECLARE @adr_id int   = (SELECT adr_id   FROM dbo.pers WHERE recid=@recid)
	DECLARE @adr50_id int = (SELECT adr50_id FROM dbo.pers WHERE recid=@recid)

	DECLARE @auxid int = (SELECT auxid FROM dbo.pers WHERE recid=@recid)

	--ФИО
	IF (@fioid is null OR @fioid=0) AND (@fam is not null and @fam!='')
	 BEGIN
      INSERT INTO dbo.fio (id,fam,d_fam,im,d_im,ot,d_ot) VALUES (@recid,@fam,coalesce(@d_fam,' '),@im,coalesce(@d_im,' '),@ot,coalesce(@d_ot,' '))
      SET @fioid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET fioid=@fioid WHERE recid=@recid
	 END 

	ELSE IF (@fioid is not null and @fioid>0) AND ((@fam!='' and @fam is not null) or (@im!='' and @im is not null) or (@ot!='' and @ot is not null))
     BEGIN
	  UPDATE dbo.fio SET fam=COALESCE(@fam, fam), im=COALESCE(@im, im), ot=COALESCE(@ot, ot) WHERE recid=@fioid
      SET @fioid = @@IDENTITY
	  UPDATE dbo.pers SET fioid=@fioid WHERE recid=@recid
	 END 

	ELSE IF (@fioid is not null and @fioid>0) AND (@fam='')
     BEGIN
	  DELETE FROM dbo.fio WHERE recid=@fioid
      SET @fioid = NULL
	 END 
	--ФИО
	--Старые ФИО
	IF (@ofioid is null OR @ofioid=0) AND ((@ofam is not null and @ofam!='') or (@oim is not null and @oim!='') or (@oot is not null and @oot!=''))
	 BEGIN
      INSERT INTO dbo.ofio (id,fam,im,ot) VALUES (@recid,@ofam,@oim,@oot)
      SET @ofioid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET ofioid=@ofioid WHERE recid=@recid
	 END 

	ELSE IF (@ofioid is not null and @ofioid>0) AND ((@ofam!='' and @ofam is not null) or (@oim!='' and @oim is not null) or (@oot!='' and @oot is not null))
     BEGIN
	  UPDATE dbo.ofio SET fam=COALESCE(@ofam, fam), im=COALESCE(@oim, im), ot=COALESCE(@oot, ot) WHERE recid=@ofioid
      SET @ofioid = @@IDENTITY
	  UPDATE dbo.pers SET ofioid=@ofioid WHERE recid=@recid
	 END 

	ELSE IF (@ofioid is not null and @ofioid>0) AND (@ofam='' and @oim='' and @oot='') 
     BEGIN
	  DELETE FROM dbo.ofio WHERE recid=@ofioid
      SET @ofioid = NULL
	 END 
	--Старые ФИО
	--ВС
	IF (@vsid is null OR @vsid=0) AND (@n_vs is not null)
	 BEGIN
      INSERT INTO dbo.kms (id, tip, s_card, n_card, dp, dt) VALUES (@recid, 1, @s_vs, @n_vs, @vs_dp, @vs_dt)
      SET @vsid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET vs=@n_vs, vsid=@vsid WHERE recid=@recid
	 END 

	ELSE IF (@vsid is not null and @vsid>0) AND ((@s_vs!='' and @s_vs is not null) or (@s_vs!='' and @s_vs is not null) or (@vs_dp is not null) or (@vs_dt is not null))
     BEGIN
	  UPDATE dbo.kms SET s_card=COALESCE(@s_vs, s_card), n_card=COALESCE(@n_vs, n_card), dp=COALESCE(@vs_dp, dp), dt=COALESCE(@vs_dt, dt) WHERE recid=@vsid
      SET @vsid = @@IDENTITY
	  UPDATE dbo.pers SET vs=coalesce(@n_vs,vs), vsid=@vsid WHERE recid=@recid
	 END 

	ELSE IF (@vsid is not null and @vsid>0) AND (@n_vs='')
     BEGIN
	  DELETE FROM dbo.kms WHERE recid=@vsid
      SET @vsid = NULL
	 END 
	--ВС
	--КМС
	IF (@kmsid is null OR @kmsid=0) AND (@n_kms is not null)
	 BEGIN
     INSERT INTO dbo.kms (id, tip, s_card, n_card, ogrn, okato, dp, dt, dr) VALUES (@recid, 2, @s_kms, @n_kms, @kmsogrn, @kmsokato, @kms_dp, @kms_dt, @kms_dr)
      SET @kmsid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET sn_card=@s_kms+@n_kms, kmsid=@kmsid WHERE recid=@recid
	 END 

	ELSE IF (@kmsid is not null and @kmsid>0) AND ((@s_kms!='' and @s_kms is not null) or (@n_kms!='' and @n_kms is not null) or (@kms_dp is not null) or (@kms_dt is not null) or (@kms_dr is not null))
     BEGIN
	  UPDATE dbo.kms SET s_card=COALESCE(@s_kms, s_card), n_card=COALESCE(@n_kms, n_card), ogrn=COALESCE(@kmsogrn, ogrn),
	   okato=COALESCE(@kmsokato, okato), dp=COALESCE(@kms_dp, dp), dt=COALESCE(@kms_dt, dt), dr=COALESCE(@kms_dr, dr) WHERE recid=@kmsid
      SET @kmsid = @@IDENTITY
	  UPDATE dbo.pers SET sn_card=coalesce(@s_kms+@n_kms,sn_card), kmsid=@kmsid WHERE recid=@recid
	 END 

	ELSE IF (@kmsid is not null and @kmsid>0) AND (@n_kms='')
     BEGIN
	  DELETE FROM dbo.kms WHERE recid=@kmsid
      SET @kmsid = NULL
	 END 
	--КМС
	--Старый КМС
	IF (@okmsid is null OR @okmsid=0) AND (@n_okms is not null)
	 BEGIN
      INSERT INTO dbo.kms (id, tip, s_card, n_card, dp, dt, dr) VALUES (@recid, 3, @s_okms, @n_okms, @okms_dp, @okms_dt, @okms_dr)
      SET @okmsid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET okmsid=@okmsid WHERE recid=@recid
	 END 

	ELSE IF (@okmsid is not null and @okmsid>0) AND ((@s_okms!='' and @s_okms is not null) or (@n_okms!='' and @n_okms is not null) or (@okms_dp is not null) or (@okms_dt is not null) or (@okms_dr is not null))
     BEGIN
	  UPDATE dbo.kms SET s_card=COALESCE(@s_okms, s_card), n_card=COALESCE(@n_okms, n_card), ogrn=COALESCE(@okmsogrn, ogrn),
	   okato=COALESCE(@okmsokato, okato), dp=COALESCE(@okms_dp, dp), dt=COALESCE(@okms_dt, dt), dr=COALESCE(@okms_dr, dr) WHERE recid=@okmsid
      SET @okmsid = @@IDENTITY
	  UPDATE dbo.pers SET okmsid=@okmsid WHERE recid=@recid
	 END 

	ELSE IF (@okmsid is not null and @okmsid>0) AND (@n_okms='')
     BEGIN
	  DELETE FROM dbo.kms WHERE recid=@okmsid
      SET @okmsid = NULL
	 END 
	--Старый КМС
	--Основной документ
	IF (@docid is null OR @docid=0) AND (@n_doc is not null)
	 BEGIN
      INSERT INTO dbo.docs (id, tip, c_doc, s_doc, n_doc, d_doc, e_doc, u_doc, x_doc) VALUES 
		(@recid, 1, @c_doc, @s_doc, @n_doc, @d_doc, @e_doc, @u_doc, @x_doc)
      SET @docid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET docid=@docid WHERE recid=@recid
	 END 

	ELSE IF (@docid is not null and @docid>0) AND ((@c_doc is not null) or (@s_doc!='' and @s_doc is not null) or (@n_doc!='' and @n_doc is not null) or
		(@d_doc is not null) or (@e_doc is not null) or (@u_doc!='' and @u_doc is not null) or (@x_doc!=0))
     BEGIN
	  UPDATE dbo.docs SET c_doc=COALESCE(@c_doc, c_doc),s_doc=COALESCE(@s_doc, s_doc), n_doc=COALESCE(@n_doc, n_doc), d_doc=COALESCE(@d_doc, d_doc),
		e_doc=COALESCE(@e_doc, e_doc), u_doc=COALESCE(@u_doc, u_doc), x_doc=COALESCE(@x_doc, x_doc) WHERE recid=@docid
      SET @docid = @@IDENTITY
	  UPDATE dbo.pers SET docid=@docid WHERE recid=@recid
	 END 

	ELSE IF (@docid is not null and @docid>0) AND (@n_doc='')
     BEGIN
	  DELETE FROM dbo.docs WHERE recid=@docid
      SET @docid = NULL
	 END 
	--Основной документ
	--Разрешение на проживание
	IF (@permid is null OR @permid=0) AND (@n_perm is not null)
	 BEGIN
      INSERT INTO dbo.docs (id, tip, c_doc, s_doc, n_doc, d_doc, e_doc) VALUES 
		(@recid, 2, @c_perm, @s_perm, @n_perm, @d_perm, @e_perm)
      SET @permid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET permid=@permid WHERE recid=@recid
	 END 

	ELSE IF (@permid is not null and @permid>0) AND ((@c_perm is not null) or (@s_perm!='' and @s_perm is not null) or (@n_perm!='' and @n_perm is not null) or
		(@d_perm is not null) or (@e_perm is not null))
     BEGIN
	  UPDATE dbo.docs SET c_doc=COALESCE(@c_perm, c_doc),s_doc=COALESCE(@s_perm, s_doc), n_doc=COALESCE(@n_perm, n_doc), d_doc=COALESCE(@d_perm, d_doc),
		e_doc=COALESCE(@e_perm, e_doc) WHERE recid=@permid
      SET @permid = @@IDENTITY
	  UPDATE dbo.pers SET permid=@permid WHERE recid=@recid
	 END 

	ELSE IF (@permid is not null and @permid>0) AND (@n_perm='')
     BEGIN
	  DELETE FROM dbo.docs WHERE recid=@permid
      SET @permid = NULL
	 END 
	--Разрешение на проживание
	--Старый документ
	IF (@odocid is null OR @odocid=0) AND (@on_doc is not null)
	 BEGIN
      INSERT INTO dbo.docs (id, tip, c_doc, s_doc, n_doc, d_doc, e_doc, u_doc, x_doc) VALUES 
		(@recid, 3, @oc_doc, @os_doc, @on_doc, @od_doc, @oe_doc, @ou_doc, @ox_doc)
      SET @odocid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET odocid=@odocid WHERE recid=@recid
	 END 

	ELSE IF (@odocid is not null and @odocid>0) AND ((@oc_doc is not null) or (@os_doc!='' and @os_doc is not null) or (@on_doc!='' and @on_doc is not null) or
		(@od_doc is not null) or (@oe_doc is not null) or (@ou_doc!='' and @ou_doc is not null) or (@ox_doc!=0))
     BEGIN
	  UPDATE dbo.docs SET c_doc=COALESCE(@oc_doc, c_doc),s_doc=COALESCE(@os_doc, s_doc), n_doc=COALESCE(@on_doc, n_doc), d_doc=COALESCE(@od_doc, d_doc),
		e_doc=COALESCE(@oe_doc, e_doc), u_doc=COALESCE(@ou_doc, u_doc), x_doc=COALESCE(@ox_doc, x_doc) WHERE recid=@odocid
      SET @odocid = @@IDENTITY
	  UPDATE dbo.pers SET odocid=@odocid WHERE recid=@recid
	 END 

	ELSE IF (@odocid is not null and @odocid>0) AND (@on_doc='')
     BEGIN
	  DELETE FROM dbo.docs WHERE recid=@odocid
      SET @odocid = NULL
	 END 
	--Старый документ
	--ЕНП
	IF (@enpid is null OR @enpid=0) AND (@enp is not null)
	 BEGIN
	  IF @enpogrn is null and @enpokato is null
       INSERT INTO dbo.enp (id, tip, enp, blanc, dp, dt) VALUES (@recid, 1, @enp, @blanc, @enp_dp, @enp_dt)
	  ELSE IF @enpogrn is null and @enpokato is not null
       INSERT INTO dbo.enp (id, tip, enp, blanc, okato, dp, dt) VALUES (@recid, 1, @enp, @blanc, @enpokato, @enp_dp, @enp_dt)
	  ELSE IF @enpogrn is not null and @enpokato is null
       INSERT INTO dbo.enp (id, tip, enp, blanc, ogrn, dp, dt) VALUES (@recid, 1, @enp, @blanc, @enpogrn, @enp_dp, @enp_dt)
	  ELSE IF @enpogrn is not null and @enpokato is not null
       INSERT INTO dbo.enp (id, tip, enp, blanc, okato, ogrn, dp, dt) VALUES (@recid, 1, @enp, @blanc, @enpokato, @enpogrn, @enp_dp, @enp_dt)

      SET @enpid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET enp=@enp, enpid=@enpid WHERE recid=@recid
	 END 

	ELSE IF (@enpid is not null and @enpid>0) AND ((@enp!='' and @enp is not null) or (@blanc!='' and @blanc is not null) or 
		(@enpogrn!='' and @enpogrn is not null) or (@enpokato!='' and @enpokato is not null) or (@enp_dp is not null) or 
		(@enp_dt is not null) or (@enp_dr is not null))
     BEGIN
	 UPDATE dbo.enp SET enp=COALESCE(@enp,enp), blanc=COALESCE(@blanc,blanc), ogrn=COALESCE(@enpogrn,ogrn),
	  okato=COALESCE(@enpokato,okato), dp=COALESCE(@enp_dp,dp), dt=COALESCE(@enp_dt,dt), dr=COALESCE(@enp_dr,dr) WHERE recid=@enpid
      SET @enpid = @@IDENTITY
	  UPDATE dbo.pers SET enp=coalesce(@enp,enp), enpid=@enpid WHERE recid=@recid
	 END 

	ELSE IF (@enpid is not null and @enpid>0) AND (@enp='')
     BEGIN
	  DELETE FROM dbo.enp WHERE recid=@enpid
      SET @enpid = NULL
	 END 
	--ЕНП
	--Второй ЕНП
	IF (@enp2id is null OR @enp2id=0) AND (@enp2 is not null)
	 BEGIN
	  IF @enp2ogrn is null and @enp2okato is null
       INSERT INTO dbo.enp (id, tip, enp, blanc, dp, dt) VALUES (@recid, 2, @enp2, @blanc2, @enp2_dp, @enp2_dt)
	  ELSE IF @enp2ogrn is null and @enp2okato is not null
       INSERT INTO dbo.enp (id, tip, enp, blanc, okato, dp, dt) VALUES (@recid, 2, @enp2, @blanc2,@enp2okato, @enp2_dp, @enp2_dt)
	  ELSE IF @enp2ogrn is not null and @enp2okato is null
       INSERT INTO dbo.enp (id, tip, enp, blanc, ogrn, dp, dt) VALUES (@recid, 2, @enp2, @blanc2, @enp2ogrn, @enp2_dp, @enp2_dt)
	  ELSE IF @enp2ogrn is not null and @enp2okato is not null
       INSERT INTO dbo.enp (id, tip, enp, blanc, okato, ogrn, dp, dt) VALUES (@recid, 2, @enp2, @blanc2, @enp2okato, @enp2ogrn, @enp2_dp, @enp2_dt)

      SET @enp2id = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET enp2id=@enp2id WHERE recid=@recid
	 END 

	ELSE IF (@enp2id is not null and @enp2id>0) AND ((@enp2!='' and @enp2 is not null) or (@blanc2!='' and @blanc2 is not null) or 
		(@enp2ogrn!='' and @enp2ogrn is not null) or (@enp2okato!='' and @enp2okato is not null) or (@enp2_dp is not null) or 
		(@enp2_dt is not null))
     BEGIN
	 UPDATE dbo.enp SET enp=COALESCE(@enp2,enp), blanc=COALESCE(@blanc2,blanc), ogrn=COALESCE(@enp2ogrn,ogrn),
	  okato=COALESCE(@enp2okato,okato), dp=COALESCE(@enp2_dp,dp), dt=COALESCE(@enp2_dt,dt) WHERE recid=@enp2id
      SET @enp2id = @@IDENTITY
	  UPDATE dbo.pers SET enp2id=@enp2id WHERE recid=@recid
	 END 

	ELSE IF (@enp2id is not null and @enp2id>0) AND (@enp2='')
     BEGIN
	  DELETE FROM dbo.enp WHERE recid=@enp2id
      SET @enp2id = NULL
	 END 
	--Второй ЕНП
	--Московский адрес
	IF (@adr_id is null OR @adr_id=0) AND (@ul is not null)
	 BEGIN
      INSERT INTO dbo.adr77 (id, ul, dom, kor, [str], kv, d_reg) VALUES (@recid, @ul, @dom, @kor, @str, @kv, @d_reg77)
      SET @adr_id = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET adr_id=@adr_id WHERE recid=@recid
	 END 

	ELSE IF (@adr_id is not null and @adr_id>0) AND ((@ul is not null) or (@dom!='' and @dom is not null) or 
		(@kor!='' and @kor is not null) or (@str!='' and @str is not null) or (@kv!='' and @kv is not null) or 
		(@d_reg77 is not null))
     BEGIN
	 UPDATE dbo.adr77 SET ul=COALESCE(@ul,ul), dom=COALESCE(@dom,dom), kor=COALESCE(@kor,kor),
	  str=COALESCE(@str,str), kv=COALESCE(@kv,kv), d_reg=COALESCE(@d_reg77,d_reg) WHERE recid=@adr_id
      SET @adr_id = @@IDENTITY
	  UPDATE dbo.pers SET adr_id=@adr_id WHERE recid=@recid
	 END 

	ELSE IF (@adr_id is not null and @adr_id>0) AND (@ul=0)
     BEGIN
	  DELETE FROM dbo.adr77 WHERE recid=@adr_id
      SET @adr_id = NULL
	 END 
	--Московский адрес
	--Иногородний адрес
	IF (@adr50_id is null OR @adr50_id=0) AND (@c_okato!='' and @c_okato is not null)
	 BEGIN
      INSERT INTO dbo.adr50 (id, c_okato, ra_name, np_c, np_name, ul_c, ul_name, dom, kor, [str], kv, d_reg) VALUES 
		(@recid, @c_okato, @ra_name, @np_c, @np_name, @ul_c, @ul_name, @dom50, @kor50, @str50, @kv50, @d_reg50)
      SET @adr50_id = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET adr50_id=@adr50_id WHERE recid=@recid
	 END 

	ELSE IF (@adr50_id is not null and @adr50_id>0) AND ((@c_okato!='' and @c_okato is not null) or (@ra_name!='' and @ra_name is not null) or
		(@np_c is not null) or (@np_name!='' and @np_name is not null) or (@ul_c is not null) or (@np_name!='' and @np_name is not null) or 
		(@dom50!='' and @dom50 is not null) or (@kor50!='' and @kor50 is not null) or (@str50!='' and @str50 is not null) or 
		(@kv50!='' and @kv50 is not null) or (@d_reg50 is not null))
     BEGIN
	 UPDATE dbo.adr50 SET c_okato=COALESCE(@c_okato,c_okato), ra_name=COALESCE(@ra_name,ra_name), np_c=COALESCE(@np_c,np_c),
	  np_name=COALESCE(@np_name,np_name), ul_c=COALESCE(@ul_c,ul_c), ul_name=COALESCE(@ul_name,ul_name), dom=COALESCE(@dom50,dom),
	  kor=COALESCE(@kor50,kor), str=COALESCE(@str50,str), kv=COALESCE(@kv50,kv), d_reg=COALESCE(@d_reg50,d_reg)
	  WHERE recid=@adr50_id
      SET @adr50_id = @@IDENTITY
	  UPDATE dbo.pers SET adr50_id=@adr50_id WHERE recid=@recid
	 END 

	ELSE IF (@adr50_id is not null and @adr50_id>0) AND (@c_okato='')
     BEGIN
	  DELETE FROM dbo.adr50 WHERE recid=@adr50_id
      SET @adr50_id = NULL
	 END 
	--Иногородний адрес
	-- auxinfo
	IF (@auxid is null OR @auxid=0) AND ((@pv!='' and @pv is not null) or (@nz!='' and @nz is not null) or (@kl is not null) or
		(@cont!='' and @cont is not null) or (@gr!='' and @gr is not null) or (@mr!='' and @mr is not null) or 
		(@comment!='' and @comment is not null) or (@ktg!='' and @ktg is not null) or (@lpuid is not null))
	 BEGIN
      INSERT INTO dbo.auxinfo(id, pv, nz, kl, cont, gr, mr, comment, ktg, lpuid) VALUES 
		(@recid, @pv, @nz, coalesce(@kl,0), @cont, @gr, @mr, @comment, @ktg, @lpuid)
      SET @auxid = SCOPE_IDENTITY()
	  UPDATE dbo.pers SET auxid=@auxid WHERE recid=@recid
	 END 

	ELSE IF (@auxid is not null and @auxid>0) AND ((@pv!='' and @pv is not null) or (@nz!='' and @nz is not null) or (@kl is not null) or
		(@cont!='' and @cont is not null) or (@gr!='' and @gr is not null) or (@mr!='' and @mr is not null) or (@comment!='' and @comment is not null) or
		(@ktg!='' and @ktg is not null) or (@lpuid is not null))
     BEGIN
	 UPDATE dbo.auxinfo SET pv=COALESCE(@pv,pv), nz=COALESCE(@nz,nz), kl=COALESCE(@kl,kl),
	  cont=COALESCE(@cont,cont), gr=COALESCE(@gr,gr), mr=COALESCE(@mr,mr), comment=COALESCE(@comment,comment),
	  ktg=COALESCE(@ktg,ktg), lpuid=COALESCE(@lpuid,lpuid) WHERE recid=@auxid
      SET @auxid = @@IDENTITY
	  UPDATE dbo.pers SET auxid=@auxid WHERE recid=@recid
	 END 
   -- auxinfo

    UPDATE dbo.pers SET status=COALESCE(@status,status), snils=COALESCE(@snils,snils), dr=COALESCE(@dr,dr), true_dr=COALESCE(@true_dr, true_dr), 
		w=COALESCE(@w,w) WHERE recid=@recid

    COMMIT TRANSACTION
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
    ROLLBACK
	DECLARE @ErrMsg nvarchar(4000), @ErrSeverity int
	SELECT @ErrMsg = ERROR_MESSAGE(),
           @ErrSeverity = ERROR_SEVERITY()
	RAISERROR(@ErrMsg, @ErrSeverity, 1)
END CATCH
GO
-- Proc dbo.ModPerson

print 'Dont forget to run EnableTrigeers!'