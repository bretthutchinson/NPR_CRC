CREATE PROCEDURE [dbo].[PSP_StationNotes_Get]
(
	@StationId BIGINT
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
		StationId = @StationId AND
		DeletedDate IS NULL
    
END
GO


