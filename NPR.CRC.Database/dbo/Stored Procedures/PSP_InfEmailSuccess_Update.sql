CREATE PROCEDURE [dbo].[PSP_InfEmailSuccess_Update]
(
	@InfEmailId BIGINT
)
AS BEGIN

	SET NOCOUNT ON

	UPDATE dbo.InfEmail
	SET
		SentDate = GETUTCDATE(),
		LastUpdatedDate = GETUTCDATE()
	WHERE
		InfEmailId = @InfEmailId

END
GO


