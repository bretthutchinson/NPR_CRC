

Create PROCEDURE [dbo].[PSP_UserStationLink_Delete]
(
	@UserId BIGINT,
	@StationId BIGINT	
)
AS BEGIN

    SET NOCOUNT ON

	DELETE FROM dbo.StationUser
	WHERE
	UserId = @UserId
	AND
	StationId=@StationId
END