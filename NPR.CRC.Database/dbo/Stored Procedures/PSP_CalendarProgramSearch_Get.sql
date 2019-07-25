CREATE PROCEDURE [dbo].[PSP_CalendarProgramSearch_Get]
(
	@ProgramName VARCHAR(250),
	@SearchType VARCHAR(50) = 'Wildcard' -- options are 'Wildcard' and 'StartsWith'
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON
	/*
	DECLARE @Program VARCHAR(250)

	SET @Program =
		CASE @SearchType
		WHEN 'StartsWith' THEN @ProgramName + '%'
		ELSE '%' + @ProgramName + '%'
		END
    */
	IF @SearchType = 'StartsWith'
		BEGIN
			IF rtrim(ltrim(@ProgramName)) = ''
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
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PSP_CalendarProgramSearch_Get] TO [crcuser]
    AS [dbo];

