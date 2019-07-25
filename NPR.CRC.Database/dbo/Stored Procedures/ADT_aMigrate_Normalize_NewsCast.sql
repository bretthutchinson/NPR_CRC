CREATE Procedure [dbo].[ADT_aMigrate_Normalize_NewsCast]



AS
BEGIN
	
	SET NOCOUNT ON

	DECLARE @simax int
	DECLARE @si int
	DECLARE @scheduleID int
	DECLARE @scheduleNewsCastID int
	DECLARE @TscheduleNewsCastID int
	Declare @HOURLYind char(1)
	DECLARE @starttime time
	Declare @endtime time
	declare @tmp int

	declare @NScheduleNewsCastID int
	declare	@sundayind char(1)
	declare	@mondayind char(1)
	declare @Tuesdayind char(1)
	declare	@Wednesdayind char(1)
	declare	@Thursdayind char(1)
	declare	@Fridayind char(1)
	declare	@Satrudayind char(1)


	DECLARE @id int
	DECLARE @idmax int

	DECLARE @schedule_table TABLE (

			idxx int Primary Key IDENTITY(1,1),
			ScheduleNewsCastID int,
			scheduleid int,
			hourlyind char(1),
			starttime time,
			endtime time
		)



		
	DECLARE @tmp_table TABLE (

			idxx int Primary Key IDENTITY(1,1),
			ScheduleNewsCastID int,
			sundayind char(1),
			mondayind char(1),
			Tuesdayind char(1),
			Wednesdayind char(1),
			Thursdayind char(1),
			Fridayind char(1),
			Satrudayind char(1)
		)



		--select * from schedulenewscast
	insert into @schedule_table select ScheduleNewsCastID, sc.scheduleid, hourlyind, starttime, endtime 
	from schedulenewscast SNC
	JOIN  SCHEDULE SC ON sc.scheduleid = snc.scheduleid
	join station s on s.stationid = sc.stationid 
	where RepeaterStatusId  > 1
	and year =2014

	SELECT  @simax = max(idxx) FROM @schedule_table
	set @si =1
	WHILE (@si <=@simax)
	Begin

		--@scheduleNewsCastID = null


		select @scheduleNewsCastID = ScheduleNewsCastID, @scheduleid=scheduleid, @hourlyind = hourlyind, @starttime = starttime, @endtime = endtime from @schedule_table WHERE idxx = @si
		
		 
		print convert(varchar, @si) +': ' +convert(varchar, @scheduleid) + ' ------ ' +  convert(varchar, @scheduleNewsCastID)  
		--print convert(varchar, @scheduleid)
		--insert into @tmp_table select schedulenewscastid, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind from schedulenewscast where ScheduleID = @scheduleid and starttime = @starttime and endtime = @endtime
		--SELECT @id =1 
		set @TscheduleNewsCastID = null
		select @TscheduleNewsCastID = ScheduleNewsCastID from schedulenewscast WHERE ScheduleNewsCastID = @scheduleNewsCastID
		If( @TscheduleNewsCastID IS NOT NULL ) bEGIN
				select @NScheduleNewsCastID = ScheduleNewsCastID,  @sundayind = sundayind, @mondayind = mondayind, @Tuesdayind = Tuesdayind, @Wednesdayind = Wednesdayind, @Thursdayind = Thursdayind, @Fridayind = Fridayind, @Satrudayind = Saturdayind
					from schedulenewscast where ScheduleID = @scheduleid and hourlyind = @hourlyind and starttime = @starttime and endtime = @endtime and ScheduleNewsCastID <> @ScheduleNewsCastID

				--print @NScheduleNewsCastID 

				--[ADT_aMigrate_Normalize_NewsCast]

				WHILE @NScheduleNewsCastID is not null
				Begin
					--select @tmp = schedulenewscastid from @tmp_table where idxx= @id
					--print @tmp
					--set @id = @id +1
			
					If @sundayind = 'Y' update schedulenewscast set sundayind = 'Y' where schedulenewscastid = @scheduleNewsCastID
					If @mondayind = 'Y' update schedulenewscast set mondayind = 'Y' where schedulenewscastid = @scheduleNewsCastID
					If @Tuesdayind = 'Y' update schedulenewscast set Tuesdayind = 'Y' where schedulenewscastid = @scheduleNewsCastID
					If @Wednesdayind = 'Y' update schedulenewscast set Wednesdayind = 'Y' where schedulenewscastid = @scheduleNewsCastID
					If @Thursdayind = 'Y' update schedulenewscast set Thursdayind = 'Y' where schedulenewscastid = @scheduleNewsCastID
					If @Fridayind = 'Y' update schedulenewscast set Fridayind = 'Y' where schedulenewscastid = @scheduleNewsCastID
					If @Satrudayind = 'Y' update schedulenewscast set saturdayind = 'Y' where schedulenewscastid = @scheduleNewsCastID
			
					print '    ---> ' + cast(@scheduleNewsCastID as varchar) + ' - ' + cast(@NScheduleNewsCastID as varchar)
					delete from schedulenewscast where schedulenewscastid = @NScheduleNewsCastID
					set @NScheduleNewsCastID = null
					select @NScheduleNewsCastID = ScheduleNewsCastID, @sundayind = sundayind, @mondayind = mondayind, @Tuesdayind = Tuesdayind, @Wednesdayind = Wednesdayind, @Thursdayind = Thursdayind, @Fridayind = Fridayind, @Satrudayind = Saturdayind
					from schedulenewscast where ScheduleID = @scheduleid and hourlyind = @hourlyind and starttime = @starttime and endtime = @endtime and ScheduleNewsCastID <> @ScheduleNewsCastID
			
				end
		End
		--drop  @tmp_table
		SET @si = @si + 1
	End
	--print 'tst'

END