
CREATE PROCEDURE [dbo].[PSP_CallLetters_Get]
(
	@StationId BIGINT
)	
	AS BEGIN
	
    SET NOCOUNT ON

    SELECT
					s.callletters + '-' + b.bandname FROM station s
					INNER JOIN Band b on b.BandId=s.BandId 
		WHERE 
		s.stationId=@StationId
	END