CREATE PROCEDURE [dbo].[PSP_InfEmail_Insert]
(
	@FromAddress VARCHAR(50),
	@ToAddress VARCHAR(MAX),
	@CcAddress VARCHAR(MAX),
	@BccAddress VARCHAR(MAX),
	@Subject VARCHAR(500),
	@Body VARCHAR(MAX),
	@HtmlInd CHAR(1),
	@Priority VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

	SET NOCOUNT ON

	INSERT INTO dbo.InfEmail
	(
		FromAddress,
		ToAddress,
		CcAddress,
		BccAddress,
		Subject,
		Body,
		HtmlInd,
		Priority,
		SentDate,
		RetryCount,
		LastError,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	)
	VALUES
	(
		@FromAddress,
		@ToAddress,
		@CcAddress,
		@BccAddress,
		@Subject,
		@Body,
		@HtmlInd,
		@Priority,
		NULL,
		0,
		NULL,
		GETUTCDATE(),
		@LastUpdatedUserId,
		GETUTCDATE(),
		@LastUpdatedUserId
	)

	DECLARE @InfEmailId INT
	SET @InfEmailId = SCOPE_IDENTITY()

	SELECT @InfEmailId AS InfEmailId

END
GO


