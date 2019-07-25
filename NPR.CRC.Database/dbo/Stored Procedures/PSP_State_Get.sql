CREATE PROCEDURE [dbo].[PSP_State_Get]
(
    @StateId BIGINT
)
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

    WHERE
        StateId = @StateId

END
GO


