CREATE PROCEDURE [dbo].[PSP_Salutations_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        SalutationId,
		SalutationName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Salutation
    
END
GO


