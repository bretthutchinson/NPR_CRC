CREATE  PROCEDURE [dbo].[PSP_ProgramRegularMulticast_Get]

WITH EXECUTE AS OWNER

AS BEGIN

    SET NOCOUNT ON

    SELECT
        
		ProgramName
	FROM
        dbo.Program

    WHERE
        ProgramName not like '%Off Air%' 

END