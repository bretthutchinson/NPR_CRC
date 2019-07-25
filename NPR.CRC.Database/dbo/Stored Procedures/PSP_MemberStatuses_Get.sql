CREATE PROCEDURE [dbo].[PSP_MemberStatuses_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MemberStatusId,
		MemberStatusName,
		NPRMembershipInd,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.MemberStatus
    
END
GO


