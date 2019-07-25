DECLARE @UserName VARCHAR(50) = 'crcuser'


DECLARE @RevokeScript NVARCHAR(MAX)
SELECT @RevokeScript = ISNULL(@RevokeScript, '') +
	'REVOKE ' + permission_name + ' ON ' + OBJECT_NAME(major_id) + ' FROM ' + @UserName + '; '
FROM sys.database_permissions
WHERE grantee_principal_id = USER_ID(@UserName)
AND major_id > 0
ORDER BY OBJECT_NAME(major_id)


DECLARE @GrantScript NVARCHAR(MAX)
SELECT @GrantScript = ISNULL(@GrantScript, '') +
	'GRANT ' +
	CASE
		WHEN type_desc = 'SQL_TABLE_VALUED_FUNCTION'
		THEN 'SELECT'
		ELSE 'EXECUTE'
	END +
	' ON ' + SCHEMA_NAME(schema_id) + '.' + name + ' TO ' + @UserName + '; '
FROM sys.objects
WHERE type_desc IN ('SQL_STORED_PROCEDURE', 'SQL_SCALAR_FUNCTION', 'SQL_TABLE_VALUED_FUNCTION')
ORDER BY name


DECLARE @FinalScript NVARCHAR(MAX)
SET @FinalScript =
	'BEGIN TRANSACTION; ' +
	'BEGIN TRY ' +
		ISNULL(@RevokeScript, '') +
		ISNULL(@GrantScript, '') +
		'COMMIT TRANSACTION; ' +
	'END TRY ' +
	'BEGIN CATCH ' +
		'IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION; ' +
		'DECLARE @ErrorMessage NVARCHAR(4000); ' +
		'SELECT @ErrorMessage = ERROR_MESSAGE(); ' +
		'RAISERROR(@ErrorMessage, 16, 1); ' +
	'END CATCH'

--PRINT @FinalScript
EXEC dbo.sp_executesql @FinalScript
