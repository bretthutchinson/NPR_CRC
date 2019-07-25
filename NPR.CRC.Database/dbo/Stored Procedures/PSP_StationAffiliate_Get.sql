CREATE PROCEDURE [dbo].[PSP_StationAffiliate_Get]
(
    @StationAffiliateId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StationAffiliateId,
		StationId,
		AffiliateId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.StationAffiliate

    WHERE
        StationAffiliateId = @StationAffiliateId

END
GO


