---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DROP PROCEDURE [dbo].[PSP_StationUsersReport_Get]
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PSP_StationUsersReport_Get]
(
	@UserPermission CHAR(1),
	@BandSpan VARCHAR(100),
	@RepeaterStatus CHAR(1),
	@DebugInd CHAR(1)
)
--[PSP_StationUsersReport_Get] 'A', '|AM|,|FM|','F', null
WITH EXECUTE AS OWNER
AS BEGIN

	SET NOCOUNT ON

	DECLARE @RepeaterStatusName VARCHAR(100);

	SELECT  @RepeaterStatusName = 
		CASE @RepeaterStatus 
			WHEN 'F' THEN 'FlagShip'
			WHEN 'R' THEN '100% Repeater'
			WHEN 'N' THEN 'Non-100% (Partial) Repeater'
			WHEN 'A' THEN 'Flagship'', ''Non-100% (Partial) Repeater'
		END

	DECLARE @DynSql NVARCHAR(MAX) =
	'
	SELECT
		sta.CallLetters + ''-'' + b.BandName As Station,
		r.RepeaterStatusName As [Repeater Status],
		crcU.FirstName + ISNULL('' '' + crcU.MiddleName, '' '' ) + crcU.LastName + ISNULL('' '' + crcU.Suffix, '''') As [Name],
		crcU.Email As [User Name],
		crcU.Phone As Telephone,
		crcU.Fax,
		crcU.Email,
		case when crcU.DisabledDate is null  then ''Yes'' else ''No'' end as Enabled
	FROM 
		dbo.StationUser staU INNER JOIN
		dbo.CRCUser crcU ON staU.UserId = crcU.UserId INNER JOIN
		dbo.Station sta ON staU.StationId = sta.StationId INNER JOIN
		dbo.Band b ON sta.BandId = b.BandId INNER JOIN
		dbo.RepeaterStatus r ON sta.RepeaterStatusId = r.RepeaterStatusId
	WHERE
		staU.GridWritePermissionsInd = ''Y''
		'
	
		IF @UserPermission = 'P'
			SET @DynSql = @DynSql + ' AND sta.PrimaryUserId = staU.UserId'
	
		SET @DynSql = @DynSql + 
		' AND b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')' +
		' AND r.RepeaterStatusName IN (''' + @RepeaterStatusName + ''')
		
		ORDER BY sta.CallLetters + ''-'' + b.BandName
		'
	IF @DebugInd = 'Y'
		PRINT @DynSql
	ELSE
		EXEC dbo.sp_executesql @DynSql 
	--[PSP_StationUsersReport_Get] 'A', '|AM|,|FM|','R', null
END

--select * from crc3_20140923.dbo.stationuser
GO


