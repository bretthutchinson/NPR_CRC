CREATE PROCEDURE [dbo].[PSP_FlagshipStationsList_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        s.StationId,
		s.CallLetters + '-' + b.BandName AS DisplayName

    FROM
        dbo.Station s

		JOIN dbo.Band b
			ON b.BandId = s.BandId

		JOIN dbo.RepeaterStatus rs
			ON rs.RepeaterStatusId = s.RepeaterStatusId

	WHERE
		rs.RepeaterStatusName = 'Flagship'
    
END
GO


