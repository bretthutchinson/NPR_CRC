CREATE PROCEDURE [dbo].[PSP_TimeZones_Get]
AS BEGIN

    SET NOCOUNT ON

    SELECT
        TimeZoneId,
		TimeZoneCode,
		DisplayName,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.TimeZone
    
END
GO


