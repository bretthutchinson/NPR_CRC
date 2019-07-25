---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--DROP PROCEDURE [dbo].[PSP_CallLettersIsUnique_Get]

CREATE PROCEDURE [dbo].[PSP_CallLettersIsUnique_Get]
(
	@StationId BIGINT,
	@CallLetters VARCHAR(50),
	@BandId BIGINT
)	
	AS BEGIN
	
    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT
					Callletters
					FROM Station
			WHERE Callletters = @CallLetters
			AND (StationId <> @StationId OR @StationId IS NULL)
			AND BandId = @BandId
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd
		
	END