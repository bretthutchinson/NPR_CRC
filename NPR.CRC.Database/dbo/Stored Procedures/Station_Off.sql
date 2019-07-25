CREATE PROCEDURE [dbo].[Station_Off]
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
		s.Abbreviation , st.city , ms.MemberStatusName , st.MetroMarketRank AS Metro , st.DMAMarketRank AS DMA
  	,SUM(DATEDIFF(MINUTE, sp.StartTime, sp.EndTime)/15) AS OffAirProgram 
	
		FROM dbo.Schedule as sc
		INNER JOIN Station as st ON st.StationId = sc.StationId
		INNER JOIN ScheduleProgram as sp ON sp.ScheduleId = sc.ScheduleId
		INNER JOIN Program as p ON p.ProgramId = sp.ProgramId
		INNER JOIN ProgramFormatType as pft ON pft.ProgramFormatTypeId = p.ProgramFormatTypeId
		INNER JOIN MajorFormat as mf ON mf.MajorFormatId = pft.MajorFormatId
		INNER JOIN State as s ON s.StateId = st.StateId
		INNER JOIN Band as b ON b.bandid = st.BandId
		INNER JOIN MemberStatus ms ON ms.MemberStatusId = st.MemberStatusId
		
WHERE

(sp.SundayInd=@SundayInd OR @SundayInd='') AND (sp.MondayInd=@MondayInd OR @MondayInd='') AND (sp.TuesdayInd=@TuesdayInd OR @TuesdayInd='') AND (sp.WednesdayInd=@WednesdayInd OR @WednesdayInd='') AND (sp.ThursdayInd=@ThursdayInd OR @ThursdayInd='') AND (sp.FridayInd=@FridayInd OR @FridayInd='') AND (sp.SaturdayInd=@SaturdayInd OR
 @SaturdayInd='') 
AND
(sp.StartTime>=@StartTime OR @StartTime='') AND (sp.EndTime<=@EndTime OR @EndTime='') 
AND
(sc.Month=@Monthh OR @Monthh='') 
AND
(sc.Year=@Yearr OR @Yearr='')
AND
(st.RepeaterStatusId = @RepeaterStatusId OR @RepeaterStatusId='')  
AND
(ms.NPRMembershipInd = @NPRMembershipInd OR @NPRMembershipInd='')
AND
(st.StationId = @StationId OR @StationId ='')
AND
(sc.Status='Accepted') AND p.ProgramName like '%Off Air%' OR p.ProgramName like '%Off-Air%'
 
GROUP BY st.CallLetters, b.BandName,
s.Abbreviation, st.City, ms.MemberStatusName , 
st.MetroMarketRank , st.DMAMarketRank
ORDER BY s.Abbreviation, st.City
END