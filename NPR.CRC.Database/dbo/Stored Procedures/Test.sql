CREATE PROCEDURE [dbo].[Test]
(
	@BandSpan VARCHAR(200),
	@MemberStatusName VARCHAR(100),
	@StationEnabled VARCHAR(50)
)
WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
	SELECT s.CallLetters  + ''-'' + b.BandName from dbo.Station as s
		INNER JOIN dbo.Band As b on b.BandId=s.BandId
		INNER JOIN dbo.MemberStatus As m on m.MemberStatusId=s.MemberStatusId
	WHERE
		m.MemberStatusName= @MemberStatusName ' + 
		'AND
		b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'
		
	IF @StationEnabled='Y'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NULL'
	IF @StationEnabled='N'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NOT NULL'
	IF @StationEnabled='B'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NOT NULL OR s.DisabledDate IS NULL'
	
	EXECUTE @DynSql

END