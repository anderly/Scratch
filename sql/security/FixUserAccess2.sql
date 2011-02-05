DECLARE @User sysname = 'RolExecUserSp' --User or Role Name [role in this case]

SET NOCOUNT ON

-- 1 - Variable declarations
DECLARE @CMD1 varchar(8000)
DECLARE @MAXOID int
DECLARE @OwnerName varchar(128)
DECLARE @ObjectName varchar(128)

-- 2 - Create temporary table
CREATE TABLE #Objects
(OID int IDENTITY (1,1),
ObjectOwner varchar(128) NOT NULL,
ObjectName varchar(128) NOT NULL)

-- 3 - Populate temporary table
INSERT INTO #Objects (ObjectOwner, ObjectName)
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
UNION
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES

-- 4 - Capture the @MAXOID value
SELECT @MAXOID = MAX(OID) FROM #Objects

-- 5 - WHILE loop
WHILE @MAXOID > 0
BEGIN

	-- 6 - Initialize the variables
	SELECT @OwnerName = ObjectOwner,
	@ObjectName = ObjectName
	FROM #Objects
	WHERE OID = @MAXOID

	SELECT '@OwnerName:' + ISNULL(@OwnerName,'NULL') + '|@ObjectName:' + ISNULL(@ObjectName,'NULL')

	-- 7 - Build the string
	SELECT @CMD1 = 'GRANT SELECT ON ' + '[' + @OwnerName + ']' + '.' + '[' + @ObjectName + ']' + ' TO ' + @user
	PRINT @CMD1

	-- 8 - Execute the string
	-- SELECT @CMD1
	EXEC(@CMD1)

	-- 9 - Decrement @MAXOID
	SET @MAXOID = @MAXOID - 1
END

-- 10 - Drop the temporary table
DROP TABLE #Objects

SET NOCOUNT OFF
GO