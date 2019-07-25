CREATE PROCEDURE [dbo].[PSP_StationNote_Get]
(
    @StationNoteId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        StationNoteId,
		StationId,
		NoteText,
		DeletedDate,
		DeletedUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId
    FROM
        dbo.StationNote
    WHERE
        StationNoteId = @StationNoteId

END
GO


