restore filelistonly from disk='D:\SalesDb\SalesDBOriginal.bak'

restore database SalesDb from disk='D:\SalesDb\SalesDBOriginal.bak' 
	with move 'SalesDBData' to 'D:\SalesDb\SalesDBData.mdf', move 'SalesDBLog' to 'D:\SalesDb\SalesDBLog.ldf'
