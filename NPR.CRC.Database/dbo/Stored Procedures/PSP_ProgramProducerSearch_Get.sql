--[PSP_ProgramProducerSearch_Get] null, null, 'N'
CREATE PROCEDURE [dbo].[PSP_ProgramProducerSearch_Get]
(
	@ProgramId BIGINT,
	@ProducerId BIGINT,
	@DebugInd CHAR(1)
)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
		DECLARE @tempOne TABLE (
			ColumnName VARCHAR(20),
			ProgramProducerId BIGINT,
			ProgramId BIGINT,
			ProducerId BIGINT
		)
		
		DECLARE @tempTwo TABLE (
			ColumnName VARCHAR(20),
			ProgramProducerId BIGINT,
			ProgramId BIGINT,
			ProducerId BIGINT
		)
		
		DECLARE @tempThree TABLE (
			ColumnName VARCHAR(20),
			ProgramProducerId BIGINT,
			ProgramId BIGINT,
			ProducerId BIGINT
		)
		
		DECLARE @temp TABLE (
			ColumnName VARCHAR(20),
			ProgramProducerId BIGINT,
			ProgramId BIGINT,
			ProducerId BIGINT
		)
		
		INSERT INTO @tempOne 
		SELECT ''ProgramOne'' As ''Col'', ProgramProducerId, ProgramId,  ProducerId FROM dbo.ProgramProducer pp WHERE 
			ProgramId IN (
			SELECT TOP 1 ProgramId FROM dbo.ProgramProducer pp1 WHERE pp.ProducerId = pp1.ProducerId ' 
		
		IF @ProgramId IS NOT NULL
			SET @DynSql = @DynSql + ' AND pp1.ProgramId = ' + CONVERT(VARCHAR, @ProgramId)

		SET @DynSql = @DynSql + 
		' ORDER BY LastUpdatedDate Desc)
		
		INSERT INTO @tempTwo 
		SELECT ''ProgramTwo'' As ''Col'', ProgramProducerId, ProgramId,  ProducerId FROM dbo.ProgramProducer pp WHERE 
			ProgramId IN (
			SELECT TOP 1 ProgramId FROM dbo.ProgramProducer pp2 WHERE pp.ProducerId = pp2.ProducerId 
			AND ProgramProducerId NOT IN (SELECT ProgramProducerId FROM @tempOne UNION SELECT ProgramProducerId FROM @tempThree) ORDER BY LastUpdatedDate Desc
		 )
		
		INSERT INTO @tempThree
		SELECT ''ProgramThree'' As ''Col'', ProgramProducerId, ProgramId,  ProducerId FROM dbo.ProgramProducer pp WHERE 
			ProgramId IN (
			SELECT TOP 1 ProgramId FROM dbo.ProgramProducer pp3 WHERE pp.ProducerId = pp3.ProducerId
			AND ProgramProducerId NOT IN (SELECT ProgramProducerId FROM @tempOne UNION SELECT ProgramProducerId FROM @tempTwo) ORDER BY LastUpdatedDate Desc
		)
		
		INSERT INTO @temp
		select * from @tempOne
		UNION ALL
		select * from @tempTwo
		UNION ALL
		select * from @tempThree
		
		SELECT
			pr.ProducerId,
			pr.FirstName + ISNULL('' '' + pr.MiddleName + '' '', '' '') + pr.LastName + ISNULL('' '' + pr.Suffix, '''') As ProducerName,
			pr.[Role],
			pr.Email,
			pr.Phone,
			pp.ProgramOneId,
			p1.ProgramName As ProgramNameOne,
			pp.ProgramTwoId,
			p2.ProgramName As ProgramNameTwo,
			pp.ProgramThreeId,
			p3.ProgramName As ProgramNameThree
		FROM
			dbo.Producer pr LEFT JOIN
			(select ProducerId,
				MAX(CASE WHEN ColumnName = ''ProgramOne'' THEN ProgramId ELSE null END) As ProgramOneId,
				MAX(CASE WHEN ColumnName = ''ProgramTwo'' THEN ProgramId ELSE null END) As ProgramTwoId,
				MAX(CASE WHEN ColumnName = ''ProgramThree'' THEN ProgramId ELSE null END) As ProgramThreeId
			FROM @temp
			Group by ProducerId) pp ON pr.ProducerId = pp.ProducerId LEFT JOIN
			dbo.Program p1 ON pp.ProgramOneId = p1.ProgramId LEFT JOIN
			dbo.Program p2 ON pp.ProgramTwoId = p2.ProgramId LEFT JOIN
			dbo.Program p3 ON pp.ProgramThreeId = p3.ProgramId
		
		--WHERE 1 = 1
		where (
			   (ProgramOneID is not null and p1.disableddate is null)
			or (ProgramTwoId is not null and p2.disableddate is null) 	
			or (ProgramThreeId is not null and p3.disableddate is null)
		)
		'

	IF @ProducerId IS NOT NULL
		SET @DynSql = @DynSql + ' AND pr.ProducerId = ' + CONVERT(VARCHAR, @ProducerId)

	IF @ProgramId IS NOT NULL
		SET @DynSql = @DynSql + ' AND ISNULL(pp.ProgramOneId, 0) = ' + CONVERT(VARCHAR, @ProgramId)

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
	BEGIN
		EXEC dbo.sp_executesql @DynSql 
	END
END
GO


