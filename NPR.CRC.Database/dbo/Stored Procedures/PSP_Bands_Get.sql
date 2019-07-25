CREATE PROCEDURE [dbo].[PSP_Bands_Get]
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
    
END
GO


