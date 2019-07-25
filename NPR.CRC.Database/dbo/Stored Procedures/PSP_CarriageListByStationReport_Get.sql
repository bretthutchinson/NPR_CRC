CREATE PROCEDURE [dbo].[PSP_CarriageListByStationReport_Get]
(
	@ProgramType VARCHAR(50),
	@Station varchar(10), 
	@Band VARCHAR(200),
	@StationStatus varchar(10),
	@MemStatus varchar(10),
	@FromMonth varchar(12),
	@FromYear varchar(12),
	@ToMonth varchar(12),
	@ToYear varchar(12)
)

WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON
	Declare @FMonth int, @TMonth int, @Date1 varchar(20), @Date2 varchar(20)
	, @RowNum int,	@MonSun varchar(20), @Mon char(1), @Tue Char(1), @Wed Char(1), @Thu Char(1), @Fri Char(1)
	, @Sat Char(1), @Sun Char(1), @StDays varchar(25), @Subsql varchar(200), @MemStatusId varchar(5)

	if @StationStatus='Yes'
	   set @Subsql = ' and st.disabledDate is null'
	else if @StationStatus='No'
	   set @Subsql = ' and st.disabledDate is not null'
	else
		Set @subsql = ''

	If @MemStatus is not null
		begin
			Select @MemStatusid=MemberStatusId from MemberStatus where MemberStatusName =@MemStatus 
			set @subsql = @subsql + ' ' + 'and st.MemberStatusId = ' +  @MemStatusid
		end
		
	Set @Date1 = convert(date,DateAdd(day, 0, DateAdd(month, @FromMonth - 1, DateAdd(Year,@FromYear-1900, 0)))) 
	Set @Date2 = convert(date,DateAdd(day, 0, DateAdd(month, @ToMonth - 1, DateAdd(Year,@ToYear-1900, 0)))) 

    DECLARE @DCSql NVARCHAR(MAX) 
	
	if @ProgramType = 'Regular'
			Set @DCSql = 'SELECT distinct s.stationid,  p.Programid,p.StartTime, p.EndTime,
			case p.MondayInd+p.TuesdayInd+p.WednesdayInd+ P.ThursdayInd+ P.FridayInd+ P.SaturdayInd +p.SundayInd
			when ''YYYYYYY'' then ''Mon-Sun'' 	when ''YYYYYYN'' then ''Mon-Sat'' 	when ''YYYYYNN'' then ''Mon-Fri'' 	when ''YYYYNNN'' then ''Mon-Thu'' 
			when ''YYYNNNN'' then ''Mon-Wed'' 	when ''YYNNNNN'' then ''Mon-Tue'' 	when ''NYYYYYY'' then ''Tue-Sun'' 	when ''NYYYYYN'' then ''Tue-Sat'' 
			when ''NYYYYNN'' then ''Tue-Fri'' 	when ''NYYYNNN'' then ''Tue-Thu'' 	when ''NYYNNNN'' then ''Tue-Wed'' 	when ''NNYYYYY'' then ''Wed-Sun'' 
			when ''NNYYYYN'' then ''Wed-Sat'' 	when ''NNYYYNN'' then ''Wed-Fri'' 	when ''NNYYNNN'' then ''Wed-Thru'' 	when ''NNNYYYY'' then ''Thu-Sun'' 
			when ''NNNYYYN'' then ''Thu-Sat'' 	when ''NNNYYNN'' then ''Thu-Fri'' 	when ''NNNNYYY'' then ''Fri-Sun'' 	when ''NNNNYYN'' then ''Fri-Sat'' 
			when ''NNNNNYY'' then ''Sat-Sun'' END,
			p.SundayInd,p.MondayInd,p.TuesdayInd,
			p.WednesdayInd, P.ThursdayInd, P.FridayInd, P.SaturdayInd
			FROM [Schedule] s 
			inner join ScheduleProgram p on s.scheduleid=p.scheduleid
			inner join Station st on st.stationid=s.stationid
			inner join band b on st.bandid = b.bandid
			where status=''Accepted'' and st.CallLetters = ''' + @Station + '''' + @subsql + '
			and b.bandname in (' + REPLACE(@Band, '|', '''') + ') and  DateAdd(day, 0, DateAdd(month, s.Month - 1, DateAdd(Year, S.Year-1900, 0))) between ''' + @date1 + ''' and ''' + @Date2 + ''''
	else
			Set @DCSql = 'SELECT distinct s.stationid, 0 Programid, p.StartTime, p.EndTime,
				case p.MondayInd+p.TuesdayInd+p.WednesdayInd+ P.ThursdayInd+ P.FridayInd+ P.SaturdayInd +p.SundayInd
				when ''YYYYYYY'' then ''Mon-Sun'' 	when ''YYYYYYN'' then ''Mon-Sat'' 	when ''YYYYYNN'' then ''Mon-Fri'' 	when ''YYYYNNN'' then ''Mon-Thu'' 
				when ''YYYNNNN'' then ''Mon-Wed'' 	when ''YYNNNNN'' then ''Mon-Tue'' 	when ''NYYYYYY'' then ''Tue-Sun'' 	when ''NYYYYYN'' then ''Tue-Sat'' 
				when ''NYYYYNN'' then ''Tue-Fri'' 	when ''NYYYNNN'' then ''Tue-Thu'' 	when ''NYYNNNN'' then ''Tue-Wed'' 	when ''NNYYYYY'' then ''Wed-Sun'' 
				when ''NNYYYYN'' then ''Wed-Sat'' 	when ''NNYYYNN'' then ''Wed-Fri'' 	when ''NNYYNNN'' then ''Wed-Thru'' 	when ''NNNYYYY'' then ''Thu-Sun'' 
				when ''NNNYYYN'' then ''Thu-Sat'' 	when ''NNNYYNN'' then ''Thu-Fri'' 	when ''NNNNYYY'' then ''Fri-Sun'' 	when ''NNNNYYN'' then ''Fri-Sat'' 
				when ''NNNNNYY'' then ''Sat-Sun'' END,
					p.SundayInd,p.MondayInd,p.TuesdayInd,
			p.WednesdayInd, P.ThursdayInd, P.FridayInd, P.SaturdayInd
			FROM [Schedule] s 
			inner join ScheduleNewsCast p on s.scheduleid=p.scheduleid
			inner join Station st on st.stationid=s.stationid
			inner join band b on st.bandid = b.bandid
			where status=''Accepted'' and st.CallLetters = ''' + @Station + '''' + @subsql + '
			and b.bandname in (' + REPLACE(@Band, '|', '''') + ') and  DateAdd(day, 0, DateAdd(month, s.Month - 1, DateAdd(Year, S.Year-1900, 0))) between ''' + @date1 + ''' and ''' + @Date2 + ''''


	 
	Create table #TempTbl (Stationid int,ProgramId int ,Starttime time(7),Endtime time(7), MonSun varchar(100), Sun char(1), Mon char(1),
						Tue char(1), Wed char(1), Thu char(1), Fri char(1), Sat char(1))
	
	Create table #TempTbl1 (RowNum int,Stationid int,ProgramId int ,Starttime varchar(5),Endtime varchar(5), MonSun varchar(100), Sun char(1), Mon char(1),
						Tue char(1), Wed char(1), Thu char(1), Fri char(1), Sat char(1))
    print @DCSQL
	insert into  #tempTbl	EXEC dbo.sp_executesql @DCSql 
	insert into #temptbl1 select ROW_NUMBER() over ( order by Programid), * from #temptbl

	Declare cur cursor for  Select  rownum, MonSun,Mon,Tue,Wed,Thu,Fri,Sat,Sun  from #TempTbl1 order by monsun desc
	Open cur
	FETCH  next FROM CUR into @rownum,@MonSun,@mon,@Tue,@Wed,@Thu,@Fri,@Sat,@Sun
	While @@Fetch_status=0
	Begin 
		if @MonSun is null
		Begin
		    if @Mon='Y'
				Set @StDays = 'Mon '
			if @Tue='Y'
				Set @StDays = @StDays + 'Tue '
			if @Wed='Y'
				Set @StDays = @StDays +'Wed '
			if @Thu='Y'
				Set @StDays = @StDays + 'Thu '
			if @Fri='Y'
				Set @StDays = @StDays + 'Fri '
			if @Sat='Y'
				Set @StDays = @StDays + 'Sat '
			if @Sun='Y'
				Set @StDays = @StDays + 'Sun '
			update #TempTbl1 set monsun = @StDays where rownum =@rownum
		End
		
	FETCH next from cur into @rownum,@MonSun,@mon,@Tue,@Wed,@Thu,@Fri,@Sat,@Sun
	set @StDays=''
	END	
	close cur
	deallocate cur	
 
  if @ProgramType='Regular'

 	  Select s.CallLetters + '-' + b.BandName Station, p.ProgramName [Program Name] ,ps.ProgramSourceName [Program Source]
		,pf.ProgramFormatTypeName [Program format],mf.MajorFormatName [Major format]
		, t.MonSun [BroadCast time Day(s)], t.Starttime [Start], t.Endtime [End], Datename(Month,@Date1) + '-' +  Datename(Year,@Date1) + ' To ' + Datename(Month,@Date2) + '-' +  Datename(Year,@Date2) as  [Survey] from #temptbl1 t 
		inner join dbo.station s on t.Stationid = s.StationId
		inner join dbo.program p on p.ProgramId = t.ProgramId 
		inner join dbo.band b on b.bandid = s.BandId 
		inner join dbo.ProgramSource ps on ps.ProgramSourceId = p.ProgramSourceId 
		inner join dbo.ProgramFormatType pf on pf.ProgramFormatTypeId = p.ProgramFormatTypeId 
		inner join dbo.MajorFormat mf on mf.MajorFormatId = pf.MajorFormatId
	else

		 Select s.CallLetters + '-' + b.BandName Station, 'NPR News Cast' [Program Name] ,'' [Program Source]
		,'' [Program format],'News and Information' [Major format]
		, t.MonSun [BroadCast time Day(s)], t.Starttime [Start], t.Endtime [End], Datename(Month,@Date1) + '-' +  Datename(Year,@Date1) + ' To ' + Datename(Month,@Date2) + '-' +  Datename(Year,@Date2) as  [Survey] from #temptbl1 t 
		inner join dbo.station s on t.Stationid = s.StationId
		inner join dbo.band b on b.bandid = s.BandId 
		
	return 0
END

