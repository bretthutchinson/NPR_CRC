CREATE PROCEDURE [dbo].[PSP_MinorityStatus_Save]
(
    @MinorityStatusId BIGINT,
	@MinorityStatusName VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.MinorityStatus
    SET
        MinorityStatusName = @MinorityStatusName,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        MinorityStatusId = @MinorityStatusId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.MinorityStatus
        (
            MinorityStatusName,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @MinorityStatusName,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @MinorityStatusId = SCOPE_IDENTITY()

    END

    SELECT @MinorityStatusId AS MinorityStatusId

END
GO


