--DROP PROCEDURE [dbo].[PSP_StationsActiveList_Get]

CREATE PROCEDURE [dbo].[PSP_StationsActiveList_Get]
(
	@UserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        s.StationId,
		s.CallLetters + '-' + b.BandName AS DisplayName

    FROM
        dbo.Station s

		JOIN dbo.Band b
			ON b.BandId = s.BandId

	WHERE s.DisabledDate IS NULL AND
		(@UserId IS NULL
		OR
		EXISTS
		(
			SELECT *
			FROM dbo.StationUser su
			WHERE su.StationId = s.StationId
			AND su.UserId = @UserId
		)
		OR
		EXISTS
		(
			SELECT *
			FROM dbo.CRCUser
			WHERE UserId = @UserId
			AND AdministratorInd = 'Y'
		))

END