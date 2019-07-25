--select * from repeaterstatus
--[PSP_CRCUsersSearch_Get] 'Yes', null, 'Paul', null, null, null, null, '
CREATE PROCEDURE [dbo].[PSP_CRCUsersSearch_Get] 
(
	@UserEnabled VARCHAR(50),
	@StationEnabled VARCHAR(50),
	@UserName VARCHAR(50),
	@RepeaterStatusId BIGINT,
	@UserRole VARCHAR(50),
	@Band VARCHAR(50),
	@UserPermission VARCHAR(50),
	@StationId BIGINT,
	@DebugInd CHAR(1) = 'N'
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

	DECLARE @DynSql NVARCHAR(MAX) =
	'
    SELECT
        u.UserId,
		dbo.FN_GetUserDisplayName(u.UserId) AS UserDisplayName,
		CASE
			WHEN u.CRCManagerInd = ''Y'' THEN ''CRC Manger''
			WHEN u.AdministratorInd = ''Y'' THEN ''Administrator''
			WHEN s.PrimaryUserId = u.UserId THEN ''Primary User''
			WHEN su.GridWritePermissionsInd = ''Y'' THEN ''Grid Write''
			ELSE ''Station User''
		END AS UserPermission,
		CASE
			WHEN u.DisabledDate IS NULL THEN ''Yes''
			ELSE ''No''
		END AS UserEnabled,
		s.StationId,
		s.CallLetters + ''-'' + b.BandName AS StationDisplayName,
		rs.RepeaterStatusName AS RepeaterStatus,
		s.FlagshipStationId,
		fs.CallLetters + ''-'' + fsb.BandName AS FlagshipStationDisplayName,
		u.Email,
		u.Phone
    FROM
        dbo.CRCUser u

		LEFT JOIN dbo.StationUser su
			ON su.UserId = u.UserId

		LEFT JOIN dbo.Station s
			ON s.StationId = su.StationId

		LEFT JOIN dbo.Band b
			ON b.BandId = s.BandId

		LEFT JOIN dbo.RepeaterStatus rs
			ON rs.RepeaterStatusId = s.RepeaterStatusId

		LEFT JOIN dbo.Station fs
			ON fs.StationId = s.FlagshipStationId

		LEFT JOIN dbo.Band fsb
			ON fsb.BandId = fs.BandId

	WHERE (s.repeaterstatusid >1 or LEN(@UserName) > 0)
	--1=1
	'
	--select * from stationuser
	--select * from station
	IF @UserEnabled = 'YES'
		SET @DynSql = @DynSql + ' AND u.DisabledDate IS NULL'
	ELSE IF @UserEnabled = 'NO'
		SET @DynSql = @DynSql + ' AND u.DisabledDate IS NOT NULL'

	IF @StationEnabled = 'YES'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NULL'
	ELSE IF @StationEnabled = 'NO'
		SET @DynSql = @DynSql + ' AND s.DisabledDate IS NOT NULL'

	IF LEN(@UserName) > 0
		SET @DynSql = @DynSql + ' AND REPLACE(u.FirstName + u.LastName, '' '', '''') LIKE ''%'' + REPLACE(@UserName, '' '', '''') + ''%'''

	IF @RepeaterStatusId IS NOT NULL
		SET @DynSql = @DynSql + ' AND rs.RepeaterStatusId = @RepeaterStatusId'

	IF @UserRole LIKE '%Station%'
		SET @DynSql = @DynSql + ' AND u.AdministratorInd = ''N'''
	ELSE IF @UserRole LIKE '%Admin%'
		SET @DynSql = @DynSql + ' AND u.AdministratorInd = ''Y'''

	IF @Band = 'Terrestrial'
		SET @DynSql = @DynSql + ' AND b.BandName IN (''AM'', ''FM'')'
	ELSE IF @Band = 'HD'
		SET @DynSql = @DynSql + ' AND b.BandName LIKE ''%HD%'''

	IF @UserPermission LIKE '%Primary%'
		SET @DynSql = @DynSql + ' AND s.PrimaryUserId = u.UserId'
	ELSE IF @UserPermission LIKE '%Write%'
		SET @DynSql = @DynSql + ' AND su.GridWritePermissionsInd = ''Y'' and not(s.PrimaryUserId = u.UserId)'

	IF @StationId IS NOT NULL
		SET @DynSql = @DynSql + ' AND s.StationId = @StationId'


	DECLARE @DynParams NVARCHAR(MAX) =
	'
	@UserName VARCHAR(50),
	@RepeaterStatusId BIGINT,
	@StationId BIGINT
	'

	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		EXEC dbo.sp_executesql
		@DynSql,
		@DynParams,
		@UserName = @UserName,
		@RepeaterStatusId = @RepeaterStatusId,
		@StationId = @StationId

END
GO


