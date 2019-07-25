CREATE PROCEDURE [dbo].[PSP_ScheduleProgram_Get]
(
    @ScheduleProgramId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ScheduleProgramId,
		ScheduleId,
		ProgramId,
		StartTime,
		EndTime,
		QuarterHours,
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
        dbo.ScheduleProgram

    WHERE
        ScheduleProgramId = @ScheduleProgramId

END
GO


