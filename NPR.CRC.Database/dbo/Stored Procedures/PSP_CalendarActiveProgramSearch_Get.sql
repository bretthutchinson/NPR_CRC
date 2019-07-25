---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--DROP PROCEDURE [dbo].[PSP_CalendarActiveProgramSearch_Get]

CREATE PROCEDURE [dbo].[PSP_CalendarActiveProgramSearch_Get]
(
	@ProgramName VARCHAR(250),
	@SearchType VARCHAR(50) = 'Wildcard' -- options are 'Wildcard' and 'StartsWith'
	,@IncludeDisabled char(1) = null
)
WITH EXECUTE AS OWNER
AS BEGIN

    SET NOCOUNT ON

	IF @SearchType = 'StartsWith'
		BEGIN
			IF rtrim(ltrim(@ProgramName)) = '*'
				BEGIN
					SELECT TOP 5000 ProgramId, ProgramName
					FROM dbo.Program
					WHERE (disableddate is null	or @IncludeDisabled='Y')
					ORDER BY ProgramName
						
				END
			ELSE
				BEGIN
					SELECT TOP 5000 ProgramId, ProgramName
					FROM dbo.Program
					WHERE ProgramName LIKE (rtrim(ltrim(@ProgramName)) + '%')
					and (disableddate is null	or @IncludeDisabled='Y')
					ORDER BY ProgramName
				END
		END
	ELSE
		BEGIN
			SELECT TOP 5000 ProgramId, ProgramName
			FROM dbo.Program
			WHERE ProgramName LIKE ('%' + rtrim(ltrim(@ProgramName)) + '%')
			and (disableddate is null	or @IncludeDisabled='Y')	
			ORDER BY ProgramName
		END
	
END