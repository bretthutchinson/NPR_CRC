CREATE PROCEDURE [dbo].[PSP_ScheduleNewscastTimezonShiftForward_Update]
(
    @ScheduleId BIGINT

)
AS BEGIN

    SET NOCOUNT ON

   


	--forward (forward file) (repeater is in front)
	--e(Rpeats)--> C
	--whatever airs no C at 8 airs on E at 7 -- whatever airs at 11:00pm Tuesday on C airs on 12:00AM Wednesday on E
	
	--1. delete where start time >= 11:00 PM
	delete from schedulenewscast where  starttime >= '11:00PM'
	-- and scheduleid = 2372076
	and scheduleid = @ScheduleId 

	
	--2. everything else add 23 hours
		update schedulenewscast
		set starttime = DATEADD(hour,1,starttime),
		endtime = DATEADD(hour,1,endtime)
		from 
		schedulenewscast where 
		scheduleid = @ScheduleId



	--3. Copy from flagship all programs >= '11:00 PM' with subtract 23 hours
		insert into schedulenewscast (scheduleid, starttime, endtime, hourlyind, durationminutes, sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind, createddate, createduserid, lastupdateddate, lastupdateduserid)
		select scr.scheduleid,
		dateadd(hour,-23,spf.starttime), 
		dateadd(hour,-23,spf.endtime),
		hourlyind,
		durationminutes,
		sundayind, mondayind, tuesdayind, wednesdayind, thursdayind, fridayind, saturdayind, 
		spf.createddate, spf.createduserid, spf.lastupdateddate, spf.lastupdateduserid
		from  schedule scr --on scr.scheduleid = spr.scheduleid
		join station sr on sr.stationid = scr.stationid
		join station sf on sf.stationid = sr.flagshipstationid 
		join schedule scf on scf.stationid = sf.stationid and scf.month = scr.month and scf.year = scr.year
		join  schedulenewscast spf on spf.scheduleid = scf.scheduleid 
		where  spf.starttime >= '11:00 PM' 
		and scr.scheduleid = @ScheduleId 


	--4. shift everthing forward one day time < 1:00 AM
		update  schedulenewscast
		set sundayind = case when Saturdayind ='Y' then 'Y' else 'N' end,
			Mondayind = case when Sundayind ='Y' then 'Y' else 'N' end,
			Tuesdayind = case when Mondayind ='Y' then 'Y' else 'N'end,
			Wednesdayind = case when Tuesdayind ='Y' then 'Y' else 'N'end,
			Thursdayind = case when Wednesdayind ='Y' then 'Y' else 'N'end,
			Fridayind = case when Thursdayind ='Y' then 'Y' else 'N'end,
			Saturdayind = case when Fridayind ='Y' then 'Y' else 'N' end
		where scheduleid = @ScheduleId 
		and starttime < '1:00 AM'
END