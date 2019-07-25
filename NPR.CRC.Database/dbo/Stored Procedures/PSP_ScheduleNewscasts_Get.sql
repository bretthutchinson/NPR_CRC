CREATE PROCEDURE [dbo].[PSP_ScheduleNewscasts_Get]
(
	@ScheduleId BIGINT,
	@GridInd CHAR(1)
)
AS BEGIN

    SET NOCOUNT ON

	IF @GridInd = 'N'
	BEGIN
		SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		0 DayOfWeekNo,
		'Sunday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		SundayInd = 'Y'

	UNION ALL
    
    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		1 DayOfWeekNo,
		'Monday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		MondayInd = 'Y'

	UNION ALL

    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		2 DayOfWeekNo,
		'Tuesday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId
	WHERE
		sn.ScheduleId = @ScheduleId AND
		TuesdayInd = 'Y'

	UNION ALL

    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		3 DayOfWeekNo,
		'Wednesday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		WednesdayInd = 'Y'

	UNION ALL

    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		4 DayOfWeekNo,
		'Thursday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		ThursdayInd = 'Y'

	UNION ALL

    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		5 DayOfWeekNo,
		'Friday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		FridayInd = 'Y'

	UNION ALL

    SELECT
        ScheduleNewscastId,
		sn.ScheduleId,
		'NPR Newscast Service' ProgramName,
		sch.[Month],
		sch.[Year],
		6 DayOfWeekNo,
		'Saturday' [DayOfWeek],
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		sn.CreatedDate,
		sn.CreatedUserId,
		sn.LastUpdatedDate,
		sn.LastUpdatedUserId
    FROM
        dbo.ScheduleNewscast sn INNER JOIN
		dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

	WHERE
		sn.ScheduleId = @ScheduleId AND
		SaturdayInd = 'Y'
	END
	ELSE
	BEGIN
		SELECT
			ScheduleNewscastId,
			sn.ScheduleId,
			'NPR Newscast Service' ProgramName,
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
			StartTime,
			EndTime,
			HourlyInd,
			DurationMinutes,
			SundayInd,
			MondayInd,
			TuesdayInd,
			WednesdayInd,
			ThursdayInd,
			FridayInd,
			SaturdayInd,
			sn.CreatedDate,
			sn.CreatedUserId,
			sn.LastUpdatedDate,
			sn.LastUpdatedUserId
		FROM
			dbo.ScheduleNewscast sn INNER JOIN
			dbo.Schedule sch ON sn.ScheduleId = sch.ScheduleId

		WHERE
			sn.ScheduleId = @ScheduleId
	END
END
GO


