DROP FUNCTION dbo.fn_token_lookup_table
GO

/*
	<name>dbo.fn_token_lookup_table</name>
	<summary>
		This function works as a token value extractor.
	</summary>
	<param name="@key_start_token"></param>
    <param name="@key_end_token"></param>
    <param name="@strInput"></param>
	<history>
		<entry author="Adam Anderly" date="08/31/2006">Created.</entry>
	</history>
*/
CREATE FUNCTION dbo.fn_token_lookup_table
(
    @key_start_token varchar(50)
    ,@key_end_token varchar(50)
    ,@strInput text
)  
RETURNS @Result TABLE
(
    ID int identity(1,1)
	,Value varchar(4000)
)
AS  
BEGIN

	-- If keys exist in the value, lookup the keys
	DECLARE @iPosition int -- Our current position in the string (First character = 1)
    DECLARE @iKey_Begin int
    DECLARE @iKey_End int
    DECLARE @strHit varchar(4000)

    -- Set our position variable to the start of the string.
    SET @iPosition = 0

    -- We loop through the looked up config value checking for dynamic config keys [config key tokens ${CONFIG_KEY}].
    -- This supports recursive config key lookups where one key can reference another key in its value.
    WHILE CHARINDEX(@key_start_token, @strInput, @iPosition) <> 0
    BEGIN

        -- Find beginning of key token
        SET @iKey_Begin = CHARINDEX(@key_start_token, @strInput, @iPosition)

        -- Find end of key token
        SET @iKey_End = CHARINDEX(@key_end_token, @strInput, @iKey_Begin)

        IF @iKey_Begin > 0 AND @iKey_End > 0
        BEGIN
            -- Extract Key that is being referenced dynamically
            SET @strHit = SUBSTRING(@strInput, @iKey_Begin + LEN(@key_start_token), (@iKey_End - (@iKey_Begin + LEN(@key_start_token))))
            INSERT INTO @Result
            SELECT @strHit
        END

        -- Set our location to start looking for config keys to the
        -- position immediately after the last key end.
        SET @iPosition = @iKey_End + LEN(@iKey_End)

    END
        
	RETURN

END

GO
GRANT SELECT ON dbo.fn_token_lookup_table TO Public