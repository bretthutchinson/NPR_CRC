CREATE PROCEDURE [dbo].[PSP_ScheduleYearsList_Get]
(
	@FutureYears INT
)
AS BEGIN

	SET NOCOUNT ON

	DECLARE @FirstYear INT =
	(
		SELECT MIN(Year)
		FROM dbo.Schedule
	)

	set @firstyear = '2001'
	SET @FirstYear = ISNULL(@FirstYear, DATEPART(YEAR, GETUTCDATE()))

	DECLARE @LastYear INT = DATEPART(YEAR, DATEADD(YEAR, @FutureYears, GETUTCDATE()))

	;WITH YearsList AS
	(
		SELECT @FirstYear AS Year
		UNION ALL
		SELECT Year + 1
		FROM YearsList
		WHERE Year < @LastYear
	)
	SELECT Year
	FROM YearsList
	order by year desc

END
GO


