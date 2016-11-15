-- The second step of creating Database KMS
-- The next (the 3rd) step is perfoming out of VFP module and populate the created here tables
--
SET NOCOUNT ON
GO
USE [kms]
GO

DECLARE @table sysname;
SET @table = 'nsi.status';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.status
CREATE TABLE nsi.status(code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(25), used bit)
INSERT INTO nsi.status VALUES (0,'Не определен',0), (1,'Ожидание подачи',0),(2,'Ожидание ответа',1),
	(3,'Обработана',1),(4,'Полис на изготовлении',1),(5,'Полис получен',1),(6,'Полис выдан',1)
GO

DECLARE @table sysname;
SET @table = 'nsi.codfio';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.codfio
CREATE TABLE nsi.codfio(code char(1) NOT NULL PRIMARY KEY CLUSTERED, name char(45))
INSERT INTO nsi.codfio VALUES (SPACE(1), 'Стандартная запись'),('0', 'Нет отчества/имени'),('1', 'Одна буква в фамилии/имени/отчестве'),
	('2', 'Пробел в фамилии/имени/отчестве'),('3', 'Одна буква+пробел в фамилии/имени/отчестве'),
	('9', 'Повтор реквизитов у разных физических лиц*')
GO

DECLARE @table sysname;
SET @table = 'nsi.predst';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.predst
CREATE TABLE nsi.predst(code tinyint PRIMARY KEY CLUSTERED, name char(30))
INSERT INTO nsi.predst (code,name) VALUES (0, 'Лично'), (1, 'Мать ребёнка'), (2, 'Отец ребёнка'),
	(3,'Иное доверенное лицо'), (4,'Ходатайствующая организация')
GO

DECLARE @table sysname;
SET @table = 'nsi.spos';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.spos
CREATE TABLE nsi.spos (code tinyint PRIMARY KEY CLUSTERED, name char(30))
INSERT INTO nsi.spos (code,name) VALUES (1, 'Лично'), (2, 'Через представителя'), (3, 'Через сайт МГФОМС'),
	(4,'Через Единый портал госуслуг')
GO

DECLARE @table sysname;
SET @table = 'nsi.form';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.form
CREATE TABLE nsi.form (code tinyint PRIMARY KEY CLUSTERED, name char(40))
INSERT INTO nsi.form (code,name) VALUES (1, 'бумажный носитель'), (2, 'электронный полис'), (3, 'УЭК (универсальная электронная карта)')
GO

DECLARE @table sysname;
SET @table = 'nsi.jt';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.jt
CREATE TABLE nsi.jt (code char(1) PRIMARY KEY CLUSTERED, name char(65), [add] bit, [mod] bit, izgt bit)
-- Заполняется модулем импорта kmssql --
GO

DECLARE @table sysname;
SET @table = 'nsi.scenario';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.scenario
CREATE TABLE nsi.scenario (code char(3) PRIMARY KEY CLUSTERED, name char(150),
	ismsk bit NULL, isown bit NULL, isenp bit NULL, izgt bit NULL)
INSERT INTO nsi.scenario VALUES 
('NB','Постановка на учет',1,1,null,1),
('CI','Перерегистрация нового московского полиса без изменения персональных данных',1,0,1,null),
('RI','Перерегистрация нового московского полиса с изменениями персональных данных',1,0,1,1),
('PI','Перерегистрация старого московского полиса без изменения персональных данных',1,0,0,1),
('PRI','Перерегистрация старого московского полиса с изменениями персональных данных',1,0,0,1),
('CT','Перерегистрация нового территориального полиса без изменения персональных данных',0,0,1,null),
('RT','Перерегистрация нового территориального полиса с изменением персональных данных',0,0,1,1),
('PT','Перерегистрация старого территориального полиса на новый без изменения персональных данных',0,0,0,1),
('PRT','Перерегистрация старого территориального полиса на новый с изменением персональных данных',0,0,0,1),
('DP','Изготовление полиса нового образца (по причине порчи/утери или после перерасчета  ЕНП)',1,1,1,1),
('CR','Замена реквизитов, не влекущих замену ЕНП, в новом полисе застахованного лица',1,1,1,1),
('CP','Замена своего старого полиса на новый без изменения персональных данных',1,1,0,1),
('PR','Замена своего старого полиса на новый с изменением персональных данных',1,1,0,1),
('MP','Разрешение дубликатов (объединение двух страховок)',null,null,null,0),
('RD','Разъединение дубликатов застрахованных лиц',null,null,null,0),
('CD','Изменение данных без замены полиса (УДЛ - при получении нового взамен старого или добавление СНИЛС)',1,1,1,0),
('CLR','Снятие с учёта от СМО',1,1,null,0),
('POK','Выдача на руки от СМО',1,1,1,0),
('CPV','Замена половозрастных реквизитов',1,null,null,0),
('AD','Актуализация данных о страховке в РС',1,1,1,0),
('XD','Исправление ошибки, не связанной с изменением состояния на учёте',1,1,1,0)
-- Заполняется модулем импорта kmssql --
GO

DECLARE @table sysname;
SET @table = 'nsi.d_gzk';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.d_gzk
CREATE TABLE nsi.d_gzk (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(75))
INSERT INTO nsi.d_gzk (code,name) VALUES (0, 'в ГОЗНАК на печать не посылать'),
	(1, 'указанный ЕНП должен быть отправлен в ГОЗНАК с признаком печати “впервые”'),
	(2, 'указанный ЕНП должен быть отправлен в ГОЗНАК с признаком печати “повторно”'),
	(3, 'изготовить электронный полис с признаком печати «впервые»'),
	(4, 'изготовить электронный полис с признаком печати «повторно»')
GO

DECLARE @table sysname;
SET @table = 'nsi.true_dr';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.true_dr
CREATE TABLE nsi.true_dr(code tinyint NOT NULL PRIMARY KEY CLUSTERED, name char(25))
INSERT INTO nsi.true_dr VALUES (1,'Дата достоверна'),(2,'Достоверны месяц и год'),(3,'Достоверен год')
GO

DECLARE @table sysname;
SET @table = 'nsi.streets';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.streets
CREATE TABLE nsi.streets(code int, name char(60),
CONSTRAINT [PK_streets] PRIMARY KEY CLUSTERED ([code] ASC))
-- Заполняется в kmssql!
GO

DECLARE @table sysname;
SET @table = 'nsi.countries';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.countries
CREATE TABLE nsi.countries(code char(3), name char(50),
CONSTRAINT [PK_countries] PRIMARY KEY CLUSTERED ([code] ASC))
-- Заполняется в kmssql!
GO

DECLARE @table sysname;
SET @table = 'nsi.kl';
IF OBJECT_ID(@table, 'U') IS NOT NULL DROP TABLE nsi.kl
CREATE TABLE nsi.kl (code tinyint PRIMARY KEY CLUSTERED, name char(40), [tip] tinyint)
INSERT INTO nsi.kl VALUES (0,'Гр. РФ, постоянная регистрация в Москве',1),(45,'Иностранцы, имеющие вид на жительстов',1),
	(73,'Беженцы и переселенцы',1),(77,'Гр. РФ, зарег. в иных субъектах РФ, БОМЖ',1),
	(99,'Иностранцы, временно проживающие в РФ',1)
GO

DECLARE @table sysname;
SET @table = 'nsi.sex';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE [nsi].[sex]
CREATE TABLE [nsi].[sex]([code] tinyint, [name] char(12),
CONSTRAINT [PK_sex] PRIMARY KEY CLUSTERED ([code] ASC))
INSERT INTO [nsi].[sex] (code,name) VALUES (0, 'не определен')
INSERT INTO [nsi].[sex] (code,name) VALUES (1, 'мужской')
INSERT INTO [nsi].[sex] (code,name) VALUES (2, 'женский')
GO
/*
DECLARE @table sysname;
SET @table = 'nsi.permission';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.permission
CREATE TABLE nsi.permission(code tinyint, name char(50),
CONSTRAINT [PK_permission] PRIMARY KEY CLUSTERED (code ASC))
INSERT INTO nsi.permission (code,name) VALUES (0,  'Не определен'), (11, 'Вид на жительство'),
	(23, 'Разрешение на временное проживание')
GO
*/
DECLARE @table sysname;
SET @table = 'nsi.viddocs';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.viddocs
CREATE TABLE nsi.viddocs (code tinyint PRIMARY KEY CLUSTERED, name char(50))
INSERT INTO nsi.viddocs (code,name) VALUES (0,  'Не определен')
GO

DECLARE @table sysname;
SET @table = 'nsi.pvp2';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.pvp2;
CREATE TABLE nsi.pvp2 (code char(3) NOT NULL PRIMARY KEY CLUSTERED, name varchar(50));
INSERT INTO nsi.pvp2 (code,name) VALUES ('000', 'Unknown punkt')
GO

DECLARE @table sysname;
SET @table = 'nsi.nompmmyy';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.nompmmyy;
CREATE TABLE nsi.nompmmyy (s_card char(6), n_card numeric(10), q char(2), enp char(16), vsn char(9), lpu_id numeric(6), date_in date, spos numeric(1));
GO

DECLARE @table sysname;
SET @table = 'nsi.sprlpu';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.sprlpu;
CREATE TABLE nsi.sprlpu (fil_id dec(4) NOT NULL PRIMARY KEY CLUSTERED,
	lpu_id dec(4), mcod char(7), name char(40), fullname char(120));
GO

DECLARE @table sysname;
SET @table = 'nsi.p_doc';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.p_doc;
CREATE TABLE nsi.p_doc (code tinyint NOT NULL PRIMARY KEY CLUSTERED,
	name varchar(10), vid_docu char(1));
GO
INSERT INTO nsi.p_doc VALUES (1,'КМС','С'),(2,'ВС','В'),(3,'ЕНП','П'),(4,'УЭК','К'),(5,'ЭлПолис','Э')
GO

DECLARE @table sysname;
SET @table = 'nsi.okato'
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.okato
CREATE TABLE nsi.okato (c_t tinyint NOT NULL PRIMARY KEY CLUSTERED, okato char(5) NOT NULL, name varchar(40))
GO

DECLARE @table sysname;
SET @table = 'nsi.tersmo'
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.tersmo
CREATE TABLE nsi.tersmo (okato char(5) NOT NULL, ogrn char(15) NOT NULL, c_t tinyint NOT NULL, t_name varchar(40), q_name varchar(150))
GO
ALTER TABLE nsi.tersmo ADD CONSTRAINT PK_tersmo PRIMARY KEY CLUSTERED (okato,ogrn)
GO

--Заполняется модулем импорта kmssql --
DECLARE @table sysname;
SET @table = 'nsi.np_c';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.np_c
CREATE TABLE nsi.np_c (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(6), fname varchar(45))
GO

--Заполняется модулем импорта kmssql --
DECLARE @table sysname;
SET @table = 'nsi.ul_c';
IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.ul_c
CREATE TABLE nsi.ul_c (code tinyint NOT NULL PRIMARY KEY CLUSTERED, name varchar(6), fname varchar(45))
GO

-- Заполняется модулем импорта kmssql --

--DECLARE @table sysname;
--SET @table = 'nsi.mgferrs';
--IF OBJECT_ID(@table) IS NOT NULL AND OBJECTPROPERTY(OBJECT_ID(@table), 'IsTable')=1 DROP TABLE nsi.mgferrs
--CREATE TABLE nsi.mgferrs (code char(2) PRIMARY KEY CLUSTERED, name char(40))
---- Заполняется модулем импорта kmssql --
--GO

print 'Run CreateEntities next!'