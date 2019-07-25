CREATE PROCEDURE [dbo].[PSP_ProgramLookup_Get]

AS BEGIN

    SET NOCOUNT ON

    SELECT
        
		ProgramID,ProgramName
		
    FROM
        dbo.Program

    WHERE
	
        DisabledDate is null

END