﻿
CREATE PROCEDURE [dbo].[PSP_RepeaterStationReport_GET]
(
	@StationEnabled VARCHAR(2),
	@BandSpan VARCHAR(MAX)
)
WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON
DECLARE
		@DynSql NVARCHAR(MAX)=
	'
			SELECT s.CallLetters + ''-'' +b.BandName Station,r.RepeaterStatusName,st.StateName, s.City,s.Frequency,m.MemberStatusName, s.MetroMarketRank, s.DmaMarketRank
			From dbo.Station AS s
			INNER JOIN dbo.Band AS b ON b.BandId=s.BandId
			INNER JOIN dbo.State AS st ON st.StateId=s.StateId
			INNER JOIN dbo.MemberStatus AS m ON m.MemberStatusId=s.MemberStatusId
			INNER JOIN dbo.RepeaterStatus AS r ON r.RepeaterStatusId=s.RepeaterStatusId
			WHERE 
			b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'
			IF(@StationEnabled='Y')
				BEGIN
					SET @DynSql= @DynSql + ' AND s.DisabledDate IS NULL'
				END
			ELSE IF (@StationEnabled='N')
				BEGIN
					SET @DynSql= @DynSql + ' AND s.DisabledDate IS NOT NULL'
				END
				
				
			SET @DynSql=@DynSql + ' Order By Station,st.StateNAme , s.City'	

		EXEC(@DynSql)
		
	END