CREATE PROCEDURE [dbo].[PSP_ScheduleNewscastTimezonShiftBackward_Update]
(
    @ScheduleId BIGINT

)
AS BEGIN

    SET NOCOUNT ON

   


	--Regaulr shift (repeater is in back)
	--M(Rpeats)--> C
	--whatever airs on M at 7 airs on C at 8 -- whatever airs at 12:00AM Tuesday on C airs on 11:00PM Monday on M
	
	--1. delete top (1:00 AM) and shift up
	delete from schedulenewscast where  starttime < '1:00 AM'
	-- and scheduleid = 2372076
	and scheduleid = @ScheduleId

	
	--2. everything else subtract 1 hour
		update schedulenewscast
		set starttime = DATEADD(hour,-1,starttime),
		endtime = DATEADD(hour,-1,endtime)
		from 
		schedulenewscast where 
		--scheduleid = 2372076 
		scheduleid = @ScheduleId



	--3. Copy from flagship all programs < '1:00 AM' with add 23 hours
		insert into schedulenewscast (scheduleid, starttime, endtime, hourlyind, durationminutes, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind, createddate, createduserid, lastupdateddate, lastupdateduserid)
		select scr.scheduleid,
		dateadd(hour,23,spf.starttime), 
		dateadd(hour,23,spf.endtime),
		hourlyind,
		durationminutes,
		sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind, 
		spf.createddate, spf.createduserid, spf.lastupdateddate, spf.lastupdateduserid
		from  schedule scr --on scr.scheduleid = spr.scheduleid
		join station sr on sr.stationid = scr.stationid
		join station sf on sf.stationid = sr.flagshipstationid 
		join schedule scf on scf.stationid = sf.stationid and scf.month = scr.month and scf.year = scr.year
		join  schedulenewscast spf on spf.scheduleid = scf.scheduleid 
		where  spf.starttime < '1:00 AM' 
		and scr.scheduleid = @ScheduleId




	--4. shift everthing forward one dayime < 1:00 AM
		update  schedulenewscast
		set sundayind = case when Mondayind ='Y' then 'Y' else 'N' end,
		 Mondayind = case when Tuesdayind ='Y' then 'Y' else 'N' end,
		 Tuesdayind = case when Wednesdayind ='Y' then 'Y' else 'N'end,
		 Wednesdayind = case when Thursdayind ='Y' then 'Y' else 'N'end,
		 Thursdayind = case when Fridayind ='Y' then 'Y' else 'N'end,
		 Fridayind = case when Saturdayind ='Y' then 'Y' else 'N'end,
		 Saturdayind = case when sundayind ='Y' then 'Y' else 'N' end
		--Where scheduleid = 2294425
		where scheduleid = @ScheduleId
		and starttime >= '11:00 PM'

END