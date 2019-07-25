-- DT_Station 1
CREATE PROCEDURE [dbo].[DT_Station]
(
	@UserId INT
)
AS BEGIN

INSERT INTO [CRC_Migration_Test_BH].[dbo].[Station]
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
	(SELECT BandId FROM [CRC_Migration_Test_BH].dbo.Band b WHERE b.BandName = Band) As Band,
	Frequency,
	(SELECT RepeaterStatusID FROM CRC_Migration_Test_BH.dbo.RepeaterStatus rs WHERE rs.RepeaterStatusName = rep.RepeaterStatusDescription),
	--(SELECT stationId FROM CRC_Migration_Test_BH.dbo.Station stat WHERE sta.CallLetters = stat.CallLetters AND stat.BandId = (SELECT BandId FROM CRC_Migration_Test_BH.dbo.Band b WHERE b.BandName = Band)) As FlagShipId,
	
	(select tstat.stationid from CRC_Migration_Test_BH.dbo.Station tstat
	join crc3_20141208_NoBackup.dbo.station tstaf on tstaf.callletters = tstat.callletters
	join  CRC_Migration_Test_BH.dbo.Band tb on tb.bandid = tstat.bandid and tb.bandname=tstaf.band
	join  crc3_20141208_NoBackup.dbo.station tsta on tstaf.stationid = tsta.flagshipid  
	where tsta.stationid=sta.stationid) as FlagShipId,	Null, --PrimaryUserId, --????	
	(SELECT MemberStatusID FROM CRC_Migration_Test_BH.dbo.MemberStatus m WHERE m.MemberStatusName = ms.MemberStatusName),
	(SELECT MinorityStatusID FROM CRC_Migration_Test_BH.dbo.MinorityStatus mem WHERE mem.MinorityStatusName = min.MinorityStatus),	
	StatusDate,
	LicenseeTypeID,
	LicenseName,
	Address1,
	Address2,
	City,	
	(SELECT StateId From CRC_Migration_Test_BH.dbo.State ss WHERE ss.Abbreviation = sta.StateProvince) As StateProvince, 
	County,
	Country,
	PostalCode,
	Telephone,
	Fax,
	CAST(Email As VARCHAR(50)),
	URL_Station, --WebPage
	TSACume,
	TSAAQH,
	(SELECT MetroMarketId FROM CRC_Migration_Test_BH.dbo.MetroMarket mm WHERE mm.MarketName = MetroMarket),
	MetroRanking, --Don't know where to find this
	(SELECT DMAMarketID FROM CRC_Migration_Test_BH.dbo.DMAMarket dm WHERE dm.MarketName = DMAMarket),
	DMARank,
	--(SELECT TimeZoneId FROM CRC_Migration_Test_BH.dbo.TimeZone tz WHERE tz.TimeZoneCode = zone.TimeZoneName) AS TimeZoneId,
	case 
		when sta.TimeZoneID = 3 then 7
		when sta.TimeZoneID = 4 then 6
		when sta.TimeZoneID = 5 then 5
		when sta.TimeZoneID = 6 then 3
		when sta.TimeZoneID = 7 then 2
		when sta.TimeZoneID = 8 then 1
	end as TimeZoneId,	HoursFromFlagship,
	AssociatedUserMax,
	NULL,--DisabledDate ??
	NULL, --DiabledUserID ??
	GETUTCDATE(), --CreatedDate
	1, --CreatedUserId
	GETUTCDATE(), --LastUpdatedDate
	1 --LastUpdatedUserId
	FROM crc3_20141208_NoBackup.dbo.Station sta	

	JOIN crc3_20141208_NoBackup.dbo.MemberStatus ms ON ms.MemberStatusId = sta.MemberStatusID
	JOIN crc3_20141208_NoBackup.dbo.MinorityStatus min ON min.MinorityStatusID = sta.MinorityStatusID
	JOIN crc3_20141208_NoBackup.dbo.RepeaterStatus rep ON rep.RepeaterStatusID = sta.RepeaterStatusID
	JOIN crc3_20141208_NoBackup.dbo.TimeZone zone ON zone.TimeZoneID = sta.TimeZoneID

	where  sta.stationid >= 4989 

	--select * from crcuser where email like 'pah%'

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