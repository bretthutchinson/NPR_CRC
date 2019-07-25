CREATE FUNCTION dbo.FN_GetUserDisplayName
(
	@UserId BIGINT
)
RETURNS VARCHAR(100)
AS BEGIN

	DECLARE @UserDisplayName VARCHAR(100)

	SELECT @UserDisplayName =
		ISNULL(s.SalutationName + ' ', '') +
		ISNULL(u.FirstName + ' ', '') +
		ISNULL(u.MiddleName + ' ', '') +
		ISNULL(u.LastName + ' ', '') +
		ISNULL(u.Suffix, '')

	FROM
		dbo.CRCUser u

		LEFT JOIN dbo.Salutation s
			ON s.SalutationId = u.SalutationId

	WHERE
		UserId = @UserId

	RETURN @UserDisplayName

END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[FN_GetUserDisplayName] TO [crcuser]
    AS [dbo];


GO
GRANT CONTROL
    ON OBJECT::[dbo].[FN_GetUserDisplayName] TO [crcuser]
    AS [dbo];


GO
GRANT ALTER
    ON OBJECT::[dbo].[FN_GetUserDisplayName] TO [crcuser]
    AS [dbo];

