CREATE PROCEDURE [dbo].[PSP_Affiliate_Get]
(
    @AffiliateId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        AffiliateId,
		AffiliateName,
		AffiliateCode,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Affiliate

    WHERE
        AffiliateId = @AffiliateId

END
GO


