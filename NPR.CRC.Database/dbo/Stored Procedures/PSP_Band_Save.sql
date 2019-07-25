CREATE PROCEDURE [dbo].[PSP_Band_Save]
(
    @BandId BIGINT,
	@BandName VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Band
    SET
        BandName = @BandName,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        BandId = @BandId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Band
        (
            BandName,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @BandName,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @BandId = SCOPE_IDENTITY()

    END

    SELECT @BandId AS BandId

END
GO


