CREATE PROCEDURE [dbo].[PSP_Affiliates_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        AffiliateId,
		AffiliateName,
		AffiliateCode,
		CASE
			WHEN DisabledDate IS NULL
			THEN 'Yes'
			ELSE 'No'
		END AS EnabledInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Affiliate
    
END
GO


