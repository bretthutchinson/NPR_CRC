CREATE PROCEDURE [dbo].[PSP_CarriageType_Save]
(
    @CarriageTypeId BIGINT,
	@CarriageTypeName VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.CarriageType
    SET
        CarriageTypeName = @CarriageTypeName,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        CarriageTypeId = @CarriageTypeId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.CarriageType
        (
            CarriageTypeName,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @CarriageTypeName,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @CarriageTypeId = SCOPE_IDENTITY()

    END

    SELECT @CarriageTypeId AS CarriageTypeId

END
GO


