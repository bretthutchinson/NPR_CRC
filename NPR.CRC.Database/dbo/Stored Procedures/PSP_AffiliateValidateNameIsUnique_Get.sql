CREATE PROCEDURE [dbo].[PSP_AffiliateValidateNameIsUnique_Get]
(
	@AffiliateId BIGINT,
    @AffiliateName VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT *
			FROM dbo.Affiliate
			WHERE AffiliateName = @AffiliateName
			AND (AffiliateId <> @AffiliateId OR @AffiliateId IS NULL)
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd

END
GO


