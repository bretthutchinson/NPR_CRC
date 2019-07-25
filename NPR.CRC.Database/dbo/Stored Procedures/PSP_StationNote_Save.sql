CREATE PROCEDURE [dbo].[PSP_StationNote_Save]
(
    @StationNoteId BIGINT,
	@StationId BIGINT,
	@NoteText VARCHAR(MAX),
	@DeletedDate DATETIME,
	@DeletedUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.StationNote
    SET
        StationId = @StationId,
		NoteText = @NoteText,
		DeletedDate = @DeletedDate,
		DeletedUserId = @DeletedUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        StationNoteId = @StationNoteId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.StationNote
        (
            StationId,
			NoteText,
			DeletedDate,
			DeletedUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @StationId,
			@NoteText,
			@DeletedDate,
			@DeletedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @StationNoteId = SCOPE_IDENTITY()

    END

    SELECT @StationNoteId AS StationNoteId

END
GO


