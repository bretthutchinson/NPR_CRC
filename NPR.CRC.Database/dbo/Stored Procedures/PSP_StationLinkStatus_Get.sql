CREATE  PROCEDURE [dbo].[PSP_StationLinkStatus_Get]

	@StationId BIGINT,
	@UserId BIGINT

AS BEGIN

    SET NOCOUNT ON

    SELECT
        
		StationUserId
		
	FROM
        dbo.StationUser

     WHERE
	 
        StationId = @StationId
		AND
		UserId = @UserId

END
GO


