CREATE PROCEDURE [dbo].[PSP_ProgramScheduleByMonth_Get]
(
	@StationId BIGINT,
	@Year INT,
	@Month INT
)
AS BEGIN

	SET NOCOUNT ON

	SELECT
		schP.ScheduleProgramId,
		schP.ProgramId,
		p.ProgramName,
		sch.Year,
		sch.Month,
		CASE 
			WHEN schP.SundayInd = 'Y' THEN 'Sunday'
			WHEN schP.MondayInd = 'Y' THEN 'Monday'
			WHEN schP.TuesdayInd = 'Y' THEN 'Tuesday'
			WHEN schP.WednesdayInd = 'Y' THEN 'Wednesday'
			WHEN schP.ThursdayInd = 'Y' THEN 'Thursday'
			WHEN schP.FridayInd = 'Y' THEN 'Friday'
			WHEN schP.SaturdayInd = 'Y' THEN 'Saturday'
		END As [DayOfWeek],
		schP.StartTime,
		schP.EndTime
	FROM
		dbo.ScheduleProgram schP INNER JOIN 
		dbo.Program p ON p.ProgramId = schP.ProgramId INNER JOIN
		dbo.Schedule sch ON schP.ScheduleId = sch.ScheduleId
	WHERE
		sch.StationId = @StationId AND
		sch.[Year] = @Year AND 
		sch.[Month] = @Month
	ORDER BY
		sch.[Year],
		sch.[Month],
		schP.StartTime
END
GO


