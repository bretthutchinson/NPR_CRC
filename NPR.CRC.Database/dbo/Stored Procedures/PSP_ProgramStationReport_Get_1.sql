CREATE PROCEDURE [dbo].[PSP_ProgramStationReport_Get]
(
	@CurrentSeason VARCHAR(50),
	@CurrentYear varchar(4),
	@PastSeason VARCHAR(50),
	@PastYear varchar(4),
	@Band varchar(250),
	@Format varchar(10)
)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON
    DECLARE @CSeasonMons varchar(10),
				 @PSeasonMons varchar(10)

	SELECT @CSeasonMons = CASE @CurrentSeason	WHEN 'Winter' THEN '1,2,3' WHEN 'Spring' THEN '4,5,6' WHEN 'Summer' THEN '7,8,9' WHEN 'Fall' THEN '10,11,12' END
		
	SELECT @PSeasonMons = CASE @PastSeason	WHEN 'Winter' THEN '1,2,3' WHEN 'Spring' THEN '4,5,6' WHEN 'Summer' THEN '7,8,9' WHEN 'Fall' THEN '10,11,12'END

    Create table #CurrentPrograms (ProgramID int, Year int, Month int)
    Create table #PastPrograms (ProgramID int, Year int, Month int)
    Create table #AllPrograms (ProgramID int, Year int, Month int, NewProgram Char(1))

    DECLARE @DCSql NVARCHAR(MAX) = 'SELECT distinct ProgramId, Year, Month  FROM [dbo].[Schedule] s 
	inner join ScheduleProgram p on s.scheduleid=p.scheduleid
	inner join Station st on st.stationid=s.stationid
	inner join band b on st.bandid = b.bandid
     where status=''Accepted''
	 and b.bandname in (' + REPLACE(@Band, '|', '''') + ') 
	 and Month in ( ' +  @CSeasonMons  + ') and year in ( ' + @currentYear + ' )'
	
	insert into #CurrentPrograms EXEC dbo.sp_executesql @DCSql 

	DECLARE @DPSql NVARCHAR(MAX) = 'SELECT distinct ProgramId, Year, Month  FROM [dbo].[Schedule] s 
	inner join ScheduleProgram p on s.scheduleid=p.scheduleid
	inner join Station st on st.stationid=s.stationid
	inner join band b on st.bandid = b.bandid
     where status=''Accepted''
	 and b.bandname in (' + REPLACE(@Band, '|', '''') + ') 
	 and Month in ( ' +  @PSeasonMons  + ') and year in ( ' + @PastYear + ' )'
	
 	 insert into #PastPrograms EXEC dbo.sp_executesql @DPSql 

     insert into #AllPrograms select  Programid,Year,Month, 'Y' from #CurrentPrograms where ProgramID not in (select ProgramID from #PastPrograms)
	 insert into #AllPrograms select  Programid,Year,Month,'N' from #PastPrograms where ProgramID in (select ProgramID from #CurrentPrograms)

	
	Declare @DFinalSQL NVARCHAR(MAX) 
	
	if @Format = 'PDF'
	begin
		Set @DFinalSQL ='Select Distinct p.ProgramCode, p.ProgramName , s.ProgramSourcecode,  a.NewProgram as ''' + 'New Program ' + @CurrentSeason + ' ' + @CurrentYear + '''
			,''' +   @CurrentSeason + ' ' + @CurrentYear + ''' as SurveyH, a.NewProgram SurveyC
		 from #AllPrograms a inner join Program p on p.programid=a.programid inner join ProgramSource s on s.ProgramSourceId=p.ProgramSourceId '
	End
	else
	begin
		Set @DFinalSQL ='Select Distinct p.ProgramCode, p.ProgramName , s.ProgramSourcecode,  a.NewProgram as ''' + 'New Program ' + @CurrentSeason + ' ' + @CurrentYear + '''
					 from #AllPrograms a inner join Program p on p.programid=a.programid inner join ProgramSource s on s.ProgramSourceId=p.ProgramSourceId '
	End
	--Print @DfinalSql
	EXEC dbo.sp_executesql @DFinalSQL

	Drop table #CurrentPrograms
    Drop table #PastPrograms
    Drop table #AllPrograms

END