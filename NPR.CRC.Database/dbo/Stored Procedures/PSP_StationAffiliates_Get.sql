CREATE PROCEDURE [dbo].[PSP_StationAffiliates_Get]
(
	@StationId BIGINT
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
		StationId = @StationId
    
END
GO


