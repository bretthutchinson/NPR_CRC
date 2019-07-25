CREATE PROCEDURE [dbo].[PSP_CRCUserPassword_Save]
(
    @UserId BIGINT,
	@Password VARCHAR(50),
	@LastUpdatedUserId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

	DECLARE @PasswordSalt VARCHAR(50) = NEWID()

    UPDATE dbo.CRCUser
    SET
		PasswordSalt = @PasswordSalt,
		PasswordHash = HASHBYTES('SHA1', @PasswordSalt + @Password),
		ResetPasswordHash = NULL,
		LastUpdatedDate = GETUTCDATE(),
		LastUpdatedUserId = @LastUpdatedUserId
    WHERE
        UserId = @UserId

END
GO


