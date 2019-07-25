CREATE Procedure [dbo].[Test_Dynamic1]
(
	@TableName varchar(200)
)	
WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON
DECLARE 
@DynSql NVARCHAR(MAX)
set @DynSql=''
If(@TableName='Program')
BEGIN
	SET @DynSql='Select * from ' + @TableName
END
ELSE
		SET @DynSql='Select * from ' + @TableName + 'WHERE ProgramName not like'+'%Off Air%'

EXEC(@DynSql)
END