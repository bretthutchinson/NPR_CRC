CREATE PROCEDURE [dbo].[PSP_InfEmailTemplateByName_Get]
(
	@TemplateName VARCHAR(50)
)
AS BEGIN

	SET NOCOUNT ON

	SELECT
		InfEmailTemplateId,
		TemplateName,
		FromAddress,
		ToAddress,
		CcAddress,
		BccAddress,
		Subject,
		Body,
		HtmlInd,
		Priority,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	FROM
		dbo.InfEmailTemplate
	WHERE
		TemplateName = @TemplateName

END
GO


