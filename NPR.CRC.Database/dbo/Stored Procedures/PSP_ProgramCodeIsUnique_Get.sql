CREATE PROCEDURE [dbo].[PSP_ProgramCodeIsUnique_Get]
(
	@ProgramId BIGINT,
    @ProgramCode VARCHAR(100)
)
AS BEGIN

    SET NOCOUNT ON
	IF(@ProgramId IS NULL)
		BEGIN
			SELECT
				CASE WHEN EXISTS
				(
					SELECT *
					FROM dbo.Program
					WHERE ProgramCode = @ProgramCode
				)
				THEN 'N'
				ELSE 'Y'
				END AS UniqueInd
		END
	ELSE 
		BEGIN
			SELECT
					CASE WHEN EXISTS
					(
						SELECT *
						FROM dbo.Program
						WHERE ProgramCode = @ProgramCode AND  ProgramId <> @ProgramId
					)
					THEN 'N'
					ELSE 'Y'
					END AS UniqueInd

		END
END
GO
GRANT EXECUTE
    ON OBJECT::[dbo].[PSP_ProgramCodeIsUnique_Get] TO [crcuser]
    AS [dbo];

