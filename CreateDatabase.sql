-- The first step of creating Database KMS
-- The next (the 2nd) step is to create Auxuiliaries 
--
DECLARE @data_path varchar(256)
SET @data_path = (SELECT SUBSTRING(physical_name, 1, CHARINDEX(N'master.mdf', LOWER(physical_name)) - 1)  
                  FROM master.sys.master_files  
                  WHERE database_id = 1 AND file_id = 1);
--SELECT @data_path

USE [master]
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name=N'kms')
 BEGIN 
  ALTER DATABASE kms SET single_user WITH rollback immediate
  DROP DATABASE kms
END 
GO

--CREATE DATABASE kms ON (NAME='KMSDat', FILENAME='c:\kms\kms.mdf', SIZE=100MB) LOG ON (NAME='KMSLog', FILENAME='c:\kms\kms_log.ldf', SIZE=5MB)
CREATE DATABASE kms
GO

USE kms
GO

IF EXISTS (SELECT * FROM sys.schemas WHERE name='nsi') DROP SCHEMA nsi
GO
CREATE SCHEMA nsi
GO

EXEC sp_dropmessage 60001, @lang='russian'
EXEC sp_dropmessage 60001, @lang='us_english'
EXEC sp_addmessage 60001, 16,
	N'Bulk update in kmsview is prohibited!', @lang='us_english'
EXEC sp_addmessage 60001, 16,
	N'Групповые изменения из представления запрещены!', @lang='russian'

EXEC sp_dropmessage 50001, @lang='russian'
EXEC sp_dropmessage 50001, @lang='us_english'
EXEC sp_addmessage 50001, 16,
	N'DOC.MODDOC trigger rejection! Editing of nonactual record is prohibited!', @lang='us_english'
EXEC sp_addmessage 50001, 16,
	N'Отказ триггера doc.moddoc. Попытка отредактировать неактуальную запись!', @lang='russian'

EXEC sp_dropmessage 50002, @lang='russian'
EXEC sp_dropmessage 50002, @lang='us_english'
EXEC sp_addmessage 50002, 16,
	N'DOC.MODDOC trigger rejection! Uniqness violation during edition!', @lang='us_english'
EXEC sp_addmessage 50002, 16,
	N'Отказ триггера doc.moddoc. Нарушение уникальности s_doc+n_doc!', @lang='russian'

EXEC sp_dropmessage 50003, @lang='russian'
EXEC sp_dropmessage 50003, @lang='us_english'
EXEC sp_addmessage 50003, 16,
	N'DOC.DELDOC trigger rejection! Deleting of nonactual record is prohibited!', @lang='us_english'
EXEC sp_addmessage 50003, 16,
	N'Отказ триггера doc.deldoc. Попытка удалить неактуальную запись!', @lang='russian'

EXEC sp_dropmessage 50501, @lang='russian'
EXEC sp_dropmessage 50501, @lang='us_english'
EXEC sp_addmessage 50501, 16,
	N'DOC.MODDOC trigger rejection! Editing of nonactual record is prohibited!', @lang='us_english'
EXEC sp_addmessage 50501, 16,
	N'Отказ триггера doc.moddoc. Попытка отредактировать неактуальную запись!', @lang='russian'

EXEC sp_dropmessage 50503, @lang='russian'
EXEC sp_dropmessage 50503, @lang='us_english'
EXEC sp_addmessage 50503, 16,
	N'PERMISS.ADDPERMISS trigger rejection! Empty c_perm, s_perm or n_perm value!', @lang='us_english'
EXEC sp_addmessage 50503, 16,
	N'Отказ триггера permiss.addpermiss. Попытка добавить пустые c_perm, s_perm или n_perm!', @lang='russian'

EXEC sp_dropmessage 50504, @lang='russian'
EXEC sp_dropmessage 50504, @lang='us_english'
EXEC sp_addmessage 50504, 16,
	N'DOC.MODDOC trigger rejection! s_doc+n_doc!', @lang='us_english'
EXEC sp_addmessage 50504, 16,
	N'Отказ триггера doc.moddoc. G s_doc+n_doc!', @lang='russian'

EXEC sp_dropmessage 90001, @lang='russian'
EXEC sp_dropmessage 90001, @lang='us_english'
EXEC sp_addmessage 90001, 16,
	N'Отказ процедуры AddPerson! Пустые поля!', @lang='us_english'
EXEC sp_addmessage 90001, 16,
	N'Отказ процедуры AddPerson! Пустые поля!', @lang='russian'

EXEC sp_dropmessage 90002, @lang='russian'
EXEC sp_dropmessage 90002, @lang='us_english'
EXEC sp_addmessage 90002, 16,
	N'Отказ процедуры AddPerson! Повтор ВС!', @lang='us_english'
EXEC sp_addmessage 90002, 16,
	N'Отказ процедуры AddPerson! Повтор ВС!', @lang='russian'

--- Procedures' definitions
IF OBJECT_ID('dbo.IsENP','FN') IS NOT NULL DROP FUNCTION dbo.IsENP
GO
-- Luhn algorithm
CREATE FUNCTION dbo.IsENP(@enp varchar(16)) RETURNS bit 
BEGIN
 SET @enp = RTRIM(LTRIM(@enp))
 SET @enp = STUFF(REPLICATE('0',16), 16-LEN(@enp)+1, LEN(@enp), @enp)
 IF LEN(@enp)<>16 RETURN 0

 DECLARE @CheckDigit char(1) = CAST(RIGHT(@enp,1) AS int)

 DECLARE @npos tinyint

 -- Нечётная часть числа
 DECLARE @OddPart varchar(16) = ''
 SET @npos = 15
 WHILE (@npos>0)
 BEGIN
  SET @OddPart = @OddPart + SUBSTRING(@enp, @npos, 1)
  IF @npos>2 SET @npos = @npos -2
  ELSE BREAK
 END

 -- Чётная часть числа
 DECLARE @EvenPart varchar(16) = ''
 SET @npos = 14
 WHILE (@npos>=1)
 BEGIN
  SET @EvenPart = @EvenPart + SUBSTRING(@enp, @npos, 1)
  IF @npos>2 SET @npos = @npos -2
  ELSE BREAK
 END

 -- Конкатенируем две части, предварительно умножив нечётную часть на два
 DECLARE @VAB char(40) = @EvenPart + RTRIM(CAST(CAST(@OddPart AS int)*2 AS char(16)))

 SET @npos = 0
 DECLARE @sum int = 0 
 WHILE (@npos <= LEN(@VAB))
 BEGIN
  SET @sum = @sum + cast(substring(@vab, @npos,1) as int)
  SET @npos = @npos + 1
 END
 
 DECLARE @vd int
 SET @vd = ceiling(cast(@sum as real)/10)*10 - @sum

 RETURN iif(@vd != @CheckDigit, 0, 1)
END
GO 

IF OBJECT_ID('dbo.KmsConv','FN') IS NOT NULL DROP FUNCTION dbo.KmsConv
GO
CREATE FUNCTION dbo.KmsConv(@sn_pol varchar(30)) RETURNS char(17)
BEGIN
 SET @sn_pol = RTRIM(LTRIM(@sn_pol))
 DECLARE @ser char(6)  = SUBSTRING(@sn_pol,1,6)
 DECLARE @num varchar(20) = SUBSTRING(@sn_pol,7,20)

 SET @num = LTRIM(RTRIM(@num))
 SET @num = STUFF(REPLICATE('0',10),10-LEN(@num)+1,LEN(@num),@num)

 RETURN @ser+' '+@num
END
GO 

IF OBJECT_ID('dbo.IsKms','FN') IS NOT NULL DROP FUNCTION dbo.IsKms
GO
CREATE FUNCTION dbo.IsKms(@sn_pol varchar(17)) RETURNS bit 
BEGIN
 SET @sn_pol = RTRIM(LTRIM(@sn_pol))
 DECLARE @ser char(6)  = SUBSTRING(@sn_pol,1,6)
 DECLARE @num char(10) = SUBSTRING(@sn_pol,8,10)

 -- Проверяем серию КМС на корректность
 IF SUBSTRING(@ser,1,2)!='77' RETURN 0
 IF ISNUMERIC(SUBSTRING(@ser,3,2))=0 RETURN 0
 IF CAST(SUBSTRING(@ser,3,2) AS tinyint) NOT BETWEEN 0 AND 99 RETURN 0
 IF ISNUMERIC(SUBSTRING(@ser,5,2))=0 RETURN 0
 IF (CAST(SUBSTRING(@ser,5,2) AS tinyint) NOT BETWEEN 0 AND 27) AND 
	(CAST(SUBSTRING(@ser,5,2) AS tinyint) NOT IN (45,50,51,52,73,77,99)) RETURN 0

SET @num = LTRIM(@num)
SET @num = STUFF(REPLICATE('0',10),10-LEN(@num)+1,LEN(@num),@num)

 -- Проверяем номер КМС на корректность
 DECLARE @n01 tinyint = CAST(SUBSTRING(@num,01,1) AS tinyint)
 DECLARE @n02 tinyint = CAST(SUBSTRING(@num,02,1) AS tinyint)
 DECLARE @n03 tinyint = CAST(SUBSTRING(@num,03,1) AS tinyint)
 DECLARE @n04 tinyint = CAST(SUBSTRING(@num,04,1) AS tinyint)
 DECLARE @n05 tinyint = CAST(SUBSTRING(@num,05,1) AS tinyint)
 DECLARE @n06 tinyint = CAST(SUBSTRING(@num,06,1) AS tinyint)
 DECLARE @n07 tinyint = CAST(SUBSTRING(@num,07,1) AS tinyint)
 DECLARE @n08 tinyint = CAST(SUBSTRING(@num,08,1) AS tinyint)
 DECLARE @n09 tinyint = CAST(SUBSTRING(@num,09,1) AS tinyint)
 DECLARE @n10 tinyint = CAST(SUBSTRING(@num,10,1) AS tinyint)

 DECLARE @r1 tinyint = (@n02*2 + @n03*8 + @n04*6 + @n05*3 + @n06*5 + @n07*4 + @n08*2 + @n09*1 + @n10*7) % 10
 IF @n01 != @r1 RETURN 0
 
 RETURN 1
END
GO 
--- Procedures' definitions

print 'Run CreateAuxiliaries.sql next!'