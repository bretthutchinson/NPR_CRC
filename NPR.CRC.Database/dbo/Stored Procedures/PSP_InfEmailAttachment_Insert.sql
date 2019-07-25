CREATE PROCEDURE [dbo].[PSP_InfEmailAttachment_Insert]
(
	@InfEmailAttachmentId BIGINT,
	@InfEmailId BIGINT,
	@AttachmentName VARCHAR(100),
	@AttachmentBytes VARBINARY(MAX),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

	SET NOCOUNT ON

	INSERT INTO dbo.InfEmailAttachment
	(
		InfEmailId,
		AttachmentName,
		AttachmentBytes,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	)
	VALUES
	(
		@InfEmailId,
		@AttachmentName,
		@AttachmentBytes,
		GETUTCDATE(),
		@LastUpdatedUserId,
		GETUTCDATE(),
		@LastUpdatedUserId
	)

	SET @InfEmailAttachmentId = SCOPE_IDENTITY()

	SELECT @InfEmailAttachmentId AS InfEmailAttachmentId

END
GO


