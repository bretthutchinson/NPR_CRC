CREATE PROCEDURE [dbo].[Test_Station]
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
@Monthh BIGINT,
@Yearr BIGINT,
@RepeaterStatusId BIGINT,
@NPRMemberShipInd varchar(1),
@StationId BIGINT
)
AS BEGIN
SET NOCOUNT ON
	SELECT
		st.CallLetters + '-' + b.BandName AS Station, 
		s.Abbreviation, 
		st.city, 
		ms.MemberStatusName, 
		st.MetroMarketRank AS Metro,
		st.DMAMarketRank AS DMA,
		SUM(DATEDIFF(MINUTE, sp.StartTime, sp.EndTime)/15) AS Summation, 
		mf.MajorFormatCode 
  
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
					((StartTime <= @StartTime AND EndTime >= @StartTime ) OR (StartTime < @EndTime AND EndTime >= @EndTime) OR (StartTime >= @StartTime AND EndTime <= @EndTime))
			)
		) sp ON sp.ScheduleId = sc.ScheduleId INNER JOIN 
		dbo.Program p ON p.ProgramId = sp.ProgramId INNER JOIN 
		dbo.ProgramFormatType pft ON pft.ProgramFormatTypeId = p.ProgramFormatTypeId INNER JOIN 
		dbo.MajorFormat mf ON mf.MajorFormatId = pft.MajorFormatId INNER JOIN 
		dbo.[State] s ON s.StateId = st.StateId INNER JOIN 
		dbo.Band b ON b.bandid = st.BandId INNER JOIN 
		dbo.MemberStatus ms ON ms.MemberStatusId = st.MemberStatusId
	WHERE
		sc.Status='Accepted'
		 AND
		(st.stationId = @StationId OR @StationId=0)
AND
st.RepeaterStatusId = @RepeaterStatusId OR @RepeaterStatusId=0
AND
(ms.NPRMembershipInd = @NPRMembershipInd OR @NPRMembershipInd='')
AND
 (sc.Status='Accepted')

	 GROUP BY 
		st.CallLetters, 
		b.BandName,
		s.Abbreviation, 
		st.City, 
		mf.MajorFormatCode, 
		ms.MemberStatusName , 
		st.MetroMarketRank, 
		st.DMAMarketRank

	ORDER BY s.Abbreviation, st.City
END