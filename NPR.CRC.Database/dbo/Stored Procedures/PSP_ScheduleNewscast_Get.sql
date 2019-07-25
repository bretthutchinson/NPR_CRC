CREATE PROCEDURE [dbo].[PSP_ScheduleNewscast_Get]
(
    @ScheduleNewscastId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ScheduleNewscastId,
		ScheduleId,
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
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.ScheduleNewscast

    WHERE
        ScheduleNewscastId = @ScheduleNewscastId

END
GO


