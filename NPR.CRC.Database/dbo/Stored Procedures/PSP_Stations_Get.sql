CREATE PROCEDURE [dbo].[PSP_Stations_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StationId,
		CallLetters,
		BandId,
		Frequency,
		RepeaterStatusId,
		FlagshipStationId,
		PrimaryUserId,
		MemberStatusId,
		MinorityStatusId,
		StatusDate,
		LicenseeTypeId,
		LicenseeName,
		AddressLine1,
		AddressLine2,
		City,
		StateId,
		County,
		Country,
		Phone,
		Fax,
		Email,
		WebPage,
		TSACume,
		TSAAQH,
		MetroMarketId,
		MetroMarketRank,
		DMAMarketId,
		DMAMarketRank,
		TimeZoneId,
		HoursFromFlagship,
		MaxNumberOfUsers,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Station
    
END
GO


