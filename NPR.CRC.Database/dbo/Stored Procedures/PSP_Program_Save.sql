CREATE PROCEDURE [dbo].[PSP_Program_Save]
(
    @ProgramId BIGINT,
	@ProgramName VARCHAR(100),
	@ProgramSourceId BIGINT,
	@ProgramFormatTypeId BIGINT,
	@ProgramCode VARCHAR(50),
	@CarriageTypeId BIGINT,
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Program
    SET
        ProgramName = @ProgramName,
		ProgramSourceId = @ProgramSourceId,
		ProgramFormatTypeId = @ProgramFormatTypeId,
		ProgramCode = @ProgramCode,
		CarriageTypeId = @CarriageTypeId,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ProgramId = @ProgramId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Program
        (
            ProgramName,
			ProgramSourceId,
			ProgramFormatTypeId,
			ProgramCode,
			CarriageTypeId,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @ProgramName,
			@ProgramSourceId,
			@ProgramFormatTypeId,
			@ProgramCode,
			@CarriageTypeId,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @ProgramId = SCOPE_IDENTITY()

    END

    SELECT @ProgramId AS ProgramId

END
GO


