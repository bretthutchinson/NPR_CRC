CREATE PROCEDURE [dbo].[PSP_FormatCalculationReport_Get] 

(

@StartTime VARCHAR(20),
@EndTime VARCHAR(20),
@SundayInd VARCHAR(1),
@MondayInd VARCHAR(1),
@TuesdayInd VARCHAR(1),
@WednesdayInd VARCHAR(1),
@ThursdayInd VARCHAR(1),
@FridayInd VARCHAR(1),
@SaturdayInd VARCHAR(1),
@Month BIGINT,
@Year BIGINT,
@RepeaterStatusId BIGINT,
@MemberStatusId CHAR(1),
@StationId BIGINT,
@Band VARCHAR(200),
@DebugInd CHAR(1)

)
--select * from station where callletters = 'KUAC'
--[PSP_FormatCalculationReport_Get] '6:00 AM', '23:59:59', 'Y', 'Y', 'Y' ,'Y' ,'Y', 'Y', 'Y', 6, 2014, 1, 'Y', 22996, '|AM|,|FM|', 'N'


WITH EXECUTE AS OWNER

AS BEGIN

SET NOCOUNT ON



	DECLARE @DynSql NVARCHAR(MAX) = '



	DECLARE @rawData TABLE (

		TableId INT IDENTITY,

		ProgramName Varchar (100),

		Station VARCHAR(100),

		StateName VARCHAR(50),

		City VARCHAR(100),

		MemberStatusName VARCHAR(100),

		Metro INT,

		DMA INT,

		MajorFormatSum INT,

		MajorFormatCode VARCHAR(10),
		 nx int
	)



	DECLARE @TotalQuarterHours NUMERIC(18, 2);



	SET @TotalQuarterHours = 0.0;



	INSERT INTO @rawData (ProgramName, Station, StateName, City, MemberStatusName, Metro, DMA, MajorFormatSum, MajorFormatCode, nx)

	SELECT

		p.ProgramName,

		st.CallLetters + ''-'' + b.BandName AS Station, 

		s.abbreviation, 

		st.city, 

		ms.MemberStatusName, 

		st.MetroMarketRank AS Metro,

		st.DMAMarketRank AS DMA,

		(

			CASE WHEN ''' + @SundayInd + ''' = ''Y'' AND sp.SundayInd = ''Y'' THEN

				SUM((DATEDIFF(MINUTE, 

											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''

													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime

													ELSE sp.StartTime

											END,

											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime

													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''

													ELSE sp.EndTime

											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000''  THEN 1 ELSE 0 END) 

			ELSE 0 END

			+ 

			CASE WHEN ''' + @MondayInd + ''' = ''Y'' AND sp.MondayInd = ''Y'' THEN

				SUM((DATEDIFF(MINUTE, 

											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''

													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime

													ELSE sp.StartTime

											END,

											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime

													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''

													ELSE sp.EndTime

											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000''  THEN 1 ELSE 0 END) 

			ELSE 0 END	

			+ 

			CASE WHEN ''' + @TuesdayInd + ''' = ''Y'' AND sp.TuesdayInd = ''Y'' THEN

				SUM((DATEDIFF(MINUTE, 

											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''

													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime

													ELSE sp.StartTime

											END,

											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime

													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''

													ELSE sp.EndTime

											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000''  THEN 1 ELSE 0 END) 

			ELSE 0 END	

			+ 

			CASE WHEN ''' + @WednesdayInd + ''' = ''Y'' AND sp.WednesdayInd = ''Y'' THEN

				SUM((DATEDIFF(MINUTE, 

											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''

													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime

													ELSE sp.StartTime

											END,

											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime

													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''

													ELSE sp.EndTime

											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000''  THEN 1 ELSE 0 END) 

			ELSE 0 END	

			+ 

			CASE WHEN ''' + @ThursdayInd + ''' = ''Y'' AND sp.ThursdayInd = ''Y'' THEN

				SUM((DATEDIFF(MINUTE, 

											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''

													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime

													ELSE sp.StartTime

											END,

											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime

													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''

													ELSE sp.EndTime

											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000''  THEN 1 ELSE 0 END) 

			ELSE 0 END	

			+ 

			CASE WHEN ''' + @FridayInd + ''' = ''Y'' AND sp.FridayInd = ''Y'' THEN

				SUM((DATEDIFF(MINUTE, 

											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''

													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime

													ELSE sp.StartTime

											END,

											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime

													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''

													ELSE sp.EndTime

											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000''  THEN 1 ELSE 0 END) 

			ELSE 0 END	

			+ 

			CASE WHEN ''' + @SaturdayInd + ''' = ''Y'' AND sp.SaturdayInd = ''Y'' THEN

				SUM((DATEDIFF(MINUTE, 

											CASE WHEN sp.StartTime < ''' + @StartTime + ''' THEN ''' + @StartTime + '''

													WHEN sp.StartTime > ''' + @StartTime + ''' THEN sp.StartTime

													ELSE sp.StartTime

											END,

											CASE WHEN sp.EndTime < ''' + @EndTime + ''' THEN sp.EndTime

													WHEN sp.EndTime > ''' + @EndTime + ''' THEN ''' + @EndTime + '''

													ELSE sp.EndTime

											END)/15) + CASE WHEN sp.EndTime = ''23:59:59.0000000''  THEN 1 ELSE 0 END) 

			ELSE 0 END

		) As MajorFormatSum,

		mf.MajorFormatCode,

		Case when p.programname in (''Morning Edition'', ''All Things Considered'')
			Then 1
			Else 0
		End 

	FROM 

		dbo.Schedule as sc INNER JOIN 

		dbo.Station st ON st.StationId = sc.StationId INNER JOIN 

		(

			SELECT * FROM ScheduleProgram sp1 WHERE ScheduleProgramId IN 

			(

				SELECT 

					ScheduleProgramId 

				FROM 

					ScheduleProgram sp2

				WHERE 

					((StartTime <= ''' + @StartTime + ''' AND EndTime > ''' + @StartTime + ''') OR (StartTime < ''' + @EndTime + ''' AND EndTime >= ''' + @EndTime + ''') OR (StartTime >= ''' + @StartTime + ''' AND EndTime <= ''' + @EndTime + '''))

				AND sp2.ScheduleId = sp1.ScheduleId

			)

		) sp ON sc.ScheduleId = sp.ScheduleId INNER JOIN 

		dbo.RepeaterStatus rs ON st.RepeaterStatusId = rs.RepeaterStatusId INNER JOIN

		dbo.Program p ON p.ProgramId = sp.ProgramId INNER JOIN 

		dbo.ProgramFormatType pft ON pft.ProgramFormatTypeId = p.ProgramFormatTypeId INNER JOIN 

		dbo.MajorFormat mf ON mf.MajorFormatId = pft.MajorFormatId INNER JOIN 

		dbo.[State] s ON s.StateId = st.StateId INNER JOIN 

		dbo.Band b ON b.bandid = st.BandId INNER JOIN 

		dbo.MemberStatus ms ON ms.MemberStatusId = st.MemberStatusId

	WHERE 

		sc.[Month] = ' + CONVERT(VARCHAR(max), @Month) + ' AND sc.[Year] = ' + CONVERT(VARCHAR(max), @Year) + '

		AND mf.MajorFormatCode <> ''OFF''

		AND b.BandName IN (' + REPLACE(@Band, '|', '''') + ')'
		+ 'AND sc.AcceptedDate is not null'

		+' And st.disableddate is  null'

		--select * from station where disableddate is not null

	IF @StationId IS NOT NULL

		SET @DynSql = @DynSql + ' AND st.stationId = ' + CONVERT(VARCHAR(max), @StationId)



	IF @RepeaterStatusId = 1

		SET @DynSql = @DynSql + ' AND rs.RepeaterStatusName IN (''Flagship'', ''Non-100% (Partial)'')'



	IF @RepeaterStatusId = 2

		SET @DynSql = @DynSql + ' AND rs.RepeaterStatusName = ''100% Repeater'''



	IF @MemberStatusId = 'Y'

		SET @DynSql = @DynSql + ' AND ms.NPRMembershipInd = ''Y'''



	IF @MemberStatusId = 'N'

		SET @DynSql = @DynSql + ' AND ms.NPRMembershipInd = ''N'''



--AND

--(st.RepeaterStatusId = ISNULL(@RepeaterStatusId OR @RepeaterStatusId=0)  

--AND

--(ms.NPRMembershipInd = @NPRMembershipInd OR @NPRMembershipInd='')

--AND

 --(sc.Status=''Accepted'')
	declare @DynSql2 nvarchar(max)
	SET @DynSql2 =  '

	 GROUP BY 

		st.CallLetters, 

		b.BandName,

		s.abbreviation, 

		st.City, 

		mf.MajorFormatCode, 

		ms.MemberStatusName , 

		st.MetroMarketRank, 

		st.DMAMarketRank,

		sp.SundayInd,

		sp.MondayInd,

		sp.TuesdayInd,

		sp.WednesdayInd,

		sp.ThursdayInd,

		sp.FridayInd,

		sp.SaturdayInd,

		p.ProgramName

	--select * from @rawData

	--SELECT @TotalQuarterHours = SUM(MajorFormatSum) FROM @rawData;



	--SELECT @TotalQuarterHours;



	DECLARE @TempResult TABLE(Total float, Station VARCHAR(100))

	DECLARE @TempResult1 TABLE(Total float, Station VARCHAR(100), MajorFormatCode VARCHAR(10), nx int)

	

	INSERT INTO @TempResult 

	Select sum(majorformatsum) as Total, Station from @rawData group by Station

	

	INSERT INTO @TempResult1

	Select sum(majorformatsum) as Total,Station,MajorFormatCode, sum(nx) FROM @rawData group by Station,MajorFormatCode order by Station

	

	DECLARE @TempResult2 TABLE(Station VARCHAR(100),StateName VARCHAR(50),City VARCHAR(100),MemberStatusName VARCHAR(100),Metro INT, DMA INT, CLS DECIMAL(8,1) , ECL DECIMAL(8,1),ENT DECIMAL(8,1),

								FLK DECIMAL(8,1),JZZ DECIMAL(8,1),NWS DECIMAL(8,1),POP DECIMAL(8,1),TRG DECIMAL(8,1),WLD DECIMAL(8,1), nx int)

	

	INSERT INTO @TempResult2

	SELECT 

		Station, StateName, City, MemberStatusName As ''Member Status'', Metro, DMA, 

		(CASE WHEN MajorFormatCode = ''CLS'' THEN ((SELECT Total FROM @TempResult1 WHERE Station = r.Station and MajorFormatCode = r.MajorFormatCode)*100/(SELECT Total FROM @TempResult WHERE Station = r.Station) ) END)  As ''CLS'',

		(CASE WHEN MajorFormatCode = ''ECL'' THEN ((SELECT Total FROM @TempResult1 WHERE Station = r.Station and MajorFormatCode = r.MajorFormatCode)*100 /(SELECT Total FROM @TempResult WHERE Station = r.Station) ) END)  As ''ECL'',

		(CASE WHEN MajorFormatCode = ''ENT'' THEN ((SELECT Total FROM @TempResult1 WHERE Station = r.Station and MajorFormatCode = r.MajorFormatCode)*100 /(SELECT Total FROM @TempResult WHERE Station = r.Station)) END)  As ''ENT'',

		(CASE WHEN MajorFormatCode = ''FLK'' THEN ((SELECT Total FROM @TempResult1 WHERE Station = r.Station and MajorFormatCode = r.MajorFormatCode)*100 /(SELECT Total FROM @TempResult WHERE Station = r.Station)) END)  As ''FLK'',

		(CASE WHEN MajorFormatCode = ''JZZ'' THEN ((SELECT Total FROM @TempResult1 WHERE Station = r.Station and MajorFormatCode = r.MajorFormatCode)*100 /(SELECT Total FROM @TempResult WHERE Station = r.Station)) END)  As ''JZZ'',

		(CASE WHEN MajorFormatCode = ''NWS'' THEN ((SELECT Total FROM @TempResult1 WHERE Station = r.Station and MajorFormatCode = r.MajorFormatCode)*100 /(SELECT Total FROM @TempResult WHERE Station = r.Station)) END)  As ''NWS'',

		(CASE WHEN MajorFormatCode = ''POP'' THEN ((SELECT Total FROM @TempResult1 WHERE Station = r.Station and MajorFormatCode = r.MajorFormatCode)*100 /(SELECT Total FROM @TempResult WHERE Station = r.Station)) END)  As ''POP'',

		(CASE WHEN MajorFormatCode = ''TRG'' THEN ((SELECT Total FROM @TempResult1 WHERE Station = r.Station and MajorFormatCode = r.MajorFormatCode)*100 /(SELECT Total FROM @TempResult WHERE Station = r.Station)) END)  As ''TRG'',

		(CASE WHEN MajorFormatCode = ''WLD'' THEN ((SELECT Total FROM @TempResult1 WHERE Station = r.Station and MajorFormatCode = r.MajorFormatCode)*100 /(SELECT Total FROM @TempResult WHERE Station = r.Station)) END)  As ''WLD'',
		
		(SELECT sum(nx) FROM @TempResult1 WHERE Station = r.Station) 


	FROM

		@rawData r

	GROUP BY

		Station, StateName, City, MemberStatusName, Metro, DMA, MajorFormatCode

	ORDER BY 

		Station, StateName, City



	SELECT 
	Station, 
	StateName as ST, 
	City, 
	MemberStatusName As ''Member Status'', 
	Metro, 
	DMA, 
	CLS = Case when  SUM(CLS) > 0 then SUM(CLS) Else null end,
	ECL = Case when  SUM(ECL) > 0 then SUM(ECL) Else null end,
	ENT = Case when  SUM(ENT) > 0 then SUM(ENT) Else null end,
	FLK = Case when  SUM(FLK) > 0 then SUM(FLK) Else null end,
	JZZ = Case when  SUM(JZZ) > 0 then SUM(JZZ) Else null end,
	NWS = Case when  SUM(NWS) > 0 then SUM(NWS) Else null end,
	POP = Case when  SUM(POP) > 0 then SUM(POP) Else null end,
	TRG = Case when  SUM(TRG) > 0 then SUM(TRG) Else null end,
	WLD = Case when  SUM(WLD) > 0 then SUM(WLD) Else null end,
	--SUM(CLS) AS CLS, 
	--SUM(ECL) AS ECL, 
	--SUM(ENT) AS ENT, 
	--SUM(FLK) AS FLK,
	--SUM(JZZ) AS JZZ,
	--SUM(NWS) AS NWS,
	--SUM(POP) AS POP,
	--SUM(TRG) AS TRG, 
	--SUM(WLD) AS WLD,
	cast(sum(nx) as decimal) as Total,
	''------------------------------------------------------------------------------'' as ExtendedFormat

	FROM @TempResult2

	GROUP BY

	Station, StateName, City, MemberStatusName, Metro, DMA

	ORDER BY 

	 StateName, City, Station

	--select * from @rawData

	--SELECT 

	--	Station, StateName, City, MemberStatusName As ''Member Status'', Metro, DMA, MajorFormatCode,

	--	SUM(CASE WHEN MajorFormatCode = ''CLS'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''CLS'',

	--	SUM(CASE WHEN MajorFormatCode = ''ECL'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''ECL'',

	--	SUM(CASE WHEN MajorFormatCode = ''ENT'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''ENT'',

	--	SUM(CASE WHEN MajorFormatCode = ''FLK'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''FLK'',

	--	SUM(CASE WHEN MajorFormatCode = ''JZZ'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''JZZ'',

	--	SUM(CASE WHEN MajorFormatCode = ''NWS'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''NWS'',

	--	SUM(CASE WHEN MajorFormatCode = ''POP'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''POP'',

	--	SUM(CASE WHEN MajorFormatCode = ''TRG'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''TRG'',

	--	SUM(CASE WHEN MajorFormatCode = ''WLD'' THEN CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) ELSE NULL END) As ''WLD''

	--FROM

	--	@rawData

	--GROUP BY

	--	Station, StateName, City, MemberStatusName, Metro, DMA, MajorFormatCode

	--ORDER BY 

	--	Station, StateName, City



	--SELECT *,  CAST(MajorFormatSum/@TotalQuarterHours * 100 As Numeric(10, 2)) As FormatPtgCalc

	--FROM @rawData

	--ORDER BY Abbreviation, City '


	declare @DynSql3 nvarchar(max)
	set @DynSql3 = @DynSql + @DynSql2
	IF @DebugInd = 'Y'

		PRINT cast(@DynSql3 as NTEXT)

	ELSE

		EXEC dbo.sp_executesql @DynSql3 

--[PSP_FormatCalculationReport_Get] '00:00:00.0000000', '23:59:59.0000000', 'Y', 'Y', 'Y' ,'Y' ,'Y', 'Y', 'Y', 1, 2014, 2, 'Y', 35198, '|AM|,|FM|', 'N'
--All Stations -- [PSP_FormatCalculationReport_Get] '00:00:00.0000000', '23:59:59.0000000', 'Y', 'Y', 'Y' ,'Y' ,'Y', 'Y', 'Y', 1, 2014, 2, 'Y', null, '|AM|,|FM|', 'N'
--[PSP_FormatCalculationReport_Get] '1:00 PM', '2:00 PM', 'Y', 'Y', 'Y' ,'Y' ,'Y', 'Y', 'Y', 1, 2014, 1, 'Y', null, '|AM|,|FM|', 'N'
--select * from station where callletters = 'KANH'

END