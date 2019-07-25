CREATE PROCEDURE [dbo].[PSP_MonthsList_Get]
AS BEGIN

	SET NOCOUNT ON

	;WITH Months AS
	(
		SELECT 1 AS MonthNumber
		UNION ALL
		SELECT MonthNumber + 1
		FROM Months
		WHERE MonthNumber < 12
	)
	SELECT
		MonthNumber,
		DATENAME(MONTH, DATEADD(MONTH, MonthNumber - 1, '1900-1-1')) AS MonthName,
		LEFT(DATENAME(MONTH, DATEADD(MONTH, MonthNumber - 1, '1900-1-1')), 3) AS MonthAbbreviation
	FROM
		Months

END
GO


