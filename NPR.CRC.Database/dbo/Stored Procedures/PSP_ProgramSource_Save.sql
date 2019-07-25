CREATE PROCEDURE [dbo].[PSP_ProgramSource_Save]
(
    @ProgramSourceId BIGINT,
	@ProgramSourceName VARCHAR(50),
	@ProgramSourceCode VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.ProgramSource
    SET
        ProgramSourceName = @ProgramSourceName,
		ProgramSourceCode = @ProgramSourceCode,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ProgramSourceId = @ProgramSourceId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.ProgramSource
        (
            ProgramSourceName,
			ProgramSourceCode,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @ProgramSourceName,
			@ProgramSourceCode,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @ProgramSourceId = SCOPE_IDENTITY()

    END

    SELECT @ProgramSourceId AS ProgramSourceId

END
GO


