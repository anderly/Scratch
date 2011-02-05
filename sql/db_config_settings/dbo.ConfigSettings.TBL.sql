if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ConfigSettings]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ConfigSettings]
GO

CREATE TABLE [dbo].[ConfigSettings]
(
	[key] [varchar](500) NOT NULL,
	[value] [varchar](2000) NOT NULL,
	CONSTRAINT [PK_ConfigSettings] PRIMARY KEY CLUSTERED 
	(
		[key] ASC
	) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE dbo.ConfigSettings
	ADD result AS dbo.fn_config_settings([key])