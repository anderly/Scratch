/****** Object:  UserDefinedFunction [dbo].[udf_Config_Settings]    Script Date: 02/17/2010 15:45:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
	<name>dbo.udf_GetConfigSetting</name>
	<summary>
		This function works as a configuration settings lookup tool for environment-specific database settings.
	</summary>
	<param name="@key">Key for which to lookup value.</param>
	<history>
		<entry author="Adam Anderly" date="08/24/2006">Created.</entry>
		<entry author="Adam Anderly" date="08/31/2006">Updated to support dynamic keys (i.e. - keys that reference other config keys).</entry>
	</history>
*/
CREATE FUNCTION [dbo].[udf_GetConfigSetting]
(
	@key varchar(4000)
)  
RETURNS varchar(4000)
AS  
BEGIN

	DECLARE @value varchar(4000)
	
	SELECT @value = [value]
	FROM dbo.ConfigSettings
	WHERE [key] = @key
	
	-- If keys exist in the value, lookup the keys
	DECLARE @iPosition int -- Our current position in the string (First character = 1)
	DECLARE @iKey_Start_Token varchar(50)
	DECLARE @iKey_End_Token varchar(50)
    DECLARE @iKey_Begin int
    DECLARE @iKey_End int
    DECLARE @temp_key varchar(4000)
    DECLARE @temp_new_key varchar(4000)
    DECLARE @strOutput varchar(4000)
    
    SET @iKey_Start_Token = '${'
    SET @iKey_End_Token = '}'

    SELECT @strOutput = @value

    -- Set our position variable to the start of the string.
    SET @iPosition = 1

    -- We loop through the looked up config value checking for dynamic config keys [config key tokens ${CONFIG_KEY}].
    -- This supports recursive config key lookups where one key can reference another key in its value.
    WHILE CHARINDEX(@iKey_Start_Token, @strOutput, @iPosition) <> 0
    BEGIN
        
        -- Find beginning of key token
        SET @iKey_Begin = CHARINDEX(@iKey_Start_Token, @strOutput, @iPosition)

        -- Find end of key token
        SET @iKey_End = CHARINDEX(@iKey_End_Token, @strOutput, @iKey_Begin)
    	
        -- Extract Key that is being referenced dynamically
        SET @temp_key = SUBSTRING(@strOutput, @iKey_Begin + LEN(@iKey_Start_Token), (@iKey_End - (@iKey_Begin + LEN(@iKey_Start_Token))))
        
        -- Now, lookup the dynamic key's value
        SELECT @temp_new_key = [value]
	    FROM dbo.ConfigSettings
	    WHERE [key] = @temp_key
	    
	    -- Replace the current key with the looked up key's value
        SET @strOutput = REPLACE(@strOutput, @iKey_Start_Token + @temp_key + @iKey_End_Token, @temp_new_key)
        
        -- 08/31/2006 - ASA - Commented out advance of @iPosition because we want to continue checking the entire @strOutput 
        -- variable until all dynamic keys (${CONFIG_KEY}) have been replaced with their looked up values
        -- Set our location to start looking for config keys to the
        -- position immediately after the last key end.
        --SET @iPosition = @iKey_End + LEN(@iKey_End)
    	
    END
	
	RETURN @strOutput

END


GO


