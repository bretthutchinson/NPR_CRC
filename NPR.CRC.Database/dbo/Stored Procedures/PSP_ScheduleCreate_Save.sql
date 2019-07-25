--DROP PROCEDURE [dbo].[PSP_ScheduleCreate_Save]
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PSP_ScheduleCreate_Save] --22722, 1 , 2013, null,null,1
(
	@StationId BIGINT,
	@Month INT,
	@Year INT,
	@MonthToCopy INT,
	@YearToCopy INT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

	SET NOCOUNT ON

	DECLARE @NewScheduleId BIGINT
	DECLARE @ScheduleIdToCopy BIGINT

	-- first check if a schedule for the specified month and year already exists
	SELECT @NewScheduleId = ScheduleId
	FROM dbo.Schedule
	WHERE StationId = @StationId
	AND Month = @Month
	AND Year = @Year

	IF @NewScheduleId IS NULL
	BEGIN

		DECLARE @Now DATETIME = GETUTCDATE()

		BEGIN TRY
			BEGIN TRAN

			INSERT INTO dbo.Schedule
			(
				StationId,
				Year,
				Month,
				CreatedDate,
				CreatedUserId,
				LastUpdatedDate,
				LastUpdatedUserId
			)
			VALUES
			(
				@StationId,
				@Year,
				@Month,
				@Now,
				@LastUpdatedUserId,
				@Now,
				@LastUpdatedUserId
			)

			SET @NewScheduleId = SCOPE_IDENTITY()
		
			-- if @MonthToCopy or @YearToCopy are null
			-- then assume we want to copy the most recent month for which a schedule exists
			IF (@MonthToCopy IS NULL) OR (@YearToCopy IS NULL)
			BEGIN
		
				SET @ScheduleIdToCopy =
				(
					SELECT TOP 1 ScheduleId
					FROM dbo.Schedule
					WHERE StationId = @StationId
					AND (Year < @Year
					or (YEAR= @Year and Month < @Month)
					)
					ORDER BY
						Year DESC,
						Month DESC
				)

			END
			ELSE BEGIN

				SET @ScheduleIdToCopy =
				(
					SELECT ScheduleId
					FROM dbo.Schedule
					WHERE Year = @YearToCopy
					AND Month = @MonthToCopy
				)

			END

			-- copy programs
			INSERT INTO dbo.ScheduleProgram
			(
				ScheduleId,
				ProgramId,
				StartTime,
				EndTime,
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
			SELECT
				@NewScheduleId,
				ProgramId,
				StartTime,
				EndTime,
				SundayInd,
				MondayInd,
				TuesdayInd,
				WednesdayInd,
				ThursdayInd,
				FridayInd,
				SaturdayInd,
				@Now,
				@LastUpdatedUserId,
				@Now,
				@LastUpdatedUserId
			FROM
				dbo.ScheduleProgram
			WHERE
				ScheduleId = @ScheduleIdToCopy

			-- copy newscasts
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
			SELECT
				@NewScheduleId,
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
				@Now,
				@LastUpdatedUserId,
				@Now,
				@LastUpdatedUserId
			FROM
				dbo.ScheduleNewscast
			WHERE
				ScheduleId = @ScheduleIdToCopy

		/****** Begin logic to add/update 100% repeater station Newscast Schedule records ******/
	DECLARE @FlagshipStationId BIGINT,
			 @RepeaterScheduleId BIGINT,
			 @FlagShipYear INT,
			 @FlagShipMonth INT,
			 @NumRows INT,
			 @NumRows2 INT,
			 @NumRows3 INT,
			 @Incr INT,
			 @Incr2 INT,
			 @Incr3 INT,
			 @FTimezone int,
			 @RTimezone int,
			 @RepeaterStationId BIGINT,
			 @FlagshipStationIdAlt BIGINT
	
	/*copy program to 100% Repeater*/
	DECLARE @FlagshipStationProgramSchedule TABLE
	(
		TableId INT IDENTITY,
		ScheduleProgramId BIGINT,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		StartTime TIME,
		EndTime TIME,
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

	/** Retrieve records for flagship station schedule **/
	INSERT INTO @FlagshipStationProgramSchedule
	SELECT
		ScheduleProgramId,
		ScheduleId,
		ProgramId,
		StartTime,
		EndTime,
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
		dbo.ScheduleProgram sp
	WHERE
		sp.ScheduleId in (@NewScheduleId)
	/*copy program to 100% Repeater*/

	/*copy newscast to 100% Repeater*/
	DECLARE @FlagshipStationNewscastSchedule TABLE
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

	/** Retrieve records for flagship station schedule **/
	INSERT INTO @FlagshipStationNewscastSchedule
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
		sn.ScheduleId in (@NewScheduleId)
	/*copy newscast to 100% Repeater*/
	
	DECLARE @RepeaterStations TABLE
	(
		TableId INT IDENTITY,
		StationId BIGINT,
		ScheduleId BIGINT,
		[Year] INT,
		[Month] INT
	)

	set @FlagshipStationId = @StationId;
	set @FlagshipYear = @Year;
	set	@FlagShipMonth = @Month;
	
	
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
		(SELECT * FROM dbo.Schedule WHERE [Year] = @FlagshipYear AND [Month] = @FlagShipMonth) sch ON st.StationId = sch.StationId
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

			/*Program*/
			/** Delete all ScheduleProgram records for current repeater station **/
		DELETE FROM dbo.ScheduleProgram WHERE ScheduleId = @RepeaterScheduleId;

		SET @Incr2 = 1;
		SELECT @NumRows2 = COUNT(*) FROM @FlagshipStationProgramSchedule;

		WHILE @Incr2 <= @NumRows2 /** Loop through @FlagshipStationSchedule table **/
			BEGIN
			/*TODO: Add time zone logic */
				INSERT INTO dbo.ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
				SELECT 
					@RepeaterScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId		
				FROM 
					@FlagshipStationProgramSchedule 
				WHERE TableId = @Incr2

				 SET @Incr2 = @Incr2 + 1;
			END
			/*Program*/

			/*Newscast*/
			/** Delete all ScheduleNewscast records for current repeater station **/
		DELETE FROM dbo.ScheduleNewscast WHERE ScheduleId = @RepeaterScheduleId;
	
		SET @Incr3 = 1;
		SELECT @NumRows3 = COUNT(*) FROM @FlagshipStationNewscastSchedule;
	
		WHILE @Incr3 <= @NumRows3 /** Loop through @FlagshipStationSchedule table **/
			BEGIN
			/*TODO: Add time zone logic */
				INSERT INTO dbo.ScheduleNewscast (ScheduleId, StartTime, EndTime, HourlyInd, DurationMinutes, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
				SELECT 
					@RepeaterScheduleId, StartTime, EndTime, HourlyInd, DurationMinutes, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId		
				FROM 
					@FlagshipStationNewscastSchedule 
				WHERE TableId = @Incr3
	
				 SET @Incr3 = @Incr3 + 1;
			END
			/*Newscast*/
	
			
				--TimeZone Logic Check and Update
				select @RepeaterStationId = StationID from schedule where scheduleid = @RepeaterScheduleId
				select @FlagshipStationIdAlt = FlagshipstationID from station where stationid = @RepeaterStationId
				select @FTimezone = timezoneID from station where stationid = @FlagshipStationIdAlt
				select @RTimezone = timezoneID from station where stationid = @RepeaterStationId
				If (@Ftimezone =6 and @Rtimezone = 5) or  (@Ftimezone =5 and @Rtimezone = 3) or  (@Ftimezone =3 and @Rtimezone = 2) or  (@Ftimezone =2 and @Rtimezone = 1) Begin
				--print 'forwards'
				
				EXEC PSP_ScheduleProgramTimezonShiftForward_Update @RepeaterScheduleId

				EXEC PSP_ScheduleNewscastTimezonShiftForward_Update @RepeaterScheduleId
			end
			else if (@Ftimezone =1 and @Rtimezone = 2) or  (@Ftimezone =2 and @Rtimezone = 3) or  (@Ftimezone =3 and @Rtimezone = 5) or  (@Ftimezone =5 and @Rtimezone = 6) begin
				--print 'backwards'
				exec PSP_ScheduleProgramTimezonShiftBackward_Update @RepeaterScheduleId
	
				exec PSP_ScheduleNewscastTimezonShiftBackward_Update @RepeaterScheduleId
			End





		SET @Incr = @Incr + 1;
	END
	/****** End logic to add/update 100% repeater station Program Schedule records ******/

			COMMIT TRAN
		END TRY
		BEGIN CATCH
			IF @@TRANCOUNT > 0 ROLLBACK

			DECLARE
				@ErrorMessage NVARCHAR(4000),
				@ErrorSeverity INT,
				@ErrorState INT

			SELECT
				@ErrorMessage = ERROR_MESSAGE(),
				@ErrorSeverity = ERROR_SEVERITY(),
				@ErrorState = ERROR_STATE();

			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)
		END CATCH

	END

	

	SELECT @NewScheduleId AS ScheduleId

END



GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PSP_ScheduleCreate_Save] TO [crcuser]
    AS [dbo];

