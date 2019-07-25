



CREATE PROCEDURE [dbo].[DT_CRCUsers_Save]
(
    @UserId BIGINT,
	@Email VARCHAR(100),
	@SalutationId BIGINT,
	@FirstName VARCHAR(50),
	@MiddleName VARCHAR(50),
	@LastName VARCHAR(50),
	@Suffix VARCHAR(50),
	@JobTitle VARCHAR(50),
	@AddressLine1 VARCHAR(50),
	@AddressLine2 VARCHAR(50),
	@City VARCHAR(50),
	@StateId BIGINT,
	@County VARCHAR(50),
	@Country VARCHAR(50),
	@ZipCode VARCHAR(50),
	@Phone VARCHAR(50),
	@Fax VARCHAR(50),
	@AdministratorInd CHAR(1),
	@CRCManagerInd CHAR(1),
	@DisabledDate DATETIME,
	@DisabledUserId BIGINT,
	@LastUpdatedUserId BIGINT,
	@Password VARCHAR(50)
)
AS BEGIN

    SET NOCOUNT ON

    UPDATE CRC_Migration.dbo.CRCUser
    SET
        Email = @Email,
		SalutationId = @SalutationId,
		FirstName = @FirstName,
		MiddleName = @MiddleName,
		LastName = @LastName,
		Suffix = @Suffix,
		JobTitle = @JobTitle,
		AddressLine1 = @AddressLine1,
		AddressLine2 = @AddressLine2,
		City = @City,
		StateId = @StateId,
		County = @County,
		Country = @Country,
		ZipCode = @ZipCode,
		Phone = @Phone,
		Fax = @Fax,
		AdministratorInd = @AdministratorInd,
		CRCManagerInd = @CRCManagerInd,
		DisabledDate = @DisabledDate,
		DisabledUserId = @DisabledUserId,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        UserId = @UserId

    IF @@ROWCOUNT < 1
    BEGIN

		DECLARE @PasswordSalt VARCHAR(50) = NEWID()		
		DECLARE @PasswordHash VARBINARY(50) = HASHBYTES('SHA1', @PasswordSalt + @Password)

        INSERT INTO dbo.CRCUser
        (
            Email,
			PasswordHash,
			PasswordSalt,
			SalutationId,
			FirstName,
			MiddleName,
			LastName,
			Suffix,
			JobTitle,
			AddressLine1,
			AddressLine2,
			City,
			StateId,
			County,
			Country,
			ZipCode,
			Phone,
			Fax,
			AdministratorInd,
			CRCManagerInd,
			DisabledDate,
			DisabledUserId,
			CreatedDate,
			CreatedUserId,
			LastUpdatedDate,
			LastUpdatedUserId
        )
        VALUES
        (
            @Email,
			@PasswordHash,
			@PasswordSalt,
			@SalutationId,
			@FirstName,
			@MiddleName,
			@LastName,
			@Suffix,
			@JobTitle,
			@AddressLine1,
			@AddressLine2,
			@City,
			@StateId,
			@County,
			@Country,
			@ZipCode,
			@Phone,
			@Fax,
			@AdministratorInd,
			@CRCManagerInd,
			@DisabledDate,
			@DisabledUserId,
			GETUTCDATE(),
			@LastUpdatedUserId,
			GETUTCDATE(),
			@LastUpdatedUserId
        )

        SET @UserId = SCOPE_IDENTITY()

    END

    SELECT @UserId AS UserId

END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[DT_CRCUsers_Save] TO [crcuser]
    AS [dbo];

