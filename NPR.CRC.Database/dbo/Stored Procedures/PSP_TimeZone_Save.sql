CREATE PROCEDURE [dbo].[PSP_TimeZone_Save]
(
    @TimeZoneId BIGINT,
	@TimeZoneCode VARCHAR(50),
	@DisplayName VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.TimeZone
    SET
        TimeZoneCode = @TimeZoneCode,
		DisplayName = @DisplayName,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        TimeZoneId = @TimeZoneId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.TimeZone
        (
            TimeZoneCode,
			DisplayName,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @TimeZoneCode,
			@DisplayName,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @TimeZoneId = SCOPE_IDENTITY()

    END

    SELECT @TimeZoneId AS TimeZoneId

END
GO


