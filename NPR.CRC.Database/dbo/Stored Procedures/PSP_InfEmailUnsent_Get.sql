CREATE PROCEDURE [dbo].[PSP_InfEmailUnsent_Get]
(
	@MaxRetryAttempts INT
)
AS BEGIN

	SET NOCOUNT ON

	SELECT
		InfEmailId,
		FromAddress,
		ToAddress,
		CcAddress,
		BccAddress,
		Priority,
		Subject,
		Body,
		HtmlInd,
		SentDate,
		RetryCount,
		LastError,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	FROM
		dbo.InfEmail
	WHERE
		SentDate IS NULL
		AND
		RetryCount < @MaxRetryAttempts
	ORDER BY
		CreatedDate

END
GO


