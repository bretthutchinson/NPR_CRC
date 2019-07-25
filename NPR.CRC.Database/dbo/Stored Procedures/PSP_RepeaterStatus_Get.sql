CREATE PROCEDURE [dbo].[PSP_RepeaterStatus_Get]
(
    @RepeaterStatusId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        RepeaterStatusId,
		RepeaterStatusName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.RepeaterStatus

    WHERE
        RepeaterStatusId = @RepeaterStatusId

END
GO


