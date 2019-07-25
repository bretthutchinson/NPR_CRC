CREATE PROCEDURE [dbo].[PSP_MajorFormatValidateNameIsUnique_Get]
(
	@MajorFormatId BIGINT,
    @MajorFormatName VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT *
			FROM dbo.MajorFormat
			WHERE MajorFormatName = @MajorFormatName
			AND (MajorFormatId <> @MajorFormatId OR @MajorFormatId IS NULL)
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd

END
GO


