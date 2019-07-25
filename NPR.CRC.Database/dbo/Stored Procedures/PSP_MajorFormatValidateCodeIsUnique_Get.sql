CREATE PROCEDURE [dbo].[PSP_MajorFormatValidateCodeIsUnique_Get]
(
	@MajorFormatId BIGINT,
    @MajorFormatCode VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT *
			FROM dbo.MajorFormat
			WHERE MajorFormatCode = @MajorFormatCode
			AND (MajorFormatId <> @MajorFormatId OR @MajorFormatId IS NULL)
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd

END
GO


