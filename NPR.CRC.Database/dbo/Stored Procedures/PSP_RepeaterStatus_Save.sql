CREATE PROCEDURE [dbo].[PSP_RepeaterStatus_Save]
(
    @RepeaterStatusId BIGINT,
	@RepeaterStatusName VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.RepeaterStatus
    SET
        RepeaterStatusName = @RepeaterStatusName,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        RepeaterStatusId = @RepeaterStatusId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.RepeaterStatus
        (
            RepeaterStatusName,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @RepeaterStatusName,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @RepeaterStatusId = SCOPE_IDENTITY()

    END

    SELECT @RepeaterStatusId AS RepeaterStatusId

END
GO


