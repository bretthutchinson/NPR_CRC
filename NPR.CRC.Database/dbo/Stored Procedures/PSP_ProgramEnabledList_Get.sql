CREATE PROCEDURE [dbo].[PSP_ProgramEnabledList_Get]

AS BEGIN

    SET NOCOUNT ON

    SELECT
        
		ProgramName
		
    FROM
        dbo.Program

    WHERE
	
        DisabledDate is null

END
GO


