CREATE PROCEDURE [dbo].[PSP_UpdateStationPrimaryId]
(
	
	@StationId BIGINT
)
AS BEGIN

    SET NOCOUNT ON
		
		UPDATE dbo.Station set PrimaryUserId=NULL where StationId=@StationId
END
GO


