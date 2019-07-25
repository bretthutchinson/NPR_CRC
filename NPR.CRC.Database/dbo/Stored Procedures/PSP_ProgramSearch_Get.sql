CREATE PROCEDURE [dbo].[PSP_ProgramSearch_Get]
(
	@ProgramName VARCHAR(250),
	@SearchType VARCHAR(50) = 'Wildcard' -- options are 'Wildcard' and 'StartsWith'
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

	IF @SearchType = 'StartsWith'
		BEGIN
			IF rtrim(ltrim(@ProgramName)) = '*'
				BEGIN
					SELECT TOP 100 ProgramId, ProgramName
					FROM dbo.Program
					ORDER BY ProgramName			
				END
			ELSE
				BEGIN
					SELECT TOP 100 ProgramId, ProgramName
					FROM dbo.Program
					WHERE ProgramName LIKE (rtrim(ltrim(@ProgramName)) + '%')
					ORDER BY ProgramName
				END
		END
	ELSE
		BEGIN
			SELECT TOP 100 ProgramId, ProgramName
			FROM dbo.Program
			WHERE ProgramName LIKE ('%' + rtrim(ltrim(@ProgramName)) + '%')
			ORDER BY ProgramName
		END
	
END