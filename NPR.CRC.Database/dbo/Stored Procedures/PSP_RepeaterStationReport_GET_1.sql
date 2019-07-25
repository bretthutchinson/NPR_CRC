CREATE PROCEDURE [dbo].[PSP_RepeaterStationReport_GET]
(
	@StationEnabled VARCHAR(2),
	@BandSpan VARCHAR(MAX)
)
--[PSP_RepeaterStationReport_GET] 'Y' , '|AM|,|FM|'
WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON
DECLARE
		@DynSql NVARCHAR(MAX)=
	'
			SELECT 
			--s.FlagshipStationId, 
			sf.CallLetters + ''-'' +bf.BandName as [Flagship],
			s.CallLetters + ''-'' +b.BandName as [Repeater Station],
			st.abbreviation as ST, 
			s.City,s.Frequency as Freq,
			m.MemberStatusName as [Member Status], 
			s.MetroMarketRank [Metro], 
			s.DmaMarketRank as [DMA]
			From dbo.Station AS s
			INNER JOIN dbo.Band AS b ON b.BandId=s.BandId
			INNER JOIN dbo.State AS st ON st.StateId=s.StateId
			INNER JOIN dbo.MemberStatus AS m ON m.MemberStatusId=s.MemberStatusId
			INNER JOIN dbo.RepeaterStatus AS r ON r.RepeaterStatusId=s.RepeaterStatusId
			join dbo.station as sf on sf.stationid = s.flagshipstationid
			join band bf on bf.bandid = sf.bandid
			WHERE s.RepeaterStatusId=1 And
			b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'
			IF(@StationEnabled='Y')
				BEGIN
					SET @DynSql= @DynSql + ' AND s.DisabledDate IS NULL'
				END
			ELSE IF (@StationEnabled='N')
				BEGIN
					SET @DynSql= @DynSql + ' AND s.DisabledDate IS NOT NULL'
				END
				
				
			SET @DynSql=@DynSql + ' Order By Flagship, [Repeater Station], st.StateNAme , s.City'	
			--print @DynSql
		EXEC(@DynSql)
		
	END