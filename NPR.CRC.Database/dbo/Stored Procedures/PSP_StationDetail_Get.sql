CREATE PROCEDURE [dbo].[PSP_StationDetail_Get]
(
    @StationId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        s.StationId,
		s.CallLetters,
		S.BandId,
		b.BandName,
		s.Frequency,
		s.RepeaterStatusId,
		RepeaterStatusName,
		s.FlagshipStationId,
		fls.CallLetters + '-' + bls.BandName As FlagshipStationName,
		s.PrimaryUserId,
		s.MemberStatusId,
		memS.MemberStatusName,
		minS.MinorityStatusId,
		MinorityStatusName,
		s.StatusDate,
		s.LicenseeTypeId,
		lType.LicenseeTypeName,
		s.LicenseeName,
		s.AddressLine1,
		s.AddressLine2,
		s.City,
		s.StateId,
		[State].Abbreviation As StateAbbreviation,
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
		metM.MarketName As MetroMarketName,
		s.MetroMarketRank,
		s.DMAMarketId,
		dmaM.MarketName As DMAMarketName,
		s.DMAMarketRank,
		s.TimeZoneId,
		tZone.DisplayName As TimeZoneName,
		s.HoursFromFlagship,
		s.MaxNumberOfUsers,
		STUFF(
			(
				SELECT ', ' + a.AffiliateCode
				FROM dbo.Affiliate a
				JOIN dbo.StationAffiliate sa ON sa.AffiliateId = a.AffiliateId
				WHERE sa.StationId = s.StationId
				ORDER BY a.AffiliateCode
				FOR XML PATH('')
			), 1, 1, '') AS AffiliateCodesList,
		s.DisabledDate,
		s.DisabledUserId,
		s.CreatedDate,
		s.CreatedUserId,
		s.LastUpdatedDate,
		s.LastUpdatedUserId

    FROM
		dbo.Station s INNER JOIN
		dbo.Band b ON s.BandId = b.BandId INNER JOIN
		dbo.RepeaterStatus rs ON s.RepeaterStatusId = rs.RepeaterStatusId INNER JOIN
		dbo.MemberStatus memS ON s.MemberStatusId = memS.MemberStatusId INNER JOIN
		dbo.MinorityStatus minS ON s.MinorityStatusId = minS.MinorityStatusId INNER JOIN
		dbo.LicenseeType lType ON s.LicenseeTypeId = lType.LicenseeTypeId LEFT JOIN
		dbo.[State] ON s.StateId = [State].StateId LEFT JOIN
		dbo.MetroMarket metM ON s.MetroMarketId = metM.MetroMarketId LEFT JOIN
		dbo.DMAMarket dmaM ON s.DMAMarketId = dmaM.DMAMarketId INNER JOIN
		dbo.TimeZone tZone ON s.TimeZoneId = tZone.TimeZoneId
		left Join station fls on fls.stationid = s.FlagshipStationId
		left join band bls on fls.bandid = bls.bandid
    WHERE
        s.StationId = @StationId 

END
GO


