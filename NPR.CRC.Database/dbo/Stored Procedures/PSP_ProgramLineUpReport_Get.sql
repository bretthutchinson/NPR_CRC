---select * from station where callletters like 'WUCX'
---select * from station where callletters like 'WUOT'
--select * from schedule where stationid = 23433 and year = 2014
--select * from scheduleprogram where scheduleid = 2385342 and programid = 1661
--select distinct(month) from schedule order by month
--[PSP_ProgramLineUpReport_Get] 1661, '4,5,6', 2014, '|AM|, |FM|', 'N', null, null
--select * from program where programname like '%now%'

CREATE PROCEDURE [dbo].[PSP_ProgramLineUpReport_Get]
(
	@ProgramId BIGINT,
	@MonthSpan VARCHAR(50),
	@Year INT,
	@BandSpan VARCHAR(200),
	@DeletedInd CHAR(1),
	@MemberStatusId BIGINT,
	@DebugInd CHAR(1)
)
--[PSP_ProgramLineUpReport_Get] 2277, '7, 8, 9', 2014, '|AM|,|FM|', 'N', null, null
WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON
	--Set @MonthSpan = 5


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

	DECLARE @MonthOne TABLE 
	(
		/*TableId INT IDENTITY,*/
		ScheduleProgramId BIGINT,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		ProgramName VARCHAR(100),
		StationId BIGINT,
		Station VARCHAR(50),
		[Month] INT,
		[Year] INT,
		StartTime TIME,
		EndTime TIME,
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

	DECLARE @MonthTwo TABLE 
	(
		/*TableId INT IDENTITY,*/
		ScheduleProgramId BIGINT,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		ProgramName VARCHAR(100),
		StationId BIGINT,
		Station VARCHAR(50),
		[Month] INT,
		[Year] INT,
		StartTime TIME,
		EndTime TIME,
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

	DECLARE @MonthThree TABLE 
	(
		/*TableId INT IDENTITY,*/
		ScheduleProgramId BIGINT,
		ScheduleId BIGINT,
		ProgramId BIGINT,
		ProgramName VARCHAR(100),
		StationId BIGINT,
		Station VARCHAR(50),
		[Month] INT,
		[Year] INT,
		StartTime TIME,
		EndTime TIME,
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
		sta.StationId,
		sta.CallLetters + ''-'' + b.BandName As Station,
		sch.[Month],
		sch.[Year],
		StartTime,
		EndTime,
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
		dbo.Band b ON sta.BandId = b.BandId INNER JOIN
		dbo.MemberStatus ms ON sta.MemberStatusId = ms.MemberStatusId
	WHERE
		p.ProgramId = ' + CONVERT(VARCHAR, @ProgramId) + ' ' +
		'AND (sch.[Month] IN (' + @MonthSpan + ') AND sch.[Year] = ' + CONVERT(VARCHAR, @Year) + ')' +
		'AND b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'
		+ 'AND sch.AcceptedDate is not null '
		--+'and (sta.callletters like ''wsu%'' or sta.callletters like ''wst%'')'
		--+'and (sta.callletters like ''KCHU%'' )'
		--+'and sta.stationid = 23632' 
--[PSP_ProgramLineUpReport_Get] 2277, '7, 8, 9', 2014, '|AM|, |FM|', 'N', null, null

	IF @DeletedInd = 'N'
		SET @DynSql = @DynSql + ' AND sta.DisabledUserId IS NULL'
	
	IF @DeletedInd = 'Y'
		SET @DynSql = @DynSql + ' AND sta.DisabledUserId IS NOT NULL'

	IF @MemberStatusId IS NOT NULL
		SET @DynSql = @DynSql + ' AND ms.MemberStatusId = ' + CONVERT(VARCHAR, @MemberStatusId)

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
	BEGIN
		--INSERT INTO @MonthOne
		--EXEC dbo.sp_executesql @DynSql 

		--Delete FROM @MonthOne WHERE Month <> @Month1;

		--INSERT INTO @MonthTwo
		--EXEC dbo.sp_executesql @DynSql 

		--Delete FROM @MonthTwo WHERE Month <> @Month2;

		INSERT INTO @MonthThree
		EXEC dbo.sp_executesql @DynSql 

		--Delete FROM @MonthThree WHERE Month <> @Month3
	END
	/** 33.3.1.4 **/
	SELECT
		Station, /*StartTime, EndTime,*/
		--CASE DaysOfWeek
		--	WHEN 'Sun Mon Tue Wed Thu Fri Sat ' THEN 'Sun - Sat'
		--	WHEN 'Mon Tue Wed Thu Fri ' THEN 'Mon - Fri'
		--	ELSE RTRIM(DaysOfWeek)
		--END + CONVERT(VARCHAR(15), StartTime, 100) + CONVERT(VARCHAR(15), EndTime, 100) As AirInfo
		 month,
		 RTRIM(DaysOfWeek) as Days,
		 CONVERT(VARCHAR(15), StartTime, 100) + 
		 case when endtime = '23:59:59'
					Then '12:00AM'
					Else LTRIM(RIGHT('0'+CONVERT(VARCHAR(20), EndTime, 100), 7)) 
				End 
		As AirInfo
	FROM 
		@MonthThree
	--[PSP_ProgramLineUpReport_Get] 2683, '1, 2, 3', 2014, '|AM|,|FM|', 'N', null, null
	--UNION
	--/** 33.3.1.5 **/
	--SELECT
	--	m1.Station, /*m1.StartTime, m1.EndTime, */
	--	--CASE m1.DaysOfWeek
	--	--	WHEN 'Sun Mon Tue Wed Thu Fri Sat ' THEN 'Sun - Sat'
	--	--	WHEN 'Mon Tue Wed Thu Fri ' THEN 'Mon - Fri'
	--	--	ELSE RTRIM(m1.DaysOfWeek)
	--	--END + CONVERT(VARCHAR(15), m1.StartTime, 100) + CONVERT(VARCHAR(15), m1.EndTime, 100) As AirInfo
	--	RTRIM(m1.DaysOfWeek) + CONVERT(VARCHAR(15), m1.StartTime, 100) + CONVERT(VARCHAR(15), m1.EndTime, 100) As AirInfo
	--FROM 
	--	@MonthOne m1,
	--	@MonthTwo m2
	--WHERE
	--	m1.StationId = m2.StationId AND
	--	m1.StartTime = m2.StartTime AND 
	--	m1.EndTime = m2.EndTime AND 
	--	m1.DaysOfWeek = m2.DaysOfWeek
	ORDER BY station, Days, airinfo, month
END
GO


