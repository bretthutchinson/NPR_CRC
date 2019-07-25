CREATE PROCEDURE [dbo].[PSP_AffiliateValidateCodeIsUnique_Get]
(
	@AffiliateId BIGINT,
    @AffiliateCode VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT *
			FROM dbo.Affiliate
			WHERE AffiliateCode = @AffiliateCode
			AND (AffiliateId <> @AffiliateId OR @AffiliateId IS NULL)
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd

END
GO


