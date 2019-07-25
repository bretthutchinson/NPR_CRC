CREATE Procedure [dbo].[ADT_Get_Grid_IDs]
AS

BEGIN
  ----SELECT top 1 GridID from crc3.dbo.grid
  -- SELECT top 1000000 ScheduleID, CreatedDate, CreatedUserID, LastUpdatedDate, LastUpdatedUserID from CRC_Migration_Test_BH.dbo.schedule 
  -- --where year > 2011
  -- where createddate < '2014-05-06'
  -- order by createddate desc
  -- --SELECT  *  from CRC_Migration_Test_BH.dbo.schedule
  
  --------***********fille schedule ids already filled**** 
  truncate table aaascheduleFilledIDList
  insert into aaascheduleFilledIDList
  select distinct(scheduleid) from CRC_Migration_Test_BH.dbo.scheduleprogram 
  
  
  
  
  declare @year int
   --set @year = 2013
	select top 100000 ScheduleID, sc.CreatedDate, sc.CreatedUserID, sc.LastUpdatedDate, sc.LastUpdatedUserID from CRC_Migration_Test_BH.dbo.schedule sc
	join CRC_Migration_Test_BH.dbo.station s on s.stationid= sc.stationid
	where scheduleid in
	(
	   --SELECT top 1000000 ScheduleID, CreatedDate, CreatedUserID, LastUpdatedDate, LastUpdatedUserID from CRC_Migration_Test_BH.dbo.schedule 
		SELECT top 100000000 ScheduleID from CRC_Migration_Test_BH.dbo.schedule 
	   --
	   --where year > 2011
	   --where createddate < '2014-05-06'
	   --where year = '2014' and month > 1
	   --and scheduleid= 257174
	   --order by createddate asc
	   
	) 
    and  scheduleid not in 
	(
		--select scheduleid from aaascheduleFilledIDList
	   select distinct(scheduleid) from CRC_Migration_Test_BH.dbo.scheduleprogram --where scheduleid = 2365560
	) 
	and repeaterstatusid > 1 --and ScheduleID = 2365560
	--and stationid in (22826, 23752, 22894, 23059, 23087, 23118, 23287, 23305)
	order by createddate asc

	--select * from station where stationid = 23563
	--select * from schedule where stationid = 24660
	--select * from schedule where scheduleid = 2304459
	--select * from crc3_20140508.dbo.grid where stationid = 3387 and  monthyear >= '2013-07-01'  and monthyear < '2013-08-01'
	--select * from crc3_20140508.dbo.station where callletters = 'WRTE'
	--select * from crc3_20140508.dbo.PERegularPartition4 where gridid= 234757
END