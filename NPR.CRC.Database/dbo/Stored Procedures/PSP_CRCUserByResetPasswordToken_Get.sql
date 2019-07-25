CREATE PROCEDURE [dbo].[PSP_CRCUserByResetPasswordToken_Get]
(
    @Token VARCHAR(50)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        UserId,
		dbo.FN_GetUserDisplayName(UserId) AS UserDisplayName,
		Email,
		PasswordHash,
		PasswordSalt,
		ResetPasswordHash,
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

    FROM
        dbo.CRCUser

    WHERE
		ResetPasswordHash = HASHBYTES('SHA1', PasswordSalt + @Token)
		AND
		DisabledDate IS NULL

END
GO


