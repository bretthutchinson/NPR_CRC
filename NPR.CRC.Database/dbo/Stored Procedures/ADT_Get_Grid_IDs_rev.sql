CREATE Procedure [dbo].[ADT_Get_Grid_IDs_rev]
AS

BEGIN
  ----SELECT top 1 GridID from crc3.dbo.grid
  -- SELECT top 1000000 ScheduleID, CreatedDate, CreatedUserID, LastUpdatedDate, LastUpdatedUserID from CRC_Migration_Test_BH.dbo.schedule 
  -- --where year > 2011
  -- where createddate < '2014-05-06'
  -- order by createddate desc
  -- --SELECT  *  from CRC_Migration_Test_BH.dbo.schedule 
  
  --truncate table aaascheduleFilledIDList
  --insert into aaascheduleFilledIDList
  --select distinct(scheduleid) from CRC_Migration_Test_BH.dbo.scheduleprogram 

   
	select top 3000 ScheduleID, CreatedDate, CreatedUserID, LastUpdatedDate, LastUpdatedUserID from CRC_Migration_Test_BH.dbo.schedule 
	where scheduleid in
	(
	   --SELECT top 1000000 ScheduleID, CreatedDate, CreatedUserID, LastUpdatedDate, LastUpdatedUserID from CRC_Migration_Test_BH.dbo.schedule 
		SELECT top 10000000 ScheduleID from CRC_Migration_Test_BH.dbo.schedule 
	   --
	   --where year > 2011
	   --where createddate < '2014-05-06'
	   where year = '2014' 
	   order by createddate asc
	) 
    and  scheduleid not in 
	(
		--select scheduleid from aaascheduleFilledIDList
	   select distinct(scheduleid) from CRC_Migration_Test_BH.dbo.scheduleprogram
	) 
	--and stationid in (22826, 23752, 22894, 23059, 23087, 23118, 23287, 23305)
	order by createddate desc




END