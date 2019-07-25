CREATE Procedure [dbo].[DT_PERegularToScheduleProgram1]
AS
BEGIN

	DECLARE @minPERegularId BIGINT,
			   @maxRERegularId BIGINT,
			   @BatchSize INT,
			   @BatchSet INT
	
	SET @BatchSet = 0;
	SET @BatchSize = 500000;
	
	SELECT @minPERegularId = MIN(crc3.dbo.PERegularPartition1.PERegularID) FROM crc3.dbo.PERegularPartition1;
	SELECT @maxRERegularId = MAX(crc3.dbo.PERegularPartition1.PERegularID) FROM crc3.dbo.PERegularPartition1;
	
	WHILE @minPERegularId <= @maxRERegularId
		BEGIN
			BEGIN TRANSACTION
		
				BEGIN TRY
				INSERT INTO [dbo].[ScheduleProgram] (ScheduleId, ProgramId, StartTime, EndTime, SundayInd, MondayInd, TuesdayInd, WednesdayInd, ThursdayInd, FridayInd, SaturdayInd, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
			
				SELECT
			--O_g.gridid,
					sch.ScheduleId As crc_ScheduleId,
					N_PR.ProgramId as crc_ProgramId,
					PER.StartTime As StartTime,
					PER.EndTime As EndTime,
					PER.SundayInd,
					PER.MondayInd,
					PER.TuesdayInd,
					PER.WednesdayInd,
					PER.ThursdayInd,
					PER.FridayInd,
					PER.SaturdayInd,
					sch.CreatedDate,
					sch.CreatedUserId,
					sch.LastUpdatedDate,
					sch.LastUpdatedUserId
			--O_g.StationId As crc3_StationId,
			--O_st.CallLetters + '-' + O_st.Band As crc3_StationName,
			--N_St.StationId As crc_StationId,
			--N_st.crcStationName crc_StationName,
			--DATEPART(Year, MonthYear) As [Year],
			--DATEPART(Month, MonthYear) As [Month],
			--PER.ProgramId as crc3_ProgramId,
			--N_PR.ProgramId as crc_ProgramId,
			--O_Pr.ProgramName As O_ProgramName,
			--N_Pr.ProgramName As N_ProgramName
					FROM	
			
				(SELECT @BatchSet As BatchNumber, * FROM 
					(SELECT 
						DISTINCT
						row_number() OVER (ORDER BY gridid, programid, startTime, endtime) As RowNum, 
						GridId, 
						ProgramId, 
						StartTime, 
						EndTime,
						ISNULL(MAX(CASE WHEN SundayInd = 'Y' THEN 'Y' ELSE NULL End), 'N') As SundayInd,
						ISNULL(MAX(CASE WHEN MondayInd = 'Y' THEN 'Y' ELSE NULL End), 'N') As MondayInd,
						ISNULL(MAX(CASE WHEN TuesdayInd = 'Y' THEN 'Y' ELSE NULL End), 'N') As TuesdayInd,
						ISNULL(MAX(CASE WHEN WednesdayInd = 'Y' THEN 'Y' ELSE NULL End), 'N') As WednesdayInd,
						ISNULL(MAX(CASE WHEN ThursdayInd = 'Y' THEN 'Y' ELSE NULL End), 'N') As ThursdayInd,
						ISNULL(MAX(CASE WHEN FridayInd = 'Y' THEN 'Y' ELSE NULL End), 'N') As FridayInd,
						ISNULL(MAX(CASE WHEN SaturdayInd = 'Y' THEN 'Y' ELSE NULL End), 'N') As SaturdayInd
					FROM 
						(SELECT
							GridID
							, ProgramId
							, CONVERT(time, startdate) As StartTime
							, CASE WHEN CONVERT(TIME, EndDate) = '00:00:00.000000' THEN '23:59:59.0000000' ELSE CONVERT(TIME, EndDate) END As EndTime,
							CASE WHEN DayNum = 1 THEN 'Y' ELSE NULL END As MondayInd,
							CASE WHEN DayNum = 2 THEN 'Y' ELSE NULL END As TuesdayInd,
							CASE WHEN DayNum = 3 THEN 'Y' ELSE NULL END As WednesdayInd,
							CASE WHEN DayNum = 4 THEN 'Y' ELSE NULL END As ThursdayInd,
							CASE WHEN DayNum = 5 THEN 'Y' ELSE NULL END As FridayInd,
							CASE WHEN DayNum = 6 THEN 'Y' ELSE NULL END As SaturdayInd,
							CASE WHEN DayNum = 7 THEN 'Y' ELSE NULL END As SundayInd
						FROM 
							crc3.dbo.PERegularPartition1
						WHERE 
							PERegularID BETWEEN @minPERegularId AND @minPERegularId + @BatchSize
						) As rawData
				GROUP BY
				GridId, ProgramId, startTime, EndTime) As PERegular
				/*ORDER BY GridId, ProgramId, startTime, EndTime*/) As PER
			
				INNER JOIN
				crc3.dbo.grid O_g ON PER.GridID = O_g.GridId INNER JOIN
				crc3.dbo.Station O_st ON O_g.StationID = O_st.StationID INNER JOIN
				(SELECT  StationId, CallLetters + '-' + BandName As crcStationName
				 FROM dbo.Station INNER JOIN dbo.Band ON station.BandId = Band.BandId) As N_st ON O_st.CallLetters + '-' + O_st.Band = N_st.crcStationName INNER JOIN
				 schedule sch ON N_St.StationId = sch.StationId AND DATEPART(Year, O_g.MonthYear) = sch.[Year] AND DATEPART(Month, O_g.MonthYear) = sch.[Month] INNER JOIN
				 crc3.dbo.Program O_Pr ON PER.ProgramId = O_Pr.ProgramId INNER JOIN
				 dbo.Program N_Pr ON rtrim(ltrim(O_Pr.ProgramName)) = rtrim(ltrim(N_Pr.ProgramName))
				 where O_g.gridId NOT IN (45683, 45684)
			
				 ORDER BY O_g.GridId, N_PR.ProgramId, startTime, EndTime
			
				SET @minPERegularId = @minPERegularId + @BatchSize;
				SET @BatchSet = @BatchSet + 1;
				
				PRINT 'BATCH ' + CONVERT(VARCHAR, @BatchSet) + ' COMPLETE.'
				COMMIT TRANSACTION 
			
				END TRY
				BEGIN CATCH
					ROLLBACK TRANSACTION
				END CATCH
		
		END
END
GO

