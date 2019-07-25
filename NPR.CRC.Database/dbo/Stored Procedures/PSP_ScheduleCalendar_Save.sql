CREATE PROCEDURE [dbo].[PSP_ScheduleCalendar_Save]
(
    @ScheduleId BIGINT,
	@DNAInd char(1),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	DECLARE @Today DateTime;

	SET @Today = GETUTCDATE();

    UPDATE dbo.Schedule
    SET
		SubmittedUserId = @LastUpdatedUserId,
		SubmittedDate = @Today,
		LastUpdatedDate = @Today,
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ScheduleId = @ScheduleId

/****** Begin logic to update 100% repeater station Schedule submitted information ******/	
	DECLARE @FlagshipStationId BIGINT,
			 @RepeaterScheduleId BIGINT,
			 @FlagShipYear INT,
			 @FlagShipMonth INT,
			 @NumRows INT,
			 @Incr INT
	
	DECLARE @RepeaterStationSchedule TABLE
	(
		TableId INT IDENTITY,
		StationId BIGINT,
		ScheduleId BIGINT,
		[Year] INT,
		[Month] INT
	)
	
	/** Retrieve Flagship values **/
	SELECT 
		@FlagshipStationId = sch.StationId,
		@FlagshipYear = sch.[Year],
		@FlagShipMonth = sch.[Month]
	FROM
		dbo.Schedule sch
	WHERE
		sch.ScheduleId = @ScheduleId
	
	/** Retrieve associated repeater stations **/
	INSERT INTO @RepeaterStationSchedule
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
	SELECT @NumRows = COUNT(*) FROM @RepeaterStationSchedule;
	
	WHILE @Incr <= @NumRows
	BEGIN
		SELECT 
			@RepeaterScheduleId = ScheduleId
		FROM
			@RepeaterStationSchedule
		WHERE 
			TableId = @Incr;

		UPDATE dbo.Schedule
		SET
			SubmittedUserId = @LastUpdatedUserId,
			SubmittedDate = @Today,
			LastUpdatedDate = @Today,
			LastUpdatedUserId = @LastUpdatedUserId
		WHERE
		    ScheduleId = @RepeaterScheduleId

		SET @Incr = @Incr + 1;
	END

	/****** End logic to update 100% repeater station Schedule submitted information ******/	

	IF @DNAInd = 'Y' /** Delete Newscast schedule and associated 100% repeater stations **/
	BEGIN
		/** Delete currently submitted newscast schedule records **/
		DELETE FROM dbo.ScheduleNewscast WHERE ScheduleId = @ScheduleId;

		SET @Incr = 1;

		/** Delete all associated 100% Repeater station newscast schedule records **/
		WHILE @Incr <= @NumRows
		BEGIN
			SELECT
				@RepeaterScheduleId = ScheduleId
			FROM
				@RepeaterStationSchedule
			WHERE
				TableId = @Incr

			DELETE FROM dbo.ScheduleNewscast WHERE ScheduleId = @RepeaterScheduleId;

			SET @Incr = @Incr + 1;
		END
	END
END
GO


