CREATE PROCEDURE [dbo].[PSP_StationUsers_Get]
(
	@StationId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StationUserId,
		StationId,
		su.UserId,
		su.UserId As UserName,
		dbo.FN_GetUserDisplayName(crcu.UserId) As CRCName,
		crcu.Email,
		crcu.Phone,
		CASE 
			WHEN GridWritePermissionsInd IS NOT NULL OR GridWritePermissionsInd = 'Y'
			THEN 'Yes'
			ELSE 'No'
		END As GridWritePermissionsInd,
		CASE
			WHEN su.UserId =
			(
				SELECT s.PrimaryUserId
				FROM dbo.Station s
				WHERE s.StationId = @StationId
			)
			THEN 'Yes'
			ELSE 'No'
		END AS PrimaryUserInd,
		su.CreatedDate,
		su.CreatedUserId,
		su.LastUpdatedDate,
		su.LastUpdatedUserId

    FROM
        dbo.StationUser su INNER JOIN
		dbo.CRCUser crcu ON su.UserId = crcu.UserId

	WHERE
		StationId = @StationId
    
END
GO


