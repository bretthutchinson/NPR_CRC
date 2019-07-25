CREATE PROCEDURE [dbo].[DT_NormalizeScheduleProgramData]
AS 
BEGIN
	SET NOCOUNT ON

	DECLARE 
	@cScheduleId BIGINT,
	@cScheduleProgramId BIGINT,
	@cProgramId BIGINT,
	@cStartTime Time,
	@cEndTime Time,
	@cSundayInd CHAR(1),
	@cMondayInd CHAR(1),
	@cTuesdayInd CHAR(1),
	@cWednesdayInd CHAR(1),
	@cThursdayInd CHAR(1),
	@cFridayInd CHAR(1),
	@cSaturdayInd CHAR(1),
	@cCreatedUserId BIGINT,
	@cCreatedDate DateTime,
	@cLastUpdatedUserId BIGINT,
	@cLastUpdatedDate DateTime,
	@cscheduleProgramIdString VARCHAR(max),
	
	@ScheduleProgramId BIGINT,
	@ProgramId BIGINT,
	@StartTime Time,
	@EndTime Time,
	@SundayInd CHAR(1),
	@MondayInd CHAR(1),
	@TuesdayInd CHAR(1),
	@WednesdayInd CHAR(1),
	@ThursdayInd CHAR(1),
	@FridayInd CHAR(1),
	@SaturdayInd CHAR(1),
	@CreatedUserId BIGINT,
	@CreatedDate DateTime,
	@LastUpdatedUserId BIGINT,
	@LastUpdatedDate DateTime,
	@scheduleProgramIdString VARCHAR(max),
	
	@loopOne INT,
	@scheduleCount INT,
	
	@loopTwo INT,
	@scheduleProgramCount INT,
	@rowIdent INT
	
	DECLARE @tempSchedule TABLE (
		TableId INT IDENTITY,
		ScheduleId BIGINT
	)
	
	DECLARE @tempScheduleProgram TABLE (
		TableId INT,
		ScheduleProgramId BIGINT,
		ProgramId BIGINT,
		StartTime Time,
		EndTime Time,
		Sundayind CHAR(1), 
		MondayInd CHAR(1), 
		TuesdayInd CHAR(1), 
		WednesdayInd CHAR(1), 
		ThursdayInd CHAR(1), 
		FridayInd CHAR(1), 
		SaturdayInd CHAR(1),
		CreatedUserId BIGINT,
		CreatedDate DateTime,
		LastUpdatedUserId BIGINT,
		LastUpdatedDate DateTime
	)
	
	DECLARE @combinedScheduleProgram TABLE (
		TableId BIGINT,
		ScheduleProgramIdString VARCHAR(MAX),
		ScheduleId BIGINT,
		ProgramId BIGINT,
		StartTime Time,
		EndTime Time,
		SundayInd CHAR(1),
		MondayInd CHAR(1),
		TuesdayInd CHAR(1),
		WednesdayInd CHAR(1),
		ThursdayInd CHAR(1),
		FridayInd CHAR(1),
		SaturdayInd CHAR(1),
		CreatedUserId BIGINT,
		CreatedDate DateTime,
		LastUpdatedUserId BIGINT,
		LastUpdatedDate DateTime
	)
	
	/** Get all schedules **/
	INSERT INTO @tempSchedule SELECT ScheduleId FROM dbo.Schedule ORDER BY ScheduleId;

	/** Set schedule loop count and max loop count **/
	SET @loopOne = 1;
	SELECT @scheduleCount = MAX(TableId) FROM @tempSchedule;
	
	--SELECT * FROM @tempSchedule --ORDER BY 1
	
	/** Loop through schedules **/
	
	WHILE @loopOne <= @scheduleCount
	BEGIN
		
		SELECT @cScheduleId = ScheduleId FROM @tempSchedule WHERE TableId = @loopOne;
	
		/** Get all scheduleProgram records associated with the current scheduleId **/
		INSERT INTO @tempScheduleProgram (TableId, ScheduleProgramId, ProgramId, StartTime, EndTime, Sundayind, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedUserId, CreatedDate, LastUpdatedUserId, LastUpdatedDate)
			SELECT ROW_NUMBER() OVER(Order By ProgramId, StartTime, EndTime), ScheduleProgramId, ProgramId, StartTime, EndTime, Sundayind, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedUserId, CreatedDate, LastUpdatedUserId, LastUpdatedDate
		FROM
			dbo.ScheduleProgram
		WHERE
			ScheduleId = @cScheduleId
		ORDER BY
			ProgramId, StartTime, EndTime
	
		/** Set scheduleProgram loop count and max loop count **/
		SET @loopTwo = 1;
		SELECT @scheduleProgramCount = MAX(TableId) FROM @tempScheduleProgram;
		
		SET @cscheduleProgramIdString = '';
	
		/** Retrieve record in scheduleProgram temp table to use as a baseline **/
		IF @loopTwo <= @scheduleProgramCount
		BEGIN
			SELECT
				@ScheduleProgramId = ScheduleProgramId,
				@ProgramId = ProgramId,
				@StartTime = StartTime,
				@EndTime = EndTime,
				@SundayInd = SundayInd ,
				@MondayInd = MondayInd,
				@TuesdayInd = TuesdayInd,
				@WednesdayInd = WednesdayInd,
				@ThursdayInd = ThursdayInd,
				@FridayInd = FridayInd,
				@SaturdayInd = SaturdayInd,
				@CreatedUserId = CreatedUserId,
				@CreatedDate = CreatedDate,
				@LastUpdatedUserId = LastUpdatedUserId,
				@LastUpdatedDate = LastUpdatedDate 
			FROM 
				@tempScheduleProgram As tSP
			WHERE 
				TableId = @loopTwo
	
			SET @scheduleProgramIdString = CONVERT(VARCHAR, @ScheduleProgramId) + ' ';
		END 
	
		SET @loopTwo = @loopTwo + 1;
	
		SET @rowIdent = 1;
	
		WHILE @loopTwo <= @scheduleProgramCount
		BEGIN
			SELECT 
				@cScheduleProgramId = ScheduleProgramId,
				@cProgramId = ProgramId,
				@cStartTime = StartTime,
				@cEndTime = EndTime,
				@cSundayInd = SundayInd ,
				@cMondayInd = MondayInd,
				@cTuesdayInd = TuesdayInd,
				@cWednesdayInd = WednesdayInd,
				@cThursdayInd = ThursdayInd,
				@cFridayInd = FridayInd,
				@cSaturdayInd = SaturdayInd,
				@cCreatedUserId = CreatedUserId,
				@cCreatedDate = CreatedDate,
				@cLastUpdatedUserId = LastUpdatedUserId,
				@cLastUpdatedDate = LastUpdatedDate 
			FROM 
				@tempScheduleProgram As tSP
			WHERE 
				TableId = @loopTwo
	
			/** Check to see if this is a concurrent timespan and program with baseline record **/
			IF @ProgramId = @cProgramId AND @SundayInd = @cSundayInd AND @MondayInd = @cMondayInd AND @TuesdayInd = @cTuesdayInd AND
				@WednesdayInd = @cWednesdayInd AND @ThursdayInd = @cThursdayInd AND @FridayInd = @cFridayInd AND @SaturdayInd = @cSaturdayInd
				BEGIN
					SET @scheduleProgramIdString = @scheduleProgramIdString + ' ' + CONVERT(VARCHAR, @cScheduleProgramId, 1);
					SET @EndTime = @cEndTime /** Keep incrementing the end time as long as the records are concurrent **/
				END
			ELSE
				BEGIN
					/** Insert combined records into holding table **/
					INSERT INTO @combinedScheduleProgram (TableId, scheduleProgramIdString, ScheduleId, ProgramId, StartTime,  EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedUserId, CreatedDate, LastUpdatedUserId, LastUpdatedDate)
					SELECT @rowIdent, @scheduleProgramIdString, @cScheduleId, @ProgramId, @StartTime, @EndTime, @SundayInd, @MondayInd, @TuesdayInd, @WednesdayInd, @ThursdayInd, @FridayInd, @SaturdayInd, @CreatedUserId,  @CreatedDate,  @LastUpdatedUserId, @LastUpdatedDate
					
					/** Reset ProgramId string **/
					SET @scheduleProgramIdString = CONVERT(VARCHAR, @cScheduleProgramId) + ' ';
			 
					/** Set new baseline data **/
					SET @ScheduleProgramId = @cScheduleProgramId
					SET @ProgramId = @cProgramId
					SET @StartTime = @cStartTime
					SET @EndTime = @cEndTime
					SET @SundayInd = @cSundayInd 
					SET @MondayInd = @cMondayInd
					SET @TuesdayInd = @cTuesdayInd
					SET @WednesdayInd = @cWednesdayInd
					SET @ThursdayInd = @cThursdayInd
					SET @FridayInd = @cFridayInd
					SET @SaturdayInd = @cSaturdayInd
					SET @CreatedUserId = @cCreatedUserId
					SET @CreatedDate = @cCreatedDate
					SET @LastUpdatedUserId = @cLastUpdatedUserId
					SET @LastUpdatedDate = @cLastUpdatedDate
	
					SET @rowIdent = @rowIdent + 1; 
				END
			SET @loopTwo = @loopTwo + 1;
		END
		
		/** Delete all existing records for current schedule **/
		DELETE FROM dbo.ScheduleProgram WHERE ScheduleId = @cScheduleId;
	
		/** Insert the new normalized "rolled up" records **/
		INSERT INTO dbo.ScheduleProgram 
			(ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
		SELECT
			ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId
		FROM
			@combinedScheduleProgram
		ORDER BY 
			ProgramId, StartTime, EndTime
	
		/** Clean up temporary tables to move onto the next schedule **/
		DELETE FROM @combinedScheduleProgram;
		DELETE FROM @tempScheduleProgram;
	
		SET @loopOne = @loopOne + 1;
	END

END