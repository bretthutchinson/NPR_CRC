CREATE PROCEDURE [dbo].[PSP_Station_Save]
(
    @StationId BIGINT,
	@CallLetters VARCHAR(50),
	@BandId BIGINT,
	@Frequency VARCHAR(50),
	@RepeaterStatusId BIGINT,
	@FlagshipStationId BIGINT,
	@MemberStatusId BIGINT,
	@MinorityStatusId BIGINT,
	@StatusDate DATE,
	@LicenseeTypeId BIGINT,
	@LicenseeName VARCHAR(50),
	@AddressLine1 VARCHAR(50),
	@AddressLine2 VARCHAR(50),
	@City VARCHAR(50),
	@StateId BIGINT,
	@County VARCHAR(50),
	@Country VARCHAR(50),
	@ZipCode VARCHAR(50),
	@Phone VARCHAR(50),
	@Fax VARCHAR(50),
	@Email VARCHAR(50),
	@WebPage VARCHAR(100),
	@TSACume VARCHAR(50),
	@TSAAQH VARCHAR(50),
	@MetroMarketId BIGINT,
	@MetroMarketRank INT,
	@DMAMarketId BIGINT,
	@DMAMarketRank INT,
	@TimeZoneId BIGINT,
	@HoursFromFlagship INT,
	@MaxNumberOfUsers INT,
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Station
    SET
        CallLetters = @CallLetters,
		BandId = @BandId,
		Frequency = @Frequency,
		RepeaterStatusId = @RepeaterStatusId,
		FlagshipStationId = @FlagshipStationId,
		MemberStatusId = @MemberStatusId,
		MinorityStatusId = @MinorityStatusId,
		StatusDate = @StatusDate,
		LicenseeTypeId = @LicenseeTypeId,
		LicenseeName = @LicenseeName,
		AddressLine1 = @AddressLine1,
		AddressLine2 = @AddressLine2,
		City = @City,
		StateId = @StateId,
		County = @County,
		Country = @Country,
		ZipCode = @ZipCode,
		Phone = @Phone,
		Fax = @Fax,
		Email = @Email,
		WebPage = @WebPage,
		TSACume = @TSACume,
		TSAAQH = @TSAAQH,
		MetroMarketId = @MetroMarketId,
		MetroMarketRank = @MetroMarketRank,
		DMAMarketId = @DMAMarketId,
		DMAMarketRank = @DMAMarketRank,
		TimeZoneId = @TimeZoneId,
		HoursFromFlagship = @HoursFromFlagship,
		MaxNumberOfUsers = @MaxNumberOfUsers,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        StationId = @StationId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Station
        (
            CallLetters,
			BandId,
			Frequency,
			RepeaterStatusId,
			FlagshipStationId,
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
			ZipCode,
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
        )
        VALUES
        (
            @CallLetters,
			@BandId,
			@Frequency,
			@RepeaterStatusId,
			@FlagshipStationId,
			@MemberStatusId,
			@MinorityStatusId,
			@StatusDate,
			@LicenseeTypeId,
			@LicenseeName,
			@AddressLine1,
			@AddressLine2,
			@City,
			@StateId,
			@County,
			@Country,
			@ZipCode,
			@Phone,
			@Fax,
			@Email,
			@WebPage,
			@TSACume,
			@TSAAQH,
			@MetroMarketId,
			@MetroMarketRank,
			@DMAMarketId,
			@DMAMarketRank,
			@TimeZoneId,
			@HoursFromFlagship,
			@MaxNumberOfUsers,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @StationId = SCOPE_IDENTITY()

    END

    SELECT @StationId AS StationId

END
GO


