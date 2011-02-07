IF object_id('[dbo].[udf_base64_decode]') IS NOT NULL
  DROP FUNCTION [dbo].[udf_base64_decode]
GO

CREATE FUNCTION udf_base64_decode
(
  @encoded_text varchar(8000)
)
RETURNS 
          varchar(6000)
AS BEGIN
--local variables
DECLARE
  @output           varchar(8000),
  @block_start      int,
  @encoded_length   int,
  @decoded_length   int,
  @mapr             binary(122)
--IF @encoded_text COLLATE LATIN1_GENERAL_BIN
-- LIKE '%[^ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=]%'
--     COLLATE LATIN1_GENERAL_BIN
--  RETURN NULL
--IF LEN(@encoded_text) & 3 > 0
--  RETURN NULL
SET @output   = ''
-- The nth byte of @mapr contains the base64 value
-- of the character with an ASCII value of n.
-- EG, 65th byte = 0x00 = 0 = value of 'A'
SET @mapr =
  0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF -- 1-33
+ 0xFFFFFFFFFFFFFFFFFFFF3EFFFFFF3F3435363738393A3B3C3DFFFFFF00FFFFFF -- 33-64
+ 0x000102030405060708090A0B0C0D0E0F10111213141516171819FFFFFFFFFFFF -- 65-96
+ 0x1A1B1C1D1E1F202122232425262728292A2B2C2D2E2F30313233 -- 97-122
--get the number of blocks to be decoded
SET @encoded_length = LEN(@encoded_text)
SET @decoded_length = @encoded_length / 4 * 3
--for each block
SET @block_start = 1
WHILE @block_start < @encoded_length BEGIN
  --decode the block and add to output
  --BINARY values between 1 and 4 bytes can be implicitly cast to INT
  SET @output = @output +  CAST(CAST(CAST(
   substring( @mapr, ascii( substring( @encoded_text, @block_start    , 1) ), 1) * 262144
 + substring( @mapr, ascii( substring( @encoded_text, @block_start + 1, 1) ), 1) * 4096
 + substring( @mapr, ascii( substring( @encoded_text, @block_start + 2, 1) ), 1) * 64
 + substring( @mapr, ascii( substring( @encoded_text, @block_start + 3, 1) ), 1) 
   AS INTEGER) AS BINARY(3)) AS VARCHAR(3))
  SET @block_start = @block_start + 4
END
IF RIGHT(@encoded_text, 2) = '=='
 SET @decoded_length = @decoded_length - 2
ELSE IF RIGHT(@encoded_text, 1) = '='
 SET @decoded_length = @decoded_length - 1
--IF SUBSTRING(@output, @decoded_length, 1) = CHAR(0)
-- SET @decoded_length = @decoded_length - 1
--return the decoded string
RETURN LEFT(@output, @decoded_length)
END
GO

IF object_id('[dbo].[udf_base64_encode]') IS NOT NULL
  DROP FUNCTION [dbo].[udf_base64_encode]
GO

CREATE FUNCTION udf_base64_encode
(
  @plain_text varchar(6000)
)
RETURNS 
          varchar(8000)
AS BEGIN
--local variables
DECLARE
  @output            varchar(8000),
  @input_length      integer,
  @block_start       integer,
  @partial_block_start  integer, -- position of last 0, 1 or 2 characters
  @partial_block_length integer,
  @block_val         integer,
  @map               char(64)
SET @map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
--initialise variables
SET @output   = ''
--set length and count
SET @input_length      = LEN( @plain_text + '#' ) - 1
SET @partial_block_length = @input_length % 3
SET @partial_block_start = @input_length - @partial_block_length
SET @block_start       = 1
--for each block
WHILE @block_start < @partial_block_start  BEGIN
  SET @block_val = CAST(SUBSTRING(@plain_text, @block_start, 3) AS BINARY(3))
  --encode the 3 character block and add to the output
  SET @output = @output + SUBSTRING(@map, @block_val / 262144 + 1, 1)
                        + SUBSTRING(@map, (@block_val / 4096 & 63) + 1, 1)
                        + SUBSTRING(@map, (@block_val / 64 & 63  ) + 1, 1)
                        + SUBSTRING(@map, (@block_val & 63) + 1, 1)
  --increment the counter
  SET @block_start = @block_start + 3
END
IF @partial_block_length > 0
BEGIN
  SET @block_val = CAST(SUBSTRING(@plain_text, @block_start, @partial_block_length)
                      + REPLICATE(CHAR(0), 3 - @partial_block_length) AS BINARY(3))
  SET @output = @output
 + SUBSTRING(@map, @block_val / 262144 + 1, 1)
 + SUBSTRING(@map, (@block_val / 4096 & 63) + 1, 1)
 + CASE WHEN @partial_block_length < 2
    THEN REPLACE(SUBSTRING(@map, (@block_val / 64 & 63  ) + 1, 1), 'A', '=')
    ELSE SUBSTRING(@map, (@block_val / 64 & 63  ) + 1, 1) END
 + CASE WHEN @partial_block_length < 3
    THEN REPLACE(SUBSTRING(@map, (@block_val & 63) + 1, 1), 'A', '=')
    ELSE SUBSTRING(@map, (@block_val & 63) + 1, 1) END
END
--return the result
RETURN @output
END
GO