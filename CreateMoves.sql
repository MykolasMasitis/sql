USE [kms]
GO

DECLARE @table sysname
SET @table = 'dbo.moves'
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE [dbo].[moves]

CREATE TABLE moves (recid int identity(1,1), kmsid int, frecid char(6),
 et char(1), fname varchar(25), mkdate smalldatetime, vs varchar(9), s_card varchar(6), n_card int,
 c_okato varchar(5), enp varchar(16), dp date, jt char(1), scn varchar(3), pricin varchar(3), tranz varchar(3),
 q varchar(2), err varchar(5), err_text varchar(max), ans_fl varchar(2), nz tinyint, n_kor int, fam varchar(25),
 im varchar(20), ot varchar(20), w Sex, dr date, c_doc tinyint, s_doc varchar(9), n_doc varchar(8), d_doc date,
 e_doc date, created datetime default sysdatetime(),
 CONSTRAINT [PK_moves] PRIMARY KEY CLUSTERED ([recid] ASC))

CREATE INDEX kmsid ON moves (kmsid)
CREATE INDEX fiorecid ON moves (kmsid) WHERE et='1'
CREATE INDEX ffrecid ON moves (kmsid) WHERE et='2'
CREATE INDEX unik ON moves (fname, frecid)
GO