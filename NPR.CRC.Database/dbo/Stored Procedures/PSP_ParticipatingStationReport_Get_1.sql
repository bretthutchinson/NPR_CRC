CREATE PROCEDURE [dbo].[PSP_ParticipatingStationReport_Get]
(
	@CurrentSeason VARCHAR(50),
	@CurrentYear varchar(4),
	@PastSeason VARCHAR(50),
	@PastYear varchar(4),
	@Band VARCHAR(200),
	@Format varchar(10)
)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON
    DECLARE @CSeasonMons varchar(10),
				 @PSeasonMons varchar(10)

	SELECT @CSeasonMons = CASE @CurrentSeason	WHEN 'Winter' THEN '1,2,3' WHEN 'Spring' THEN '4,5,6' WHEN 'Summer' THEN '7,8,9' WHEN 'Fall' THEN '10,11,12' END
		
	SELECT @PSeasonMons = CASE @PastSeason	WHEN 'Winter' THEN '1,2,3' WHEN 'Spring' THEN '4,5,6' WHEN 'Summer' THEN '7,8,9' WHEN 'Fall' THEN '10,11,12'END

    Create table #CurrentStations (StationID int, Year int, Month int)
    Create table #PastStations (StationID int, Year int, Month int)
    Create table #AllStations (StationID int, Year int, Month int, NewStation Char(1))

    DECLARE @DCSql NVARCHAR(MAX) = 'SELECT distinct StationID, Year, Month  FROM [dbo].[Schedule]
     where status=''Accepted''
	  and Month in ( ' +  @CSeasonMons  + ') and year in ( ' + @currentYear + ' )'
	
	insert into #CurrentStations EXEC dbo.sp_executesql @DCSql 

	DECLARE @DPSql NVARCHAR(MAX) = 'SELECT distinct StationID, Year, Month  FROM [dbo].[Schedule]
     where status=''Accepted''
	  and Month in ( ' +  @PSeasonMons  + ') and year in ( ' + @PastYear + ' )'
	
	insert into #PastStations EXEC dbo.sp_executesql @DPSql 


	 insert into #AllStations select  Stationid,Year,Month, 'Y' from #CurrentStations where StationID not in (select StationID from #PastStations)
	 insert into #AllStations select  Stationid,Year,Month,'N' from #PastStations where StationID in (select StationID from #CurrentStations)



	Declare @DFinalSQL NVARCHAR(MAX)
	
	if @Format = 'PDF'
	begin
		Set @DFinalSQL ='Select Distinct t.CallLetters + ''-'' + b.bandname as Station,
		st.Abbreviation as State, t.City as City, t.Frequency as Freq, m. memberstatusName as Membership, t.MetroMarketRank as Metro,
		t.DMAMarketRank as DMA,  s.NewStation as ''' + 'New Station ' + @CurrentSeason + ' ' + @CurrentYear + '''
		,''' +   @CurrentSeason + ' ' + @CurrentYear + ''' as SurveyH, s.NewStation SurveyC
		 from #AllStations s inner join Station t on s.StationID = t.StationId 
		 Left  outer join state st on st.stateid=t.stateid
		 inner join MemberStatus m on m.MemberStatusID=t.memberstatusid
		 inner join band b on b.bandid=t.bandid
		 and b.bandname in (' + REPLACE(@Band, '|', '''') + ')'
	end
	else
	begin
	    Set @DFinalSQL ='Select Distinct t.CallLetters + ''-'' + b.bandname as Station,
		st.Abbreviation as State, t.City as City, t.Frequency as Freq, m. memberstatusName as Membership, t.MetroMarketRank as Metro,
		t.DMAMarketRank as DMA,  s.NewStation as ''' + 'New Station ' + @CurrentSeason + ' ' + @CurrentYear + '''
		from #AllStations s inner join Station t on s.StationID = t.StationId 
		 Left  outer join state st on st.stateid=t.stateid
		 inner join MemberStatus m on m.MemberStatusID=t.memberstatusid
		 inner join band b on b.bandid=t.bandid
		 and b.bandname in (' + REPLACE(@Band, '|', '''') + ')'
	end
	EXEC dbo.sp_executesql @DFinalSQL

	Drop table #CurrentStations
    Drop table #PastStations
    Drop table #AllStations 

END