CREATE PROCEDURE [dbo].[PSP_ScheduleProgram_Save]
(
    @ScheduleProgramId BIGINT,
	@ScheduleId BIGINT,
	@ProgramId BIGINT,
	@StartTime TIME,
	@EndTime TIME,
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

	

	DECLARE @tScheduleProgramID [int]
	Declare @tstartTime time
	Declare @tendtime	time
	declare @tProgramID int
	declare @tnendtime time
	Declare @nScheduleProgramID int
	Declare @OrigScheduleId bigint

	set @OrigScheduleId = @ScheduleId;

	-------------Begin Sunday------
	
	If @SundayInd = 'Y' Begin
		---1. Sunday - Overlapping Upper Edge?
			select @tScheduleProgramID=scheduleProgramid, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime)and SundayInd = 'Y'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'
	
			--If so, is it the only day in the record? Then Modify
			if @tScheduleProgramID is not null begin
				 Update scheduleprogram set endtime = @starttime where scheduleprogramid = @tScheduleProgramID 
				 --If the end time went beyond the end time of the new program (i.e. old program engulfs new one), we have to split and add one at the end
				 If @tnendtime > @endtime
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @endtime, @tnendtime,'Y','N','N','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and create new
				select @tScheduleProgramID=scheduleProgramid, @tstartTime = starttime, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime) and SundayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Sundayind = 'N' where scheduleprogramid = @tScheduleProgramID 
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @tstarttime, @starttime,'Y','N','N','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
				--If the end time went beyond the end time of the new program, we have to split and add one at the end
				If @tnendtime > @endtime
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @endtime, @tnendtime,'Y','N','N','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)

				End 
			End

		--2. Sunday - Overlapping Lower Edge?
			set @tScheduleProgramID = null
			select @tScheduleProgramID=scheduleProgramid from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and SundayInd = 'Y'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then Modify
				if @tScheduleProgramID is not null begin
				 Update scheduleprogram set starttime = @endtime where scheduleprogramid = @tScheduleProgramID 
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and create new
				select @tScheduleProgramID=scheduleProgramid, @tendTime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and SundayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Sundayind = 'N' where scheduleprogramid = @tScheduleProgramID 
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values(@scheduleid, @tProgramID, @endtime, @tendtime,'Y','N','N','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
				End 
			End


		--3. Sunday - Delete All In between if no other days indicated, otherwise update indacator
			delete from scheduleprogram where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and sundayInd = 'Y' and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'
			update scheduleprogram set SundayInd = 'N' where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and SundayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
			

		--4. Sunday - Insert New record
		  insert into scheduleprogram 
		  (ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
		  values( @scheduleid, @ProgramID, @starttime, @endtime,'Y','N','N','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		  select @nscheduleProgramID = SCOPE_IDENTITY()

		--5. Sunday - Check upper edge for same program and merge
		  set @tScheduleProgramID = null
		  select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid and SundayInd = 'Y'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then delete and change start time of newly created program
			if @tScheduleProgramID is not null begin
				 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
				 update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and change start time of newly created schedule
				select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid  and SundayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Sundayind = 'N' where scheduleprogramid = @tScheduleProgramID
					update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
				End 
			End 

		--6. Sunday - Check lower edge for same program and merge
		  set @tScheduleProgramID = null
		  select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid and SundayInd = 'Y'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then delete and change start time of newly created program
			if @tScheduleProgramID is not null begin
				 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
				 update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and change start time of newly created schedule
				select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid  and SundayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Sundayind = 'N' where scheduleprogramid = @tScheduleProgramID
					update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
				End 
			End 
		End

		-------------Begin Saturday------

		If @SaturdayInd = 'Y' Begin
		---1. Saturday - Overlapping Upper Edge?
			select @tScheduleProgramID=scheduleProgramid, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime)and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'Y'
	
			--If so, is it the only day in the record? Then Modify
			if @tScheduleProgramID is not null begin
				 Update scheduleprogram set endtime = @starttime where scheduleprogramid = @tScheduleProgramID 
				 --If the end time went beyond the end time of the new program (i.e. old program engulfs new one), we have to split and add one at the end
				 If @tnendtime > @endtime
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','N','N','N','N','N','Y', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and create new
				select @tScheduleProgramID=scheduleProgramid, @tstartTime = starttime, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime) and SaturdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR FridayInd = 'Y'  OR SundayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Saturdayind = 'N' where scheduleprogramid = @tScheduleProgramID 
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @tstarttime, @starttime,'N','N','N','N','N','N','Y', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
				--If the end time went beyond the end time of the new program, we have to split and add one at the end
				If @tnendtime > @endtime
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','N','N','N','N','N','Y', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)

				End 
			End

		--2. Saturday - Overlapping Lower Edge?
			set @tScheduleProgramID = null
			select @tScheduleProgramID=scheduleProgramid from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'Y'

			--If so, is it the only day in the record? Then Modify
				if @tScheduleProgramID is not null begin
				 Update scheduleprogram set starttime = @endtime where scheduleprogramid = @tScheduleProgramID 
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and create new
				select @tScheduleProgramID=scheduleProgramid, @tendTime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and SaturdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR FridayInd = 'Y'  OR SundayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Saturdayind = 'N' where scheduleprogramid = @tScheduleProgramID 
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values(@scheduleid, @tProgramID, @endtime, @tendtime,'N','N','N','N','N','N','Y', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
				End 
			End


		--3. Saturday - Delete All In between
			delete from scheduleprogram where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and sundayInd = 'N' and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'Y'
			update scheduleprogram set SaturdayInd = 'N' where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and SaturdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR FridayInd = 'Y'  OR SundayInd = 'Y')
			

		--4. Saturday - Insert New record
		  insert into scheduleprogram 
		  (ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
		  values( @scheduleid, @ProgramID, @starttime, @endtime,'N','N','N','N','N','N','Y', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		  select @nscheduleProgramID = SCOPE_IDENTITY()

		--5. Saturday - Check upper edge for same program and merge
		  set @tScheduleProgramID = null
		  select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'Y'

			--If so, is it the only day in the record? Then delete and change start time of newly created program
			if @tScheduleProgramID is not null begin
				 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
				 update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and change start time of newly created schedule
				select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid  and SaturdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR FridayInd = 'Y'  OR SundayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Saturdayind = 'N' where scheduleprogramid = @tScheduleProgramID
					update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
				End 
			End 

		--6. Saturday - Check lower edge for same program and merge
		  set @tScheduleProgramID = null
		  select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'Y'

			--If so, is it the only day in the record? Then delete and change start time of newly created program
			if @tScheduleProgramID is not null begin
				 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
				 update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and change start time of newly created schedule
				select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid  and SaturdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR FridayInd = 'Y'  OR SundayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Saturdayind = 'N' where scheduleprogramid = @tScheduleProgramID
					update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
				End 
			End 
		End
		-------------Begin Friday------
	
		If @FridayInd = 'Y' Begin
		---1. Friday - Overlapping Upper Edge?
			select @tScheduleProgramID=scheduleProgramid, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime)and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'Y'  and SaturdayInd = 'N'
	
			--If so, is it the only day in the record? Then Modify
			if @tScheduleProgramID is not null begin
				 Update scheduleprogram set endtime = @starttime where scheduleprogramid = @tScheduleProgramID 
				 --If the end time went beyond the end time of the new program (i.e. old program engulfs new one), we have to split and add one at the end
				 If @tnendtime > @endtime
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','N','N','N','N','Y','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and create new
				select @tScheduleProgramID=scheduleProgramid, @tstartTime = starttime, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime) and FridayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SaturdayInd = 'Y'  OR SundayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Fridayind = 'N' where scheduleprogramid = @tScheduleProgramID 
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @tstarttime, @starttime,'N','N','N','N','N','Y','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
				--If the end time went beyond the end time of the new program, we have to split and add one at the end
				If @tnendtime > @endtime
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','N','N','N','N','Y','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)

				End 
			End

		--2. Friday - Overlapping Lower Edge?
			set @tScheduleProgramID = null
			select @tScheduleProgramID=scheduleProgramid from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'Y'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then Modify
				if @tScheduleProgramID is not null begin
				 Update scheduleprogram set starttime = @endtime where scheduleprogramid = @tScheduleProgramID 
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and create new
				select @tScheduleProgramID=scheduleProgramid, @tendTime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and FridayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SaturdayInd = 'Y'  OR SundayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Fridayind = 'N' where scheduleprogramid = @tScheduleProgramID 
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values(@scheduleid, @tProgramID, @endtime, @tendtime,'N','N','N','N','N','Y','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
				End 
			End


		--3. Friday - Delete All In between
			delete from scheduleprogram where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and sundayInd = 'N' and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'Y'  and SaturdayInd = 'N'
			update scheduleprogram set FridayInd = 'N' where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and FridayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SaturdayInd = 'Y'  OR SundayInd = 'Y')

		--4. Friday - Insert New record
		  insert into scheduleprogram 
		  (ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
		  values( @scheduleid, @ProgramID, @starttime, @endtime,'N','N','N','N','N','Y','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		  select @nscheduleProgramID = SCOPE_IDENTITY()

		--5. Friday - Check upper edge for same program and merge
		  set @tScheduleProgramID = null
		  select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'Y'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then delete and change start time of newly created program
			if @tScheduleProgramID is not null begin
				 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
				 update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and change start time of newly created schedule
				select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid  and FridayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SaturdayInd = 'Y'  OR SundayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Fridayind = 'N' where scheduleprogramid = @tScheduleProgramID
					update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
				End 
			End 

		--6. Friday - Check lower edge for same program and merge
		  set @tScheduleProgramID = null
		  select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'Y'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then delete and change start time of newly created program
			if @tScheduleProgramID is not null begin
				 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
				 update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and change start time of newly created schedule
				select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid  and FridayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SaturdayInd = 'Y'  OR SundayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Fridayind = 'N' where scheduleprogramid = @tScheduleProgramID
					update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
				End 
			End 
		End

	-------------Begin Thursday------
	
	If @ThursdayInd = 'Y' Begin
		---1. Thursday - Overlapping Upper Edge?
			select @tScheduleProgramID=scheduleProgramid, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime)and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'Y'  and FridayInd = 'N'  and SaturdayInd = 'N'
	
			--If so, is it the only day in the record? Then Modify
			if @tScheduleProgramID is not null begin
				 Update scheduleprogram set endtime = @starttime where scheduleprogramid = @tScheduleProgramID 
				 --If the end time went beyond the end time of the new program (i.e. old program engulfs new one), we have to split and add one at the end
				 If @tnendtime > @endtime
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','N','N','N','Y','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and create new
				select @tScheduleProgramID=scheduleProgramid, @tstartTime = starttime, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime) and ThursdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Thursdayind = 'N' where scheduleprogramid = @tScheduleProgramID 
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @tstarttime, @starttime,'N','N','N','N','Y','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
				--If the end time went beyond the end time of the new program, we have to split and add one at the end
				If @tnendtime > @endtime
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','N','N','N','Y','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)

				End 
			End

		--2. Thursday - Overlapping Lower Edge?
			set @tScheduleProgramID = null
			select @tScheduleProgramID=scheduleProgramid from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'Y'  and FridayInd = 'N'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then Modify
				if @tScheduleProgramID is not null begin
				 Update scheduleprogram set starttime = @endtime where scheduleprogramid = @tScheduleProgramID 
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and create new
				select @tScheduleProgramID=scheduleProgramid, @tendTime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and ThursdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Thursdayind = 'N' where scheduleprogramid = @tScheduleProgramID 
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values(@scheduleid, @tProgramID, @endtime, @tendtime,'N','N','N','N','Y','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
				End 
			End


		--3. Thursday - Delete All In between if no other days indicated, otherwise update indacator
			delete from scheduleprogram where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and sundayInd = 'N' and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'Y'  and FridayInd = 'N'  and SaturdayInd = 'N'
			update scheduleprogram set ThursdayInd = 'N' where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and ThursdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
			

		--4. Thursday - Insert New record
		  insert into scheduleprogram 
		  (ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
		  values( @scheduleid, @ProgramID, @starttime, @endtime,'N','N','N','N','Y','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		  select @nscheduleProgramID = SCOPE_IDENTITY()

		--5. Thursday - Check upper edge for same program and merge
		  set @tScheduleProgramID = null
		  select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'Y'  and FridayInd = 'N'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then delete and change start time of newly created program
			if @tScheduleProgramID is not null begin
				 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
				 update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and change start time of newly created schedule
				select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid  and ThursdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Thursdayind = 'N' where scheduleprogramid = @tScheduleProgramID
					update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
				End 
			End 

		--6. Thursday - Check lower edge for same program and merge
		  set @tScheduleProgramID = null
		  select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'Y'  and FridayInd = 'N'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then delete and change start time of newly created program
			if @tScheduleProgramID is not null begin
				 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
				 update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and change start time of newly created schedule
				select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid  and ThursdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Thursdayind = 'N' where scheduleprogramid = @tScheduleProgramID
					update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
				End 
			End 
		End
	

		-------------Begin Wednesday------
	
		If @WednesdayInd = 'Y' Begin
			---1. Wednesday - Overlapping Upper Edge?
				select @tScheduleProgramID=scheduleProgramid, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime)and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'Y'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'
	
				--If so, is it the only day in the record? Then Modify
				if @tScheduleProgramID is not null begin
					 Update scheduleprogram set endtime = @starttime where scheduleprogramid = @tScheduleProgramID 
					 --If the end time went beyond the end time of the new program (i.e. old program engulfs new one), we have to split and add one at the end
					 If @tnendtime > @endtime
						Insert into scheduleprogram 
						(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
						values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','N','N','Y','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
				End 
				Else
				Begin
					--If there are other days in the record, remove from day list and create new
					select @tScheduleProgramID=scheduleProgramid, @tstartTime = starttime, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime) and WednesdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
					if @tScheduleProgramID is not null begin
						Update scheduleprogram set Wednesdayind = 'N' where scheduleprogramid = @tScheduleProgramID 
						Insert into scheduleprogram 
						(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
						values( @scheduleid, @tProgramID, @tstarttime, @starttime,'N','N','N','Y','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
					--If the end time went beyond the end time of the new program, we have to split and add one at the end
					If @tnendtime > @endtime
						Insert into scheduleprogram 
						(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
						values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','N','N','Y','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)

					End 
				End

			--2. Wednesday - Overlapping Lower Edge?
				set @tScheduleProgramID = null
				select @tScheduleProgramID=scheduleProgramid from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'Y'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

				--If so, is it the only day in the record? Then Modify
					if @tScheduleProgramID is not null begin
					 Update scheduleprogram set starttime = @endtime where scheduleprogramid = @tScheduleProgramID 
				End 
				Else
				Begin
					--If there are other days in the record, remove from day list and create new
					select @tScheduleProgramID=scheduleProgramid, @tendTime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and WednesdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
					if @tScheduleProgramID is not null begin
						Update scheduleprogram set Wednesdayind = 'N' where scheduleprogramid = @tScheduleProgramID 
						Insert into scheduleprogram 
						(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
						values(@scheduleid, @tProgramID, @endtime, @tendtime,'N','N','N','Y','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
					End 
				End


			--3. Wednesday - Delete All In between if no other days indicated, otherwise update indacator
				delete from scheduleprogram where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and sundayInd = 'N' and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'Y'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'
				update scheduleprogram set WednesdayInd = 'N' where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and WednesdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
			

			--4. Wednesday - Insert New record
			  insert into scheduleprogram 
			  (ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
			  values( @scheduleid, @ProgramID, @starttime, @endtime,'N','N','N','Y','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
			  select @nscheduleProgramID = SCOPE_IDENTITY()

			--5. Wednesday - Check upper edge for same program and merge
			  set @tScheduleProgramID = null
			  select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'Y'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

				--If so, is it the only day in the record? Then delete and change start time of newly created program
				if @tScheduleProgramID is not null begin
					 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
					 update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
				End 
				Else
				Begin
					--If there are other days in the record, remove from day list and change start time of newly created schedule
					select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid  and WednesdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
					if @tScheduleProgramID is not null begin
						Update scheduleprogram set Wednesdayind = 'N' where scheduleprogramid = @tScheduleProgramID
						update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
					End 
				End 

			--6. Wednesday - Check lower edge for same program and merge
			  set @tScheduleProgramID = null
			  select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'Y'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

				--If so, is it the only day in the record? Then delete and change start time of newly created program
				if @tScheduleProgramID is not null begin
					 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
					 update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
				End 
				Else
				Begin
					--If there are other days in the record, remove from day list and change start time of newly created schedule
					select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid  and WednesdayInd = 'Y' and (  MondayInd = 'Y'  OR TuesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
					if @tScheduleProgramID is not null begin
						Update scheduleprogram set Wednesdayind = 'N' where scheduleprogramid = @tScheduleProgramID
						update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
					End 
				End 
			End

		-------------Begin Tuesday------
	
		If @TuesdayInd = 'Y' Begin
			---1. Tuesday - Overlapping Upper Edge?
				select @tScheduleProgramID=scheduleProgramid, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime)and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'Y'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'
	
				--If so, is it the only day in the record? Then Modify
				if @tScheduleProgramID is not null begin
					 Update scheduleprogram set endtime = @starttime where scheduleprogramid = @tScheduleProgramID 
					 --If the end time went beyond the end time of the new program (i.e. old program engulfs new one), we have to split and add one at the end
					 If @tnendtime > @endtime
						Insert into scheduleprogram 
						(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
						values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','N','Y','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
				End 
				Else
				Begin
					--If there are other days in the record, remove from day list and create new
					select @tScheduleProgramID=scheduleProgramid, @tstartTime = starttime, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime) and TuesdayInd = 'Y' and (  MondayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
					if @tScheduleProgramID is not null begin
						Update scheduleprogram set Tuesdayind = 'N' where scheduleprogramid = @tScheduleProgramID 
						Insert into scheduleprogram 
						(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
						values( @scheduleid, @tProgramID, @tstarttime, @starttime,'N','N','Y','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
					--If the end time went beyond the end time of the new program, we have to split and add one at the end
					If @tnendtime > @endtime
						Insert into scheduleprogram 
						(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
						values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','N','Y','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)

					End 
				End

			--2. Tuesday - Overlapping Lower Edge?
				set @tScheduleProgramID = null
				select @tScheduleProgramID=scheduleProgramid from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'Y'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

				--If so, is it the only day in the record? Then Modify
					if @tScheduleProgramID is not null begin
					 Update scheduleprogram set starttime = @endtime where scheduleprogramid = @tScheduleProgramID 
				End 
				Else
				Begin
					--If there are other days in the record, remove from day list and create new
					select @tScheduleProgramID=scheduleProgramid, @tendTime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and TuesdayInd = 'Y' and (  MondayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
					if @tScheduleProgramID is not null begin
						Update scheduleprogram set Tuesdayind = 'N' where scheduleprogramid = @tScheduleProgramID 
						Insert into scheduleprogram 
						(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
						values(@scheduleid, @tProgramID, @endtime, @tendtime,'N','N','Y','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
					End 
				End


			--3. Tuesday - Delete All In between if no other days indicated, otherwise update indacator
				delete from scheduleprogram where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and sundayInd = 'N' and MondayInd = 'N'  and TuesdayInd = 'Y'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'
				update scheduleprogram set TuesdayInd = 'N' where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and TuesdayInd = 'Y' and (  MondayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
			

			--4. Tuesday - Insert New record
			  insert into scheduleprogram 
			  (ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
			  values( @scheduleid, @ProgramID, @starttime, @endtime,'N','N','Y','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
			  select @nscheduleProgramID = SCOPE_IDENTITY()

			--5. Tuesday - Check upper edge for same program and merge
			  set @tScheduleProgramID = null
			  select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'Y'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

				--If so, is it the only day in the record? Then delete and change start time of newly created program
				if @tScheduleProgramID is not null begin
					 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
					 update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
				End 
				Else
				Begin
					--If there are other days in the record, remove from day list and change start time of newly created schedule
					select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid  and TuesdayInd = 'Y' and (  MondayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
					if @tScheduleProgramID is not null begin
						Update scheduleprogram set Tuesdayind = 'N' where scheduleprogramid = @tScheduleProgramID
						update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
					End 
				End 

			--6. Tuesday - Check lower edge for same program and merge
			  set @tScheduleProgramID = null
			  select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid and SundayInd = 'N'  and MondayInd = 'N'  and TuesdayInd = 'Y'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

				--If so, is it the only day in the record? Then delete and change start time of newly created program
				if @tScheduleProgramID is not null begin
					 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
					 update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
				End 
				Else
				Begin
					--If there are other days in the record, remove from day list and change start time of newly created schedule
					select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid  and TuesdayInd = 'Y' and (  MondayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
					if @tScheduleProgramID is not null begin
						Update scheduleprogram set Tuesdayind = 'N' where scheduleprogramid = @tScheduleProgramID
						update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
					End 
				End 
			End

	-------------Begin Monday------
	
	If @MondayInd = 'Y' Begin
		---1. Monday - Overlapping Upper Edge?
			select @tScheduleProgramID=scheduleProgramid, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime)and SundayInd = 'N'  and MondayInd = 'Y'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'
	
			--If so, is it the only day in the record? Then Modify
			if @tScheduleProgramID is not null begin
				 Update scheduleprogram set endtime = @starttime where scheduleprogramid = @tScheduleProgramID 
				 --If the end time went beyond the end time of the new program (i.e. old program engulfs new one), we have to split and add one at the end
				 If @tnendtime > @endtime
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','Y','N','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and create new
				select @tScheduleProgramID=scheduleProgramid, @tstartTime = starttime, @tnendtime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (endtime > @StartTime and starttime<@starttime) and MondayInd = 'Y' and (  TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Mondayind = 'N' where scheduleprogramid = @tScheduleProgramID 
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @tstarttime, @starttime,'N','Y','N','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		
				--If the end time went beyond the end time of the new program, we have to split and add one at the end
				If @tnendtime > @endtime
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values( @scheduleid, @tProgramID, @endtime, @tnendtime,'N','Y','N','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)

				End 
			End

		--2. Monday - Overlapping Lower Edge?
			set @tScheduleProgramID = null
			select @tScheduleProgramID=scheduleProgramid from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and SundayInd = 'N'  and MondayInd = 'Y'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then Modify
				if @tScheduleProgramID is not null begin
				 Update scheduleprogram set starttime = @endtime where scheduleprogramid = @tScheduleProgramID 
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and create new
				select @tScheduleProgramID=scheduleProgramid, @tendTime = endtime, @tProgramID=programID from scheduleprogram where scheduleid=@scheduleID and (starttime < @EndTime and endtime>@endtime) and MondayInd = 'Y' and (  TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Mondayind = 'N' where scheduleprogramid = @tScheduleProgramID 
					Insert into scheduleprogram 
					(ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
					values(@scheduleid, @tProgramID, @endtime, @tendtime,'N','Y','N','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
				End 
			End


		--3. Monday - Delete All In between if no other days indicated, otherwise update indacator
			delete from scheduleprogram where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and sundayInd = 'N' and MondayInd = 'Y'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'
			update scheduleprogram set MondayInd = 'N' where scheduleid = @scheduleid and starttime >= @starttime and endtime<=@endtime and MondayInd = 'Y' and (  TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
			

		--4. Monday - Insert New record
		  insert into scheduleprogram 
		  (ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
		  values( @scheduleid, @ProgramID, @starttime, @endtime,'N','Y','N','N','N','N','N', GETUTCDATE(), @LastUpdatedUserId, GETUTCDATE(), @LastUpdatedUserId)
		  select @nscheduleProgramID = SCOPE_IDENTITY()

		--5. Monday - Check upper edge for same program and merge
		  set @tScheduleProgramID = null
		  select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid and SundayInd = 'N'  and MondayInd = 'Y'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then delete and change start time of newly created program
			if @tScheduleProgramID is not null begin
				 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
				 update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and change start time of newly created schedule
				select @tScheduleProgramID=scheduleProgramid, @tstartTime=starttime from scheduleprogram where scheduleid=@scheduleID and endtime = @starttime and programid=@programid  and MondayInd = 'Y' and (  TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Mondayind = 'N' where scheduleprogramid = @tScheduleProgramID
					update scheduleprogram set starttime = @tstartTime where scheduleprogramid = @nscheduleProgramID
				End 
			End 

		--6. Monday - Check lower edge for same program and merge
		  set @tScheduleProgramID = null
		  select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid and SundayInd = 'N'  and MondayInd = 'Y'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'

			--If so, is it the only day in the record? Then delete and change start time of newly created program
			if @tScheduleProgramID is not null begin
				 delete from scheduleprogram where scheduleprogramid = @tScheduleProgramID 
				 update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
			End 
			Else
			Begin
				--If there are other days in the record, remove from day list and change start time of newly created schedule
				select @tScheduleProgramID=scheduleProgramid, @tendTime=endtime from scheduleprogram where scheduleid=@scheduleID and starttime = @endtime and programid=@programid  and MondayInd = 'Y' and (  TuesdayInd = 'Y'  OR WednesdayInd = 'Y'  OR ThursdayInd = 'Y'  OR SundayInd = 'Y'  OR FridayInd = 'Y'  OR SaturdayInd = 'Y')
				if @tScheduleProgramID is not null begin
					Update scheduleprogram set Mondayind = 'N' where scheduleprogramid = @tScheduleProgramID
					update scheduleprogram set endtime = @tendTime where scheduleprogramid = @nscheduleProgramID
				End 
			End 
		End


  --select * from station 
  --select * from schedule where stationid =9
  --select * from scheduleprogram where scheduleid =66
 -- select * from program where programid in (
	--select programid from scheduleprogram where scheduleid =66
 -- )
 -- insert into scheduleprogram 
 -- (ScheduleId,ProgramId,StartTime,EndTime,SundayInd,MondayInd,TuesdayInd,WednesdayInd,ThursdayInd,FridayInd,SaturdayInd,CreatedDate,CreatedUserId,LastUpdatedDate,LastUpdatedUserId)
 -- values( 66, 23, '3:00AM','4:00AM','Y','N','N','N','N','N','N', GETUTCDATE(), 1, GETUTCDATE(), 1)
-- select * from scheduleprogram where scheduleid=66 and (endtime > '9:30am' and starttime < '9:30am' )and SundayInd = 'Y'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'
--select * from scheduleprogram where scheduleid =66 and ( sundayind = 'Y' or saturdayind ='y')
--update scheduleprogram set endtime= '10:00am' where scheduleprogramid = 	391392
--delete from scheduleprogram where scheduleid =66 and ( fridayind = 'Y' or saturdayind ='y')
--select scheduleProgramid from scheduleprogram where scheduleid=66 and (starttime < '8:00pm' and endtime>'8:00pm') and SundayInd = 'Y'  and MondayInd = 'N'  and TuesdayInd = 'N'  and WednesdayInd = 'N'  and ThursdayInd = 'N'  and FridayInd = 'N'  and SaturdayInd = 'N'



		DECLARE @numEvents INT,
				 @incrTableId INT,
				@cScheduleProgramId BIGINT, 
				@cScheduleId BIGINT, 
				@cProgramId BIGINT, 
				@cStartTime TIME, 
				@cEndTime TIME, 
				@cSundayInd CHAR(1), 
				@cMondayInd CHAR(1), 
				@cTuesdayInd CHAR(1), 
				@cWednesdayInd CHAR(1), 
				@cThursdayInd CHAR(1), 
				@cFridayInd CHAR(1), 
				@cSaturdayInd  CHAR(1)

	DECLARE @OverlappingEvents TABLE
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

	DECLARE @CombineEvents TABLE
	(
		TableId INT IDENTITY,
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
		CreatedUserId BIGINT,
		LastUpdatedUserId BIGINT	
	)


	/** Housecleaning. Combine events that have same start time, end time and program id. This can be caused by users creating/updating distinct events with same program and start and end time. **/
	INSERT INTO @CombineEvents
	SELECT 
		ScheduleId, 
		ProgramId, 
		StartTime, 
		EndTime, 
		MAX(SundayInd) SundayInd, 
		MAX(MondayInd) MondayInd, 
		MAX(TuesdayInd) TuesdayInd, 
		MAX(WednesdayInd) WednesdayInd, 
		MAX(ThursdayInd) ThursdayInd, 
		MAX(FridayInd) FridayInd, 
		MAX(SaturdayInd) SaturdayInd, 
		MAX(CreatedUserId) CreatedUserId, 
		MAX(LastUpdatedUserId) LastUpdatedUserId
	FROM 
		dbo.ScheduleProgram
	WHERE
		ScheduleId = @ScheduleId
	GROUP BY ScheduleId, ProgramId, StartTime, EndTime
	HAVING COUNT(ProgramId) > 1

	SET @incrTableId = 1;
	SET @numEvents = (SELECT COUNT(*) FROM @CombineEvents);

	WHILE @incrTableId <= @numEvents
	BEGIN
		SELECT @ScheduleId = ScheduleId, @ProgramId = ProgramId, @StartTime = StartTime, @EndTime = EndTime
		FROM @CombineEvents 
		WHERE TableId = @incrTableId;

		/** Delete individual events with same program, start time, and end time **/
		DELETE FROM ScheduleProgram WHERE ScheduleId = @ScheduleId AND ProgramId = @ProgramId AND StartTime = @StartTime AND EndTime = @EndTime;

		/** Insert new event with combined days indicator **/
		INSERT INTO dbo.ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
		SELECT ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, GETUTCDATE(), CreatedUserId, GETUTCDATE(), LastUpdatedUserId
		FROM @CombineEvents
		WHERE TableId = @incrTableId;

		SET @incrTableId = @incrTableId + 1;
	END

	/****** End logic to adjust Program Schedule based on Section 13.5.2.2 of requirements document ******/

	/****** Begin logic to add/update 100% repeater station Program Schedule records ******/
	DECLARE @FlagshipStationId BIGINT,
			 @RepeaterScheduleId BIGINT,
			 @RepeaterScheduleProgramId BIGINT,
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
		sp.ScheduleId = @ScheduleId

	/** Retrieve Flagship default values **/
	SELECT top 1
		@FlagshipStationId = sch.StationId,
		@FlagshipYear = sch.[Year],
		@FlagShipMonth = sch.[Month]
	FROM
		dbo.Schedule sch 
	WHERE
		sch.ScheduleId = @OrigScheduleId

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
		dbo.ScheduleProgram sp ON sch.ScheduleId = sp.ScheduleId
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

		/** Delete all ScheduleProgram records for current repeater station **/
		DELETE FROM dbo.ScheduleProgram WHERE ScheduleId = @RepeaterScheduleId;

		SET @Incr2 = 1;
		SELECT @NumRows2 = COUNT(*) FROM @FlagshipStationSchedule;

		WHILE @Incr2 <= @NumRows2 /** Loop through @FlagshipStationSchedule table **/
		BEGIN
		/*TODO: Add time zone logic */
			INSERT INTO dbo.ScheduleProgram (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
			SELECT 
				@RepeaterScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId		
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
			EXEC PSP_ScheduleProgramTimezonShiftForward_Update @RepeaterScheduleId
		end
		else if (@Ftimezone =1 and @Rtimezone = 2) or  (@Ftimezone =2 and @Rtimezone = 3) or  (@Ftimezone =3 and @Rtimezone = 5) or  (@Ftimezone =5 and @Rtimezone = 6) begin
			--print 'backwards'
			exec PSP_ScheduleProgramTimezonShiftBackward_Update @RepeaterScheduleId
		End



		SET @Incr = @Incr + 1;
	END
	/****** End logic to add/update 100% repeater station Program Schedule records ******/
	
    SELECT @ScheduleProgramId AS ScheduleProgramId;

END
GO


