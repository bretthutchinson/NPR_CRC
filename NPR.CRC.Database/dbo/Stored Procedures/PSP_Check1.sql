CREATE PROCEDURE [dbo].[PSP_Check1]
(
	@MemberStatusName VARCHAR(100)

)

WITH EXECUTE AS OWNER
 
AS BEGIN
    
		SET NOCOUNT ON
		
		DECLARE @DynSql NVARCHAR(MAX) =
		
		'
		SELECT s.CallLetters from station AS s
		INNER JOIN  dbo.MemberStatus AS m on m.MemberStatusId=s.MemberStatusId
		INNER JOIN dbo.Band AS b on b.BandId=s.BandId

		where '

		IF @MemberStatusName IS NOT NULL
			SET @DynSql= @DynSql + 'm.MemberStatusName=@MemberStatusName'
		
		IF @MemberStatusName IS NULL
			SET @DynSql= @DynSql + '@MemberStatusName=@MemberStatusName'
		
 
	PRINT @DynSql

END