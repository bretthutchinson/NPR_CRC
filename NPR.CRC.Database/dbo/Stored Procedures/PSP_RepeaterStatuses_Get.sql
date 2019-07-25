CREATE PROCEDURE [dbo].[PSP_RepeaterStatuses_Get]
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
    
END
GO


