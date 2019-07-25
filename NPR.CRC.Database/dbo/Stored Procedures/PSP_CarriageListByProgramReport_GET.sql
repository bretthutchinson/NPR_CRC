--select * from program where programid =  1533
CREATE PROCEDURE [dbo].[PSP_CarriageListByProgramReport_GET]
(
	--@CarriageTypeId BIGINT,
	--@MonthSpan VARCHAR(50),
	--@Year INT,
	--@BandSpan VARCHAR(200),
	--@DeletedInd CHAR(1),
	--@MemberStatusId BIGINT,
	--@DebugInd CHAR(1)
	--select * from program where programname like '%24%'
	--[PSP_CarriageListByProgramReport_GET] 'Regular', 'Yes', '1551', '4', '2014', '6', '2014', 'Excel', '|AM|, |FM|', 'Yes', null, null, null, null,'N'
	@programType   nvarchar(500),
	@ProgramEnabled   nvarchar(500),
	@ProgramID   nvarchar(500),
	@fromMonth   nvarchar(500),
	@fromYear   nvarchar(500),
	@toMonth   nvarchar(500),
	@toYear   nvarchar(500),
	@ReportFormat   nvarchar(500),


	@Band   nvarchar(500),
	@StationEnabled   nvarchar(500),
	@MemberStatusId   nvarchar(500),
	@StationId   nvarchar(500),
	@City   nvarchar(500),
	@StateId   nvarchar(500),
	@DebugInd CHAR(1) = 'N'


)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	/** Creating the dynamic sql and executing VIA EXEC instead of dbo.sp_executesql because IN clause is being used for months and bands. **/
	/** No threat of sql injection because input is being strictly controlled via controller **/

	--DECLARE @Month1 INT,
	--		@Month2 INT
				

	--SELECT 
	--		@Month1 = 
	--		CASE @fromMonth 
	--				WHEN '1, 2, 3' THEN 1
	--				WHEN '4, 5, 6' THEN 4
	--				WHEN '7, 8, 9' THEN 7
	--				WHEN '10, 11, 12' THEN 8
	--		END,
	--		@Month2 = 
	--		CASE @toMonth 
	--				WHEN '1, 2, 3' THEN 2
	--				WHEN '4, 5, 6' THEN 5
	--				WHEN '7, 8, 9' THEN 8
	--				WHEN '10, 11, 12' THEN 11 
	--		END

	DECLARE @Temp TABLE 
	(
		ScheduleProgramId BIGINT,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		ProgramName VARCHAR(100),
		CarriageTypeId BIGINT,
		StationId BIGINT,
		Station VARCHAR(50),
		Frequency VARCHAR(50),
		City VARCHAR(100),
		StateAbbreviation VARCHAR(10),
		[Month] INT,
		[Year] INT,
		StartTime TIME,
		EndTime TIME,
		MetroMarketRank VARCHAR(50),--INT,
		DMAMarketRank VARCHAR(50),--INT,
		QuarterHours FLOAT,
		DaysOfWeek VARCHAR(100),
		SundayInd CHAR(1),
		MondayInd CHAR(1),
		TuesdayInd CHAR(1),
		WednesdayInd CHAR(1),
		ThursdayInd CHAR(1),
		FridayInd CHAR(1),
		SaturdayInd CHAR(1),
		MemberStatusId BIGINT,
		MemberStatusName VARCHAR(50)
	)

	DECLARE @DynSql NVARCHAR(MAX) 
	
	IF @programType = 'Regular' Begin 
		set @DynSql= 
		'
		SELECT 
			sp.ScheduleProgramId, 
			sch.ScheduleId,
			p.ProgramId,
			p.ProgramName,
			p.CarriageTypeId,
			sta.StationId,
			sta.CallLetters + ''-'' + b.BandName As Station,
			Frequency,
			City,
			[state].Abbreviation,
			sch.[Month],
			sch.[Year],
			StartTime,
			EndTime,
			MetroMarketRank,
			DMAMarketRank,
			QuarterHours,
			
			CASE WHEN MondayInd = ''Y'' THEN ''Mon '' ELSE '''' END +
			CASE WHEN TuesdayInd = ''Y'' THEN ''Tue '' ELSE '''' END +
			CASE WHEN WednesdayInd = ''Y'' THEN ''Wed '' ELSE '''' END +
			CASE WHEN ThursdayInd = ''Y'' THEN ''Thu '' ELSE '''' END +
			CASE WHEN FridayInd = ''Y'' THEN ''Fri '' ELSE '''' END +
			CASE WHEN SaturdayInd = ''Y'' THEN ''Sat '' ELSE '''' END +
			CASE WHEN SundayInd = ''Y'' THEN ''Sun '' ELSE '''' END 	
			As DaysOfWeek,
			SundayInd,
			MondayInd,
			TuesdayInd,
			WednesdayInd,
			ThursdayInd,
			FridayInd,
			SaturdayInd,
			ms.MemberStatusId,
			MemberStatusName
		FROM
			dbo.Program p INNER JOIN
			dbo.ScheduleProgram sp ON p.ProgramId = sp.ProgramId INNER JOIN
			dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId INNER JOIN
			dbo.Station sta ON sch.StationId = sta.StationId INNER JOIN
			dbo.State On sta.StateId = State.StateId INNER JOIN
			dbo.Band b ON sta.BandId = b.BandId INNER JOIN
			dbo.MemberStatus ms ON sta.MemberStatusId = ms.MemberStatusId
		WHERE'
			--+ p.CarriageTypeId = ' +'2'
			--+ 'AND (sch.[Month] IN (' + @fromMonth + ') AND sch.[Year] = ' + CONVERT(VARCHAR, @fromYear) + ')'
			--+ ' (sch.[month]>=' + @fromMonth +'and  sch.[year] >= ' + @fromYear + ') and (sch.[month] <=' + @toMonth + 'and sch.[year] <=' + @toYear +')'
			
			+ ' CONVERT(DATE,''1/''+CONVERT(Varchar(2),sch.[Month])+''/''+CONVERT(Varchar(4),sch.[Year])) 
			   BETWEEN CONVERT(DATE,''1/'+@fromMonth+'/'+@fromYear+''') AND CONVERT(DATE,''1/'+@toMonth+'/'+@toYear+''')'
			+ 'AND b.BandName IN (' + REPLACE(@Band, '|', '''') + ')' 
			+ 'AND p.ProgramID = ' + @ProgramID 
			+ 'AND sch.AcceptedDate is not null'
		--select * from schedule
		--[PSP_CarriageListByProgramReport_GET] 'Regular', 'Yes', '1900', '1', '1871', '1', '2012', 'Excel', '|AM|, |FM|', 'Yes', null, 'Washignton', null, null
		IF @ProgramEnabled = 'Yes'
		SET @DynSql = @DynSql + ' AND P.DisabledUserId IS NULL'
	
		IF @ProgramEnabled = 'No'
		SET @DynSql = @DynSql + ' AND P.DisabledUserId IS NOT NULL'
		--SELECT * FROM PROGRAM

	End
	Else Begin 
		set @DynSql= 
		'
		SELECT 
			sp.ScheduleNewsCastId, 
			sch.ScheduleId,
			p.ProgramId,
			p.ProgramName,
			p.CarriageTypeId,
			sta.StationId,
			sta.CallLetters + ''-'' + b.BandName As Station,
			Frequency,
			City,
			[state].Abbreviation,
			sch.[Month],
			sch.[Year],
			StartTime,
			EndTime,
			MetroMarketRank,
			DMAMarketRank,
			0 as QuarterHours,
			
			CASE WHEN MondayInd = ''Y'' THEN ''Mon '' ELSE '''' END +
			CASE WHEN TuesdayInd = ''Y'' THEN ''Tue '' ELSE '''' END +
			CASE WHEN WednesdayInd = ''Y'' THEN ''Wed '' ELSE '''' END +
			CASE WHEN ThursdayInd = ''Y'' THEN ''Thu '' ELSE '''' END +
			CASE WHEN FridayInd = ''Y'' THEN ''Fri '' ELSE '''' END +
			CASE WHEN SaturdayInd = ''Y'' THEN ''Sat '' ELSE '''' END +
			CASE WHEN SundayInd = ''Y'' THEN ''Sun '' ELSE '''' END 		
			As DaysOfWeek,
			SundayInd,
			MondayInd,
			TuesdayInd,
			WednesdayInd,
			ThursdayInd,
			FridayInd,
			SaturdayInd,
			ms.MemberStatusId,
			MemberStatusName
		FROM
			dbo.Program p INNER JOIN
			dbo.ScheduleNewsCast sp ON sp.ScheduleNewscastId = sp.ScheduleNewscastId INNER JOIN
			dbo.Schedule sch ON sp.ScheduleId = sch.ScheduleId INNER JOIN
			dbo.Station sta ON sch.StationId = sta.StationId INNER JOIN
			dbo.State On sta.StateId = State.StateId INNER JOIN
			dbo.Band b ON sta.BandId = b.BandId INNER JOIN
			dbo.MemberStatus ms ON sta.MemberStatusId = ms.MemberStatusId
		WHERE'
			--+ p.CarriageTypeId = ' +'2'
			--+ 'AND (sch.[Month] IN (' + @fromMonth + ') AND sch.[Year] = ' + CONVERT(VARCHAR, @fromYear) + ')'
			-- + ' (sch.[month]>=' + @fromMonth +'and  sch.[year] >= ' + @fromYear + ') and (sch.[month] <=' + @toMonth + 'and sch.[year] <=' + @toYear +')'

			+ ' CONVERT(DATE,''1/''+CONVERT(Varchar(2),sch.[Month])+''/''+CONVERT(Varchar(4),sch.[Year])) 
			   BETWEEN CONVERT(DATE,''1/'+@fromMonth+'/'+@fromYear+''') AND CONVERT(DATE,''1/'+@toMonth+'/'+@toYear+''')'
			+ 'AND b.BandName IN (' + REPLACE(@Band, '|', '''') + ')' 
			+ 'AND p.ProgramName like ''npr newscast%'''  
	End

	IF @StationId IS NOT NULL
		SET @DynSql = @DynSql + ' AND sta.StationID = ' + CONVERT(VARCHAR, @StationId)

	

	IF @StationEnabled = 'Yes'
		SET @DynSql = @DynSql + ' AND sta.DisabledUserId IS NULL'
	
	IF @StationEnabled = 'No'
		SET @DynSql = @DynSql + ' AND sta.DisabledUserId IS NOT NULL'

	IF @MemberStatusId IS NOT NULL
		SET @DynSql = @DynSql + ' AND ms.MemberStatusId = ' + CONVERT(VARCHAR, @MemberStatusId)

	IF @StateId IS NOT NULL
		SET @DynSql = @DynSql + ' AND State.StateId = ' + CONVERT(VARCHAR, @StateId)
	
	IF @City IS NOT NULL
		SET @DynSql = @DynSql + ' AND sta.City = ''' +  @City +''''

	SET @DynSql = @DynSql + ' ORDER BY sta.CallLetters + ''-'' + b.BandName '
	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		BEGIN
			INSERT INTO @Temp
			EXEC dbo.sp_executesql @DynSql 
			--[PSP_CarriageListByProgramReport_GET] 'NewsCast', 'Yes', '1900', '1', '1871', '1', '2012', 'Excel', '|AM|, |FM|', 'Yes', null, null, 'Washington', null
			SELECT Distinct
				Station,
				StateAbbreviation as [St],
				City,
				Frequency as Freq,
				MemberStatusName as [NPR Membership],
				MetroMarketRank as [Metro Rank],
				DMAMarketRank as [DMA Rank],
				DaysOfWeek,
				--StartTime as Start,
				--CONVERT(varchar(15),CAST(StartTime AS TIME),100) as Start,
				LTRIM(RIGHT('0'+CONVERT(VARCHAR(20), StartTime, 100), 7)) as Start,
				--EndTime as [End],
				--CONVERT(varchar(15),CAST(EndTime AS TIME),100) as [End],
				case when endtime = '23:59:59'
					Then '12:00AM'
					Else LTRIM(RIGHT('0'+CONVERT(VARCHAR(20), EndTime, 100), 7)) 
				End as [End]
				--ScheduleProgramId, 
				--ScheduleId,
				--ProgramId,
				--ProgramName AS [Program Name]
				--CarriageTypeId,
				--StationId,
				--[Month],
				--[Year]
				--QuarterHours,
				--DaysOfWeek,
				--SundayInd,
				--MondayInd,
				--TuesdayInd,
				--WednesdayInd,
				--ThursdayInd,
				--FridayInd,
				--SaturdayInd,
				--MemberStatusId,
				--MemberStatusName			
			 FROM @Temp
			 ORDER BY
			 2,3,1,10
				--[State],
				--City,
				--Station

		--return program name
		
				SELECT TOP 1 ProgramName FROM [dbo].[Program] WHERE ProgramId=@ProgramID

				select count(distinct station) from @Temp --group by station				
		END

END





--select * from program where programname like 'npr newscast%'
GO


