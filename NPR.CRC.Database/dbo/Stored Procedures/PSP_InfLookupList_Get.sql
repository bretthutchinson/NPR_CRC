CREATE PROCEDURE [dbo].[PSP_InfLookupList_Get]
(
    @TableName SYSNAME,
	@IdColumnName SYSNAME,
	@DisplayColumnName SYSNAME
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

	IF EXISTS
	(
		SELECT *
		FROM sys.tables tbl
		JOIN sys.columns id_col ON id_col.object_id = tbl.object_id
		JOIN sys.columns disp_col ON disp_col.object_id = tbl.object_id
		WHERE tbl.name = @TableName
		AND id_col.name = @IdColumnName
		AND disp_col.name = @DisplayColumnName
	)
	BEGIN

		DECLARE @DynSql NVARCHAR(500) =
			'SELECT ' + @IdColumnName + ', '  + @DisplayColumnName +
			' FROM ' + @TableName +
			' ORDER BY ' + @DisplayColumnName

		EXEC dbo.sp_executesql @DynSql

	END

END
GO


