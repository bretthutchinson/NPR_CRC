CREATE PROCEDURE [dbo].[PSP_Salutation_Save]
(
    @SalutationId BIGINT,
	@SalutationName VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Salutation
    SET
        SalutationName = @SalutationName,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        SalutationId = @SalutationId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Salutation
        (
            SalutationName,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @SalutationName,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @SalutationId = SCOPE_IDENTITY()

    END

    SELECT @SalutationId AS SalutationId

END
GO


