Select 
[tgr].[name] as [trigger name], 
[tbl].[name] as [table name]

from sysobjects tgr 

join sysobjects tbl
on tgr.parent_obj = tbl.id

WHERE tgr.xtype = 'TR'