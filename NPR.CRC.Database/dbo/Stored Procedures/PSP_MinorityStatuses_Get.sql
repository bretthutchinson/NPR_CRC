CREATE PROCEDURE [dbo].[PSP_MinorityStatuses_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MinorityStatusId,
		MinorityStatusName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MinorityStatus
    
END
GO


