CREATE PROCEDURE [dbo].[PSP_ProgramSource_Get]
(
    @ProgramSourceId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        ProgramSourceId,
		ProgramSourceName,
		ProgramSourceCode,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.ProgramSource

    WHERE
        ProgramSourceId = @ProgramSourceId

END
GO


