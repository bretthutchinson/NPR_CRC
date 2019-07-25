CREATE PROCEDURE [dbo].[PSP_MajorFormat_Get]
(
    @MajorFormatId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MajorFormatId,
		MajorFormatName,
		MajorFormatCode,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MajorFormat

    WHERE
        MajorFormatId = @MajorFormatId

END
GO


