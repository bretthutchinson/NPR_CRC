CREATE PROCEDURE [dbo].[PSP_InfEmailAttachmentsForEmail_Get]
(
	@InfEmailId BIGINT
)
AS BEGIN

	SET NOCOUNT ON

	SELECT
		InfEmailAttachmentId,
		InfEmailId,
		AttachmentName,
		AttachmentBytes,
		AttachmentSize,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	FROM
		dbo.InfEmailAttachment
	WHERE
		InfEmailId = @InfEmailId
	ORDER BY
		AttachmentName

END
GO


