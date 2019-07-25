CREATE Procedure [dbo].[ADT_Insert_Day_Recs_For_ScheduleID]

		--[ADT_Insert_Day_Recs_For_ScheduleID] 2104585, 2485, '4:10am', '9:00am', 'N', 'N','N','N','N','N','N', '2000-01-01',1,'2001-01-01', 1
		
		@ScheduleId			bigint,
		@ProgramId			bigint,
		@StartTime			time(7),
		@EndTime			time(7),
		@SundayInd			CHAR(1),
		@MondayInd			CHAR(1),
		@TuesdayInd			CHAR(1),
		@WednesdayInd		CHAR(1),
		@ThursdayInd		CHAR(1),
		@FridayInd			CHAR(1),
		@SaturdayInd		CHAR(1),
		@CreatedDate		datetime,
		@CreatedUserId		bigint,
		@LastUpdatedDate	datetime,
		@LastUpdatedUserId	bigint,
		@GridID				bigint
AS
BEGIN
	Declare	@newProgramID as bigint
	Declare	@eScheduleProgramID as bigint
	--set @eScheduleProgramID = -1
	--select * from program
	select  @newProgramID = np.programid from program np
	join crc3_20140508.dbo.program op on np.programname = op.programname
	where op.programid=@ProgramId
	SELECT @eScheduleProgramID = scheduleprogramid FROM [ScheduleProgram] WHERE ScheduleId=@ScheduleId and starttime = @starttime and endtime=@endtime and programid =@newProgramID
	--SELECT scheduleprogramid FROM [ScheduleProgram] WHERE ScheduleId=2104585 and starttime = '4:00AM' and endtime= '9:00am' and programid =1836
	--select @eScheduleProgramID
	--SELECT @eScheduleProgramID = scheduleprogramid FROM [ScheduleProgram] WHERE ScheduleId=@ScheduleId and starttime = @starttime and endtime=@endtime and programid =@Programid
	--SELECT * FROM ScheduleProgram where PROGRAMID = 1836 AND STARTTIME = '4:00AM' and endtime = '9:00am'
	 --set  @eScheduleProgramID = 2
	IF (@eScheduleProgramID is null )
		INSERT INTO [dbo].[ScheduleProgram] (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId, GridID)
	  values (@ScheduleId, @newProgramID, @StartTime, @EndTime, @SundayInd, @MondayInd, @TuesdayInd, @WednesdayInd, @ThursdayInd, @FridayInd, @SaturdayInd, @CreatedDate, @CreatedUserId, @LastUpdatedDate, @LastUpdatedUserId, @GridID)
			
	
	ELSE
		if(@MondayInd='y')
		  update ScheduleProgram set MondayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		else if(@TuesdayInd='y')
		  update ScheduleProgram set TuesdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		else if(@WednesdayInd='y')
		  update ScheduleProgram set WednesdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		else if(@ThursdayInd='y')
		  update ScheduleProgram set ThursdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		else if(@FridayInd='y')
		  update ScheduleProgram set FridayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		else if(@SaturdayInd='y')
		  update ScheduleProgram set SaturdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
	   
	END
	--select @eScheduleProgramID