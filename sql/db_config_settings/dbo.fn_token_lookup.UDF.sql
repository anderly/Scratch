DROP FUNCTION dbo.fn_token_lookup
GO

/*
	<name>dbo.fn_token_lookup</name>
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
CREATE FUNCTION dbo.fn_token_lookup
(
    @key_start_token varchar(50)
    ,@key_end_token varchar(50)
    ,@strInput varchar(4000)
)  
RETURNS varchar(4000)
AS  
BEGIN

	-- If keys exist in the value, lookup the keys
	DECLARE @iPosition int -- Our current position in the string (First character = 1)
    DECLARE @iKey_Begin int
    DECLARE @iKey_End int
    DECLARE @strOutput varchar(4000)

    -- Set our position variable to the start of the string.
    SET @iPosition = 0

    -- Find beginning of key token
    SET @iKey_Begin = CHARINDEX(@key_start_token, @strInput, @iPosition)

    -- Find end of key token
    SET @iKey_End = CHARINDEX(@key_end_token, @strInput, @iKey_Begin)

    IF @iKey_Begin > 0 AND @iKey_End > 0
    BEGIN
        -- Extract Key that is being referenced dynamically
        SET @strOutput = SUBSTRING(@strInput, @iKey_Begin + LEN(@key_start_token), (@iKey_End - (@iKey_Begin + LEN(@key_start_token))))
    END
        
	RETURN @strOutput

END

GO
GRANT EXECUTE ON dbo.fn_token_lookup TO Public

 