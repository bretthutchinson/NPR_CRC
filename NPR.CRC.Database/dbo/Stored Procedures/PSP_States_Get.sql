CREATE PROCEDURE [dbo].[PSP_States_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StateId,
		StateName,
		Abbreviation,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.[State]
    
END
GO


