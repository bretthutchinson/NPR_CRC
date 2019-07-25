CREATE PROCEDURE [dbo].[PSP_StationAssociates_Get]
(
    @StationId BIGINT,
	@HDFlag CHAR(1)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        s.StationId,
		s.CallLetters + '-' + b.BandName As CallLetters,
		s.BandId,
		b.BandName,
		s.Frequency,
		s.RepeaterStatusId,
		RepeaterStatusName,
		s.FlagshipStationId,
		flagSS.CallLetters + '-' + b1.BandName As FlagshipStationName,
		/*s.PrimaryUserId,*/
		s.MemberStatusId,
		memS.MemberStatusName,
		/*minS.MinorityStatusId,
		MinorityStatusName,
		StatusDate,*/
		s.LicenseeTypeId,
		lType.LicenseeTypeName,
		s.LicenseeName,
		/*s.AddressLine1,
		s.AddressLine2,*/
		s.City,
		s.StateId,
		[State].Abbreviation As StateAbbreviation,
		/*County,
		Country,
		ZipCode,
		Phone,
		Fax,
		Email,
		WebPage,
		TSACume,
		TSAAQH,
		s.MetroMarketId,
		metM.MarketName As MetroMarketName,*/
		s.MetroMarketRank,
		/*s.DMAMarketId,
		dmaM.MarketName As DMAMarketName,*/
		s.DMAMarketRank,
		/*s.TimeZoneId,
		tZone.DisplayName As TimeZoneName,
		HoursFromFlagship,
		MaxNumberOfUsers,*/
		STUFF(
			(
				SELECT ', ' + a.AffiliateCode
				FROM dbo.Affiliate a
				JOIN dbo.StationAffiliate sa ON sa.AffiliateId = a.AffiliateId
				WHERE sa.StationId = s.StationId
				ORDER BY a.AffiliateCode
				FOR XML PATH('')
			), 1, 1, '') AS AffiliateCodesList,
		CASE WHEN s.DisabledDate IS NULL THEN 'Enabled' ELSE 'Disabled' END As EnabledInd,
		s.DisabledDate,
		s.DisabledUserId,
		s.CreatedDate,
		s.CreatedUserId,
		s.LastUpdatedDate,
		s.LastUpdatedUserId

    FROM
		dbo.Station s INNER JOIN
		dbo.Station FlagSS ON s.FlagshipStationId = FlagSS.StationId INNER JOIN 
		dbo.Band b ON s.BandId = b.BandId INNER JOIN
		dbo.RepeaterStatus rs ON s.RepeaterStatusId = rs.RepeaterStatusId INNER JOIN
		dbo.MemberStatus memS ON s.MemberStatusId = memS.MemberStatusId INNER JOIN
		dbo.MinorityStatus minS ON s.MinorityStatusId = minS.MinorityStatusId INNER JOIN
		dbo.LicenseeType lType ON s.LicenseeTypeId = lType.LicenseeTypeId LEFT JOIN
		dbo.[State] ON s.StateId = [State].StateId LEFT JOIN
		dbo.MetroMarket metM ON s.MetroMarketId = metM.MetroMarketId LEFT JOIN
		dbo.DMAMarket dmaM ON s.DMAMarketId = dmaM.DMAMarketId INNER JOIN
		dbo.TimeZone tZone ON s.TimeZoneId = tZone.TimeZoneId LEFT JOIN
		dbo.Band b1 ON FlagSS.BandId = b1.BandId
    WHERE
        s.FlagshipStationId = @StationId AND 
		/* Retrieve HD vs non-HD stations */
		s.BandId IN (
			SELECT 
				BandId
			FROM
				dbo.Band
			WHERE
				BandName like CASE WHEN @HDFlag = 'Y' THEN '%HD%' ELSE '%M' END)
END
GO


