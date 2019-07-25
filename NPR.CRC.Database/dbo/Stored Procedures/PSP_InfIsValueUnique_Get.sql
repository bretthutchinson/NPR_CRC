CREATE PROCEDURE [dbo].[PSP_InfIsValueUnique_Get]
(
	@Value SQL_VARIANT,
	@TableName SYSNAME,
	@ColumnName SYSNAME,
	@Id BIGINT
)
WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @IdColumnName SYSNAME
	DECLARE @HasDeletedInd CHAR(1)

	SELECT
		@IdColumnName = col.name,
		@HasDeletedInd =
			CASE WHEN EXISTS
			(
				SELECT *
				FROM sys.columns col_d
				WHERE col_d.object_id = ix.object_id
				AND col_d.name = 'DeletedInd'
			)
			THEN 'Y'
			ELSE 'N'
			END
	FROM
		sys.indexes ix
	JOIN sys.index_columns ixc
		ON ixc.object_id = ix.object_id
		AND ixc.index_id = ix.index_id
	JOIN sys.columns col
		ON col.object_id = ixc.object_id
		AND col.column_id = ixc.column_id
	WHERE
		OBJECT_NAME(ix.object_id) = @TableName
		AND ix.is_primary_key = 1
		AND ixc.index_column_id = 1
		AND EXISTS
		(
			SELECT *
			FROM sys.columns
			WHERE OBJECT_NAME(object_id) = @TableName
			AND name = @ColumnName
		)

	IF LEN(@IdColumnName) > 0
	BEGIN
		DECLARE @DynSql NVARCHAR(MAX) =
		'
		SELECT
			CASE WHEN EXISTS
			(
				SELECT *
				FROM ' + @TableName + '
				WHERE ' + @ColumnName + ' = @Value
				AND (' + @IdColumnName + ' <> @Id OR @Id IS NULL) 
				' +
				CASE @HasDeletedInd
					WHEN 'Y' THEN 'AND DeletedInd = ''N'''
					ELSE ''
					END + '
			)
			THEN ''N''
			ELSE ''Y''
			END AS IsUniqueInd
		'

		PRINT @DynSql

		DECLARE @DynParams NVARCHAR(MAX) =
		'
			@Value SQL_VARIANT,
			@Id BIGINT
		'

		EXEC dbo.sp_executesql
			@DynSql,
			@DynParams,
			@Value = @Value,
			@Id = @Id

	END

END
GO


