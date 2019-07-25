CREATE PROCEDURE [dbo].[PSP_GridDataReport_Get]
(
@BandSpan VARCHAR(200),
@DeletedInd CHAR(1),
@RepeaterStatus CHAR(1),
@RegularNewscastInd VARCHAR(25),
@Month BIGINT,
@Year BIGINT,
@DebugInd CHAR(1)
)

WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON

	DECLARE @RepeaterStatusName VARCHAR(100);

	SELECT  @RepeaterStatusName = 
		CASE @RepeaterStatus 
			WHEN 'F' THEN 'FlagShip'
			WHEN 'R' THEN '100% Repeater'
			WHEN 'N' THEN 'Non-100% (Partial) Repeater'
			WHEN 'A' THEN 'Flagship'', ''Non-100% (Partial) Repeater'', ''100% Repeater'
		END

	DECLARE @DynSql NVARCHAR(MAX) 
	
	IF @RegularNewscastInd = 'Regular'
	BEGIN
		SET @DynSql = '
		SELECT
			st.CallLetters + ''-'' + b.BandName As Station, ' +
			CONVERT(VARCHAR, @Year) 

			IF LEN(@Month) = 1
				SET @DynSql = @DynSql + '0' +
			
			CONVERT(VARCHAR, @Month) + ' As YearMonth,  
			pr.ProgramName, 
			pFT.ProgramFormatTypeCode,
			pS.ProgramSourceCode,
			CASE schP.SundayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.MondayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.TuesdayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.WednesdayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.ThursdayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.FridayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END +
			CASE schP.SaturdayInd WHEN ''Y'' THEN ''1'' ELSE ''0'' END As DaysInd,
			SUBSTRING(REPLACE(REPLACE(CONVERT(VARCHAR, schP.StartTime), '':'', ''''), ''.'', ''''), 0, 5) As StartTime,
			SUBSTRING(REPLACE(REPLACE(CONVERT(VARCHAR, CASE schP.EndTime WHEN ''23:59:59.0000000'' THEN ''00:00:00.0000000'' ELSE schP.EndTime END), '':'', ''''), ''.'', ''''), 0, 5) As EndTime,
			CONVERT(INT,
				CASE schP.SundayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END +
				CASE schP.MondayInd WHEN ''Y'' THEN  schP.QuarterHours ELSE 0 END +
				CASE schP.TuesdayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END +
				CASE schP.WednesdayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END +
				CASE schP.ThursdayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END +
				CASE schP.FridayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END +
				CASE schP.SaturdayInd WHEN ''Y'' THEN schP.QuarterHours ELSE 0 END) As ProgramQuarterHours,
TotalQHours
		FROM
			dbo.Schedule sch INNER JOIN
			dbo.ScheduleProgram schP ON sch.ScheduleId = schP.ScheduleId INNER JOIN
			dbo.Program pr ON schP.ProgramId = pr.ProgramId INNER JOIN
			dbo.ProgramFormatType pFT ON pr.ProgramFormatTypeId = pFT.ProgramFormatTypeId INNER JOIN
			dbo.ProgramSource pS ON pr.ProgramSourceId = pS.ProgramSourceId INNER JOIN
			dbo.Station st ON sch.StationId = st.StationId INNER JOIN
			dbo.Band b ON st.BandId = b.BandId INNER JOIN
			dbo.RepeaterStatus rS ON st.RepeaterStatusId = rS.RepeaterStatusId LEFT JOIN
			(
				SELECT 
					sch.StationId, 
					SUM(
						CASE WHEN SundayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END + 
						CASE WHEN MondayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END +
						CASE WHEN TuesdayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END +
						CASE WHEN WednesdayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END +
						CASE WHEN ThursdayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END +
						CASE WHEN FridayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END +
						CASE WHEN SaturdayInd = ''Y'' THEN schP.QuarterHours ELSE 0 END
						) As TotalQHours
				FROM
					dbo.Schedule sch INNER JOIN
					dbo.ScheduleProgram schP ON sch.ScheduleId = schP.ScheduleId
				WHERE
					sch.[Month] = ' + CONVERT(VARCHAR, @Month) + ' AND sch.[Year] = ' + CONVERT(VARCHAR, @Year) + '
				GROUP BY
					sch.StationId
			) As stQHours ON sch.StationId = stQHours.StationId
		WHERE
			--stQHours.TotalQHours = 672 AND
			b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ') AND
			sch.[Month] = ' + CONVERT(VARCHAR, @Month) + ' AND sch.[Year] = ' + CONVERT(VARCHAR, @Year) + ' AND
			rS.RepeaterStatusName IN (''' + @RepeaterStatusName + ''') '

		IF @DeletedInd = 'N'
			SET @DynSql = @DynSql + ' AND st.DisabledUserId IS NULL'
	
		IF @DeletedInd = 'Y'
			SET @DynSql = @DynSql + ' AND st.DisabledUserId IS NOT NULL'
	END

	IF @DebugInd = 'Y'
		PRINT CAST(@DynSql As NTEXT)
	ELSE
		EXEC dbo.sp_executesql @DynSql 

END