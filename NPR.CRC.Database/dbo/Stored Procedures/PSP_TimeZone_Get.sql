CREATE PROCEDURE [dbo].[PSP_TimeZone_Get]
(
    @TimeZoneId BIGINT
)
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

    WHERE
        TimeZoneId = @TimeZoneId

END
GO


