CREATE PROCEDURE [dbo].[PSP_ProgramSources_Get]
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
    
END
GO


