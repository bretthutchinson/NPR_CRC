CREATE PROCEDURE [dbo].[PSP_InfEmailError_Update]
(
	@InfEmailId BIGINT,
	@LastError VARCHAR(MAX)
)
AS BEGIN

	SET NOCOUNT ON

	UPDATE dbo.InfEmail
	SET
		RetryCount = RetryCount + 1,
		LastError = @LastError,
		LastUpdatedDate = GETUTCDATE()
	WHERE
		InfEmailId = @InfEmailId

END
GO


