CREATE Procedure [dbo].[Test_Dynamic]
(
	@TableName varchar(200)
)
WITH EXECUTE AS OWNER
 AS BEGIN

 SET NOCOUNT ON
 DECLARE
 @DynSql NVARCHAR(MAX)=
 
				'Select * from ' + @TableName

	EXEC(@DynSql)		
	END