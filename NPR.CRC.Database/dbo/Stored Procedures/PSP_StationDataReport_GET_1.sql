CREATE PROCEDURE [dbo].[PSP_StationDataReport_GET]
(
	@StationEnabled VARCHAR(2),
	@BandSpan VARCHAR(MAX),
	@RepeaterStatus VARCHAR(50)
)
WITH EXECUTE AS OWNER
AS BEGIN
SET NOCOUNT ON
DECLARE
		@DynSql NVARCHAR(MAX)=
	'
			SELECT s.CallLetters + ''-'' +b.BandName Station,st.Abbreviation as [State], s.City,s.Frequency AS [Freq],m.MemberStatusName AS [MemberStatus], s.MetroMarketRank AS [MetroRank], s.DmaMarketRank AS [DMARank]
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
				
			IF(@RepeaterStatus='1' OR @RepeaterStatus='2' OR @RepeaterStatus='3' )
				BEGIN
					SET @DynSql= @DynSql + ' AND s.RepeaterStatusId= '''+ CONVERT(VARCHAR, @RepeaterStatus) +'''' 
				END	
			ELSE
			SET @DynSql= @DynSql + ' AND s.RepeaterStatusId IN (' + REPLACE(@RepeaterStatus, '|', '''') + ') '
				
						
		SET @DynSql=@DynSql + ' Order By Station,st.StateNAme , s.City'

		--Insert Data into table variable
		SET @DynSql='DECLARE @ResultTable TABLE(
								Station varchar(100),
								[State] varchar(100),
								City varchar(100),
								[Freq] varchar(100),
								[MemberStatus] varchar(100),
								[MetroRank] varchar(100),
								[DMARank] varchar(100))   
						
						Insert into @ResultTable  '+ @DynSql +'  

						Select Station, state as ST, City, Freq, memberstatus as [Member Status], metrorank as [Metro Rank], dmarank as [DMA Rank]
						 from @ResultTable Order By st , City, Station'
		
		Print @DynSql
		 --return result table
		EXEC(@DynSql )
		
	END