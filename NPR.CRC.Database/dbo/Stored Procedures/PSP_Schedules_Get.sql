CREATE PROCEDURE [dbo].[PSP_Schedules_Get]
(
	@StationId BIGINT,
	@Year INT,
	@Month INT,
	@Status VARCHAR(50)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ScheduleId,
		StationId,
		[Year],
		[Month],
		SubmittedDate,
		SubmittedUserId,
		AcceptedDate,
		AcceptedUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Schedule

	WHERE
		StationId = @StationId
		AND
		(Year = @Year OR @Year IS NULL)
		AND
		(Month = @Month OR @Month IS NULL)
		-- todo: status
    
END
GO


