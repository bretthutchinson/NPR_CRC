CREATE PROCEDURE [dbo].[PSP_ProgramsSearch_Get]
(
	@ProgramId BIGINT,
	@ProgramSourceId BIGINT,
	@ProgramFormatTypeId BIGINT,
	@MajorFormatId BIGINT,
	@Enabled VARCHAR(50),
	@DebugInd CHAR(1) = 'N'
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
    SELECT
        p.ProgramId,
		p.ProgramName,
		p.ProgramSourceId,
		ps.ProgramSourceName,
		p.ProgramFormatTypeId,
		pft.ProgramFormatTypeName,
		mf.MajorFormatName,
		p.ProgramCode,
		CASE
			WHEN p.DisabledDate IS NULL
			THEN ''Yes''
			ELSE ''No''
		END AS Enabled

    FROM
        dbo.Program p

		JOIN dbo.ProgramSource ps
			ON ps.ProgramSourceId = p.ProgramSourceId

		JOIN dbo.ProgramFormatType pft
			ON pft.ProgramFormatTypeId = p.ProgramFormatTypeId

		JOIN dbo.MajorFormat mf
			ON mf.MajorFormatId = pft.MajorFormatId

	WHERE 1=1
	'

	IF @ProgramId IS NOT NULL
		SET @DynSql = @DynSql + ' AND p.ProgramId = @ProgramId'

	IF @ProgramSourceId IS NOT NULL
		SET @DynSql = @DynSql + ' AND p.ProgramSourceId = @ProgramSourceId'

	IF @ProgramFormatTypeId IS NOT NULL
		SET @DynSql = @DynSql + ' AND p.ProgramFormatTypeId = @ProgramFormatTypeId'

	IF @MajorFormatId IS NOT NULL
		SET @DynSql = @DynSql + ' AND pft.MajorFormatId = @MajorFormatId'

	IF @Enabled = 'YES'
		SET @DynSql = @DynSql + ' AND p.DisabledDate IS NULL'
	ELSE IF @Enabled = 'NO'
		SET @DynSql = @DynSql + ' AND p.DisabledDate IS NOT NULL'
    
	DECLARE @DynParams NVARCHAR(MAX) =
	'
	@ProgramId BIGINT,
	@ProgramSourceId BIGINT,
	@ProgramFormatTypeId BIGINT,
	@MajorFormatId BIGINT
	'

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		EXEC dbo.sp_executesql
			@DynSql,
			@DynParams,
			@ProgramId = @ProgramId,
			@ProgramSourceId = @ProgramSourceId,
			@ProgramFormatTypeId = @ProgramFormatTypeId,
			@MajorFormatId = @MajorFormatId

END
GO


