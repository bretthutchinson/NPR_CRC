CREATE PROCEDURE [dbo].[PSP_InfReverseLookup_Get]
(
	@LookupTableName VARCHAR(50),
	@LookupColumnName VARCHAR(50),
	@LookupValue VARCHAR(50)
)
WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	-- get the name of the ID key column
	-- while at the same time verifying that the specified combination of lookup table and column names is valid
	-- this effectively protects the dynamic SQL below from sql injection
	DECLARE @IdColumnName VARCHAR(50)
	SELECT @IdColumnName = col.name
	FROM sys.indexes ix
	JOIN sys.index_columns ixc
		ON ixc.object_id = ix.object_id
		AND ixc.index_id = ix.index_id
	JOIN sys.columns col
		ON col.object_id = ixc.object_id
		AND col.column_id = ixc.column_id
	WHERE OBJECT_NAME(ix.object_id) = @LookupTableName
	AND ix.is_primary_key = 1
	AND ixc.index_column_id = 1
	AND EXISTS
	(
		SELECT *
		FROM sys.columns
		WHERE OBJECT_NAME(object_id) = @LookupTableName
		AND name = @LookupColumnName
	)

	IF LEN(@IdColumnName) > 0
	BEGIN

		DECLARE @DynamicSql NVARCHAR(MAX) =
			'SELECT ' + @IdColumnName +
			' FROM ' + @LookupTableName +
			' WHERE ' + @LookupColumnName + ' = @LookupValue'

		DECLARE @DynamicParams NVARCHAR(MAX) =
			'@LookupValue VARCHAR(50)'

		EXEC dbo.sp_executesql
			@DynamicSql,
			@DynamicParams,
			@LookupValue = @LookupValue

	END


END
GO


