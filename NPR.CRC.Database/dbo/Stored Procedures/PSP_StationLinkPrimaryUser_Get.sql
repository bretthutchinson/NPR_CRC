CREATE  PROCEDURE [dbo].[PSP_StationLinkPrimaryUser_Get]

	@StationId BIGINT
	
AS BEGIN

    SET NOCOUNT ON

    SELECT
        
		FirstName , MiddleName , LastName 
		
	FROM
	
        dbo.CRCUser

     WHERE
	 
        UserId 
		 
		 in
		 
		( select primaryuserid from dbo.station where StationId = @StationId )	

END
GO


