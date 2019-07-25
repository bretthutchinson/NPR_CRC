CREATE PROCEDURE [dbo].[PSP_CRCUserPasswordReset_Save]
(
    @Email VARCHAR(100),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	DECLARE @UserId BIGINT
	DECLARE @Token VARCHAR(50)
	DECLARE @CRCUserFirstName VARCHAR(50)
	DECLARE @CRCUserLastName VARCHAR(50)
	DECLARE @CRCUserEmail VARCHAR(100)
	DECLARE @CRCManagerUserId BIGINT
	DECLARE @CRCManagerFirstName VARCHAR(50)
	DECLARE @CRCManagerLastName VARCHAR(50)
	DECLARE @CRCManagerEmail VARCHAR(100)
	DECLARE @CRCManagerPhone VARCHAR(50)
	DECLARE @CRCManagerJobTitle VARCHAR(50)

	SELECT @UserId = UserId
	FROM dbo.CRCUser
	WHERE Email = @Email
	AND DisabledDate IS NULL

	IF @UserId IS NOT NULL
	BEGIN
		
		SET @Token = NEWID()

		SELECT
			@CRCUserFirstName = FirstName,
			@CRCUserLastName = LastName,
			@CRCUserEmail = Email
		FROM
			dbo.CRCUser
		WHERE
			UserId = @UserId

		SELECT
			@CRCManagerUserId = UserId,
			@CRCManagerFirstName = FirstName,
			@CRCManagerLastName = LastName,
			@CRCManagerEmail = Email,
			@CRCManagerPhone = Phone,
			@CRCManagerJobTitle = JobTitle
		FROM
			dbo.CRCUser
		WHERE
			CRCManagerInd = 'Y'

		UPDATE dbo.CRCUser
		SET
			ResetPasswordHash = HASHBYTES('SHA1', PasswordSalt + @Token),
			LastUpdatedDate = GETUTCDATE(),
			LastUpdatedUserId = ISNULL(@LastUpdatedUserId, @UserId)
		WHERE
			UserId = @UserId

	END

	SELECT
		@Token AS Token,
		@UserId AS UserId,
		@CRCUserFirstName AS CRCUserFirstName,
		@CRCUserLastName AS CRCUserLastName,
		@CRCUserEmail AS CRCUserEmail,
		@CRCManagerFirstName AS CRCManagerFirstName,
		@CRCManagerLastName AS CRCManagerLastName,
		@CRCManagerEmail AS CRCManagerEmail,
		@CRCManagerPhone AS CRCManagerPhone,
		@CRCManagerJobTitle AS CRCManagerJobTitle
	WHERE
		@UserId IS NOT NULL

END
GO


