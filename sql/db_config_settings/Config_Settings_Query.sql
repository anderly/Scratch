
SELECT *
FROM dbo.ConfigSettings

SELECT [key], dbo.udf_GetConfigSetting([key]) [value]
FROM dbo.ConfigSettings

SELECT [key], [value], fn_token_lookup('<datasrc>','</datasrc>',[value])
FROM dbo.ConfigSettings