CREATE PROCEDURE dbo.DT_Station
(
	@UserId INT
)
AS BEGIN

INSERT INTO [CRC_Migration].[dbo].[Station]
           ([CallLetters]
           ,[BandId]
           ,[Frequency]
           ,[RepeaterStatusId]
           ,[FlagshipStationId]
           ,[PrimaryUserId]
           ,[MemberStatusId]
           ,[MinorityStatusId]
           ,[StatusDate]
           ,[LicenseeTypeId]
           ,[LicenseeName]
           ,[AddressLine1]
           ,[AddressLine2]
           ,[City]
           ,[StateId]
           ,[County]
           ,[Country]
           ,[ZipCode]
           ,[Phone]
           ,[Fax]
           ,[Email]
           ,[WebPage]
           ,[TSACume]
           ,[TSAAQH]
           ,[MetroMarketId]
           ,[MetroMarketRank]
           ,[DMAMarketId]
           ,[DMAMarketRank]
           ,[TimeZoneId]
           ,[HoursFromFlagship]
           ,[MaxNumberOfUsers]
           ,[DisabledDate]
           ,[DisabledUserId]
           ,[CreatedDate]
           ,[CreatedUserId]
           ,[LastUpdatedDate]
           ,[LastUpdatedUserId])

	SELECT 
	CallLetters,	
	(SELECT BandId FROM CRC_Migration.dbo.Band b WHERE b.BandName = Band) As Band,
	Frequency,
	(SELECT RepeaterStatusID FROM CRC_Migration.dbo.RepeaterStatus rs WHERE rs.RepeaterStatusName = rep.RepeaterStatusDescription),
	(SELECT FlagShipId FROM CRC_Migration.dbo.Station stat WHERE stat.CallLetters = CallLetters AND stat.BandId = (SELECT BandId FROM CRC_Migration.dbo.Band b WHERE b.BandName = Band)) As FlagShipId,
	Null, --PrimaryUserId, --????	
	(SELECT MemberStatusID FROM CRC_Migration.dbo.MemberStatus m WHERE m.MemberStatusName = ms.MemberStatusName),
	(SELECT MinorityStatusID FROM CRC_Migration.dbo.MinorityStatus mem WHERE mem.MinorityStatusName = min.MinorityStatus),	
	StatusDate,
	LicenseeTypeID,
	LicenseName,
	Address1,
	Address2,
	City,	
	(SELECT StateId From CRC_Migration.dbo.State ss WHERE ss.Abbreviation = sta.StateProvince) As StateProvince, 
	County,
	Country,
	PostalCode,
	Telephone,
	Fax,
	CAST(Email As VARCHAR(50)),
	URL_Station, --WebPage
	TSACume,
	TSAAQH,
	(SELECT MetroMarketId FROM CRC_Migration.dbo.MetroMarket mm WHERE mm.MarketName = MetroMarket),
	MetroRanking, --Don't know where to find this
	(SELECT DMAMarketID FROM CRC_Migration.dbo.DMAMarket dm WHERE dm.MarketName = DMAMarket),
	DMARank,
	(SELECT TimeZoneId FROM CRC_Migration.dbo.TimeZone tz WHERE tz.TimeZoneCode = zone.TimeZoneName) AS TimeZoneId,
	HoursFromFlagship,
	AssociatedUserMax,
	NULL,--DisabledDate ??
	NULL, --DiabledUserID ??
	GETUTCDATE(), --CreatedDate
	@UserId, --CreatedUserId
	GETUTCDATE(), --LastUpdatedDate
	@UserId --LastUpdatedUserId
	FROM crc3.dbo.Station sta	

	JOIN crc3.dbo.MemberStatus ms ON ms.MemberStatusId = sta.MemberStatusID
	JOIN crc3.dbo.MinorityStatus min ON min.MinorityStatusID = sta.MinorityStatusID
	JOIN crc3.dbo.RepeaterStatus rep ON rep.RepeaterStatusID = sta.RepeaterStatusID
	JOIN crc3.dbo.TimeZone zone ON zone.TimeZoneID = sta.TimeZoneID

	/* COULD NOT find corresponding values in target table
	Satellite,
	Notes,
	InternetReady,
	JointWithTV,
	Budget,
	NPRDues,
	URL_Station,
	Comment,	
	NPRMemberStatus  
	*/

GRANT EXEC ON dbo.DT_Station TO CRCUser

END