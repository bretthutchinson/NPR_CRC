CREATE PROCEDURE [dbo].[PSP_State_Save]
(
    @StateId BIGINT,
	@StateName VARCHAR(50),
	@Abbreviation VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.[State]
    SET
        StateName = @StateName,
		Abbreviation = @Abbreviation,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        StateId = @StateId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.[State]
        (
            StateName,
			Abbreviation,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @StateName,
			@Abbreviation,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @StateId = SCOPE_IDENTITY()

    END

    SELECT @StateId AS StateId

END
GO


