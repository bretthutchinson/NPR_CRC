CREATE PROCEDURE [dbo].[PSP_Check]
(   @BandSpan VARCHAR(100),
	@MemberStatusName VARCHAR(100),
	@StationEnabled VARCHAR(10)
)

WITH EXECUTE AS OWNER

AS BEGIN
    
		SET NOCOUNT ON
		SELECT s.CallLetters from station AS s
		INNER JOIN  dbo.MemberStatus AS m on m.MemberStatusId=s.MemberStatusId
		INNER JOIN dbo.Band AS b on b.BandId=s.BandId

where 
b.BandName IN (REPLACE(@BandSpan, '|', '''') )
AND
(m.MemberStatusName=@MemberStatusName OR Coalesce(@MemberStatusName,'0')='0')
AND
	((s.DisabledDate IS NULL AND @StationEnabled = 'Y') OR (s.DisabledDate IS NOT NULL AND @StationEnabled = 'N') OR Coalesce(@StationEnabled,'0')='0')
	
END