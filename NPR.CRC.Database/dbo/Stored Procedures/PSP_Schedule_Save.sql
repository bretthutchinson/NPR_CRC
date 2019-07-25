CREATE PROCEDURE [dbo].[PSP_Schedule_Save]
(
    @ScheduleId BIGINT,
	@StationId BIGINT,
	@Year INT,
	@Month INT,
	@SubmittedDate DATETIME,
	@SubmittedUserId BIGINT,
	@AcceptedDate DATETIME,
	@AcceptedUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Schedule
    SET
        StationId = @StationId,
		[Year] = @Year,
		[Month] = @Month,
		SubmittedDate = @SubmittedDate,
		SubmittedUserId = @SubmittedUserId,
		AcceptedDate = @AcceptedDate,
		AcceptedUserId = @AcceptedUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ScheduleId = @ScheduleId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Schedule
        (
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
        )
        VALUES
        (
            @StationId,
			@Year,
			@Month,
			@SubmittedDate,
			@SubmittedUserId,
			@AcceptedDate,
			@AcceptedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @ScheduleId = SCOPE_IDENTITY()

    END

    SELECT @ScheduleId AS ScheduleId

END
GO


