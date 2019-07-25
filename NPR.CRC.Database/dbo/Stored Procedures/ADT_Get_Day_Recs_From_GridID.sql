CREATE Procedure [dbo].[ADT_Get_Day_Recs_From_GridID]


	@ScheduleID BIGINT,
	@Day	Int

AS
BEGIN
	declare @GridID as bigint
	declare @tdate as varchar(200)
	declare @station as varchar(200)
	declare @OldStationID as bigint

	select  
	@tdate =  CAST(year AS varchar(4)) + '-' +  CAST(month AS varchar(2)) + '-' + '01', 
	@station = callletters + '-' + b.bandname
	from schedule sch 
	join station st on st.stationid = sch.stationid 
	join band b on b.bandid = st.bandid
	where scheduleid = @ScheduleID 

	select @OldStationID = stationid from crc3_20141208_NoBackup.dbo.station where @station = callletters + '-'+band
	

	select @GridID = Gridid from crc3_20141208_NoBackup.dbo.grid where stationid = @OldStationID and monthyear in (@tdate) 
    SELECT * from  
	(	select * from crc3_20141208_NoBackup.dbo.PERegularpartition4
				union 
		select * from crc3_20141208_NoBackup.dbo.PERegularpartition3
				union 
		select * from crc3_20141208_NoBackup.dbo.PERegularpartition2 
				union 
		select * from crc3_20141208_NoBackup.dbo.PERegularpartition1  
	) as per
	--join crc3_20141208_NoBackup.dbo.program p on p.programid = per.programid
	where GridID = @GridID and DayNum = @Day 
	and gridId NOT IN (45683, 45684)
	order by startdate
	--select @OldStationID
END

   --[ADT_Get_Day_Recs_From_GridID] 2104585, 1
   --select * from crc3_20141208_NoBackup.dbo.program where programid = 3589