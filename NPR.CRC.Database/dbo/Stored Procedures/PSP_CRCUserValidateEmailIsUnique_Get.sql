CREATE PROCEDURE [dbo].[PSP_CRCUserValidateEmailIsUnique_Get]
(
	@UserId BIGINT,
    @Email VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT *
			FROM dbo.CRCUser
			WHERE Email = @Email
			AND (UserId <> @UserId OR @UserId IS NULL)
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd

END
GO


