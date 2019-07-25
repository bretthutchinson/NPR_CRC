CREATE PROCEDURE [dbo].[PSP_ScheduleProgramTimezonShiftForward_Update]
(
	--repeater schedule ID
    @ScheduleId BIGINT

)
AS BEGIN

    SET NOCOUNT ON


		--1 Adjust times down if end times spans below 1:00 AM (and start time is less than 1:00 AM)
		---alt adjust *UP* if 
		update scheduleprogram set endtime = '22:59:59' 
		from scheduleprogram where  starttime < '11:00 PM' and endtime > '11:00 PM' 
		--and scheduleid = 2372076 
		and scheduleid = @ScheduleId



		--2 Delete (and eventually re-copy) if time is equal to or less than 1:00 AM
		delete from scheduleprogram where  starttime >= '11:00PM'
		-- and scheduleid = 2372076
		and scheduleid = @ScheduleId


		update scheduleprogram set endtime = '22:59:59' where endtime = '11:00 PM' 
		--and scheduleid = 2372076 
		and scheduleid = @ScheduleId

		--3 Adjust all times up
		--Alt shift all times down
		update scheduleprogram 
		set starttime = DATEADD(hour,1,starttime),
		endtime = DATEADD(hour,1,endtime)
		from 
		scheduleprogram where 
		--scheduleid = 2372076 
		scheduleid = @ScheduleId


		--4 Copy from flagship stations with 23 hours added
				---Sunday
				insert into scheduleprogram (scheduleid, programid, starttime, endtime, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind, createddate, createduserid, lastupdateddate, lastupdateduserid)
				select scr.scheduleid, spf.programid,
				case when spf.starttime < '11:00 PM' then '12:00 AM' else dateadd(hour,-23,spf.starttime) End, 
				dateadd(hour,-23,spf.endtime),
				'Y', 'N', 'N', 'N', 'N', 'N', 'N', spf.createddate, spf.createduserid, spf.lastupdateddate, spf.lastupdateduserid
				from  schedule scr --on scr.scheduleid = spr.scheduleid
				join station sr on sr.stationid = scr.stationid
				join station sf on sf.stationid = sr.flagshipstationid 
				join schedule scf on scf.stationid = sf.stationid and scf.month = scr.month and scf.year = scr.year
				join  scheduleprogram spf on spf.scheduleid = scf.scheduleid 
				where  spf.endtime > '11:00 PM' 
				--and scr.scheduleid = 2372076
				and scr.scheduleid = @ScheduleId
				and sundayind = 'Y'

				---Monday
				insert into scheduleprogram (scheduleid, programid, starttime, endtime, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind, createddate, createduserid, lastupdateddate, lastupdateduserid)
				select scr.scheduleid, spf.programid,
				case when spf.starttime < '11:00 PM' then '12:00 AM' else dateadd(hour,-23,spf.starttime) End, 
				dateadd(hour,-23,spf.endtime),
				'N', 'Y', 'N', 'N', 'N', 'N', 'N', spf.createddate, spf.createduserid, spf.lastupdateddate, spf.lastupdateduserid
				from  schedule scr --on scr.scheduleid = spr.scheduleid
				join station sr on sr.stationid = scr.stationid
				join station sf on sf.stationid = sr.flagshipstationid 
				join schedule scf on scf.stationid = sf.stationid and scf.month = scr.month and scf.year = scr.year
				join  scheduleprogram spf on spf.scheduleid = scf.scheduleid 
				where  spf.endtime > '11:00 PM' 
				--and scr.scheduleid = 2372076
				and scr.scheduleid = @ScheduleId
				and mondayind = 'Y'


				---Tuesday
				insert into scheduleprogram (scheduleid, programid, starttime, endtime, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind, createddate, createduserid, lastupdateddate, lastupdateduserid)
				select scr.scheduleid, spf.programid,
				case when spf.starttime < '11:00 PM' then '12:00 AM' else dateadd(hour,-23,spf.starttime) End, 
				dateadd(hour,-23,spf.endtime),
				'N', 'N', 'Y', 'N', 'N', 'N', 'N', spf.createddate, spf.createduserid, spf.lastupdateddate, spf.lastupdateduserid
				from  schedule scr --on scr.scheduleid = spr.scheduleid
				join station sr on sr.stationid = scr.stationid
				join station sf on sf.stationid = sr.flagshipstationid 
				join schedule scf on scf.stationid = sf.stationid and scf.month = scr.month and scf.year = scr.year
				join  scheduleprogram spf on spf.scheduleid = scf.scheduleid 
				where  spf.endtime > '11:00 PM' 
				--and scr.scheduleid = 2372076
				and scr.scheduleid = @ScheduleId
				and tuesdayind = 'Y'


				---Wednesday
				insert into scheduleprogram (scheduleid, programid, starttime, endtime, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind, createddate, createduserid, lastupdateddate, lastupdateduserid)
				select scr.scheduleid, spf.programid,
				case when spf.starttime < '11:00 PM' then '12:00 AM' else dateadd(hour,-23,spf.starttime) End, 
				dateadd(hour,-23,spf.endtime),
				'N', 'N', 'N', 'Y', 'N', 'N', 'N', spf.createddate, spf.createduserid, spf.lastupdateddate, spf.lastupdateduserid
				from  schedule scr --on scr.scheduleid = spr.scheduleid
				join station sr on sr.stationid = scr.stationid
				join station sf on sf.stationid = sr.flagshipstationid 
				join schedule scf on scf.stationid = sf.stationid and scf.month = scr.month and scf.year = scr.year
				join  scheduleprogram spf on spf.scheduleid = scf.scheduleid 
				where  spf.endtime > '11:00 PM' 
				--and scr.scheduleid = 2372076
				and scr.scheduleid = @ScheduleId
				and wednesdayind = 'Y'

		
				---Thursday
				insert into scheduleprogram (scheduleid, programid, starttime, endtime, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind, createddate, createduserid, lastupdateddate, lastupdateduserid)
				select scr.scheduleid, spf.programid,
				case when spf.starttime < '11:00 PM' then '12:00 AM' else dateadd(hour,-23,spf.starttime) End, 
				dateadd(hour,-23,spf.endtime),
				'N', 'N', 'N', 'N', 'Y', 'N', 'N', spf.createddate, spf.createduserid, spf.lastupdateddate, spf.lastupdateduserid
				from  schedule scr --on scr.scheduleid = spr.scheduleid
				join station sr on sr.stationid = scr.stationid
				join station sf on sf.stationid = sr.flagshipstationid 
				join schedule scf on scf.stationid = sf.stationid and scf.month = scr.month and scf.year = scr.year
				join  scheduleprogram spf on spf.scheduleid = scf.scheduleid 
				where  spf.endtime > '11:00 PM' 
				--and scr.scheduleid = 2372076
				and scr.scheduleid = @ScheduleId
				and thursdayind = 'Y'

		
				---Friday
				insert into scheduleprogram (scheduleid, programid, starttime, endtime, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind, createddate, createduserid, lastupdateddate, lastupdateduserid)
				select scr.scheduleid, spf.programid,
				case when spf.starttime < '11:00 PM' then '12:00 AM' else dateadd(hour,-23,spf.starttime) End, 
				dateadd(hour,-23,spf.endtime),
				'N', 'N', 'N', 'N', 'N', 'Y', 'N', spf.createddate, spf.createduserid, spf.lastupdateddate, spf.lastupdateduserid
				from  schedule scr --on scr.scheduleid = spr.scheduleid
				join station sr on sr.stationid = scr.stationid
				join station sf on sf.stationid = sr.flagshipstationid 
				join schedule scf on scf.stationid = sf.stationid and scf.month = scr.month and scf.year = scr.year
				join  scheduleprogram spf on spf.scheduleid = scf.scheduleid 
				where  spf.endtime > '11:00 PM' 
				--and scr.scheduleid = 2372076
				and scr.scheduleid = @ScheduleId
				and fridayind = 'Y'

		
				---Saturday
				insert into scheduleprogram (scheduleid, programid, starttime, endtime, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind, createddate, createduserid, lastupdateddate, lastupdateduserid)
				select scr.scheduleid, spf.programid,
				case when spf.starttime < '11:00 PM' then '12:00 AM' else dateadd(hour,-23,spf.starttime) End, 
				dateadd(hour,-23,spf.endtime),
				'N', 'N', 'N', 'N', 'N', 'N', 'Y', spf.createddate, spf.createduserid, spf.lastupdateddate, spf.lastupdateduserid
				from  schedule scr --on scr.scheduleid = spr.scheduleid
				join station sr on sr.stationid = scr.stationid
				join station sf on sf.stationid = sr.flagshipstationid 
				join schedule scf on scf.stationid = sf.stationid and scf.month = scr.month and scf.year = scr.year
				join  scheduleprogram spf on spf.scheduleid = scf.scheduleid 
				where  spf.endtime > '11:00 PM' 
				--and scr.scheduleid = 2372076
				and scr.scheduleid = @ScheduleId
				and saturdayind = 'Y'



		--delete from scheduleprogram where scheduleprogramid in (39750431, 39750432)

		--5. shift baackwards 1 (or forward -1)

		--forward (-1)
		update  scheduleprogram
		set sundayind = case when Saturdayind ='Y' then 'Y' else 'N' end,
		 Mondayind = case when Sundayind ='Y' then 'Y' else 'N' end,
		 Tuesdayind = case when Mondayind ='Y' then 'Y' else 'N'end,
		 Wednesdayind = case when Tuesdayind ='Y' then 'Y' else 'N'end,
		 Thursdayind = case when Wednesdayind ='Y' then 'Y' else 'N'end,
		 Fridayind = case when Thursdayind ='Y' then 'Y' else 'N'end,
		 Saturdayind = case when Fridayind ='Y' then 'Y' else 'N' end
		--Where scheduleid = 2294425
		where scheduleid =@ScheduleId
		 and endtime <= '1:00 AM'

		----Backward (1)
		--update  scheduleprogram
		--set sundayind = case when Mondayind ='Y' then 'Y' else 'N' end,
		-- Mondayind = case when Tuesdayind ='Y' then 'Y' else 'N' end,
		-- Tuesdayind = case when Wednesdayind ='Y' then 'Y' else 'N'end,
		-- Wednesdayind = case when Thursdayind ='Y' then 'Y' else 'N'end,
		-- Thursdayind = case when Fridayind ='Y' then 'Y' else 'N'end,
		-- Fridayind = case when Saturdayind ='Y' then 'Y' else 'N'end,
		-- Saturdayind = case when sundayind ='Y' then 'Y' else 'N' end
		--Where 
		----scheduleid = 2372076
		--scheduleid in (
		--	select scheduleid from schedule sc
		--	join station s on s.stationid = sc.stationid
		--	where s.stationid in (23709, 23540, 23138, 23529, 23415, 24681, 22884)

		--) and starttime >= '11:00 PM'

		--select * from schedule where stationid = 23709
		--select * from scheduleprogram where scheduleid =2386654

		----*****Fix "59:59"
		update scheduleprogram set endtime = '1:00 AM' where endtime = '0:59:59' 
		--and scheduleid = 2372076 
		and scheduleid = @ScheduleId

		--select * from scheduleprogram where  scheduleid = 2372076 and endtime = '11:00 PM'
		--select * from program where programid = 1691
		--select * from program where programname like 'jazz%'--1660
		--6. Merge upper and delete if same program
		--upd8te scheduleprogram set programid = 1660 where scheduleprogramid = 39750441


				DECLARE @simax int
				DECLARE @si int
				DECLARE @TscheduleID int
				DECLARE @scheduleprogramID int
				DECLARE @TscheduleprogramID int
				DECLARE @starttime time
				Declare @endtime time
				declare @tmp int

				declare @NscheduleprogramID int
				declare @programid int
				declare	@sundayind char(1)
				declare	@mondayind char(1)
				declare @Tuesdayind char(1)
				declare	@Wednesdayind char(1)
				declare	@Thursdayind char(1)
				declare	@Fridayind char(1)
				declare	@Saturdayind char(1)


				DECLARE @id int
				DECLARE @idmax int

				DECLARE @schedule_table TABLE (

						idxx int Primary Key IDENTITY(1,1),
						scheduleprogramID int,
						scheduleid int,
						programid int,
						starttime time,
						endtime time
					)

				insert into @schedule_table select scheduleprogramID,  sc.scheduleid, programid, starttime, endtime 
				--select *  
				from scheduleprogram SNC
				JOIN  SCHEDULE SC ON sc.scheduleid = snc.scheduleid
				join station s on s.stationid = sc.stationid 
				--where  sc.scheduleid = 2372076
				where sc.scheduleid =@ScheduleId
				and snc.endtime = '1:00 AM'
	

				SELECT  @simax = max(idxx) FROM @schedule_table
				set @si =1
				WHILE (@si <=@simax)
				Begin

					--@scheduleprogramID = null
					--select * from scheduleprogram where  scheduleid = 2372076 --39750441

					select @scheduleprogramID = scheduleprogramID, @TscheduleID=scheduleid,  @programid=programid, @starttime = starttime, @endtime = endtime 
					from @schedule_table WHERE idxx = @si
		
		 
					print convert(varchar, @si) +': ' +convert(varchar, @programid) + ' ------ ' +  convert(varchar, @scheduleprogramID)  
					--print convert(varchar, @TscheduleID)
					--insert into @tmp_table select scheduleprogramid, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind from scheduleprogram where ScheduleID = @TscheduleID and starttime = @starttime and endtime = @endtime
					--SELECT @id =1 
					set @TscheduleprogramID = null
					select @TscheduleprogramID = scheduleprogramID,  @sundayind = sundayind, @mondayind = mondayind, @Tuesdayind = Tuesdayind, @Wednesdayind = Wednesdayind, @Thursdayind = Thursdayind, @Fridayind = Fridayind, @Saturdayind = Saturdayind from scheduleprogram
					 WHERE scheduleprogramID = @scheduleprogramID
					print convert(varchar, @si) +':T ' +convert(varchar, @TscheduleprogramID) 
					If( @TscheduleprogramID IS NOT NULL ) bEGIN
							set @NscheduleprogramID = null
							--select @NscheduleprogramID = scheduleprogramID, @starttime = starttime
							select @NscheduleprogramID = scheduleprogramID, @endtime = endtime
								from scheduleprogram where ScheduleID = @TscheduleID and  starttime = '1:00 AM' 
								and (Sundayind = 'Y' or @sundayind ='N')
								and (Mondayind = 'Y' or @Mondayind ='N')
								and (tuesdayind = 'Y' or @tuesdayind ='N')
								and (wednesdayind = 'Y' or @wednesdayind ='N')
								and (thursdayind = 'Y' or @thursdayind ='N')
								and (fridayind = 'Y' or @fridayind ='N')
								and (saturdayind = 'Y' or @saturdayind='N')
								and programid=@programid and scheduleprogramID <> @scheduleprogramID 
				
							print convert(varchar, @si) +': N ' +convert(varchar, @NscheduleprogramID) + '   PID: ' +convert(varchar, @programid) + ' --start time ' + convert(varchar,@starttime)
							if(@NscheduleprogramID is not null) Begin
								--update scheduleprogram set endtime =@endtime where scheduleprogramid = @NscheduleprogramID
								--update scheduleprogram set starttime =@starttime where scheduleprogramid = @TscheduleprogramID
								update scheduleprogram set endtime =@endtime where scheduleprogramid = @TscheduleprogramID
								IF  @sundayind ='Y' 
									update scheduleprogram set Sundayind = 'N' where scheduleprogramid = @NscheduleprogramID
								Else IF @mondayind = 'Y'
									update scheduleprogram set Mondayind = 'N' where scheduleprogramid = @NscheduleprogramID
								Else if  @Tuesdayind ='Y'
									update scheduleprogram set tuesdayind = 'N' where scheduleprogramid = @NscheduleprogramID
								else if @Wednesdayind = 'Y'
									update scheduleprogram set wednesdayind = 'N' where scheduleprogramid = @NscheduleprogramID
								else if @Thursdayind = 'Y'
									update scheduleprogram set thursdayind = 'N' where scheduleprogramid = @NscheduleprogramID
								else if @Fridayind = 'Y'
									update scheduleprogram set fridayind = 'N' where scheduleprogramid = @NscheduleprogramID
								else if @Saturdayind = 'Y'
									update scheduleprogram set saturdayind = 'N' where scheduleprogramid = @NscheduleprogramID
					
								--if all days removed delete the record
								delete from scheduleprogram where scheduleprogramid = @NscheduleprogramID
								   and sundayind ='N' and mondayind ='N' and Tuesdayind = 'N' and Wednesdayind = 'N' and Thursdayind ='N' and Fridayind = 'N' and Saturdayind = 'N'
					
								--select * from scheduleprogram where scheduleprogramid = 34874489
								--select * from scheduleprogram where scheduleid = 2372076 and programid = 1498
								--update scheduleprogram set starttime  = '11:00 PM' where scheduleprogramid = 39750441
								--select * from program where programname like 'bbc%'
								--update scheduleprogram set programid = 1660 where scheduleprogramid = 39750442
								--print 'ts'
							End
							set @NscheduleprogramID =null
							set @programid = null
			
					End
					--drop  @tmp_table
					SET @si = @si + 1
				End



		--7. Normalize


			SET NOCOUNT ON

			--DECLARE @simax int
			--DECLARE @si int
			--DECLARE @TscheduleID int
			--DECLARE @scheduleprogramID int
			--DECLARE @TscheduleprogramID int
			--DECLARE @starttime time
			--Declare @endtime time
			--declare @tmp int

			--declare @NscheduleprogramID int
			--declare @programid int
			--declare	@sundayind char(1)
			--declare	@mondayind char(1)
			--declare @Tuesdayind char(1)
			--declare	@Wednesdayind char(1)
			--declare	@Thursdayind char(1)
			--declare	@Fridayind char(1)
			--declare	@SatURdayind char(1)


			--DECLARE @id int
			--DECLARE @idmax int

			set @TscheduleprogramID = null
			set @NscheduleprogramID = null
			set @programid = null

			DECLARE @Xschedule_table TABLE (

					idxx int Primary Key IDENTITY(1,1),
					scheduleprogramID int,
					scheduleid int,
					programid int, 
					starttime time,
					endtime time
				)

				--select * from scheduleprogram
			insert into @Xschedule_table select scheduleprogramID, sc.scheduleid, programid,  starttime, endtime 
			--select *
			from scheduleprogram SNC
			JOIN  SCHEDULE SC ON sc.scheduleid = snc.scheduleid
			join station s on s.stationid = sc.stationid 
			--where sc.scheduleid = 2372076
			where sc.scheduleid = @ScheduleId
	
	 

			SELECT  @simax = max(idxx) FROM @Xschedule_table
			set @si =1
			WHILE (@si <=@simax)
			Begin

				--@scheduleprogramID = null


				select @scheduleprogramID = scheduleprogramID, @TscheduleID=scheduleid, @programid=programid, @starttime = starttime, @endtime = endtime from @Xschedule_table WHERE idxx = @si
		
		 
				--**print convert(varchar, @si) +': ' +convert(varchar, @TscheduleID) + ' ------ ' +  convert(varchar, @scheduleprogramID)  
		
				--print convert(varchar, @TscheduleID)
				--insert into @tmp_table select scheduleprogramid, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind from scheduleprogram where ScheduleID = @TscheduleID and starttime = @starttime and endtime = @endtime
				--SELECT @id =1 
				set @TscheduleprogramID = null
				select @TscheduleprogramID = scheduleprogramID from scheduleprogram WHERE scheduleprogramID = @scheduleprogramID
				If( @TscheduleprogramID IS NOT NULL ) bEGIN
						select @NscheduleprogramID = scheduleprogramID, @sundayind = sundayind, @mondayind = mondayind, @Tuesdayind = Tuesdayind, @Wednesdayind = Wednesdayind, @Thursdayind = Thursdayind, @Fridayind = Fridayind, @SatURdayind = Saturdayind
							from scheduleprogram where ScheduleID = @TscheduleID and starttime = @starttime and endtime = @endtime and programid=@programid and scheduleprogramID <> @scheduleprogramID 

						--print @NscheduleprogramID 

						--[ADT_aMigrate_Normalize_NewsCast]

						WHILE @NscheduleprogramID is not null
						Begin
							--select @tmp	 = scheduleprogramid from @tmp_table where idxx= @id
							--print @tmp
							--set @id = @id +1
			
							If @sundayind = 'Y' update scheduleprogram set sundayind = 'Y' where scheduleprogramid = @scheduleprogramID
							If @mondayind = 'Y' update scheduleprogram set mondayind = 'Y' where scheduleprogramid = @scheduleprogramID
							If @Tuesdayind = 'Y' update scheduleprogram set Tuesdayind = 'Y' where scheduleprogramid = @scheduleprogramID
							If @Wednesdayind = 'Y' update scheduleprogram set Wednesdayind = 'Y' where scheduleprogramid = @scheduleprogramID
							If @Thursdayind = 'Y' update scheduleprogram set Thursdayind = 'Y' where scheduleprogramid = @scheduleprogramID
							If @Fridayind = 'Y' update scheduleprogram set Fridayind = 'Y' where scheduleprogramid = @scheduleprogramID
							If @SatURdayind = 'Y' update scheduleprogram set saturdayind = 'Y' where scheduleprogramid = @scheduleprogramID
			
							print '    ---> ' + cast(@scheduleprogramID as varchar) + ' - ' + cast(@NscheduleprogramID as varchar)
							delete from scheduleprogram where scheduleprogramid = @NscheduleprogramID
							set @NscheduleprogramID = null
							--set @programid = null
							select @NscheduleprogramID = scheduleprogramID, @sundayind = sundayind, @mondayind = mondayind, @Tuesdayind = Tuesdayind, @Wednesdayind = Wednesdayind, @Thursdayind = Thursdayind, @Fridayind = Fridayind, @SatURdayind = Saturdayind
							from scheduleprogram where ScheduleID = @TscheduleID and starttime = @starttime and endtime = @endtime and programid=@programid and scheduleprogramID <> @scheduleprogramID
			
						end
				End
				--drop  @tmp_table
				SET @si = @si + 1
			End
	

End