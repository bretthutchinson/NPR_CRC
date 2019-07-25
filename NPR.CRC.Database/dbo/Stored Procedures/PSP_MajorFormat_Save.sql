CREATE PROCEDURE [dbo].[PSP_MajorFormat_Save]
(
    @MajorFormatId BIGINT,
	@MajorFormatName VARCHAR(50),
	@MajorFormatCode VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.MajorFormat
    SET
        MajorFormatName = @MajorFormatName,
		MajorFormatCode = @MajorFormatCode,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        MajorFormatId = @MajorFormatId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.MajorFormat
        (
            MajorFormatName,
			MajorFormatCode,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @MajorFormatName,
			@MajorFormatCode,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @MajorFormatId = SCOPE_IDENTITY()

    END

    SELECT @MajorFormatId AS MajorFormatId

END
GO


