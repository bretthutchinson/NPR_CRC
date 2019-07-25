CREATE PROCEDURE [dbo].[PSP_Affiliate_Save]
(
    @AffiliateId BIGINT,
	@AffiliateName VARCHAR(50),
	@AffiliateCode VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Affiliate
    SET
        AffiliateName = @AffiliateName,
		AffiliateCode = @AffiliateCode,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        AffiliateId = @AffiliateId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Affiliate
        (
            AffiliateName,
			AffiliateCode,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @AffiliateName,
			@AffiliateCode,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @AffiliateId = SCOPE_IDENTITY()

    END

    SELECT @AffiliateId AS AffiliateId

END
GO


