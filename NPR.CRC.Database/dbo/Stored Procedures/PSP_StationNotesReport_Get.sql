CREATE PROCEDURE [dbo].[PSP_StationNotesReport_Get]
(
	@StationId BIGINT,
	@Keyword VARCHAR(50),
	@LastUpdatedFromDate DateTime,
	@LastUpdatedToDate DateTime,
	@DeletedInd CHAR(1),
	@DebugInd CHAR(1)
)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
	SELECT
		staN.StationId,
		staN.StationNoteId,
		CallLetters + ''-'' + BandName As StationName,
		NoteText,
		staN.LastUpdatedDate,
		staN.LastUpdatedUserId,
		dbo.FN_GetUserDisplayName(staN.LastUpdatedUserId) As LastUpdatedUser,
		staN.DeletedDate,
		staN.DeletedUserId

	FROM
		dbo.StationNote staN INNER JOIN
		dbo.Station sta ON staN.StationId = sta.StationId INNER JOIN
		dbo.Band b ON sta.BandId = b.BandId
	WHERE '

	IF @DeletedInd = 'Y'
		SET @DynSql = @DynSql + ' DeletedUserId IS NOT NULL'
	ELSE
		SET @DynSql = @DynSql + ' DeletedUserId IS NULL'

	IF @StationId IS NOT NULL
		SET @DynSql = @DynSql + ' AND staN.StationId = @StationId'

	IF @Keyword IS NOT NULL
		SET @DynSql = @DynSql + ' AND staN.NoteText LIKE ''%'' + RTRIM(LTRIM(@Keyword)) + ''%'''

	IF @LastUpdatedFromDate IS NOT NULL AND @LastUpdatedToDate IS NOT NULL
		SET @DynSql = @DynSql + ' AND CONVERT(DateTime, CONVERT(VARCHAR(10), staN.LastUpdatedDate, 112)) >= @LastUpdatedFromDate AND CONVERT(DateTime, CONVERT(VARCHAR(10), staN.LastUpdatedDate, 112)) <= @LastUpdatedToDate'

	DECLARE @DynParams NVARCHAR(MAX) =
	'
	@StationId BIGINT,
	@Keyword VARCHAR(50),
	@LastUpdatedFromDate DateTime,
	@LastUpdatedToDate DateTime,
	@DeletedInd CHAR(1)
	'

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		EXEC dbo.sp_executesql
		@DynSql,
		@DynParams,
		@StationId = @StationId,
		@Keyword = @Keyword,
		@LastUpdatedFromDate = @LastUpdatedFromDate,
		@LastUpdatedToDate = @LastUpdatedToDate,
		@DeletedInd = @DeletedInd
END
GO


