CREATE PROCEDURE [dbo].[PSP_AddDropProgramReport_Get]
(
	@StationType VARCHAR(200),
	@StationStatus varchar(10),
	@RepeaterStatus varchar(200),
	@Program varchar(10), 
	@CurrentSeason VARCHAR(50),
	@CurrentYear varchar(4),
	@PastSeason VARCHAR(50),
	@PastYear varchar(4),
	@Format varchar(10)
)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @CSeasonMons varchar(10), @PSeasonMons varchar(10), @Substr varchar(200)

	SELECT @CSeasonMons = CASE @CurrentSeason	WHEN 'Winter' THEN '1,2,3' WHEN 'Spring' THEN '4,5,6' WHEN 'Summer' THEN '7,8,9' WHEN 'Fall' THEN '10,11,12' END
	SELECT @PSeasonMons = CASE @PastSeason	WHEN 'Winter' THEN '1,2,3' WHEN 'Spring' THEN '4,5,6' WHEN 'Summer' THEN '7,8,9' WHEN 'Fall' THEN '10,11,12'END
	Select @Substr = case @StationStatus when 'Enabled' then ' and st.DisabledDate is null' when 'Disabled' then ' and st.DisabledDate is not null' when 'Both' then ' ' end
	Select @substr = @substr +  case  @repeaterStatus when 'All' then ' ' else ' and rs.RepeaterStatusName in ( ' + replace(@RepeaterStatus,'|','''') + ')'  end

	Create table #CurrentProgramStations (StationId int, ProgramID int)
    Create table #PastProgramstations (StationId int, ProgramID int)
    Create table #AllProgramStations (StationId int, ProgramID int, AddDrop varchar(5))

    DECLARE @DCSql NVARCHAR(MAX) = 'SELECT distinct s.stationid, p.ProgramId  FROM [Schedule] s 
	  inner join ScheduleProgram p on s.scheduleid=p.scheduleid
	  inner join Program pg on pg.programid=p.programid
	  inner join station st on st.stationid=s.stationid
	  inner join band b on b.bandid=st.bandid
	  inner join repeaterstatus rs on rs.RepeaterStatusID = st.RepeaterStatusID
      where status=''Accepted''
	  and Month in ( ' +  @CSeasonMons  + ') and year in ( ' + @currentYear + ' )
	  and p.programid =' + @Program + '
	  --and rs.RepeaterStatusName in ( ' + replace(@RepeaterStatus,'|','''') + ')
	  and b.bandname in (' + replace(@StationType,'|','''') + ') ' + @substr

	--print @DCSql

	insert into #CurrentProgramStations EXEC dbo.sp_executesql @DCSql 

	DECLARE @DPSql NVARCHAR(MAX) = 'SELECT distinct s.stationid, p.ProgramId  FROM [Schedule] s 
	  inner join ScheduleProgram p on s.scheduleid=p.scheduleid
	  inner join Program pg on pg.programid=p.programid
	  inner join station st on st.stationid=s.stationid
	  inner join band b on b.bandid=st.bandid
	  inner join repeaterstatus rs on rs.RepeaterStatusID = st.RepeaterStatusID
      where status=''Accepted''
	  and Month in ( ' +  @PSeasonMons  + ') and year in ( ' + @pastYear + ' )
	  and p.programid =' + @Program + '
	  --and rs.RepeaterStatusName in ( ' + replace(@RepeaterStatus,'|','''') + ')
	  and b.bandname in (' + replace(@StationType,'|','''') + ') ' + @substr

	--print @DPSql

	insert into #PastProgramStations EXEC dbo.sp_executesql @DPSql
	 
	 insert into #AllProgramStations select stationid,Programid, 'Drop' from #CurrentProgramStations where stationid not in (select stationid from #PastProgramstations)
	 insert into #AllProgramStations select  stationid,Programid,'Add' from #PastProgramstations where stationid not in (select stationid from #CurrentProgramStations)


	 Declare @DFinalSQL NVARCHAR(MAX) 
	 
	 if @Format = 'PDF'
	 begin
	 Set @DFinalSQL = 'Select p.ProgramName, s.CallLetters + ''-'' + b.BandName Station, st.StateName, s.City, s.Frequency, m.MemberStatusName, s.MetroMarketRank, s.DMAMarketRank, a.AddDrop   as ' + '''Add/Drop ' +  @PastSeason + ' ' + @PastYear + '''
	 ,' + '''Add/Drop ' +  @PastSeason + ' ' + @PastYear + ''' as SurveyH, a.AddDrop SurveyC
	    from #AllProgramStations a 
	 inner join station s on s.stationid=a.stationid
	 inner join program p on p.programid=a.programid
	 inner join band b on b.bandid = s.BandId 
	 left outer join state st on st.StateId = s.StateId 
	 inner join MemberStatus m on m.MemberStatusId = s.MemberStatusId  '

	end
	else
	begin
	 Set @DFinalSQL = 'Select p.ProgramName, s.CallLetters + ''-'' + b.BandName Station, st.StateName, s.City, s.Frequency, m.MemberStatusName, s.MetroMarketRank, s.DMAMarketRank, a.AddDrop   as ' + '''Add/Drop ' +  @PastSeason + ' ' + @PastYear + '''
	    from #AllProgramStations a 
	 inner join station s on s.stationid=a.stationid
	 inner join program p on p.programid=a.programid
	 inner join band b on b.bandid = s.BandId 
	 left outer join state st on st.StateId = s.StateId 
	 inner join MemberStatus m on m.MemberStatusId = s.MemberStatusId  '
	end

	--Print @DfinalSql
	EXEC dbo.sp_executesql @DFinalSQL

	
	Drop table #CurrentProgramStations 
    Drop table #PastProgramstations
    Drop table #AllProgramStations 

END

GO


