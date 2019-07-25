CREATE Procedure [dbo].[ADT_Insert_Day_Recs_For_ScheduleID_New]

		--[ADT_Insert_Day_Recs_For_ScheduleID_New] 2104585, 2485, '4:10am', '9:00am', 'N', 'N','N','N','N','N','N', '2000-01-01',1,'2001-01-01', 1
		--[ADT_Insert_Day_Recs_For_ScheduleID_New] 2104585, 2485, '4:10am', '9:00am', 1, '2000-01-01',1,'2001-01-01', 1, null
		
		@ScheduleId			bigint,
		@ProgramId			bigint,
		@StartTime			time(7),
		@EndTime			time(7),
		@DayInd				int,
		--@SundayInd			CHAR(1),
		--@MondayInd			CHAR(1),
		--@TuesdayInd			CHAR(1),
		--@WednesdayInd		CHAR(1),
		--@ThursdayInd		CHAR(1),
		--@FridayInd			CHAR(1),
		--@SaturdayInd		CHAR(1),
		@CreatedDate		datetime,
		@CreatedUserId		bigint,
		@LastUpdatedDate	datetime,
		@LastUpdatedUserId	bigint,
		@GridID				bigint
AS
BEGIN
	SET NOCOUNT ON
	Declare	@newProgramID as bigint
	Declare	@eScheduleProgramID as bigint
	--set @eScheduleProgramID = -1
	--select * from program

	select  @newProgramID = np.programid from program np
	join crc3_20141208_NoBackup.dbo.program op on np.programname = op.programname
	where op.programid=@ProgramId

	--select * from program
	--select  @newProgramID  = 1457
	SELECT @eScheduleProgramID = scheduleprogramid FROM ScheduleProgram WHERE ScheduleId=@ScheduleId and starttime = @starttime and endtime=@endtime and programid =@newProgramID
	--SELECT @eScheduleProgramID = 1


	--SELECT scheduleprogramid FROM [ScheduleProgram] WHERE ScheduleId=2104585 and starttime = '4:00AM' and endtime= '9:00am' and programid =1836
	--select @eScheduleProgramID
	--SELECT @eScheduleProgramID = scheduleprogramid FROM [ScheduleProgram] WHERE ScheduleId=@ScheduleId and starttime = @starttime and endtime=@endtime and programid =@Programid
	--SELECT * FROM ScheduleProgram where PROGRAMID = 1836 AND STARTTIME = '4:00AM' and endtime = '9:00am'
	 --set  @eScheduleProgramID = 2
	 
	IF (@eScheduleProgramID is null ) begin
		--declare @SundayInd			CHAR(1)
		--declare @MondayInd			CHAR(1)
		--declare @TuesdayInd			CHAR(1)
		--declare @WednesdayInd		CHAR(1)
		--declare @ThursdayInd		CHAR(1)
		--declare @FridayInd			CHAR(1)
		--declare @SaturdayInd		CHAR(1)

		--INSERT INTO [dbo].ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId, GridID)
		--values (@ScheduleId, @newProgramID, @StartTime, @EndTime, 'N', 'N', 'N', 'N', 'N', 'N', 'N', @CreatedDate, @CreatedUserId, @LastUpdatedDate, @LastUpdatedUserId, @GridID)
		
		
		if(@DayInd=6)
		  	INSERT INTO [dbo].ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId, GridID)
			values (@ScheduleId, @newProgramID, @StartTime, @EndTime, 'N', 'N', 'N', 'N', 'N', 'N', 'Y', @CreatedDate, @CreatedUserId, @LastUpdatedDate, @LastUpdatedUserId, @GridID)
		
		
		else if(@DayInd=7)
		 	INSERT INTO [dbo].ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId, GridID)
			values (@ScheduleId, @newProgramID, @StartTime, @EndTime, 'Y', 'N', 'N', 'N', 'N', 'N', 'N', @CreatedDate, @CreatedUserId, @LastUpdatedDate, @LastUpdatedUserId, @GridID)
		
		
		else if(@DayInd=1)
		 	INSERT INTO [dbo].ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId, GridID)
			values (@ScheduleId, @newProgramID, @StartTime, @EndTime, 'N', 'Y', 'N', 'N', 'N', 'N', 'N', @CreatedDate, @CreatedUserId, @LastUpdatedDate, @LastUpdatedUserId, @GridID)
		
		
		else if(@DayInd=2)
		 	INSERT INTO [dbo].ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId, GridID)
			values (@ScheduleId, @newProgramID, @StartTime, @EndTime, 'N', 'N', 'Y', 'N', 'N', 'N', 'N', @CreatedDate, @CreatedUserId, @LastUpdatedDate, @LastUpdatedUserId, @GridID)
		
		
		else if(@DayInd=3)
		  	INSERT INTO [dbo].ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId, GridID)
			values (@ScheduleId, @newProgramID, @StartTime, @EndTime, 'N', 'N', 'N', 'Y', 'N', 'N', 'N', @CreatedDate, @CreatedUserId, @LastUpdatedDate, @LastUpdatedUserId, @GridID)
		
		
		else if(@DayInd=4)
		  	INSERT INTO [dbo].ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId, GridID)
			values (@ScheduleId, @newProgramID, @StartTime, @EndTime, 'N', 'N', 'N', 'N', 'Y', 'N', 'N', @CreatedDate, @CreatedUserId, @LastUpdatedDate, @LastUpdatedUserId, @GridID)
		
		
		else if(@DayInd=5)
		  	INSERT INTO [dbo].ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId, GridID)
			values (@ScheduleId, @newProgramID, @StartTime, @EndTime, 'N', 'N', 'N', 'N', 'N', 'Y', 'N', @CreatedDate, @CreatedUserId, @LastUpdatedDate, @LastUpdatedUserId, @GridID)
		
		



		--select @eScheduleProgramID = SCOPE_IDENTITY()
	end
	Else Begin
	
		--if(@MondayInd='y')
		--  update ScheduleProgram set MondayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		--else if(@TuesdayInd='y')
		--  update ScheduleProgram set TuesdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		--else if(@WednesdayInd='y')
		--  update ScheduleProgram set WednesdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		--else if(@ThursdayInd='y')
		--  update ScheduleProgram set ThursdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		--else if(@FridayInd='y')
		--  update ScheduleProgram set FridayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		--else if(@SaturdayInd='y')
		--  update ScheduleProgram set SaturdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID

		if(@DayInd=1)
		  update ScheduleProgram set MondayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		else if(@DayInd=2)
		  update ScheduleProgram set TuesdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		else if(@DayInd=3)
		  update ScheduleProgram set WednesdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		else if(@DayInd=4)
		  update ScheduleProgram set ThursdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		else if(@DayInd=5)
		  update ScheduleProgram set FridayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		else if(@DayInd=6)
		  update ScheduleProgram set SaturdayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID
		else if(@DayInd=7)
		  update ScheduleProgram set SundayInd = 'Y' where ScheduleProgramID = @eScheduleProgramID

	  End
	END
	--select @eScheduleProgramID