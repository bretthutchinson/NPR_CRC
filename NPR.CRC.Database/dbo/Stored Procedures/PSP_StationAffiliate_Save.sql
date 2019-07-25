CREATE PROCEDURE [dbo].[PSP_StationAffiliate_Save]
(
    @StationAffiliateId BIGINT,
	@StationId BIGINT,
	@AffiliateId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.StationAffiliate
    SET
        StationId = @StationId,
		AffiliateId = @AffiliateId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        StationAffiliateId = @StationAffiliateId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.StationAffiliate
        (
            StationId,
			AffiliateId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @StationId,
			@AffiliateId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @StationAffiliateId = SCOPE_IDENTITY()

    END

    SELECT @StationAffiliateId AS StationAffiliateId

END
GO


