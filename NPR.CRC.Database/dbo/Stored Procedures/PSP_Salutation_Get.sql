CREATE PROCEDURE [dbo].[PSP_Salutation_Get]
(
    @SalutationId BIGINT
)
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

    WHERE
        SalutationId = @SalutationId

END
GO


