--DROP PROCEDURE [dbo].[PSP_StationActiveSearch_Get]

CREATE PROCEDURE [dbo].[PSP_StationActiveSearch_Get]
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
		sta.DisabledDate IS NULL AND
		CallLetters + '-' + BandName LIKE '%' + REPLACE(@SearchTerm, ' ', '') + '%'
	ORDER BY
		CallLetters
END