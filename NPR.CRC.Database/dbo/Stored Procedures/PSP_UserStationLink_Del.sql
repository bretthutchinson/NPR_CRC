Create PROCEDURE [dbo].[PSP_UserStationLink_Del]
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
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PSP_UserStationLink_Del] TO [crcuser]
    AS [dbo];

