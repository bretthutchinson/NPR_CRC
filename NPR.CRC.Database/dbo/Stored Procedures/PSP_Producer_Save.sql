CREATE PROCEDURE [dbo].[PSP_Producer_Save]
(
    @ProducerId BIGINT,
	@SalutationId BIGINT,
	@FirstName VARCHAR(50),
	@MiddleName VARCHAR(50),
	@LastName VARCHAR(50),
	@Suffix VARCHAR(50),
	@Role VARCHAR(50),
	@Email VARCHAR(100),
	@Phone VARCHAR(50),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE dbo.Producer
    SET
        SalutationId = @SalutationId,
		FirstName = @FirstName,
		MiddleName = @MiddleName,
		LastName = @LastName,
		Suffix = @Suffix,
		[Role] = @Role,
		Email = @Email,
		Phone = @Phone,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        ProducerId = @ProducerId

    IF @@ROWCOUNT < 1
    BEGIN

        INSERT INTO dbo.Producer
        (
            SalutationId,
			FirstName,
			MiddleName,
			LastName,
			Suffix,
			[Role],
			Email,
			Phone,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @SalutationId,
			@FirstName,
			@MiddleName,
			@LastName,
			@Suffix,
			@Role,
			@Email,
			@Phone,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @ProducerId = SCOPE_IDENTITY()

    END

    SELECT @ProducerId AS ProducerId

END
GO


