CREATE PROCEDURE [dbo].[PSP_SchedulePrograms_Get]
(
	@ScheduleId BIGINT,
	@GridInd CHAR(1)
)
AS BEGIN

    SET NOCOUNT ON
	IF @GridInd = 'N'
	BEGIN
		SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		0 DayOfWeekNo,
		'Sunday' [DayOfWeek],
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND SundayInd = 'Y'

	UNION ALL

	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		1,
		'Monday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND MondayInd = 'Y'
	
	UNION ALL
	
	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		2,
		'Tuesday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND TuesdayInd = 'Y'
	
	UNION ALL
	
	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		3,
		'Wednesday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND WednesdayInd = 'Y'
	
	UNION ALL
	
	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		4,
		'Thursday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND ThursdayInd = 'Y'
	
	UNION ALL
	
	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		5,
		'Friday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND FridayInd = 'Y'
	
	UNION ALL
	
	SELECT
        sp.ScheduleProgramId,
		sp.ScheduleId,
		sp.ProgramId,
		p.ProgramName,
		sch.[Month],
		sch.[Year],
		6,
		'Saturday',
		sp.StartTime,
		sp.EndTime,
		sp.QuarterHours,
		sp.SundayInd,
		sp.MondayInd,
		sp.TuesdayInd,
		sp.WednesdayInd,
		sp.ThursdayInd,
		sp.FridayInd,
		sp.SaturdayInd,
		sp.CreatedDate,
		sp.CreatedUserId,
		sp.LastUpdatedDate,
		sp.LastUpdatedUserId
    FROM
        dbo.ScheduleProgram sp INNER JOIN
		dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
		dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
	WHERE
		sp.ScheduleId = @ScheduleId AND SaturdayInd = 'Y'

	Order By ScheduleProgramId, DayOfWeekNo
    END
	ELSE
	BEGIN
		SELECT
			sp.ScheduleProgramId,
			sp.ScheduleId,
			sp.ProgramId,
			p.ProgramName,
			sch.[Month],
			sch.[Year],
			--CASE WHEN SundayInd = 'Y' THEN 'Sun ' ELSE + '' END + 
			CASE WHEN MondayInd = 'Y' THEN 'Mon ' ELSE + '' END + 
			CASE WHEN TuesdayInd = 'Y' THEN 'Tue ' ELSE + '' END + 
			CASE WHEN WednesdayInd = 'Y' THEN 'Wed ' ELSE + '' END + 
			CASE WHEN ThursdayInd = 'Y' THEN 'Thu ' ELSE + '' END + 
			CASE WHEN FridayInd = 'Y' THEN 'Fri ' ELSE + '' END + 
			CASE WHEN SaturdayInd = 'Y' THEN 'Sat ' ELSE + '' END +
			CASE WHEN SundayInd = 'Y' THEN 'Sun ' ELSE + '' END 
			As [DaysOfWeek],
			sp.StartTime,
			sp.EndTime,
			sp.QuarterHours,
			CASE WHEN SundayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN MondayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN TuesdayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN WednesdayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN ThursdayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN FridayInd = 'Y' THEN QuarterHours ELSE + 0 END + 
			CASE WHEN SaturdayInd = 'Y' THEN QuarterHours ELSE + 0 END As [TotalQuarterHours],
			sp.SundayInd,
			sp.MondayInd,
			sp.TuesdayInd,
			sp.WednesdayInd,
			sp.ThursdayInd,
			sp.FridayInd,
			sp.SaturdayInd,
			sp.CreatedDate,
			sp.CreatedUserId,
			sp.LastUpdatedDate,
			sp.LastUpdatedUserId
		FROM
			dbo.ScheduleProgram sp INNER JOIN
			dbo.Program p ON sp.ProgramId = p.ProgramId INNER JOIN
			dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId
		WHERE
			sp.ScheduleId = @ScheduleId
	END
END
GO


