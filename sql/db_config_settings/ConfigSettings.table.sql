/****** Object:  Table [dbo].[ConfigSettings]    Script Date: 02/17/2010 15:43:57 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ConfigSettings](
	[key] [varchar](500) NOT NULL,
	[value] [varchar](2000) NOT NULL,
	[result]  AS ([dbo].[udf_GetConfigSetting]([key])),
 CONSTRAINT [PK_ConfigSettings] PRIMARY KEY CLUSTERED 
(
	[key] ASC
) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


