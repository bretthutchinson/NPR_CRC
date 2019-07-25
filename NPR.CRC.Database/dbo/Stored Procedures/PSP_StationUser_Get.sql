CREATE PROCEDURE [dbo].[PSP_StationUser_Get]
(
    @StationId BIGINT,
	@UserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        su.StationUserId,
		su.StationId,
		su.UserId,
		su.GridWritePermissionsInd,
		CASE
			WHEN su.UserId =
			(
				SELECT s.PrimaryUserId
				FROM dbo.Station s
				WHERE s.StationId = su.StationId
			)
			THEN 'Y'
			ELSE 'N'
		END AS PrimaryUserInd,
		su.CreatedDate,
		su.CreatedUserId,
		su.LastUpdatedDate,
		su.LastUpdatedUserId

    FROM
        dbo.StationUser su

    WHERE
        su.StationId = @StationId
		AND
		su.UserId = @UserId

END
GO


