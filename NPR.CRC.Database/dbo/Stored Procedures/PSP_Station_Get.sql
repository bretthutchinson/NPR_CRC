--DROP PROCEDURE [dbo].[PSP_Station_Get]

CREATE PROCEDURE [dbo].[PSP_Station_Get] --1
(
    @StationId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        s.StationId,
		s.CallLetters,
		s.BandId,
		s.CallLetters + '-' + b.BandName AS StationDisplayName,
		s.Frequency,
		s.RepeaterStatusId,
		s.FlagshipStationId,
		s.PrimaryUserId,
		dbo.FN_GetUserDisplayName(s.PrimaryUserId) AS PrimaryUserDisplayName,
		u.Phone AS PrimaryUserPhone,
		u.Email AS PrimaryUserEmail,
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
		s.ZipCode,
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
		s.LastUpdatedUserId,
		sf.CallLetters + '-' + fb.bandname as flagship 

    FROM
        dbo.Station s

		JOIN dbo.Band b
			ON b.BandId = s.BandId

		LEFT JOIN dbo.CRCUser u
			ON u.UserId = s.PrimaryUserId
			left join station sf on sf.stationid = s.FlagshipStationId
			left join band fb on fb.bandid = sf.bandid

    WHERE
        s.StationId = @StationId
	--select * from band
END
GO


