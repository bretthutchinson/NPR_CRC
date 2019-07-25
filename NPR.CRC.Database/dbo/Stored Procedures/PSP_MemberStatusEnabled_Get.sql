CREATE  PROCEDURE [dbo].[PSP_MemberStatusEnabled_Get]
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

    SELECT
        MemberStatusId,
		MemberStatusName
	FROM
        dbo.MemberStatus

    WHERE
        NPRMembershipInd='Y'

END
GO


