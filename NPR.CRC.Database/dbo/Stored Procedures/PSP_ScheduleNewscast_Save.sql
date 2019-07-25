---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DROP PROCEDURE [dbo].[PSP_ScheduleNewscast_Save]

-- [PSP_ScheduleNewscast_Save] 2685617, 2382626, '11:01 pm', '11:06 pm', 'Y', 5, 'N', 'Y', 'Y', 'N', 'Y', 'Y', 'N', 1
--select * from schedulenewscast where scheduleid = 2382626

--select * from schedulenewscast where ScheduleNewscastId = 346008948

--[PSP_ScheduleNewscast_Save] null, 2409457, '1:00 am', '5:08 am', 'Y', 5, 'N', 'N', 'N', 'N', 'N', 'Y', 'N', 1

CREATE PROCEDURE [dbo].[PSP_ScheduleNewscast_Save]
(
    @ScheduleNewscastId BIGINT,
	@ScheduleId BIGINT,
	@StartTime TIME,
	@EndTime TIME,
	@HourlyInd CHAR(1),
	@DurationMinutes INT,
	@SundayInd CHAR(1),
	@MondayInd CHAR(1),
	@TuesdayInd CHAR(1),
	@WednesdayInd CHAR(1),
	@ThursdayInd CHAR(1),
	@FridayInd CHAR(1),
	@SaturdayInd CHAR(1),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	IF @HourlyInd = 'N'
	BEGIN
	
		/** Delete overlapping newscast records **/
		DELETE
		FROM
			dbo.ScheduleNewscast
		WHERE
			ScheduleId = @ScheduleId AND
			((StartTime BETWEEN @StartTime AND @EndTime) OR ((EndTime BETWEEN @StartTime AND @EndTime))) AND
			SundayInd = @SundayInd AND
			MondayInd = @MondayInd AND
			TuesdayInd = @TuesdayInd AND
			WednesdayInd = @WednesdayInd AND
			ThursdayInd = @ThursdayInd AND
			FridayInd = @FridayInd AND
			SaturdayInd = @SaturdayInd

		UPDATE dbo.ScheduleNewscast
		SET
			ScheduleId = @ScheduleId,
			StartTime = @StartTime,
			EndTime = @EndTime,
			HourlyInd = @HourlyInd,
			DurationMinutes = @DurationMinutes,
			SundayInd = @SundayInd,
			MondayInd = @MondayInd,
			TuesdayInd = @TuesdayInd,
			WednesdayInd = @WednesdayInd,
			ThursdayInd = @ThursdayInd,
			FridayInd = @FridayInd,
			SaturdayInd = @SaturdayInd,
			LastUpdatedDate = GETUTCDATE(),
			LastUpdatedUserId = @LastUpdatedUserId
		WHERE
			ScheduleNewscastId = @ScheduleNewscastId
	
		IF @@ROWCOUNT < 1
		BEGIN
	
			INSERT INTO dbo.ScheduleNewscast
			(
				ScheduleId,
				StartTime,
				EndTime,
				HourlyInd,
				DurationMinutes,
				SundayInd,
				MondayInd,
				TuesdayInd,
				WednesdayInd,
				ThursdayInd,
				FridayInd,
				SaturdayInd,
				CreatedDate,
				CreatedUserId,
				LastUpdatedDate,
				LastUpdatedUserId
			)
			VALUES
			(
				@ScheduleId,
				@StartTime,
				@EndTime,
				@HourlyInd,
				@DurationMinutes,
				@SundayInd,
				@MondayInd,
				@TuesdayInd,
				@WednesdayInd,
				@ThursdayInd,
				@FridayInd,
				@SaturdayInd,
				GETUTCDATE(),
				@LastUpdatedUserId,
				GETUTCDATE(),
				@LastUpdatedUserId
			)
	
			SET @ScheduleNewscastId = SCOPE_IDENTITY()
		END

	END
	ELSE
	BEGIN
		DECLARE @CurrentHour	TIME;

		SET @CurrentHour = @StartTime;

		delete from ScheduleNewscast where ScheduleNewscastID = @ScheduleNewscastId

		WHILE @CurrentHour <= @EndTime
		
		BEGIN		
		
		/** Delete overlapping newscast records **/
		DELETE
		FROM
			dbo.ScheduleNewscast
		WHERE
			ScheduleId = @ScheduleId AND
			((StartTime BETWEEN @CurrentHour AND DATEADD(MINUTE, @DurationMinutes, @CurrentHour)) 
				OR ((EndTime BETWEEN @CurrentHour AND DATEADD(MINUTE, @DurationMinutes, @CurrentHour)))) AND
			SundayInd = @SundayInd AND
			MondayInd = @MondayInd AND
			TuesdayInd = @TuesdayInd AND
			WednesdayInd = @WednesdayInd AND
			ThursdayInd = @ThursdayInd AND
			FridayInd = @FridayInd AND
			SaturdayInd = @SaturdayInd
		
		--delete from ScheduleNewscast where ScheduleNewscastID = @ScheduleNewscastId

			INSERT INTO dbo.ScheduleNewscast
			(
				ScheduleId,
				StartTime,
				EndTime,
				HourlyInd,
				DurationMinutes,
				SundayInd,
				MondayInd,
				TuesdayInd,
				WednesdayInd,
				ThursdayInd,
				FridayInd,
				SaturdayInd,
				CreatedDate,
				CreatedUserId,
				LastUpdatedDate,
				LastUpdatedUserId
			)
			VALUES
			(
				@ScheduleId,
				@CurrentHour,
				DATEADD(MINUTE, @DurationMinutes, @CurrentHour),
				@HourlyInd,
				@DurationMinutes,
				@SundayInd,
				@MondayInd,
				@TuesdayInd,
				@WednesdayInd,
				@ThursdayInd,
				@FridayInd,
				@SaturdayInd,
				GETUTCDATE(),
				@LastUpdatedUserId,
				GETUTCDATE(),
				@LastUpdatedUserId
			)
			--select * from schedulenewscast

			--check for rollover, otherwise infinte loop
			If @CurrentHour >= '11:00 PM'  SET @CurrentHour = DATEADD(MINUTE, 1, @EndTime)
			Else 
			SET @CurrentHour = DATEADD(MINUTE, 60, @CurrentHour)

			--IF @CurrentHour = @StartTime
			--BEGIN
				SET @ScheduleNewscastId = SCOPE_IDENTITY();
			--END

		END
	END

	/****** Begin logic to add/update 100% repeater station Newscast Schedule records ******/
	DECLARE @FlagshipStationId BIGINT,
			 @RepeaterScheduleId BIGINT,
			 @FlagShipYear INT,
			 @FlagShipMonth INT,
			 @NumRows INT,
			 @NumRows2 INT,
			 @Incr INT,
			 @Incr2 INT,
			 @FTimezone int,
			 @RTimezone int,
			 @RepeaterStationId BIGINT,
			 @FlagshipStationIdAlt BIGINT
	
	DECLARE @FlagshipStationSchedule TABLE
	(
		TableId INT IDENTITY,
		ScheduleNewscastId BIGINT,
		ScheduleId BIGINT,
		StartTime TIME,
		EndTime TIME,
		HourlyInd CHAR(1),
		DurationMinutes INT,
		SundayInd CHAR(1),
		MondayInd CHAR(1),
		TuesdayInd CHAR(1),
		WednesdayInd CHAR(1),
		ThursdayInd CHAR(1),
		FridayInd CHAR(1),
		SaturdayInd CHAR(1),
		CreatedDate DATETIME,
		CreatedUserId BIGINT,
		LastUpdatedDate DATETIME,
		LastUpdatedUserId BIGINT	
	)
	
	DECLARE @RepeaterStations TABLE
	(
		TableId INT IDENTITY,
		StationId BIGINT,
		ScheduleId BIGINT,
		[Year] INT,
		[Month] INT
	)
	
	/** Retrieve records for flagship station schedule **/
	INSERT INTO @FlagshipStationSchedule
	SELECT
		ScheduleNewscastId,
		ScheduleId,
		StartTime,
		EndTime,
		HourlyInd,
		DurationMinutes,
		SundayInd,
		MondayInd,
		TuesdayInd,
		WednesdayInd,
		ThursdayInd,
		FridayInd,
		SaturdayInd,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
	FROM 
		dbo.ScheduleNewscast sn
	WHERE
		sn.ScheduleId = @ScheduleId
		
	/** Retrieve Flagship default values **/
	SELECT 
		@FlagshipStationId = sch.StationId,
		@FlagshipYear = sch.[Year],
		@FlagShipMonth = sch.[Month]
	FROM
		dbo.Schedule sch INNER JOIN
		dbo.ScheduleNewscast sn ON sch.ScheduleId = sn.ScheduleId
	WHERE
		sn.ScheduleNewscastId = @ScheduleNewscastId
	
	/** Retrieve associated repeater stations **/
	INSERT INTO @RepeaterStations
	SELECT 
		st.StationId,
		sch.ScheduleId,
		@FlagshipYear,
		@FlagShipMonth
	FROM
		dbo.Station st INNER JOIN
		dbo.RepeaterStatus rs ON st.RepeaterStatusId = rs.RepeaterStatusId LEFT JOIN
		/** Retrieve only records with same month and year from schedule **/
		(SELECT * FROM dbo.Schedule WHERE [Year] = @FlagshipYear AND [Month] = @FlagShipMonth) sch ON st.StationId = sch.StationId LEFT JOIN
		dbo.ScheduleNewscast sn ON sch.ScheduleId = sn.ScheduleNewscastId
	WHERE
		st.FlagshipStationId = @FlagshipStationId AND 
		rs.RepeaterStatusName = '100% Repeater'
	
	/** Set initial values for repeater stations **/
	SET @Incr = 1;
	SELECT @NumRows = COUNT(*) FROM @RepeaterStations;
	
	WHILE @Incr <= @NumRows /** Loop through @RepeaterStations table **/
	BEGIN
		IF (SELECT ScheduleId FROM @RepeaterStations WHERE TableId = @Incr) IS NULL
			/** Insert into Schedule table if record does not exist for repeater station **/
			BEGIN
				INSERT INTO dbo.Schedule (StationId, [Year], [Month], SubmittedDate, SubmittedUserId, AcceptedDate, AcceptedUserId, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
				SELECT StationId, [Year], [Month], NULL, NULL, NULL, NULL, GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId  FROM @RepeaterStations WHERE TableId = @Incr
			
				SET @RepeaterScheduleId = SCOPE_IDENTITY();
				
				/** Update temporary table ScheduleId to be used later **/
				UPDATE @RepeaterStations
				SET ScheduleId = @RepeaterScheduleId
				WHERE TableId = @Incr
			END
	        ELSE
			/** Update Schedule table **/
			BEGIN
				SET @RepeaterScheduleId = (SELECT ScheduleId FROM @RepeaterStations WHERE TableId = @Incr)	
							
				UPDATE dbo.Schedule
				SET LastUpdatedDate = GETUTCDATE(),
					  LastUpdatedUserId = @LastUpdatedUserId
				WHERE Schedule.ScheduleId = @RepeaterScheduleId
			END
	
		/** Delete all ScheduleNewscast records for current repeater station **/
		DELETE FROM dbo.ScheduleNewscast WHERE ScheduleId = @RepeaterScheduleId;
	
		SET @Incr2 = 1;
		SELECT @NumRows2 = COUNT(*) FROM @FlagshipStationSchedule;
	
		WHILE @Incr2 <= @NumRows2 /** Loop through @FlagshipStationSchedule table **/
			BEGIN
			/*TODO: Add time zone logic */
				INSERT INTO dbo.ScheduleNewscast (ScheduleId, StartTime, EndTime, HourlyInd, DurationMinutes, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
				SELECT 
					/** Updated to get all in FlagshipStation **/
					@RepeaterScheduleId, StartTime, EndTime, HourlyInd, DurationMinutes, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId	
					
				FROM 
					@FlagshipStationSchedule 
				WHERE TableId = @Incr2
	
				 SET @Incr2 = @Incr2 + 1;
			END

		--TimeZone Logic Check and Update
		select @RepeaterStationId = StationID from schedule where scheduleid = @RepeaterScheduleId
		select @FlagshipStationIdAlt = FlagshipstationID from station where stationid = @RepeaterStationId
		select @FTimezone = timezoneID from station where stationid = @FlagshipStationIdAlt
		select @RTimezone = timezoneID from station where stationid = @RepeaterStationId
		If (@Ftimezone =6 and @Rtimezone = 5) or  (@Ftimezone =5 and @Rtimezone = 3) or  (@Ftimezone =3 and @Rtimezone = 2) or  (@Ftimezone =2 and @Rtimezone = 1) Begin
			--print 'forwards'
			EXEC PSP_ScheduleNewscastTimezonShiftForward_Update @RepeaterScheduleId
		end
		else if (@Ftimezone =1 and @Rtimezone = 2) or  (@Ftimezone =2 and @Rtimezone = 3) or  (@Ftimezone =3 and @Rtimezone = 5) or  (@Ftimezone =5 and @Rtimezone = 6) begin
			--print 'backwards'
			exec PSP_ScheduleNewscastTimezonShiftBackward_Update @RepeaterScheduleId
		End

	
		SET @Incr = @Incr + 1;
	END
	/****** End logic to add/update 100% repeater station Program Schedule records ******/

    SELECT @ScheduleNewscastId AS ScheduleNewscastId

END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PSP_ScheduleNewscast_Save] TO [crcuser]
    AS [dbo];

