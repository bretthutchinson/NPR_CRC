CREATE PROCEDURE [dbo].[PSP_MemberStatus_Get]
(
    @MemberStatusId BIGINT
)
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

    WHERE
        MemberStatusId = @MemberStatusId

END
GO


