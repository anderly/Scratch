declare @targetdir varchar(1000)
set @targetdir = 'C:\DTS\'

/*
select distinct  
	'dtsrun /S '
	+ convert(varchar(200), serverproperty('servername')) 
	+ ' /E ' 
	+ ' /N '
	+ '"' + name  + '"'
	+ ' /F '
	+ '"' + @targetdir + name + '.dts"'
	+ ' /!X'
from msdb.dbo.sysdtspackages p
order by 1
*/

select distinct name, 
	'dtsrun /F '
	+ '"' + @targetdir + name + '.dts"' 
	+ ' /N '
	+ '"' + name  + '"'
	+ ' /E'
from msdb.dbo.sysdtspackages p
order by 1
