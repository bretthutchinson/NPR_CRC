CREATE PROCEDURE [dbo].[PSP_StationSearch_Get]
(
	@SearchTerm VARCHAR(250)
)

AS BEGIN

    SET NOCOUNT ON

	SELECT
		StationId,
		CallLetters + '-' + BandName AS CallLetters
	FROM
		dbo.Station sta INNER JOIN
		dbo.Band band ON sta.BandId = band.BandId
	WHERE
		CallLetters + '-' + BandName LIKE '%' + REPLACE(@SearchTerm, ' ', '') + '%'
	ORDER BY
		CallLetters
END
GO


