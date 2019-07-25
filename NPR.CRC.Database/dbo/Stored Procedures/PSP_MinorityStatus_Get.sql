CREATE PROCEDURE [dbo].[PSP_MinorityStatus_Get]
(
    @MinorityStatusId BIGINT
)
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

    WHERE
        MinorityStatusId = @MinorityStatusId

END
GO


