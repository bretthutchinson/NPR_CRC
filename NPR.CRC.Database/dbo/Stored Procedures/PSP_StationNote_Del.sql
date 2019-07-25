CREATE PROCEDURE [dbo].[PSP_StationNote_Del]
(
	@StationNoteId BIGINT,
	@DeletedDate Datetime,
	@DeletedUserId BIGINT,
	@LastUpdatedDate Datetime,
	@LastUpdatedUserId BIGINT
)
AS BEGIN
    SET NOCOUNT ON

    UPDATE
		dbo.StationNote
	SET
		DeletedDate = @DeletedDate,
		DeletedUserId = @DeletedUserId,
		LastUpdatedDate = @LastUpdatedDate,
		LastUpdatedUserId = @LastUpdatedUserId
	WHERE
		StationNoteId = @StationNoteId
    
END
GO


