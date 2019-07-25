--DROP PROCEDURE [dbo].[PSP_ScheduleIsUnique_Get]

CREATE PROCEDURE [dbo].[PSP_ScheduleIsUnique_Get]
(
	@StationId BIGINT,
	@Month INT,
	@Year INT
)	
	AS BEGIN
	
    SET NOCOUNT ON

    SELECT
		CASE WHEN EXISTS
		(
			SELECT
					s.StationId
					FROM Schedule s
			WHERE s.StationId = @StationId
			AND s.Month = @Month
			AND s.Year = @Year
		)
		THEN 'N'
		ELSE 'Y'
		END AS UniqueInd
		
	END