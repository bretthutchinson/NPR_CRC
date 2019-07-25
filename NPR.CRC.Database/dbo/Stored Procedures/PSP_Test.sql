CREATE PROCEDURE [dbo].[PSP_Test]

	AS BEGIN

    	
		DECLARE

		@sql NVARCHAR(MAX);

		set @sql = 'SELECT

	
		st.CallLetters, b.BandName AS Station,
	 
		s.Abbreviation , st.city , ms.MemberStatusName , st.MetroMarketRank , st.DMAMarketRank 
  
  FROM dbo.Schedule as sc
  
	LEFT JOIN Station as st ON st.StationId = sc.StationId
	
	LEFT JOIN ScheduleProgram as sp ON sp.ScheduleId = sc.ScheduleId
	
	INNER JOIN State as s ON s.StateId = st.StateId
	
	LEFT JOIN Band as b ON b.bandid = st.BandId
	
	INNER JOIN MemeberState ms ON ms.MemberStateId = st.MemberStatusId
	
	WHERE 
	
		sc.Year = 2014';

		set @sql = @sql + ' AND sc.Month = 2';

END