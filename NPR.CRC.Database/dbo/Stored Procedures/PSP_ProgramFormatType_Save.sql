CREATE PROCEDURE [dbo].[PSP_ProgramFormatType_Save]
(
    @ProgramFormatTypeId BIGINT,
	@ProgramFormatTypeName VARCHAR(50),
	@ProgramFormatTypeCode VARCHAR(50),
	@MajorFormatId BIGINT,
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.ProgramFormatType
    SET
        ProgramFormatTypeName = @ProgramFormatTypeName,
		ProgramFormatTypeCode = @ProgramFormatTypeCode,
		MajorFormatId = @MajorFormatId,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ProgramFormatTypeId = @ProgramFormatTypeId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.ProgramFormatType
        (
            ProgramFormatTypeName,
			ProgramFormatTypeCode,
			MajorFormatId,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @ProgramFormatTypeName,
			@ProgramFormatTypeCode,
			@MajorFormatId,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @ProgramFormatTypeId = SCOPE_IDENTITY()

    END

    SELECT @ProgramFormatTypeId AS ProgramFormatTypeId

END
GO


