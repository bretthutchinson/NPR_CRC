CREATE PROCEDURE [dbo].[PSP_CarriageWorkBookFile_Get]
(
	@ProgramId BIGINT,
	@CarriageTypeId BIGINT,
	@MonthSpan VARCHAR(50),
	@Year INT,
	@BandSpan VARCHAR(200),
	@DeletedInd CHAR(1),
	@MemberStatusId BIGINT,
	@DebugInd CHAR(1)
)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	/** Creating the dynamic sql and executing VIA EXEC instead of dbo.sp_executesql because IN clause is being used for months and bands. **/
	/** No threat of sql injection because input is being strictly controlled via controller **/

	DECLARE @Month1 INT,
			@Month2 INT,
			@Month3 INT

	SELECT 
			@Month1 = 
			CASE @MonthSpan 
					WHEN '1, 2, 3' THEN 1
					WHEN '4, 5, 6' THEN 4
					WHEN '7, 8, 9' THEN 7
					WHEN '10, 11, 12' THEN 8
			END,
			@Month2 = 
			CASE @MonthSpan 
					WHEN '1, 2, 3' THEN 2
					WHEN '4, 5, 6' THEN 5
					WHEN '7, 8, 9' THEN 8
					WHEN '10, 11, 12' THEN 11 
			END,
			@Month3 = 
			CASE @MonthSpan 
					WHEN '1, 2, 3' THEN 3
					WHEN '4, 5, 6' THEN 6
					WHEN '7, 8, 9' THEN 9
					WHEN '10, 11, 12' THEN 12
			END

	DECLARE @Temp TABLE 
	(
		ScheduleProgramId BIGINT,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		ProgramName VARCHAR(200),
		ProgramCode VARCHAR(50),
		CarriageTypeId BIGINT,
		StationId BIGINT,
		Station VARCHAR(50),
		Frequency VARCHAR(50),
		City VARCHAR(100),
		StateAbbreviation VARCHAR(2),
		[Month] INT,
		[Year] INT,
		StartTime TIME,
		EndTime TIME,
		MetroMarketRank INT,
		DMAMarketRank INT,
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

	DECLARE @DynSql NVARCHAR(MAX) =
	'
	SELECT 
		sp.ScheduleProgramId, 
		sch.ScheduleId,
		p.ProgramId,
		p.ProgramName,
		p.ProgramCode,
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
		CASE WHEN SundayInd = ''Y'' THEN ''Sun '' ELSE '''' END +
		CASE WHEN MondayInd = ''Y'' THEN ''Mon '' ELSE '''' END +
		CASE WHEN TuesdayInd = ''Y'' THEN ''Tue '' ELSE '''' END +
		CASE WHEN WednesdayInd = ''Y'' THEN ''Wed '' ELSE '''' END +
		CASE WHEN ThursdayInd = ''Y'' THEN ''Thu '' ELSE '''' END +
		CASE WHEN FridayInd = ''Y'' THEN ''Fri '' ELSE '''' END +
		CASE WHEN SaturdayInd = ''Y'' THEN ''Sat '' ELSE '''' END		
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
	WHERE
		p.CarriageTypeId = ' + CONVERT(VARCHAR, @CarriageTypeId) + ' ' +
		'AND (sch.[Month] IN (' + @MonthSpan + ') AND sch.[Year] = ' + CONVERT(VARCHAR, @Year) + ') ' +
		'AND b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'

	IF @DeletedInd = 'N'
		SET @DynSql = @DynSql + ' AND sta.DisabledUserId IS NULL'
	
	IF @DeletedInd = 'Y'
		SET @DynSql = @DynSql + ' AND sta.DisabledUserId IS NOT NULL'

	IF @MemberStatusId IS NOT NULL
		SET @DynSql = @DynSql + ' AND ms.MemberStatusId = ' + CONVERT(VARCHAR, @MemberStatusId)

	SET @DynSql = @DynSql + ' ORDER BY sta.CallLetters + ''-'' + b.BandName '
	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		BEGIN
			INSERT INTO @Temp
			EXEC dbo.sp_executesql @DynSql 

			SELECT
				--ScheduleId,
				ProgramName as Program,
				--CarriageTypeId,
				--StationId,
				Station,
				
				max(StateAbbreviation) as St,
				max(City) as City,
				max(Frequency) as Freq,
				max(MemberStatusName) as [Member Status],
				--[Month],
				--[Year],

				max(MetroMarketRank) as Metro,
				max(DMAMarketRank) as DMA,
				--QuarterHours,
				DaysOfWeek as [Day(s)],
				--StartTime as Start,
				LTRIM(RIGHT('0'+CONVERT(VARCHAR(20), StartTime, 100), 7)) as Start,
				--EndTime as [End]
				LTRIM(RIGHT('0'+CONVERT(VARCHAR(20), EndTime, 100), 7)) as [End]
				--SundayInd,
				--MondayInd,
				--TuesdayInd,
				--WednesdayInd,
				--ThursdayInd,
				--FridayInd,
				--SaturdayInd,
				--MemberStatusId,
		
			 FROM 
				@Temp
			 WHERE
				ProgramId = @ProgramId
			 GROUP BY 
				ProgramName, Station, DaysOfWeek, StartTime, EndTime
			 ORDER BY
				ProgramName,
				Station
				--[Month],
				--[Year]
		END

END