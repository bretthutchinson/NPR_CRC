--[PSP_ScheduleSearchManage_Get] null, 10,2014,null
CREATE PROCEDURE [dbo].[PSP_ScheduleSearchManage_Get]
(
	@StationId BIGINT,
	@Month INT,
	@Year INT,
	@Status VARCHAR(50),
	@DebugInd CHAR(1) = 'N'
)
WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
	Select * from 
	(SELECT
		sch.ScheduleId,
		sta.StationId,
		sta.CallLetters + ''-'' + b.BandName AS StationDisplayName,
		ISNULL(sch.Month, @Month) AS Month,
		(
			Select DateName( month , DateAdd( month , ISNULL(sch.Month, @Month) , 0 ) - 1 )
		) As MonthName,
		ISNULL(sch.Year, @Year) AS Year,
		--sch.ScheduleId,

		LEFT(DATENAME(MONTH, DATEADD(MONTH, ISNULL(sch.Month, @Month) - 1 , ''1900-01-01'' )), 3) +
			''. '' +
			CAST(ISNULL(sch.Year, @Year) AS VARCHAR(50))
			AS ScheduleDisplayName,
		
		CAST(
			CAST(ISNULL(sch.Year, @Year) AS VARCHAR(50)) +
			''-'' +
			CAST(ISNULL(sch.Month, @Month) AS VARCHAR(50)) +
			''-1''
			AS DATE) AS ScheduleStartDate,

		sch.Status,
		sch.SubmittedDate,
		sch.SubmittedUserId,
		dbo.FN_GetUserDisplayName(sch.SubmittedUserId) AS SubmittedUserDisplayName,
		sch.AcceptedDate,
		sch.AcceptedUserId,
		dbo.FN_GetUserDisplayName(sch.AcceptedUserId) AS AcceptedUserDisplayName,
		sta.PrimaryUserId,
		dbo.FN_GetUserDisplayName(pu.UserId) AS PrimaryUserDisplayName,
		pu.Email AS PrimaryUserEmail,
		pu.Phone AS PrimaryUserPhone

	FROM
		dbo.Station sta

		JOIN dbo.Band b
			ON b.BandId = sta.BandId

		JOIN dbo.RepeaterStatus rs
			ON sta.RepeaterStatusId = rs.RepeaterStatusId

		LEFT JOIN dbo.CRCUser pu
			ON pu.UserId = sta.PrimaryUserId

		 INNER JOIN dbo.Schedule sch
			ON sch.StationId = sta.StationId

		Where sta.repeaterstatusid >1
	'
	
	IF @Month IS NOT NULL
		SET @DynSql = @DynSql + ' AND sch.Month = @Month'

	IF @Year IS NOT NULL
		SET @DynSql = @DynSql + ' AND sch.Year = @Year'

	IF @Status IS NOT NULL AND @Status <> 'All'
		SET @DynSql = @DynSql + ' AND sch.Status = @Status'

	--SET @DynSql = @DynSql + ' WHERE rs.RepeaterStatusName <> ''100% Repeater'' '

	IF @StationId IS NOT NULL
		SET @DynSql = @DynSql + ' AND sta.StationId = @StationId'

	IF @Status in ('Unsubmitted','All') SET @DynSql = @DynSql + ' union
		SELECT
		null,
		sta.StationId,
		sta.callletters +''-''+ b.BandName AS StationDisplayName,
		@month,
		null As MonthName,
		@year AS Year,
		--null,

		null
			AS ScheduleDisplayName,
		null AS ScheduleStartDate,

		null,
		null,
		null,
		null AS SubmittedUserDisplayName,
		null,
		null,
		null AS AcceptedUserDisplayName,
		null,
		dbo.FN_GetUserDisplayName(pu.UserId) AS PrimaryUserDisplayName,
		pu.Email AS PrimaryUserEmail,
		pu.Phone AS PrimaryUserPhone

	FROM
		dbo.Station sta
		join band b on b.bandid = sta.bandid		
		LEFT JOIN dbo.CRCUser pu
			ON pu.UserId = sta.PrimaryUserId

		Where sta.repeaterstatusid >1 
		and sta.stationid not in 
		(
			select s.stationid from station s
			join schedule sch on sch.stationid = s.stationid
			where sch.month = @month and sch.year = @year
		)
		and sta.disableddate is null
		'

	 SET @DynSql = @DynSql +'	) as a
		order by StationDisplayName
	'


	DECLARE @DynParams NVARCHAR(MAX) =
	'
	@StationId BIGINT,
	@Month INT,
	@Year INT,
	@Status VARCHAR(50)
	'
	--[PSP_ScheduleSearchManage_Get] null, 10,2014,null
	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		EXEC dbo.sp_executesql
		@DynSql,
		@DynParams,
		@StationId = @StationId,
		@Month = @Month,
		@Year = @Year,
		@Status = @Status

END