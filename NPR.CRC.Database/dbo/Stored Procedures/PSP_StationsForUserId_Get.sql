CREATE PROCEDURE [dbo].[PSP_StationsForUserId_Get]
(
	@UserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        s.StationId,
		su.UserId,
		CASE
			WHEN s.PrimaryUserId = su.UserId
			THEN 'Y'
			ELSE 'N'
		END AS PrimaryUserInd,
		su.GridWritePermissionsInd,
		s.CallLetters,
		s.BandId,
		s.CallLetters + '-' + b.BandName AS StationDisplayName,
		s.Frequency,
		s.RepeaterStatusId,
		s.FlagshipStationId,
		s.PrimaryUserId,
		s.MemberStatusId,
		s.MinorityStatusId,
		s.StatusDate,
		s.LicenseeTypeId,
		s.LicenseeName,
		s.AddressLine1,
		s.AddressLine2,
		s.City,
		s.StateId,
		s.County,
		s.Country,
		s.Phone,
		s.Fax,
		s.Email,
		s.WebPage,
		s.TSACume,
		s.TSAAQH,
		s.MetroMarketId,
		s.MetroMarketRank,
		s.DMAMarketId,
		s.DMAMarketRank,
		s.TimeZoneId,
		s.HoursFromFlagship,
		s.MaxNumberOfUsers,
		s.DisabledDate,
		s.DisabledUserId,
		s.CreatedDate,
		s.CreatedUserId,
		s.LastUpdatedDate,
		s.LastUpdatedUserId

    FROM
        dbo.Station s

		JOIN dbo.Band b
			ON b.BandId = s.BandId

		JOIN dbo.StationUser su
			ON su.StationId = s.StationId

	WHERE
		su.UserId = @UserId

END
GO


