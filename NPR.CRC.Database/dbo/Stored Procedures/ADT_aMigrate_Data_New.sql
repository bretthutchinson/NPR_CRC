CREATE Procedure [dbo].[ADT_aMigrate_Data_New]



AS
BEGIN
		--select * from station order by createddate

	--select * from crc3_20140508.dbo.station

	--ADT_Get_Day_Recs_From_GridID 2159464, 3

	--select * from schedule where scheduleid = 2159464
	--select * from station where stationid = 23118

	--select * from scheduleprogram where gridid =215709
	--select * from scheduleprogram where scheduleid < 2214614

	--select * from crc3_20140508.dbo.grid where gridid =215709

	--select top 10 * from crc3_20140508.dbo.PERegularpartition4

	--select PERegularID from crc3_20140508.dbo.PERegularpartition1 where PERegularID in
	--(

	--	select PERegularID from crc3_20140508.dbo.PERegularpartition1
	--)



	--------INSERT INTO  crc3_20140508.dbo.PERegularPartitionx
	--------SELECT * FROM  crc3_20140508.dbo.PERegularpartition1

	--------INSERT INTO  crc3_20140508.dbo.PERegularPartitionx
	--------SELECT * FROM  crc3_20140508.dbo.PERegularpartition2

	--select * from crc3_20140508.dbo.PERegularPartitionx

	--truncate table CRC_Migration_Test_BH.dbo.scheduleprogram

	--USE master ;
	--ALTER DATABASE CRC_Migration_Test_BH SET RECOVERY SIMPLE ;

	SET NOCOUNT ON

	DECLARE @schedule_table TABLE (

			idxx int Primary Key IDENTITY(1,1),
			ScheduleID int, 
			CreatedDate datetime, 
			CreatedUserID int, 
			LastUpdatedDate datetime, 
			LastUpdatedUserID int

		)


		INSERT @schedule_table exec ADT_Get_Grid_IDs 

		DECLARE @si int
		DECLARE @simax int
		declare @scheduleID int
		declare @CreatedDateT datetime
		declare @CreatedUserIDT int
		declare @LastUpdatedDateT datetime
		declare @LastUpdatedUserIDT int		

		SELECT  @si = min(idxx) FROM @schedule_table
		SELECT  @simax = max(idxx) FROM @schedule_table
		--truncate table CRC_Migration_Test_BH.dbo.scheduleprogram

		WHILE (@si <=@simax)
		Begin
				
				select @scheduleID = scheduleID from @schedule_table WHERE idxx = @si
				print @scheduleID
				declare @day int =1
				while (@day < 8)
				Begin
					declare @numrows int
					DECLARE @i int
					DECLARE @PERegularID int


					DECLARE @PERegular_table TABLE (
						idx int Primary Key IDENTITY(1,1),
						PERegularID int,
						gridID int,
						ProgramID int,
						startdate datetime,
						enddate datetime,
						ProgramTypeID int,
						Daynum int
					)

					
					INSERT @PERegular_table exec ADT_Get_Day_Recs_From_GridID @scheduleID, @day

					--SELECT * FROM crc3_20140508.dbo.grid where gridid =215709
					--SELECT * FROM ADT_Get_Day_Recs_From_GridID 2147608, 3

					SELECT  @i = min(idx) FROM @PERegular_table
					SET @numrows = (SELECT COUNT(*) FROM @PERegular_table)

					declare @c int =0
					declare @starttime datetime
					declare @endtime datetime
					declare @programID int = -1

					declare @programIDT int
					declare @starttimeT datetime
					declare @endtimeT datetime
	

					IF @numrows > 0 Begin 
						--select @i
						WHILE (@i <= (SELECT MAX(idx) FROM @PERegular_table))
						BEGIN
						SELECT @programIDT = programID, @starttimeT = StartDate, @endtimeT=endDate, @programIDT=programid FROM @PERegular_table WHERE idx = @i
							--print 	'raw---- ' + cast(@programIDT as varchar) + ' : '+	cast(@starttimeT as varchar)  + ' : ' + cast(@endtimeT as varchar)

							IF @c = 0 Begin
								SELECT  @programID = @programIDT, @starttime = @starttimeT, @endtime=@endtimeT	
				
								--print 	'being---- ' + cast(@programID as varchar) + ' : '+	cast(@starttimeT as varchar)  + ' : ' + cast(@endtime as varchar)

								set @c = 1
							End 
        
							IF @programID <> @programIDT Begin

								exec ADT_Insert_Day_Recs_For_ScheduleID_New @scheduleID, @programID, @starttime, @endtime, @day, '2013-01-01',1,'2013-01-01', 1,null
								--exec ADT_Insert_Day_Recs_For_ScheduleID @scheduleID, @programID, @starttime, @endtime, 'Y', 'N', 'N', 'N', 'N', 'N', 'N', '2013-01-01',1,'2013-01-01', 1,null


								--print 	cast(@programID as varchar) + ' : '+	cast(CONVERT(TIME,@starttime) as varchar)  + ' : ' + cast(CONVERT(TIME,@endtime) as varchar)

								set @starttime = @starttimeT
								set @programID = @programIDT

							End
							set @endtime = @endtimeT
							SET @i = @i + 1
						End
						
					END
					
						exec ADT_Insert_Day_Recs_For_ScheduleID_New @scheduleID, @programID, @starttime, '23:59:59', @day, '2013-01-01',1,'2013-01-01', 1,null

					--print 	cast(@programID as varchar) + ' : '+	cast(CONVERT(TIME,@starttime) as varchar)  + ' : ' + '23:59:59'
					
					
					
					--truncate  @PERegular_table
					delete from @PERegular_table
					--print 'del table'
					--set @starttimeT = 'Feb  4 2013  8:00PM'
					set @day = @day+1
				End

				--truncate table CRC_Migration_Test_BH.dbo.scheduleprogram
				--select * from scheduleprogram where scheduleid =  2159464 and mondayind = 'Y'
			SET @si = @si + 1

			--print @si
		End
END