
CREATE PROCEDURE [dbo].[PSP_StationListAsMemberBand_Get]
(
	@BandSpan VARCHAR(220),
	@MemberStatusName VARCHAR(100),
	@StationEnabled VARCHAR(50)
)

WITH EXECUTE AS OWNER

AS BEGIN
    
		SET NOCOUNT ON
	
	DECLARE 
	@DynSql NVARCHAR(MAX) =
	
	'SELECT s.CallLetters + ''-'' +b.BandName  Station from dbo.Station as s
		INNER JOIN dbo.Band As b on b.BandId=s.BandId
		INNER JOIN dbo.MemberStatus As m on m.MemberStatusId=s.MemberStatusId
		WHERE b.BandName IN (' + REPLACE(@BandSpan, '|', '''') + ')'
		IF (@MemberStatusName <> '')
			SET @DynSql= @DynSql + ' AND m.MemberStatusName= '''+ CONVERT(VARCHAR, @MemberStatusName) +'''' 
								
		IF(@StationEnabled='Y')
		
		set @DynSql= @DynSql + ' AND s.DisabledDate IS NULL'
		
		ELSE IF (@StationEnabled='N')
		
				SET @DynSql= @DynSql + ' AND s.DisabledDate IS NOT NULL'
		
		EXEC(@DynSql)
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PSP_StationListAsMemberBand_Get] TO [crcuser]
    AS [dbo];

