CREATE PROCEDURE [dbo].[PSP_Band_Get]
(
    @BandId BIGINT
)
AS BEGIN

    SET NOCOUNT ON

    SELECT
        BandId,
		BandName,
		DisabledDate,
		DisabledUserId,
		CreatedDate,
		CreatedUserId,
		LastUpdatedDate,
		LastUpdatedUserId

    FROM
        dbo.Band

    WHERE
        BandId = @BandId

END
GO


