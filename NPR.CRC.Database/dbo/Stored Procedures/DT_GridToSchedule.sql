CREATE Procedure [dbo].[DT_GridToSchedule]
AS

BEGIN
	/** Clean data. Set submitted/accepted date and submitted/accepted user to null where there is a minimum date **/
	UPDATE crc3_20141208_NoBackup.dbo.grid
	SET SubmittedUser = NULL, LastSubmitted = NULL
	FROM crc3_20141208_NoBackup.dbo.grid
	WHERE LastSubmitted = '1900-01-01 00:00:00.000' 
	
	UPDATE crc3_20141208_NoBackup.dbo.grid
	SET AcceptedUser = NULL, LastAccepted = NULL
	FROM crc3_20141208_NoBackup.dbo.grid
	WHERE LastAccepted = '1900-01-01 00:00:00.000'
	
	/***************************************************************************************/
	
	/** Default submitted, accepted, created, lastupdated userid to Paul Ahlers. If he doesn't exist, set default CRCUserId = 1 **/
	DECLARE @DefaultUserId INT
	SELECT @DefaultUserId = UserId FROM CRCUser WHERE FirstName + ' ' + LastName = 'Paul Ahlers'
	
	IF @DefaultUserId = NULL
		SET @DefaultUserId = 1
	/***************************************************************************************/
	
	INSERT INTO dbo.Schedule (StationId, [Year], [Month], SubmittedDate, SubmittedUserId, AcceptedDate, AcceptedUserId, CreatedDate, CreatedUserId, LastUpdatedDate, LastUpdatedUserId)
	
	SELECT 
	--O_g.gridid,
	--O_g.StationId As crc3_20141208_NoBackup_StationId,
	--O_st.CallLetters + '-' + O_st.Band As crc3_20141208_NoBackup_StationName,
		N_St.StationId As crc_StationId,
	--N_st.crcStationName crc_StationName,
		DATEPART(Year, MonthYear) As [Year],
		DATEPART(Month, MonthYear) As [Month],
		LastSubmitted As SubmittedDate,
		(
		CASE WHEN LastSubmitted IS NOT NULL AND
		(SELECT top 1 UserId FROM CRCUser LEFT JOIN Salutation sal ON CRCUser.SalutationId =  sal.SalutationId 
		  WHERE ISNULL(SalutationName + ' ', '') + CRCUser.FirstName + ' '  + CRCUser.LastName = 
		    O_g.SubmittedUser) IS NULL THEN @DefaultUserId
		 ELSE
		(SELECT top 1 UserId FROM CRCUser LEFT JOIN Salutation sal ON CRCUser.SalutationId =  sal.SalutationId 
			  WHERE ISNULL(SalutationName + ' ', '') + CRCUser.FirstName + ' '  + CRCUser.LastName = 
				O_g.SubmittedUser)
		END
		) As SubmittedUserId,
		CASE WHEN LastAccepted = '1900-01-01 00:00:00.000' OR LastSubmitted = '1900-01-01 00:00:00.000' THEN NULL 
				WHEN LastAccepted = LastSubmitted AND LastAccepted <> '1900-01-01 00:00:00.000' THEN DATEADD(MINUTE, 1, LastAccepted)
				ELSE LastAccepted END 
		As AcceptedDate,
		--LastAccepted As AcceptedDate,
		(
		CASE WHEN LastAccepted IS NOT NULL AND 
			(SELECT top 1 UserId FROM CRCUser LEFT JOIN Salutation sal ON CRCUser.SalutationId =  sal.SalutationId 
			  WHERE ISNULL(SalutationName + ' ', '') + CRCUser.FirstName + ' '  + CRCUser.LastName = 
				O_g.AcceptedUser) IS NULL THEN @DefaultUserId
			 ELSE 
			(SELECT top 1 UserId FROM CRCUser LEFT JOIN Salutation sal ON CRCUser.SalutationId =  sal.SalutationId 
					  WHERE ISNULL(SalutationName + ' ', '') + CRCUser.FirstName + ' '  + CRCUser.LastName = 
						O_g.AcceptedUser)	
			END
		) As AcceptedUserId,
		 ISNULL(ISNULL(LastSubmitted, LastAccepted), GETUTCDATE()) As CreatedDate,
		 @DefaultUserId As CreatedUserId,
		 ISNULL(ISNULL(LastAccepted, LastSubmitted), GETUTCDATE()) As LastUpdatedDate,
		 @DefaultUserId As LastUpdatedUserId
	FROM 
		crc3_20141208_NoBackup.dbo.grid O_g INNER JOIN
		crc3_20141208_NoBackup.dbo.Station O_st ON O_g.StationID = O_st.StationID INNER JOIN
		(SELECT  StationId, CallLetters + '-' + BandName As crcStationName
		 FROM dbo.Station INNER JOIN dbo.Band ON station.BandId = Band.BandId) As N_st ON O_st.CallLetters + '-' + O_st.Band = N_st.crcStationName
	
	WHERE O_g.gridId NOT IN (45683, 45684) -- Duplicate data in grid table not linked to any PERegular records
	--and MonthYear >= '2013-01-01' and MonthYear < '2014-10-02'
	and  O_g.gridid not in(
		select gridid from aaascheduleCrossRef acr
	join schedule stn on stn.stationid = acr.newstationid and stn.year = acr.year and stn.month = acr.montn
		) 
	ORDER BY crc_StationId, [Year], [Month]
	--[DT_GridToSchedule]

END