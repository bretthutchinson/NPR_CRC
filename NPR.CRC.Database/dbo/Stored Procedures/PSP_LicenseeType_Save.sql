CREATE PROCEDURE [dbo].[PSP_LicenseeType_Save]
(
    @LicenseeTypeId BIGINT,
	@LicenseeTypeName VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.LicenseeType
    SET
        LicenseeTypeName = @LicenseeTypeName,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        LicenseeTypeId = @LicenseeTypeId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.LicenseeType
        (
            LicenseeTypeName,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @LicenseeTypeName,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @LicenseeTypeId = SCOPE_IDENTITY()

    END

    SELECT @LicenseeTypeId AS LicenseeTypeId

END
GO


