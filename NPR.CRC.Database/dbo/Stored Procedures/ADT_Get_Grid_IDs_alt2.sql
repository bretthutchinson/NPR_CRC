CREATE  Procedure [dbo].[ADT_Get_Grid_IDs_alt2]
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
	select top 100000 ScheduleID, CreatedDate, CreatedUserID, LastUpdatedDate, LastUpdatedUserID from CRC_Migration_Test_BH.dbo.schedule 
	where scheduleid in
	(
	   --SELECT top 1000000 ScheduleID, CreatedDate, CreatedUserID, LastUpdatedDate, LastUpdatedUserID from CRC_Migration_Test_BH.dbo.schedule 
		SELECT top 1000000 ScheduleID from CRC_Migration_Test_BH.dbo.schedule 
	   --
	   --where year > 2011
	   --where createddate < '2014-05-06'
	   where year = '2013' and month >8 
	   order by createddate asc
	) 
    and scheduleid not in 
	(
		select scheduleid from aaascheduleFilledIDList
	   --select distinct(scheduleid) from CRC_Migration_Test_BH.dbo.scheduleprogram
	) order by createddate asc





END