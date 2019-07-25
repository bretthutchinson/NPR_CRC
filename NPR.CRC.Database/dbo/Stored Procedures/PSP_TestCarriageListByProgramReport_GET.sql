
	
CREATE PROCEDURE [dbo].[PSP_TestCarriageListByProgramReport_GET]
(
	@ProgramType VARCHAR(50),
	@BandSpan VARCHAR(MAX),
	@StationEnabled VARCHAR(2),
	@MemberStatusName VARCHAR(50)
	
)
WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON
DECLARE
		@DynSql NVARCHAR(MAX)=
'		
	SELECT DISTINCT
	p.ProgramName, ps.ProgramSourceName, pf.ProgramFormatTypeName, mf.MajorFormatName, sp.StartTime, sp.EndTime
	FROM dbo.Program AS p
	INNER JOIN  dbo.ProgramSource AS ps ON ps.ProgramSourceId = p.ProgramSourceId
	INNER JOIN  dbo.ProgramFormatType AS pf ON pf.ProgramFormatTypeId = p.ProgramFormatTypeId	
	INNER JOIN  dbo.MajorFormat AS mf ON mf.MajorFormatId = pf.MajorFormatId
	INNER JOIN  dbo.ScheduleProgram AS sp ON sp.ProgramId = p.ProgramId
	LEFT JOIN  dbo.ScheduleNewscast AS sc ON sc.ScheduleId = sp.ScheduleId
	INNER JOIN  dbo.Schedule AS s ON s.ScheduleId = sp.ScheduleId
	INNER JOIN  dbo.Station AS st ON st.StationId = s.StationId
	INNER JOIN 	dbo.Band AS b ON b.BandId=st.BandId
	INNER JOIN  dbo.MemberStatus As m ON m.MemberStatusId = st.MemberStatusId
	WHERE 
	p.ProgramName NOT LIKE ''%Off Air%'' AND b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'
	
	IF(@ProgramType='Regular')
		BEGIN 
			SET @DynSql= @DynSql +' AND sc.ScheduleNewscastId IS NULL' 
		END
	ELSE IF(@ProgramType='NprNewsCast')
		BEGIN 
			SET @DynSql= @DynSql +' AND sc.ScheduleNewscastId IS NOT NULL' 
		END
		
	IF(@MemberStatusName <> '')	
		BEGIN
			SET @DynSql = @DynSql + ' AND m.MemberStatusName= '''+ CONVERT(VARCHAR, @MemberStatusName) +'''' 
		END
		
	IF(@StationEnabled='Y')
		SET @DynSql= @DynSql + ' AND st.DisabledDate IS NULL'
	ELSE IF (@StationEnabled='N')
		SET @DynSql= @DynSql + ' AND st.DisabledDate IS NOT NULL'	
		
		Print @DynSql
	END